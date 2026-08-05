# Story 34.1: Search Bar & Notification Prompt Cloud Glyph Standardization

Status: ready-for-dev

## Story

As a UX Designer,  
I want text headers like `"Cumulus >"` in search pickers and notifications replaced with the minimalist cloud glyph (`☁ `),  
so that search prompts and notification titles are clean, modern, and uncluttered.

## Acceptance Criteria

1. **Given** `lua/cumulus/plugins/editor-snacks.lua`,
   - **When** search pickers or notifications initialize,
   - **Then** picker prompts use `" ☁ > "` and notification window titles use `" ☁ "` instead of `" Cumulus > "`.
2. **Given** search pickers and notification windows,
   - **When** displayed on screen,
   - **Then** prompt text renders the signature `☁ ` cloud glyph cleanly without text truncation or horizontal overflow.
3. **Given** headless validation command `nvim --headless "+Lazy check" +qa`,
   - **When** executed after changes,
   - **Then** Neovim completes plugin validation with exit code 0 and zero errors.

## Tasks / Subtasks

- [ ] Update UI prompt strings in `lua/cumulus/plugins/editor-snacks.lua` (AC: #1, #2)
  - [ ] Set `opts.styles.notification.title = " ☁ "`
  - [ ] Set `opts.styles.notification_history.title = " ☁ Notifications "`
  - [ ] Set `opts.picker.prompt = " ☁ > "`
- [ ] Headless Validation (AC: #3)
  - [ ] Run `nvim --headless "+Lazy check" +qa` to confirm zero spec syntax errors

## Dev Notes

- **Affected File:** `lua/cumulus/plugins/editor-snacks.lua` [editor-snacks.lua:15-30](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/plugins/editor-snacks.lua#L15-L30)

### References

- [Epics Document: Epic 34](file://_bmad-output/planning-artifacts/epics.md#L1082)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

### File List

- `_bmad-output/implementation-artifacts/34-1-search-bar-notification-prompt-cloud-glyph-standardization.md`
