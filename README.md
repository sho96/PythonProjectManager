# pynstal

A CLI utility to manage Python virtual environments with auto-detection of system Python installations.

## Features

- **Auto-detect Python installations** across Windows, macOS, and Linux (pyenv, conda, system Python)
- **Manage interpreters** - add/list/remove and set defaults
- **Project-aware defaults** - per-project `pynstal.json` plus global config under `~/.pynstal`
- **Create virtual environments** using any configured Python interpreter
- **Install templates** - predefined and custom package templates (including pip args like CUDA wheels)
- **Persistent configuration** - interpreter paths and templates stored in global config, with optional project-local defaults

## Installation

### From PyPI

```bash
pip install pynstal
```

After installation, use the `pynstal` command:

```bash
pynstal --help
```

### From source

```bash
git clone https://github.com/yourusername/PythonProjectManager.git
cd PythonProjectManager
pip install -e .
```

## Quick Start

### 1. Detect and add Python installations

```bash
# List found Python installations
pynstal interpreter detect

# Interactively select which to add
pynstal interpreter detect --add

# Add all detected interpreters
pynstal interpreter detect --add-all
```

### 2. Set a default interpreter (optional)

```bash
pynstal set-default-interpreter   # prompts to choose from the configured list
```

### 3. Create a virtual environment

```bash
# Uses project-local default (pynstal.json) or global default if not provided
pynstal create-venv my_venv

# Or specify an interpreter explicitly
pynstal create-venv my_venv --interpreter "/usr/bin/python3.12"
```

### 4. Install packages using templates

```bash
# List available templates
pynstal template list

# Create venv with datascience template (numpy, scipy, pandas, etc.)
pynstal create-from-template datascience my_ds_venv

# Create venv with PyTorch (CUDA 12.4)
pynstal create-from-template pytorch-cu124 my_pytorch_venv
```

### 5. Create custom templates

```bash
# Create a template (interactive)
pynstal template add mytemplate
# then add packages
pynstal template add-pkg mytemplate numpy scipy matplotlib
# or add packages with custom pip args
pynstal template add-pkg-complex mytemplate torch torchvision --args-str "--index-url https://download.pytorch.org/whl/cu124"

# Create venv from the custom template
pynstal create-from-template mytemplate my_venv
```

## Commands

- Interpreter management
  - `pynstal interpreter list` - List configured interpreters
  - `pynstal interpreter detect [--add | --add-all]` - Auto-detect system Python installations
  - `pynstal interpreter add` - Interactive prompt to add interpreter paths
  - `pynstal interpreter remove` - Interactive prompt to remove interpreter paths
  - `pynstal add-interpreter <path>` - Manually add a Python interpreter path (positional)
  - `pynstal set-default-interpreter` - Interactive prompt to choose the global default interpreter

- `pynstal create-venv <venv_dir> [--interpreter <path>] [--dry-run]` - Create a virtual environment
- `pynstal create-from-template <template> <venv_dir> [--interpreter <path>] [--dry-run]` - Create venv and install template packages
- `pynstal remove-venv <venv_dir>` - Delete a virtual environment and clean up references
- `pynstal install <template> [--interpreter <path>] [--dry-run]` - Install packages from a template into an interpreter without creating a venv

- Template management
  - `pynstal template list` - List all templates
  - `pynstal template show <name>` - Show template details
  - `pynstal template create <name>` - Create a new template interactively
  - `pynstal template add-pkg <name> <packages...>` - Add packages to an existing template
  - `pynstal template add-pkg-complex <name> <packages...> --args-str "<args>"` - Add packages with pip args to a template
  - `pynstal template remove-pkg <name>` - Interactively remove packages from a template
  - `pynstal template remove <name>` - Remove a template

## Data Storage

- **Global config**: `~/.pynstal` (or `$XDG_CONFIG_HOME/pynstal`)
  - `interpreters.json` – configured interpreter paths and `default_interpreter`
  - `templates.json` – user-defined package templates
- **Project-local config**: `./pynstal.json`
  - `default_interpreter` – default interpreter for the current project (set automatically when creating a venv)

## Platform Support

- **Windows**: Detects pyenv-win, AppData Python installations, system Python
- **macOS/Linux**: Detects /usr/bin/python*, pyenv, conda, system Python

## License

MIT

## Contributing

Contributions welcome! Please feel free to submit issues and pull requests.
