# Story 30.2: Global Devicons Integration for Document Tree & Pickers

Status: done

## Story

As a Developer,  
I want `nvim-tree/nvim-web-devicons` configured as a top-level global plugin specification (`lazy = false`),  
so that document trees (`Snacks.explorer`) and Telescope pickers display filetype icons for Terraform, Docker, Ansible, Kotlin, Java, and YAML.

## Acceptance Criteria

1. **Given** `lua/cumulus/plugins/ui-theme.lua`,
   - **When** Neovim initializes,
   - **Then** `nvim-tree/nvim-web-devicons` is loaded globally as a non-lazy plugin (`lazy = false`, `opts = { default = true }`).
2. **Given** document tree (`Snacks.explorer`) or Telescope picker,
   - **When** viewing file listings,
   - **Then** all files render high-clarity devicons corresponding to their file extension.
3. **Given** headless validation command `nvim --headless "+Lazy check" +qa`,
   - **When** executed after changes,
   - **Then** Neovim completes plugin validation with exit code 0 and zero errors.

## Tasks / Subtasks

- [x] Configure global `nvim-web-devicons` spec in `lua/cumulus/plugins/ui-theme.lua` (AC: #1, #2)
  - [x] Add top-level spec `{ "nvim-tree/nvim-web-devicons", lazy = false, opts = { default = true } }`
- [x] Headless Validation (AC: #3)
  - [x] Run `nvim --headless "+Lazy check" +qa` to confirm zero spec syntax errors

## Dev Notes

- **Affected Files:**
  - `lua/cumulus/plugins/ui-theme.lua` [ui-theme.lua:134-142](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/plugins/ui-theme.lua#L134-L142)

### References

- [Epics Document: Epic 30](file://_bmad-output/planning-artifacts/epics.md#L946)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Added top-level `nvim-tree/nvim-web-devicons` spec with `lazy = false` in `lua/cumulus/plugins/ui-theme.lua`.
- Confirmed zero errors via `nvim --headless "+Lazy check" +qa`.

### File List

- `lua/cumulus/plugins/ui-theme.lua`
- `_bmad-output/implementation-artifacts/30-2-global-devicons-integration-for-document-tree-pickers.md`
