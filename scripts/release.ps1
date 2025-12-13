<#
.pynstal/scripts/release.ps1

Builds the project, pushes to GitHub, and uploads to PyPI.

Usage (PowerShell):
  # required: set PYPI_API_TOKEN in environment (a PyPI API token starting with pypi-...)
  .\scripts\release.ps1 -Tag v0.1.1 -Branch main -Message "Release v0.1.1"

Parameters:
  -Tag      : Git tag to create and push (e.g. v0.1.1). If omitted, the script will prompt.
  -Branch   : Branch to push (default: main)
  -Message  : Tag message (default: "Release <Tag>")
  -DryRun   : If present, show commands without executing uploads/pushes
  -Force    : Force actions even if working tree is dirty

Environment:
  - PYPI_API_TOKEN : required to upload to PyPI. Twine will use __token__ / $env:PYPI_API_TOKEN

Notes:
  - Run from repository root. Ensure Python (3.8+) is on PATH.
  - This script uses `python -m build` and `python -m twine upload`.
#>

param(
    [string]$Tag,
    [string]$Branch = 'main',
    [string]$Message,
    [switch]$DryRun,
    [switch]$Force
)

function Exec([string]$cmd) {
    Write-Host "> $cmd"
    if (-not $DryRun) {
        $rc = & cmd /c $cmd
        if ($LASTEXITCODE -ne 0) { throw "Command failed: $cmd" }
    }
}

try {
    # Ensure we're at repo root (where .git exists)
    if (-not (Test-Path .git)) {
        throw "Run this script from the repository root (where .git exists)."
    }

    # Ensure PYPI token present for upload
    if (-not $env:PYPI_API_TOKEN) {
        Write-Warning "Environment variable PYPI_API_TOKEN is not set. Upload to PyPI will fail."
    }

    # Check working tree
    $status = git status --porcelain
    if ($status -and -not $Force) {
        Write-Host "Working tree is not clean. Commit or use -Force to proceed."
        Write-Host $status
        exit 1
    }

    # Prompt for tag if not provided
    if (-not $Tag) {
        $Tag = Read-Host "Enter git tag to create (e.g. v0.1.1)"
        if (-not $Tag) { throw "Tag is required." }
    }

    if (-not $Message) { $Message = "Release $Tag" }

    # Clean previous builds
    if (Test-Path dist) { if (-not $DryRun) { Remove-Item -Recurse -Force dist } else { Write-Host "DRY RUN: would remove dist/" } }

    # Build package
    Exec "python -m pip install --upgrade build twine"
    Exec "python -m build"

    # Ensure branch exists locally; fall back to current branch if not
    & git show-ref --verify --quiet "refs/heads/$Branch" 2>$null
    if ($LASTEXITCODE -ne 0) {
        $currentBranch = (git rev-parse --abbrev-ref HEAD)
        Write-Host "Branch '$Branch' not found locally; using current branch '$currentBranch' instead."
        $Branch = $currentBranch
    }

    # Push branch
    Exec "git push origin $Branch"

    # Create annotated tag and push it (handle existing tags when -Force)
    & git rev-parse -q --verify "refs/tags/$Tag" > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        if ($Force) {
            Exec "git tag -f -a $Tag -m \"$Message\""
            Exec "git push -f origin $Tag"
        } else {
            throw "Tag $Tag already exists locally. Use -Force to overwrite."
        }
    } else {
        Exec "git tag -a $Tag -m \"$Message\""
        Exec "git push origin $Tag"
    }

    # Upload to PyPI using twine and PYPI_API_TOKEN
    if (-not $env:PYPI_API_TOKEN) {
        Write-Warning "PYPI_API_TOKEN is not set; skipping upload to PyPI."
    } else {
        # Use __token__ username and token as password
        if (-not $DryRun) {
            $env:TWINE_USERNAME = "__token__"
            $env:TWINE_PASSWORD = $env:PYPI_API_TOKEN
        } else {
            Write-Host "DRY RUN: TWINE_USERNAME=__token__ TWINE_PASSWORD=<redacted> python -m twine upload dist/*"
        }
        Exec "python -m twine check dist/*"
        Exec "python -m twine upload dist/*"
    }

    Write-Host "Release script completed successfully."
} catch {
    Write-Error "Release failed: $_"
    exit 1
}
