# Story 27.1: Search Keymap Taxonomy Standardization

Status: done

## Story

As a Developer,  
I want keymap descriptions in `editor-telescope.lua` and `ui-whichkey.lua` standardized under Telescope UI naming,  
so that backend CLI implementation details (like Ripgrep) are abstracted away from the editor UI menu labels.

## Acceptance Criteria

1. **Given** Neovim buffer,
   - **When** pressing `<leader>/`, `<leader><space>`, `<leader>ff`, `<leader>tf`, `<leader>sg`, `<leader>tg`, or `<leader>sw`,
   - **Then** keymap descriptions in Telescope / WhichKey state Telescope UI terminology (e.g., `"Live Grep (Telescope)"`, `"Find Files (Telescope)"`, `"Word Under Cursor (Telescope)"`), removing `"Ripgrep"` references from menu labels.
2. **Given** `lua/cumulus/plugins/editor-telescope.lua`,
   - **When** keymaps are registered,
   - **Then** all `desc` fields conform to standardized Telescope naming taxonomy without breaking functionality.
3. **Given** headless validation command `nvim --headless "+Lazy check" +qa`,
   - **When** executed after changes,
   - **Then** Neovim completes plugin validation with exit code 0 and zero errors.

## Tasks / Subtasks

- [x] Standardize keymap descriptions in `lua/cumulus/plugins/editor-telescope.lua` (AC: #1, #2)
  - [x] Replace `"Ripgrep Live Search (Telescope)"` with `"Live Grep (Telescope)"` for `<leader>/`, `<leader>sg`, and `<leader>tg`
  - [x] Replace `"Find Files (Telescope Ripgrep)"` with `"Find Files (Telescope)"` for `<leader><space>`, `<leader>ff`, and `<leader>tf`
  - [x] Replace `"Ripgrep Word Under Cursor (Telescope)"` with `"Word Under Cursor (Telescope)"` for `<leader>sw`
- [x] Verify WhichKey registration in `lua/cumulus/plugins/ui-whichkey.lua` (AC: #1)
  - [x] Confirm `<leader>s` ("search") and `<leader>t` ("telescope search") group headers align with updated descriptions
- [x] Headless Validation (AC: #3)
  - [x] Run `nvim --headless "+Lazy check" +qa` to confirm zero spec syntax errors

## Dev Notes

- **Primary Goal:** Abstract low-level CLI tool names (`Ripgrep`) out of user-facing UI keymap titles.
- **Affected Files:**
  - `lua/cumulus/plugins/editor-telescope.lua` [editor-telescope.lua:20-99](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/plugins/editor-telescope.lua#L20-L99)
  - `lua/cumulus/plugins/ui-whichkey.lua` [ui-whichkey.lua:1-26](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/plugins/ui-whichkey.lua#L1-L26)

### Project Structure Notes

- `lua/cumulus/plugins/editor-telescope.lua` manages all Telescope keymaps and options.
- Maintain existing function bindings (`live_grep`, `find_files`, `grep_string`, `current_buffer_fuzzy_find`).

### References

- [Epics Document: Epic 27](file://_bmad-output/planning-artifacts/epics.md#L861)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Standardized all Telescope keymap `desc` strings in `lua/cumulus/plugins/editor-telescope.lua` to remove `"Ripgrep"` references.
- Confirmed zero errors via `nvim --headless "+Lazy check" +qa`.

### File List

- `lua/cumulus/plugins/editor-telescope.lua`
- `_bmad-output/implementation-artifacts/27-1-search-keymap-taxonomy-standardization.md`

