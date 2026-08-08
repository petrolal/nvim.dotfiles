---
baseline_commit: db64133972545c6bde97faf8e116ad091734bfca
---

# Story 39.1: Removal of Go, Python, and JS/TS LSP, DAP, and Formatting Dependencies

## Status: review

## Story Description
As a Lead Developer,  
I want Go (`gopls`, `delve`), Python (`pyright`, `debugpy`, `ruff`), and JS/TS (`typescript-language-server`, `vscode-js-debug`) removed from Mason, LSP, DAP, and formatting configurations,  
So that Cumulus Neovim is lightweight and tightly focused on JVM and Cloud workloads.

## Acceptance Criteria
- [x] **Given** Cumulus Neovim startup, **When** Mason and LSP plugins load, **Then** no Go, Python, or JS/TS LSP servers, DAP adapters, or formatters are installed or registered.

## Tasks
- [x] Remove `gopls`, `pyright`, and `typescript-language-server` (`ts_ls`) from `lua/cumulus/plugins/lsp-devops.lua`.
- [x] Remove `delve` (`nvim-dap-go`) and `debugpy` (`nvim-dap-python`) from `lua/cumulus/plugins/tools-dap-devops.lua`.
- [x] Remove `ruff_format` and `ruff_organize_imports` from `lua/cumulus/plugins/tools-formatting.lua`.
- [x] Remove `"gopls"`, `"delve"`, `"pyright"`, `"debugpy"`, `"typescript-language-server"` from `lua/cumulus/plugins/tools-mason.lua`.

## Dev Agent Record

### Implementation Plan
- Stripped Go/Python/JS-TS treesitter parsers (`go`, `gomod`, `gowork`, `gotmpl`, `python`, `javascript`, `typescript`) and `gopls`/`pyright`/`ts_ls` server configs from `lua/cumulus/plugins/lsp-devops.lua`, keeping the shared DevOps servers (`jsonls`, `lemminx`, `bashls`) and their parsers (`json`, `xml`, `bash`) intact.
- Removed the `leoluz/nvim-dap-go` and `mfussenegger/nvim-dap-python` plugin specs from `lua/cumulus/plugins/tools-dap-devops.lua`, leaving the central `mfussenegger/nvim-dap` keymap suite (Story 12.3) untouched.
- Removed the `python = { "ruff_format", "ruff_organize_imports" }` entry from `conform.nvim`'s `formatters_by_ft` in `lua/cumulus/plugins/tools-formatting.lua`.
- Removed `gopls`, `delve`, `pyright`, `debugpy`, `typescript-language-server` from the Mason `ensure_installed` list in `lua/cumulus/plugins/tools-mason.lua`.
- Updated `lua/cumulus/health.lua` so the `node`/`python3` binary descriptions no longer cite the removed JS LSP servers, instead reflecting the DevOps tooling (yamlls, ansible-language-server, ansible-lint, cfn-lint) that still depends on those runtimes.

### Debug Log
- `nvim --headless "+Lazy check" +qa` completed with no output (zero spec errors).
- `nvim --headless -c "lua print('LOADED OK')" -c "qa"` confirmed clean startup after all edits.

### Completion Notes
- No residual `gopls`/`pyright`/`ts_ls`/`delve`/`debugpy`/`ruff`/`vscode-js-debug` references remain anywhere under `lua/` or `ftplugin/`.
- `node` and `python3` remain listed in `:checkhealth cumulus` because other retained DevOps LSP servers/linters (yaml-language-server, ansible-language-server, ansible-lint, cfn-lint, markdown-preview) still depend on those runtimes -- this is not JS/Python *development* support, so it stays.
- `scripts/install.sh` still references `ruff`/`pyright`/`flake8` and Go-based `lazydocker` installation; left out of scope for this story since it is a standalone environment bootstrap script, not part of the `lua/cumulus/*` runtime config this story's acceptance criteria target. Flagged for a follow-up cleanup story.

## File List
- `lua/cumulus/plugins/lsp-devops.lua`
- `lua/cumulus/plugins/tools-dap-devops.lua`
- `lua/cumulus/plugins/tools-formatting.lua`
- `lua/cumulus/plugins/tools-mason.lua`
- `lua/cumulus/health.lua`

## Change Log
- Removed Go, Python, and JS/TS LSP servers, DAP adapters, formatters, treesitter parsers, and Mason packages.
- Updated `:checkhealth cumulus` binary descriptions to reflect remaining DevOps LSP/linter dependents of node/python3.
