# Sentry-Wrench Dependencies

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

### Kotlin LSP (JDK 21 requirement)
`kotlin-language-server` bundles `kotlin-compiler` 2.1.0, whose IntelliJ-derived
`JavaVersion` parser crashes on newer JDK version strings (e.g. Java 25's
`25.0.3`). `scripts/install.sh` installs a JDK 21 package (`openjdk-21-jdk` /
`jdk21-openjdk` / `java-21-openjdk`) alongside the system default JDK, and
`lua/plugins/lsp-kotlin.lua` pins the server's `JAVA_HOME` to that JDK 21
install regardless of which JDK is the system default.

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
