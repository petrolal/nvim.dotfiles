# Story 33.1: Save Current File (`<leader>fs` & `<C-s>`) via `:update`

Status: done

## Story

As a Developer,  
I want `<leader>fs` and `<C-s>` configured to save the current buffer using `:update`,  
so that modified files are saved to disk with clear visual feedback.

## Acceptance Criteria

1. **Given** an active buffer in Neovim,
   - **When** pressing `<leader>fs` or `<C-s>`,
   - **Then** Neovim executes `:update` and notifies the user upon save (`Saved <filename>`).
2. **Given** `lua/cumulus/core/keymaps.lua`,
   - **When** keymaps initialize,
   - **Then** `<leader>fs` and `<C-s>` are bound in Normal and Insert modes.
3. **Given** headless validation command `nvim --headless "+Lazy check" +qa`,
   - **When** executed after changes,
   - **Then** Neovim completes plugin validation with exit code 0 and zero errors.

## Tasks / Subtasks

- [x] Map `<leader>fs` and `<C-s>` in `lua/cumulus/core/keymaps.lua` (AC: #1, #2)
  - [x] Implement `:update` call with filename notification
  - [x] Bind in Normal and Insert modes
- [x] Headless Validation (AC: #3)
  - [x] Run `nvim --headless "+Lazy check" +qa` to confirm zero spec syntax errors

## Dev Notes

- **Affected File:** `lua/cumulus/core/keymaps.lua` [keymaps.lua:1-96](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/core/keymaps.lua#L1-L96)

### References

- [Epics Document: Epic 33](file://_bmad-output/planning-artifacts/epics.md#L1040)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Mapped `<leader>fs` and `<C-s>` to `:update` with notification in `lua/cumulus/core/keymaps.lua`.
- Confirmed zero errors via `nvim --headless "+Lazy check" +qa`.

### File List

- `lua/cumulus/core/keymaps.lua`
- `_bmad-output/implementation-artifacts/33-1-save-current-file-via-update.md`

