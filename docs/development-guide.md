# Cumulus Development & Validation Guide

## System Prerequisites

- Neovim >= 0.10.0 (v0.11.4 recommended)
- `git`, `curl`, `unzip`, `tar`, `gzip`
- `stylua` for Lua code formatting
- Language runtimes: `node`/`npm`, `python3`, `go` (for Mason LSP installations)

---

## Validation Commands

Before committing any changes to Cumulus:

### 1. Format Lua Codebase
```bash
stylua lua
```
*(Enforces 2-space indentation and 120-column line width per `stylua.toml`)*

### 2. Headless Plugin Spec & Syntax Check
```bash
nvim --headless "+Lazy check" +qa
```
*(Validates all `cumulus.plugins` specs without opening a GUI window)*

### 3. Check Mason Tools Update
```bash
nvim --headless "+MasonUpdate" +qa
```

---

## Code Conventions

* **Namespace Rule:** Place all Lua modules under `lua/cumulus/`. Do not introduce top-level plugins outside `cumulus.plugins`.
* **Zero LazyVim Dependency:** Do not import `lazyvim.plugins` or call `LazyVim.*` utility functions. Use standard Neovim Lua APIs (`vim.api.*`, `vim.keymap.set`, `vim.notify`).
* **Clean Commits:** Write conventional commit messages (`feature:`, `fix:`, `refactor:`, `docs:`).
