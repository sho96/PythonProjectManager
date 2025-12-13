# Publishing to PyPI via GitHub

This guide walks you through publishing `pythonprojectmanager` (ppm) to PyPI.

## Prerequisites

1. **PyPI Account** - Create one at https://pypi.org/account/register/
2. **GitHub Account** - The repository needs to be on GitHub
3. **PyPI API Token** - Generate at https://pypi.org/manage/account/tokens/

## Step 1: Create a GitHub Repository

1. Go to https://github.com/new
2. Create a new repository named `PythonProjectManager`
3. Choose public/private as desired
4. **Do not initialize** with README (we already have one)
5. Click "Create repository"

## Step 2: Push Code to GitHub

From your local repository directory:

```powershell
cd "C:\Users\kurok\Desktop\pythonFiles\PythonProjectManager"

# If not already initialized
git init
git config user.email "your.email@gmail.com"
git config user.name "Your Name"

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Python virtual environment manager CLI"

# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/PythonProjectManager.git
git branch -M main

# Push to GitHub
git push -u origin main
```

## Step 3: Configure PyPI API Token in GitHub

1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `PYPI_API_TOKEN`
5. Value: Paste your PyPI API token (from https://pypi.org/manage/account/tokens/)
6. Click **Add secret**

## Step 4: Update Package Metadata (Optional)

Edit `setup.cfg` to add your GitHub username and email:

```ini
[metadata]
url = https://github.com/YOUR_USERNAME/PythonProjectManager
author = Your Name
author_email = your.email@gmail.com
```

## Step 5: Create a Release Tag and Publish

The GitHub Actions workflow is already configured to publish whenever you push a tag starting with `v`.

### First Release (v0.1.0)

```powershell
cd "C:\Users\kurok\Desktop\pythonFiles\PythonProjectManager"

# Create a git tag
git tag v0.1.0

# Push the tag to GitHub
git push origin v0.1.0
```

This will trigger the `.github/workflows/publish-pypi.yml` workflow which:
1. Builds the wheel package
2. Publishes to PyPI

### Check Publication Status

1. Go to your GitHub repository
2. Click **Actions** tab
3. Watch the "Publish Python package" workflow run
4. Once complete, your package is available on PyPI!

### Future Releases

For each new version:

1. Update version in `setup.cfg`:
   ```ini
   [metadata]
   version = 0.2.0
   ```

2. Commit and tag:
   ```powershell
   git add setup.cfg
   git commit -m "Bump version to 0.2.0"
   git tag v0.2.0
   git push origin main
   git push origin v0.2.0
   ```

## Step 6: Install from PyPI

Once published, users can install with:

```bash
pip install pythonprojectmanager
ppm --help
```

## Workflow Details

The `.github/workflows/publish-pypi.yml` file:
- Triggers on any tag matching `v*` (e.g., v0.1.0, v1.0.0)
- Builds a wheel distribution
- Uploads to PyPI using the `PYPI_API_TOKEN` secret
- Automatically creates a GitHub Release

## Troubleshooting

### Package name already taken on PyPI?

If `pythonprojectmanager` is taken, modify in `setup.cfg`:
```ini
name = python-project-manager  # or similar
```

### Workflow fails with "API token invalid"?

Make sure you:
1. Created the token correctly on PyPI (it starts with `pypi-`)
2. Pasted it correctly in GitHub Secrets
3. The secret name matches exactly: `PYPI_API_TOKEN`

### Want to test before publishing to PyPI?

Build locally:
```powershell
python -m pip install build
python -m build --wheel
# Creates dist/pythonprojectmanager-0.1.0-py3-none-any.whl

# Test install
pip install dist/pythonprojectmanager-0.1.0-py3-none-any.whl
ppm --help
```

## Useful Links

- PyPI: https://pypi.org/project/pythonprojectmanager/
- GitHub Releases: https://github.com/YOUR_USERNAME/PythonProjectManager/releases
- PyPI API Tokens: https://pypi.org/manage/account/tokens/
