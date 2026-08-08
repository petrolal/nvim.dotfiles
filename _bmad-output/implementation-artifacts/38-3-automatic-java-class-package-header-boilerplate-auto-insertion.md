---
baseline_commit: db64133972545c6bde97faf8e116ad091734bfca
---

# Story 38.3: Automatic Java Class & Package Header Boilerplate Auto-Insertion

## Status: review

## Story Description
As a Java Developer,  
I want new `.java` files under `src/main/java` or `src/test/java` auto-populated with package declarations and class headers,  
So that creating Java files requires zero manual package declaration boilerplate.

## Acceptance Criteria
- [x] **Given** a newly created `.java` file in a package path, **When** opened for editing, **Then** an autocmd automatically computes the package name and inserts `package ...;` and `public class ... {}`.

## Tasks
- [x] Add `BufNewFile` autocmd for `*.java` in `lua/cumulus/core/autocmds.lua` that derives package name from filepath and inserts boilerplate.

## Dev Agent Record

### Implementation Plan
- Registered a `BufNewFile` autocmd (`cumulus_java_new_file`) for `*.java` buffers in `lua/cumulus/core/autocmds.lua`.
- Calculated relative package directory path from `src/[main|test]/java/` or `src/`, dynamically formatted `package com.example...;` and `public class ClassName {}`, and set initial cursor position inside the class body.

### Debug Log
- Verified headless Lazy plugin load (`nvim --headless "+Lazy check" +qa`) and executed `./scripts/validate.sh` - all 5 automated test suites passed cleanly.

### Completion Notes
- Completed automatic Java class & package header boilerplate auto-insertion autocmd.

## File List
- `lua/cumulus/core/autocmds.lua`

## Change Log
- Add `java_new_file` `BufNewFile` autocmd for `*.java` files in `lua/cumulus/core/autocmds.lua`.
