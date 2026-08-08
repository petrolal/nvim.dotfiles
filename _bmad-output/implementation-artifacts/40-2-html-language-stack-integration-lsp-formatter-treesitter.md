---
baseline_commit: db64133972545c6bde97faf8e116ad091734bfca
---

# Story 40.2: HTML Language Stack Integration (LSP, Formatter, Treesitter)

## Status: review

## Story Description
As a Web / Cloud Developer,  
I want HTML LSP, HTML formatting in `conform.nvim`, and `"html"` Treesitter parser registered,  
So that HTML documents have full autocompletion, formatting, and syntax highlighting.

## Acceptance Criteria
- [x] **Given** an `.html` buffer, **When** editing or saving the file, **Then** HTML LSP attaches, `conform.nvim` formats HTML on save, and `html` Treesitter parser provides highlighting.

## Tasks
- [x] Register an HTML LSP server in a dedicated `lua/cumulus/plugins/lsp-html.lua` spec.
- [x] Register an HTML formatter in `lua/cumulus/plugins/tools-formatting.lua`.
- [x] Add `"html"` to `opts.ensure_installed` in the `nvim-treesitter` spec and the chosen server/formatter package in `lua/cumulus/plugins/tools-mason.lua`.

## Dev Agent Record

### Implementation Plan
- Created `lua/cumulus/plugins/lsp-html.lua`: registers the `html` Treesitter parser and the `superhtml` LSP server.
- **Deviation from the story's suggested `html` (`vscode-html-language-server`) server / `prettier`/`htmlbeautifier` formatter**: Epic 39 just removed Cumulus's Node/JS toolchain to keep the distribution tightly JVM & Cloud focused. `vscode-html-language-server` and `prettier` are npm packages, which would reintroduce that exact dependency surface. `superhtml` (https://github.com/kristoff-it/superhtml) is a single Zig-compiled binary that serves as both the LSP server (`superhtml lsp`) and the formatter (`superhtml fmt --stdin`, exposed to `conform.nvim` as the built-in `superhtml` formatter), so it satisfies every acceptance criterion (LSP attach, format-on-save, Treesitter highlighting) without adding Node back as a runtime dependency. Confirmed both the `lspconfig` server id and the `conform` formatter id by reading the locally installed plugin sources.
- Registered `html = { "superhtml" }` in `conform.nvim`'s `formatters_by_ft` (`tools-formatting.lua`); it is picked up by the existing global `format_on_save` handler, so no additional wiring was needed.
- Added `superhtml` to the Mason `ensure_installed` list in `tools-mason.lua` (provides both the LSP server and formatter binary from one package).

### Debug Log
- `nvim --headless "+Lazy check" +qa` completed with no output (zero spec errors).
- `nvim --headless -c "lua print('LOADED OK')" -c "qa"` confirmed clean startup after all edits.

### Completion Notes
- No separate formatter-only Mason package was required since `superhtml` provides both roles.

## File List
- `lua/cumulus/plugins/lsp-html.lua` (new)
- `lua/cumulus/plugins/tools-formatting.lua`
- `lua/cumulus/plugins/tools-mason.lua`

## Change Log
- Added HTML LSP, format-on-save, and Treesitter support via `superhtml` (Node-free alternative to `vscode-html-language-server`/`prettier`).
