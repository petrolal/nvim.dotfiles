---
baseline_commit: db64133972545c6bde97faf8e116ad091734bfca
---

# Story 38.2: Java AST Refactoring Keymaps Suite

## Status: review

## Story Description
As a Java Developer,  
I want `<leader>cxv` (extract variable), `<leader>cxc` (extract constant), and visual mode `<leader>cxm` (extract method) integrated via JDTLS,  
So that I can refactor Java code structures safely via AST transformations.

## Acceptance Criteria
- [x] **Given** a Java buffer or visual selection, **When** pressing `<leader>cxv`, `<leader>cxc`, or visual `<leader>cxm`, **Then** JDTLS extracts variables, constants, or methods with interactive naming prompts.

## Tasks
- [x] Register `<leader>cxv` (`require("jdtls").extract_variable()`), `<leader>cxc` (`require("jdtls").extract_constant()`), and visual mode `<leader>cxm` (`require("jdtls").extract_method(true)`) in `lua/cumulus/core/keymaps.lua` for `java` filetypes.

## Dev Agent Record

### Implementation Plan
- Updated `lua/cumulus/core/lang-keymaps.lua` to support explicit `mode` properties (e.g. `mode = "v"` for visual selection keybindings).
- Registered AST refactoring keymaps under `<leader>cx` in `lua/cumulus/core/keymaps.lua` for `java`, `kotlin`, and `groovy` filetypes:
  - `<leader>cxv` -> `jdtls.extract_variable()`
  - `<leader>cxc` -> `jdtls.extract_constant()`
  - Visual `<leader>cxm` -> `jdtls.extract_method(true)`

### Debug Log
- Verified headless Lazy plugin load (`nvim --headless "+Lazy check" +qa`) and executed `./scripts/validate.sh` - all 5 automated test suites passed cleanly.

### Completion Notes
- Completed Java AST refactoring keymaps suite for JDTLS.

## File List
- `lua/cumulus/core/lang-keymaps.lua`
- `lua/cumulus/core/keymaps.lua`

## Change Log
- Support `mode` property in `lua/cumulus/core/lang-keymaps.lua`.
- Add `<leader>cxv`, `<leader>cxc`, and visual `<leader>cxm` keymaps in `lua/cumulus/core/keymaps.lua`.
