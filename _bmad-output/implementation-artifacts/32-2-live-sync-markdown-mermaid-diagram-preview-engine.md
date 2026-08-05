# Story 32.2: Live Sync Markdown & Mermaid Diagram Preview Engine

Status: done

## Story

As an Architect,  
I want `<leader>mp` mapped to launch a live sync Markdown preview supporting Mermaid flowcharts (`graph TD`, `sequenceDiagram`) and MathJax LaTeX,  
so that I can view rendered architecture diagrams without leaving my workspace.

## Acceptance Criteria

1. **Given** `lua/cumulus/plugins/editor-markdown.lua`,
   - **When** `iamcco/markdown-preview.nvim` is configured,
   - **Then** `:MarkdownPreview` and `:MarkdownPreviewStop` are registered.
2. **Given** a Markdown file containing Mermaid diagrams,
   - **When** pressing `<leader>mp`,
   - **Then** a live synchronized preview window launches in the default web browser displaying rendered Mermaid diagrams and LaTeX.
3. **Given** headless validation command `nvim --headless "+Lazy check" +qa`,
   - **When** executed after changes,
   - **Then** Neovim completes plugin validation with exit code 0 and zero errors.

## Tasks / Subtasks

- [x] Add `iamcco/markdown-preview.nvim` to `lua/cumulus/plugins/editor-markdown.lua` (AC: #1, #2)
  - [x] Configure `build = "cd app && npm install"` or pre-built app step
  - [x] Map `<leader>mp` to `<cmd>MarkdownPreviewToggle<cr>` with description `"Markdown: Toggle Live Preview (Mermaid)"`
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

- Added `iamcco/markdown-preview.nvim` spec and mapped `<leader>mp` in `lua/cumulus/plugins/editor-markdown.lua`.
- Confirmed zero errors via `nvim --headless "+Lazy check" +qa`.

### File List

- `lua/cumulus/plugins/editor-markdown.lua`
- `_bmad-output/implementation-artifacts/32-2-live-sync-markdown-mermaid-diagram-preview-engine.md`

