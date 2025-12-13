# pynstal

A CLI utility to manage Python virtual environments with auto-detection of system Python installations.

## Features

- **Auto-detect Python installations** across Windows, macOS, and Linux (pyenv, conda, system Python)
- **Manage interpreters** - add, list, and configure Python interpreter paths
- **Create virtual environments** using any configured Python interpreter
- **Install templates** - predefined and custom package templates with special pip arguments (e.g., CUDA-specific PyTorch)
- **Persistent configuration** - interpreter paths and templates stored in `data/interpreters.json` and `data/templates.json`

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

### 2. Create a virtual environment

```bash
pynstal create-venv "C:\Users\...\python.exe" my_venv
```

### 3. Install packages using templates

```bash
# List available templates
pynstal template list

# Create venv with datascience template (numpy, scipy, pandas, etc.)
pynstal create-from-template datascience my_ds_venv

# Create venv with PyTorch (CUDA 12.4)
pynstal create-from-template pytorch-cu124 my_pytorch_venv
```

### 4. Create custom templates

```bash
# Simple template
pynstal template add mytemplate "numpy scipy matplotlib"

# Template with special pip arguments
pynstal template add-complex pytorch-custom "torch torchvision" --args-str "--index-url https://download.pytorch.org/whl/cu124"

# Create venv from custom template
pynstal create-from-template pytorch-custom my_venv
```

## Commands

- `pynstal add-interpreter <path>` - Manually add a Python interpreter path
- `pynstal list` - List all configured interpreters
- `pynstal interpreter detect [--add | --add-all]` - Auto-detect system Python installations
- `pynstal create-venv <interpreter> <venv_dir> [--dry-run]` - Create a virtual environment
- `pynstal create-from-template <template> <venv_dir> [--interpreter <path>] [--dry-run]` - Create venv and install template packages
- `pynstal template list` - List all templates
- `pynstal template show <name>` - Show template details
- `pynstal template add <name> "<packages>"` - Add a simple template
- `pynstal template add-complex <name> "<packages>" --args-str "<args>"` - Add template with pip arguments
- `pynstal template remove <name>` - Remove a template

## Data Storage

- **Interpreters**: `data/interpreters.json` - stores configured Python interpreter paths
- **Templates**: `data/templates.json` - stores user-defined package installation templates

## Configuration

### interpreters.json

```json
{
    "FILE_PATH": "interpreters.json",
    "interpreters": [
        "C:\\Users\\...\\python.exe",
        "/usr/bin/python3.12"
    ],
    "global_interpreter": null
}
```

### templates.json

```json
{
    "templates": {
        "simple": ["numpy", "scipy"],
        "pytorch-cu124": {
            "packages": ["torch", "torchvision"],
            "args": ["--index-url", "https://download.pytorch.org/whl/cu124"]
        }
    }
}
```

## Platform Support

- **Windows**: Detects pyenv-win, AppData Python installations, system Python
- **macOS/Linux**: Detects /usr/bin/python*, pyenv, conda, system Python

## License

MIT

## Contributing

Contributions welcome! Please feel free to submit issues and pull requests.
