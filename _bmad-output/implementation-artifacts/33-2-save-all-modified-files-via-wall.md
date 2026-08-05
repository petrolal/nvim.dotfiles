# Story 33.2: Save All Modified Files (`<leader>fa`) via `:wall`

Status: done

## Story

As a Developer,  
I want `<leader>fa` configured to save all open modified buffers using `:wall`,  
so that all pending changes across workspace buffers are saved atomically.

## Acceptance Criteria

1. **Given** `lua/cumulus/core/keymaps.lua`,
   - **When** pressing `<leader>fa`,
   - **Then** Neovim executes `:wall` and displays a notification indicating all modified files were saved (`Saved all modified files`).
2. **Given** headless validation command `nvim --headless "+Lazy check" +qa`,
   - **When** executed after changes,
   - **Then** Neovim completes plugin validation with exit code 0 and zero errors.

## Tasks / Subtasks

- [x] Map `<leader>fa` in `lua/cumulus/core/keymaps.lua` (AC: #1)
  - [x] Implement `:wall` call with notification
- [x] Headless Validation (AC: #2)
  - [x] Run `nvim --headless "+Lazy check" +qa` to confirm zero spec syntax errors

## Dev Notes

- **Affected File:** `lua/cumulus/core/keymaps.lua` [keymaps.lua:107-110](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/core/keymaps.lua#L107-L110)

### References

- [Epics Document: Epic 33](file://_bmad-output/planning-artifacts/epics.md#L1040)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Mapped `<leader>fa` to `:wall` with notification in `lua/cumulus/core/keymaps.lua`.
- Confirmed zero errors via `nvim --headless "+Lazy check" +qa`.

### File List

- `lua/cumulus/core/keymaps.lua`
- `_bmad-output/implementation-artifacts/33-2-save-all-modified-files-via-wall.md`
