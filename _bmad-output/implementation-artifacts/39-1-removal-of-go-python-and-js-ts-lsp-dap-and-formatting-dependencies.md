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

### Follow-up Fix: Mason Auto-Install Was Never Actually Running
- Discovered while investigating a user report of the statusline showing "No LSP" for Java: `WhoIsSethDaniel/mason-tool-installer.nvim`'s auto-install is driven entirely by a `VimEnter` autocmd baked into its own `plugin/mason-tool-installer.lua`, which is only sourced once lazy.nvim actually loads the plugin. It was gated behind `event = { "BufReadPre", "BufNewFile" }` in `tools-mason.lua`, but `VimEnter` fires exactly once at startup -- if that first buffer-read event happens at or after `VimEnter` (e.g. `nvim .` with no file argument), the plugin loads too late for its own hook to ever fire. `ensure_installed` was silently never installing anything for anyone, on any of these tools, the whole time.
- Fixed by setting `lazy = false` on both `williamboman/mason.nvim` and `WhoIsSethDaniel/mason-tool-installer.nvim` in `lua/cumulus/plugins/tools-mason.lua`, so they load before `VimEnter` fires.
- Verified for real (not just structurally): ran a live headless `nvim .` session end-to-end and confirmed `jdtls`, `kotlin-language-server`, `kotlin-debug-adapter`, `groovy-language-server`, `google-java-format`, `ktlint`, and `npm-groovy-lint` all installed to `~/.local/share/nvim/mason/bin/` without any manual `:MasonToolsInstall`. Also cross-checked all 25 `ensure_installed` package names against the live Mason registry (588 packages) -- no typos, every name resolves to a real package.

## File List
- `lua/cumulus/plugins/lsp-devops.lua`
- `lua/cumulus/plugins/tools-dap-devops.lua`
- `lua/cumulus/plugins/tools-formatting.lua`
- `lua/cumulus/plugins/tools-mason.lua`
- `lua/cumulus/health.lua`
- `lua/cumulus/core/autocmds.lua` (README auto-open, unrelated follow-up)
- `lua/cumulus/core/keymaps.lua` (`<leader>cl` dead `:LspInfo` fix, `<leader>cjr` Groovy runner)
- `ftplugin/java.lua` (JDTLS attach notification)
- `lua/cumulus/plugins/core-treesitter.lua` (new; Treesitter install/highlight fix)

## Change Log
- Removed Go, Python, and JS/TS LSP servers, DAP adapters, formatters, treesitter parsers, and Mason packages.
- Updated `:checkhealth cumulus` binary descriptions to reflect remaining DevOps LSP/linter dependents of node/python3.
- Fixed `mason-tool-installer.nvim` never actually auto-installing anything (eager-load fix) -- guarantees jdtls/kotlin-language-server/groovy-language-server and every other configured LSP/tool actually get installed on startup.
