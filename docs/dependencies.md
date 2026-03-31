# TurasVim Dependencies

## Overview
This LazyVim-based config relies on a handful of system tools plus Mason-managed language servers and linters. Install the system prerequisites first; Mason will fetch the rest on demand.

## System Packages (Windows — Scoop)

Install [Scoop](https://scoop.sh) first, then add the required buckets:
```powershell
scoop bucket add extras
scoop bucket add java
```

Core tools:
```powershell
scoop install git curl unzip ripgrep fd stylua tree-sitter lazygit lazydocker
```

C compiler (required by nvim-treesitter):
```powershell
winget install --id BrechtSanders.WinLibs.POSIX.UCRT -e
```

Language runtimes:
```powershell
scoop install python nodejs
winget install --id Rustlang.Rustup -e   # installs cargo + rustc
```

> After installing Rust via rustup, restart your terminal so `~/.cargo/bin` is on PATH.

## Mason-Managed Tools

Mason (`ensure_installed`) handles these automatically on first launch:
- **Formatters/linters**: `shfmt`, `shellcheck`, `flake8`, `ruff`
- **LSP servers**: `pyright`
- **Debug adapters**: `debugpy`
- **Java**: `jdtls`, `java-debug-adapter`, `java-test`, `google-java-format`
- **Treesitter**: `tree-sitter-cli` (auto-installed by LazyVim if `tree-sitter` is not in PATH)

To check status or install manually inside Neovim:
```vim
:Mason
```

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
Confirm all providers show **OK**. If any command is missing, install it via Scoop/winget and rerun the checks.
