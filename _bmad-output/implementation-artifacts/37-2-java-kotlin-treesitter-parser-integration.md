---
baseline_commit: db64133972545c6bde97faf8e116ad091734bfca
---

# Story 37.2: Java & Kotlin Treesitter Parser Integration

## Status: review

## Story Description
As a Developer,  
I want `"java"` and `"kotlin"` added to `opts.ensure_installed` for `nvim-treesitter`,  
So that AST-based syntax highlighting, folding, and textobjects work automatically for Java and Kotlin files.

## Acceptance Criteria
- [x] **Given** a `.java` or `.kt` buffer, **When** opening the file in Neovim, **Then** `nvim-treesitter` automatically installs and loads `java` and `kotlin` parsers.

## Tasks
- [x] Update `lua/cumulus/plugins/lsp-java.lua` and `lua/cumulus/plugins/lsp-kotlin.lua` to extend `opts.ensure_installed` with `"java"` and `"kotlin"`.
- [x] Run headless check to ensure treesitter spec evaluates cleanly.

## Dev Agent Record

### Implementation Plan
- Added `nvim-treesitter` plugin spec extensions in `lua/cumulus/plugins/lsp-java.lua` and `lua/cumulus/plugins/lsp-kotlin.lua` extending `opts.ensure_installed` with `"java"` and `"kotlin"`.

### Debug Log
- Verified headless Lazy plugin load (`nvim --headless "+Lazy check" +qa`) and ran `./scripts/validate.sh` - all validations passed successfully.

### Completion Notes
- Completed co-located `nvim-treesitter` parser specifications for Java and Kotlin.

## File List
- `lua/cumulus/plugins/lsp-java.lua`
- `lua/cumulus/plugins/lsp-kotlin.lua`

## Change Log
- Add `"java"` parser to `nvim-treesitter` spec in `lua/cumulus/plugins/lsp-java.lua`.
- Add `"kotlin"` parser to `nvim-treesitter` spec in `lua/cumulus/plugins/lsp-kotlin.lua`.
