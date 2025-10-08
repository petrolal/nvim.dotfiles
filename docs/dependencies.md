# TurasVim Dependencies

## Overview
This LazyVim-based config relies on a handful of system tools plus Mason-managed language servers and linters. Install the system prerequisites first; Mason will fetch the rest on demand.

## System Packages
- Git + curl or wget (plugin bootstrap):
  ```bash
  sudo apt install git curl # Debian/Ubuntu
  sudo pacman -S git curl    # Arch
  sudo dnf install git curl  # Fedora
  ```
- Compression utilities (`tar`, `unzip`) usually ship with the distro; otherwise install them via your package manager.
- Search helpers: `ripgrep` and `fd` (or `fd-find`):
  ```bash
  sudo apt install ripgrep fd-find
  sudo pacman -S ripgrep fd
  sudo dnf install ripgrep fd-find
  ```
- Compiler toolchain for native plugins:
  ```bash
  sudo apt install build-essential
  sudo pacman -S base-devel
  sudo dnf groupinstall "Development Tools"
  ```
- Language hosts:
  ```bash
  sudo apt install python3 python3-pip nodejs npm cargo
  # or equivalent pacman/dnf commands
  ```
- Remote workflow:
  ```bash
  sudo apt install openssh sshpass
  sudo pacman -S openssh sshpass
  sudo dnf install openssh-clients sshpass
  ```
- Optional CLI integrations:
  ```bash
  sudo apt install lazygit lazydocker  # use yay/paru on Arch, brew on macOS
  ```

## User Binaries
- `stylua`: install via cargo for formatting
  ```bash
  cargo install stylua --locked
  ```
- `distant`: bundled under `remotes/bin`. `init.lua` adds it to PATH; no global install required.

## Mason-Managed Tools
Open Neovim and run:
```vim
:MasonInstall shellcheck shfmt flake8 pyright ruff debugpy
```
Mason installs into `~/.local/share/nvim/mason`; rerun `:Mason` anytime to check status.

## Verification
1. Restart Neovim and execute:
   ```bash
   nvim --headless "+Lazy sync" +qa
   nvim --headless "+Lazy check" +qa
   ```
2. Inside Neovim:
   ```vim
   :checkhealth
   :Mason
   ```
Confirm all providers show **OK**. If any command is missing, install it via your package manager and rerun the checks.
