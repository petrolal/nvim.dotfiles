# Story 28.2: Ecosystem Terminology Disambiguation Guide

Status: done

## Story

As a Technical Writer,  
I want a clear "Ecosystem Terminology" section added to `README.md` and `docs/architecture.md`,  
so that users clearly understand the difference between `lazy.nvim` (plugin manager), `lazy-lock.json` (SHA lockfile), and `lazygit` (Git TUI).

## Acceptance Criteria

1. **Given** `README.md` and `docs/architecture.md`,
   - **When** reading the architecture and system overview,
   - **Then** an explicit "Ecosystem Terminology" callout section clarifies:
     - `lazy.nvim`: Neovim plugin manager loaded in `lua/cumulus/core/lazy.lua`.
     - `lazy-lock.json`: Auto-generated lockfile pinning git commit SHAs for reproducible builds (unrelated to lazygit).
     - `lazygit`: Optional terminal TUI for Git launched via `<leader>og`.
2. **Given** headless validation command `nvim --headless "+Lazy check" +qa`,
   - **When** executed after documentation updates,
   - **Then** Neovim completes plugin validation with exit code 0 and zero errors.

## Tasks / Subtasks

- [x] Add Ecosystem Terminology callout to `README.md` (AC: #1)
- [x] Add Ecosystem Terminology section to `docs/architecture.md` (AC: #1)
- [x] Headless Validation (AC: #2)
  - [x] Run `nvim --headless "+Lazy check" +qa` to confirm zero spec syntax errors

## Dev Notes

- **Affected Files:**
  - `README.md` [README.md:13](file:///home/petrolal/Projects/Linux/neovim-dotfiles/README.md#L13)
  - `docs/architecture.md` [architecture.md:55](file:///home/petrolal/Projects/Linux/neovim-dotfiles/docs/architecture.md#L55)

### References

- [Epics Document: Epic 28](file://_bmad-output/planning-artifacts/epics.md#L892)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Added Ecosystem Terminology callout to `README.md` and comparison table to `docs/architecture.md`.
- Confirmed zero errors via `nvim --headless "+Lazy check" +qa`.

### File List

- `README.md`
- `docs/architecture.md`
- `_bmad-output/implementation-artifacts/28-2-ecosystem-terminology-disambiguation-guide.md`

