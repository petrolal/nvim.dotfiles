# Story 33.3: Interactive Save As... (`<leader>fS`) via `vim.ui.input` & `:saveas`

Status: done

## Story

As a Developer,  
I want `<leader>fS` mapped to prompt for a target file path and execute `:saveas`,  
so that I can duplicate or rename the current buffer to a new target path.

## Acceptance Criteria

1. **Given** `lua/cumulus/core/keymaps.lua`,
   - **When** pressing `<leader>fS`,
   - **Then** an interactive prompt requests a new file path (`vim.ui.input`), executes `:saveas!`, and updates the buffer target.
2. **Given** headless validation command `nvim --headless "+Lazy check" +qa`,
   - **When** executed after changes,
   - **Then** Neovim completes plugin validation with exit code 0 and zero errors.

## Tasks / Subtasks

- [x] Map `<leader>fS` in `lua/cumulus/core/keymaps.lua` (AC: #1)
  - [x] Implement interactive `vim.ui.input` prompt and `:saveas!` command
- [x] Headless Validation (AC: #2)
  - [x] Run `nvim --headless "+Lazy check" +qa` to confirm zero spec syntax errors

## Dev Notes

- **Affected File:** `lua/cumulus/core/keymaps.lua` [keymaps.lua:112-120](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/core/keymaps.lua#L112-L120)

### References

- [Epics Document: Epic 33](file://_bmad-output/planning-artifacts/epics.md#L1040)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Mapped `<leader>fS` to interactive `vim.ui.input` and `:saveas!` in `lua/cumulus/core/keymaps.lua`.
- Confirmed zero errors via `nvim --headless "+Lazy check" +qa`.

### File List

- `lua/cumulus/core/keymaps.lua`
- `_bmad-output/implementation-artifacts/33-3-interactive-save-as-via-input-saveas.md`
