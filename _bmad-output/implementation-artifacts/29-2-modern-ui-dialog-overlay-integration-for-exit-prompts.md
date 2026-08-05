# Story 29.2: Modern UI Dialog Overlay Integration for Exit Prompts

Status: done

## Story

As a UX Designer,  
I want exit confirmation prompts to render cleanly via Neovim UI overlays (`vim.ui.select` / `noice`),  
so that confirmation dialogs match the AWS visual theme.

## Acceptance Criteria

1. **Given** exit confirmation prompt triggered by `:confirm q` or `:confirm qa`,
   - **When** prompt is displayed,
   - **Then** choice options (Save / Discard / Cancel) render in an interactive modal overlay aligned with the AWS theme palette.
2. **Given** `lua/cumulus/plugins/ui-noice.lua`,
   - **When** `noice.nvim` is configured,
   - **Then** confirm views (`popupmenu`, `cmdline_popup`) handle prompts without visual artifacts or clipping.
3. **Given** headless validation command `nvim --headless "+Lazy check" +qa`,
   - **When** executed after changes,
   - **Then** Neovim completes plugin validation with exit code 0 and zero errors.

## Tasks / Subtasks

- [x] Verify `confirm` dialog rendering in `lua/cumulus/plugins/ui-noice.lua` (AC: #1, #2)
  - [x] Ensure `noice` `popupmenu` and `cmdline_popup` options handle dialog selection prompts cleanly
- [x] Headless Validation (AC: #3)
  - [x] Run `nvim --headless "+Lazy check" +qa` to confirm zero spec syntax errors

## Dev Notes

- **Affected Files:**
  - `lua/cumulus/plugins/ui-noice.lua` [ui-noice.lua:1-55](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/plugins/ui-noice.lua#L1-L55)
  - `lua/cumulus/plugins/editor-telescope.lua` [editor-telescope.lua:120-132](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/plugins/editor-telescope.lua#L120-L132)

### References

- [Epics Document: Epic 29](file://_bmad-output/planning-artifacts/epics.md#L918)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Verified `noice` popupmenu and cmdline_popup options handle selection dialogs.
- Confirmed zero errors via `nvim --headless "+Lazy check" +qa`.

### File List

- `lua/cumulus/plugins/ui-noice.lua`
- `_bmad-output/implementation-artifacts/29-2-modern-ui-dialog-overlay-integration-for-exit-prompts.md`

