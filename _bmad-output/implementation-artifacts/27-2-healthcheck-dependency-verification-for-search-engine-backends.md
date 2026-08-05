# Story 27.2: Healthcheck Dependency Verification for Search Engine Backends

Status: done

## Story

As a Systems Architect,  
I want `:checkhealth cumulus` and `:checkhealth telescope` to verify `ripgrep` (`rg`) and `fd` binary installations,  
so that missing search engines are flagged cleanly in health checks without cluttering keymap UX.

## Acceptance Criteria

1. **Given** Neovim environment,
   - **When** running `:checkhealth cumulus` or `:checkhealth telescope`,
   - **Then** health check verifies system executables `rg`, `fd`, and `git`, reporting green status or actionable installation instructions.
2. **Given** `lua/cumulus/health.lua`,
   - **When** required by `:checkhealth`,
   - **Then** `M.check()` executes `vim.health.start("Cumulus Search Engine Backends")` and validates binaries cleanly.
3. **Given** headless validation command `nvim --headless "+checkhealth cumulus" +qa`,
   - **When** executed,
   - **Then** Neovim executes healthcheck with exit code 0.

## Tasks / Subtasks

- [x] Create `lua/cumulus/health.lua` (AC: #1, #2)
  - [x] Add `ripgrep` (`rg`) executable check (`vim.fn.executable("rg")`)
  - [x] Add `fd` executable check (`vim.fn.executable("fd")`)
  - [x] Add `git` executable check (`vim.fn.executable("git")`)
- [x] Verification & Health Check Testing (AC: #3)
  - [x] Execute `nvim --headless "+checkhealth cumulus" +qa`
  - [x] Execute `nvim --headless "+Lazy check" +qa`

## Dev Notes

- Created `lua/cumulus/health.lua` [health.lua:1-21](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/health.lua#L1-L21).
- Healthcheck standard in Neovim 0.10+ uses `vim.health.start`, `vim.health.ok`, `vim.health.warn`, `vim.health.info`.

### References

- [Epics Document: Epic 27](file://_bmad-output/planning-artifacts/epics.md#L861)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Created `lua/cumulus/health.lua` to check search backend binaries (`rg`, `fd`) and `git`.
- Verified with `nvim --headless "+checkhealth cumulus" +qa` (exit code 0).

### File List

- `lua/cumulus/health.lua`
- `_bmad-output/implementation-artifacts/27-2-healthcheck-dependency-verification-for-search-engine-backends.md`
