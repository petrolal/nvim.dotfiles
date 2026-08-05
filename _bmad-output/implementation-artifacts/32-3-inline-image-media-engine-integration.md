# Story 32.3: Inline Image & Media Engine Integration (`Snacks.image` / `image.nvim`)

Status: done

## Story

As a Developer,  
I want inline image rendering for `.png`, `.jpg`, `.svg`, and `.webp` files,  
so that images referenced in Markdown documents display directly within Neovim.

## Acceptance Criteria

1. **Given** `lua/cumulus/plugins/editor-snacks.lua`,
   - **When** `Snacks.image` module is enabled (`opts.image = { enabled = true }`),
   - **Then** Neovim detects terminal graphics capability and renders inline image attachments.
2. **Given** image files (.png, .jpg, .svg, .webp),
   - **When** opening or previewing,
   - **Then** images render inline inside Neovim terminal windows.
3. **Given** headless validation command `nvim --headless "+Lazy check" +qa`,
   - **When** executed after changes,
   - **Then** Neovim completes plugin validation with exit code 0 and zero errors.

## Tasks / Subtasks

- [x] Enable `Snacks.image` module in `lua/cumulus/plugins/editor-snacks.lua` (AC: #1, #2)
  - [x] Add `opts.image = { enabled = true, doc = { inline = true } }`
- [x] Headless Validation (AC: #3)
  - [x] Run `nvim --headless "+Lazy check" +qa` to confirm zero spec syntax errors

## Dev Notes

- **Affected File:** `lua/cumulus/plugins/editor-snacks.lua`

### References

- [Epics Document: Epic 32](file://_bmad-output/planning-artifacts/epics.md#L1002)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Enabled `Snacks.image` module (`doc = { inline = true }`) in `lua/cumulus/plugins/editor-snacks.lua`.
- Confirmed zero errors via `nvim --headless "+Lazy check" +qa`.

### File List

- `lua/cumulus/plugins/editor-snacks.lua`
- `_bmad-output/implementation-artifacts/32-3-inline-image-media-engine-integration.md`

