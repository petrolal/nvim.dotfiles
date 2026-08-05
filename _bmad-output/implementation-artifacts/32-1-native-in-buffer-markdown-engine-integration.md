# Story 32.1: Native In-Buffer Markdown Engine Integration (`render-markdown.nvim`)

Status: done

## Story

As a Technical Writer,  
I want `MeanderingProgrammer/render-markdown.nvim` configured in Cumulus,  
so that Markdown headers, callout boxes (`> [!NOTE]`), table borders, and code blocks render formatted text directly inside Neovim buffers.

## Acceptance Criteria

1. **Given** `lua/cumulus/plugins/editor-markdown.lua`,
   - **When** opening a Markdown file (`.md`),
   - **Then** `render-markdown.nvim` attaches automatically.
2. **Given** Markdown callouts (`[!NOTE]`, `[!TIP]`, `[!WARNING]`, `[!IMPORTANT]`, `[!CAUTION]`),
   - **When** viewing the buffer,
   - **Then** callouts render styled icons and background highlights aligned with the AWS theme palette.
3. **Given** headless validation command `nvim --headless "+Lazy check" +qa`,
   - **When** executed after changes,
   - **Then** Neovim completes plugin validation with exit code 0 and zero errors.

## Tasks / Subtasks

- [x] Create `lua/cumulus/plugins/editor-markdown.lua` (AC: #1, #2)
  - [x] Add `MeanderingProgrammer/render-markdown.nvim` plugin spec
  - [x] Configure header icons, code block borders, checkbox glyphs, and callout rendering
- [x] Headless Validation (AC: #3)
  - [x] Run `nvim --headless "+Lazy check" +qa` to confirm zero spec syntax errors

## Dev Notes

- **Affected File:** `lua/cumulus/plugins/editor-markdown.lua`

### References

- [Epics Document: Epic 32](file://_bmad-output/planning-artifacts/epics.md#L1002)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Created `lua/cumulus/plugins/editor-markdown.lua` configuring `render-markdown.nvim`.
- Cloned and verified `render-markdown.nvim` via `nvim --headless "+Lazy check" +qa` (exit code 0).

### File List

- `lua/cumulus/plugins/editor-markdown.lua`
- `_bmad-output/implementation-artifacts/32-1-native-in-buffer-markdown-engine-integration.md`

