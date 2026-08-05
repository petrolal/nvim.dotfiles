# Story 35.2: Complete Automated Validation Script Update (`scripts/validate.sh`)

Status: done

## Story

As a Developer,  
I want `scripts/validate.sh` updated to test all 4 cloud themes (`aws-theme`, `azure-theme`, `gcp-theme`, `oci-theme`), `confirm = true`, `:checkhealth cumulus`, and keymaps,  
so that `./scripts/validate.sh` serves as an automated CLI test suite.

## Acceptance Criteria

1. **Given** terminal shell,
   - **When** executing `./scripts/validate.sh`,
   - **Then** all 5 validation stages (Lazy check, core options & exit confirm, 4 cloud themes, `:checkhealth cumulus`, markdown plugins) pass with exit code 0.
2. **Given** headless validation command `./scripts/validate.sh`,
   - **When** executed after changes,
   - **Then** output confirms `ALL 5 VALIDATIONS PASSED SUCCESSFULLY!`.

## Tasks / Subtasks

- [x] Modernize `scripts/validate.sh` (AC: #1, #2)
  - [x] Test Lazy check, core options (`confirm = true`), all 4 cloud themes, `:checkhealth cumulus`, and markdown modules
- [x] CLI Validation (AC: #1, #2)
  - [x] Run `./scripts/validate.sh` to confirm 100% pass with exit code 0

## Dev Notes

- **Affected File:** `scripts/validate.sh` [validate.sh:1-45](file:///home/petrolal/Projects/Linux/neovim-dotfiles/scripts/validate.sh#L1-L45)

### References

- [Epics Document: Epic 35](file://_bmad-output/planning-artifacts/epics.md#L1098)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Modernized `scripts/validate.sh` to test 5 comprehensive stages.
- Executed `./scripts/validate.sh` with 100% pass rate (exit code 0).

### File List

- `scripts/validate.sh`
- `_bmad-output/implementation-artifacts/35-2-complete-automated-validation-script-update.md`
