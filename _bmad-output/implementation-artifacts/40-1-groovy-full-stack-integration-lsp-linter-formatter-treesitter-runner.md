---
baseline_commit: db64133972545c6bde97faf8e116ad091734bfca
---

# Story 40.1: Groovy Full Stack Integration (LSP, Linter, Formatter, Treesitter & Runner)

## Status: review

## Story Description
As a JVM & DevOps Engineer,  
I want Groovy LSP (`groovyls`), `npm-groovy-lint` linter/formatter, `"groovy"` Treesitter parser, and `<leader>cjr` Groovy script runner integrated,  
So that editing Jenkinsfiles, Gradle scripts, and Groovy classes has full IDE capabilities.

## Acceptance Criteria
- [x] **Given** a `.groovy` or `Jenkinsfile` buffer, **When** opening or editing the file, **Then** Groovy LSP attaches, `npm-groovy-lint` provides diagnostic linting & formatting, Treesitter highlights syntax, and `<leader>cjr` executes the Groovy script.

## Tasks
- [x] Register `groovyls` in a dedicated `lua/cumulus/plugins/lsp-groovy.lua` LSP spec.
- [x] Register `npm-groovy-lint` in `lua/cumulus/plugins/tools-linting.lua` and `lua/cumulus/plugins/tools-formatting.lua`.
- [x] Add `"groovy"` to `opts.ensure_installed` in `nvim-treesitter` spec and `"npm-groovy-lint"`, `"groovy-language-server"` in `lua/cumulus/plugins/tools-mason.lua`.
- [x] Add `<leader>cjr` keymap in `lua/cumulus/core/keymaps.lua` for running Groovy scripts in a terminal split.

## Dev Agent Record

### Implementation Plan
- Created `lua/cumulus/plugins/lsp-groovy.lua`: registers the `groovy` Treesitter parser and the `groovyls` (`groovy-language-server`) LSP server via the same `neovim/nvim-lspconfig` opts-merge pattern used by `lsp-java.lua`/`lsp-kotlin.lua`.
- Added `vim.filetype.add({ filename = { Jenkinsfile = "groovy" } })` in `lsp-groovy.lua` because Neovim's built-in filetype detection does not map the extension-less `Jenkinsfile` to `groovy` on its own -- required for the `Jenkinsfile` half of the acceptance criteria.
- Registered `groovy = { "npm-groovy-lint" }` in both `nvim-lint`'s `linters_by_ft` (`tools-linting.lua`) and `conform.nvim`'s `formatters_by_ft` (`tools-formatting.lua`), matching the exact linter/formatter module names shipped by those plugins (`lint/linters/npm-groovy-lint.lua`, `conform/formatters/npm-groovy-lint.lua`).
- Added `groovy-language-server` and `npm-groovy-lint` to the Mason `ensure_installed` list in `tools-mason.lua`.
- Added the `<leader>cjr` "Groovy: Run Script" keymap to the existing `<leader>cj` java/jvm build group in `lua/cumulus/core/keymaps.lua`. That group's `lang_keymaps.register` block already lists `"groovy"` in its `filetypes`, so the group activates directly on any Groovy buffer (independent of the Maven/Gradle `condition`). The keymap saves the buffer, then runs `groovy <file>` via `Snacks.terminal(...)`, matching the pattern used by the existing `<leader>cjs` Spring Boot/Quarkus launcher.

### Debug Log
- `nvim --headless "+Lazy check" +qa` completed with no output (zero spec errors).
- `nvim --headless -c "lua print('LOADED OK')" -c "qa"` confirmed clean startup after all edits.

### Completion Notes
- Confirmed exact `lspconfig` server name (`groovyls`), Mason package name conventions, and the `npm-groovy-lint` linter/formatter module names by inspecting the locally installed plugin sources under `~/.local/share/nvim/lazy/` rather than guessing.
- Refactor (`<leader>cx`) and Maven/Gradle build (`<leader>cj*`) keymap groups already included `"groovy"` in their filetype lists from prior work, so no changes were needed there.

## File List
- `lua/cumulus/plugins/lsp-groovy.lua` (new)
- `lua/cumulus/plugins/tools-linting.lua`
- `lua/cumulus/plugins/tools-formatting.lua`
- `lua/cumulus/plugins/tools-mason.lua`
- `lua/cumulus/core/keymaps.lua`

## Change Log
- Added full Groovy LSP/lint/format/treesitter/runner integration, including Jenkinsfile filetype detection.
