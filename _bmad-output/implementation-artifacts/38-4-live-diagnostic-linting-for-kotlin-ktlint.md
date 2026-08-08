---
baseline_commit: db64133972545c6bde97faf8e116ad091734bfca
---

# Story 38.4: Live Diagnostic Linting for Kotlin (`ktlint`)

## Status: review

## Story Description
As a Kotlin Developer,  
I want `kotlin = { "ktlint" }` registered in `nvim-lint`,  
So that Kotlin formatting and style errors display as real-time diagnostic squigglies while editing.

## Acceptance Criteria
- [x] **Given** a `.kt` buffer with formatting issues, **When** editing or saving the buffer, **Then** `nvim-lint` triggers `ktlint` and displays diagnostic squigglies inline.

## Tasks
- [x] Register `kotlin = { "ktlint" }` in `linters_by_ft` in `lua/cumulus/plugins/tools-linting.lua`.

## Dev Agent Record

### Implementation Plan
- Added `kotlin = { "ktlint" }` to `linters_by_ft` in `lua/cumulus/plugins/tools-linting.lua` (`nvim-lint` spec).

### Debug Log
- Verified headless Lazy plugin load (`nvim --headless "+Lazy check" +qa`) and executed `./scripts/validate.sh` - all 5 automated test suites passed cleanly.

### Completion Notes
- Completed real-time `ktlint` diagnostic linting registration for Kotlin buffers.

## File List
- `lua/cumulus/plugins/tools-linting.lua`

## Change Log
- Register `kotlin = { "ktlint" }` in `lua/cumulus/plugins/tools-linting.lua`.
