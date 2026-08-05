# Story 31.2: Interactive Cloud Theme Switcher Keymap & Persistence

Status: done

## Story

As a Cloud Specialist,  
I want `<leader>ut` mapped to an interactive Cloud Theme selector picker that persists my selection across restarts,  
so that I can select and switch cloud themes effortlessly.

## Acceptance Criteria

1. **Given** `lua/cumulus/theme/init.lua`,
   - **When** calling `require("cumulus.theme").select_theme()`,
   - **Then** a picker displays AWS 🟧, Azure 🟦, GCP 🟩, and OCI 🟥 theme options.
2. **Given** `lua/cumulus/core/keymaps.lua`,
   - **When** pressing `<leader>ut`,
   - **Then** `select_theme()` is executed.
3. **Given** a selected theme option,
   - **When** chosen from the picker,
   - **Then** the selection is applied immediately and persisted in state storage (`vim.fn.stdpath("state") .. "/cumulus_theme"`), auto-reloading on next Neovim startup.
4. **Given** headless validation command `nvim --headless "+Lazy check" +qa`,
   - **When** executed after changes,
   - **Then** Neovim completes plugin validation with exit code 0 and zero errors.

## Tasks / Subtasks

- [x] Build theme switcher & state storage in `lua/cumulus/theme/init.lua` (AC: #1, #3)
  - [x] Implement `select_theme()`, `set_theme()`, and `load_saved_theme()`
- [x] Bind `<leader>ut` in `lua/cumulus/core/keymaps.lua` (AC: #2)
  - [x] Add `<leader>ut` mapped to `require("cumulus.theme").select_theme()`
- [x] Update options startup initialization in `lua/cumulus/core/options.lua` (AC: #3)
  - [x] Call `require("cumulus.theme").load_saved_theme()` on vim.schedule
- [x] Headless Validation (AC: #4)
  - [x] Run `nvim --headless "+Lazy check" +qa` to confirm zero spec syntax errors

## Dev Notes

- **Affected Files:**
  - `lua/cumulus/theme/init.lua` [init.lua:1-49](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/theme/init.lua#L1-L49)
  - `lua/cumulus/core/keymaps.lua` [keymaps.lua:89-94](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/core/keymaps.lua#L89-L94)
  - `lua/cumulus/core/options.lua` [options.lua:16-19](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/core/options.lua#L16-L19)

### References

- [Epics Document: Epic 31](file://_bmad-output/planning-artifacts/epics.md#L968)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Implemented theme switcher engine and persistence in `lua/cumulus/theme/init.lua`.
- Mapped `<leader>ut` in `lua/cumulus/core/keymaps.lua`.
- Connected persistent startup loading in `lua/cumulus/core/options.lua`.
- Confirmed zero errors via `nvim --headless "+Lazy check" +qa`.

### File List

- `lua/cumulus/theme/init.lua`
- `lua/cumulus/core/keymaps.lua`
- `lua/cumulus/core/options.lua`
- `_bmad-output/implementation-artifacts/31-2-interactive-cloud-theme-switcher-keymap-persistence.md`
