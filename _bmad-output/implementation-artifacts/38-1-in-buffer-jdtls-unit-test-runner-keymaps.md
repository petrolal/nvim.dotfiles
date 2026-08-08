---
baseline_commit: db64133972545c6bde97faf8e116ad091734bfca
---

# Story 38.1: In-Buffer JDTLS Unit Test Runner Keymaps

## Status: review

## Story Description
As a Developer,  
I want `<leader>cjtm` (test method), `<leader>cjtc` (test class), and `<leader>cjtp` (pick test) keymaps bound to native `nvim-jdtls` test runner APIs,  
So that I can execute individual unit tests instantly with zero build overhead.

## Acceptance Criteria
- [x] **Given** a Java test file, **When** pressing `<leader>cjtm`, `<leader>cjtc`, or `<leader>cjtp`, **Then** JDTLS test runner executes the target method or class directly with in-buffer test results.

## Tasks
- [x] Register `<leader>cjtm` (`require("jdtls").test_nearest_method()`), `<leader>cjtc` (`require("jdtls").test_class()`), and `<leader>cjtp` (`require("jdtls").pick_test()`) in `lua/cumulus/core/keymaps.lua`.

## Dev Agent Record

### Implementation Plan
- Added buffer-local keybindings under `<leader>cj` in `lua/cumulus/core/keymaps.lua` for `java`, `kotlin`, and `groovy` filetypes:
  - `<leader>cjtm` -> `jdtls.test_nearest_method()`
  - `<leader>cjtc` -> `jdtls.test_class()`
  - `<leader>cjtp` -> `jdtls.pick_test()`

### Debug Log
- Verified headless Lazy plugin load (`nvim --headless "+Lazy check" +qa`) and executed `./scripts/validate.sh` - all 5 automated test suites passed cleanly.

### Completion Notes
- Completed in-buffer unit test runner keymap integration for JDTLS.

## File List
- `lua/cumulus/core/keymaps.lua`

## Change Log
- Add `<leader>cjtm`, `<leader>cjtc`, and `<leader>cjtp` buffer-local keymaps in `lua/cumulus/core/keymaps.lua`.
