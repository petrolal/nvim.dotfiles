# Story 29.1: Global `confirm` Option Enablement & Safe Exit Keymaps

Status: done

## Story

As a Developer,  
I want `vim.opt.confirm = true` set in options and exit shortcuts configured to prompt for save confirmation,  
so that exiting Neovim with unsaved changes prompts me to save, discard, or cancel instead of failing or losing data.

## Acceptance Criteria

1. **Given** modified buffers in Neovim,
   - **When** attempting to quit via `:q`, `:qa`, or `<leader>qq`,
   - **Then** Neovim presents a confirmation dialog prompting to save changes, discard, or cancel exit (`Save changes to "..."? [Y]es, (N)o, (C)ancel:`).
2. **Given** `lua/cumulus/core/options.lua`,
   - **When** Neovim initializes,
   - **Then** `vim.opt.confirm = true` is set globally.
3. **Given** `lua/cumulus/core/keymaps.lua` and `lua/cumulus/plugins/editor-snacks.lua`,
   - **When** triggering `<leader>qq` or dashboard quit action (`key = "q"`),
   - **Then** `:confirm qa` is executed instead of unconfirmed `:qa`.
4. **Given** headless validation command `nvim --headless "+Lazy check" +qa`,
   - **When** executed after changes,
   - **Then** Neovim completes plugin validation with exit code 0 and zero errors.

## Tasks / Subtasks

- [x] Enable `confirm` option in `lua/cumulus/core/options.lua` (AC: #1, #2)
  - [x] Add `vim.opt.confirm = true` to core options
- [x] Update exit keymaps in `lua/cumulus/core/keymaps.lua` (AC: #1, #3)
  - [x] Map `<leader>qq` to `<cmd>confirm qa<cr>` with description `"Quit Neovim (Confirm)"`
  - [x] Map `<leader>qQ` to `<cmd>qa!<cr>` with description `"Force Quit Neovim (No Save)"`
- [x] Update Dashboard Quit action in `lua/cumulus/plugins/editor-snacks.lua` (AC: #1, #3)
  - [x] Change `{ action = ":qa" }` to `{ action = ":confirm qa" }`
- [x] Headless Validation (AC: #4)
  - [x] Run `nvim --headless "+Lazy check" +qa` to confirm zero spec syntax errors

## Dev Notes

- **Primary Goal:** Protect developers against accidental loss of unsaved changes upon exit.
- **Affected Files:**
  - `lua/cumulus/core/options.lua` [options.lua:1-19](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/core/options.lua#L1-L19)
  - `lua/cumulus/core/keymaps.lua` [keymaps.lua:1-85](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/core/keymaps.lua#L1-L85)
  - `lua/cumulus/plugins/editor-snacks.lua` [editor-snacks.lua:130-135](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/plugins/editor-snacks.lua#L130-L135)

### References

- [Epics Document: Epic 29](file://_bmad-output/planning-artifacts/epics.md#L918)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Enabled `vim.opt.confirm = true` in `lua/cumulus/core/options.lua`.
- Added `<leader>qq` (`:confirm qa`) and `<leader>qQ` (`:qa!`) in `lua/cumulus/core/keymaps.lua`.
- Updated Dashboard Quit action to `:confirm qa` in `lua/cumulus/plugins/editor-snacks.lua`.
- Verified with `nvim --headless "+Lazy check" +qa` (exit code 0).

### File List

- `lua/cumulus/core/options.lua`
- `lua/cumulus/core/keymaps.lua`
- `lua/cumulus/plugins/editor-snacks.lua`
- `_bmad-output/implementation-artifacts/29-1-global-confirm-option-enablement-safe-exit-keymaps.md`

