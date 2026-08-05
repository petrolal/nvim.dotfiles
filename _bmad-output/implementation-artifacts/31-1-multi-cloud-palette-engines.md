# Story 31.1: Multi-Cloud Palette Engines

Status: done

## Story

As a DevOps Engineer,  
I want dedicated theme engines for Azure (`azure.lua`), GCP (`gcp.lua`), and OCI (`oci.lua`),  
so that I can switch my editor aesthetic to match my target cloud provider platform.

## Acceptance Criteria

1. **Given** `lua/cumulus/theme/azure.lua`,
   - **When** executing `colorscheme azure-theme` or `require("cumulus.theme.azure").load()`,
   - **Then** Neovim applies signature Azure Cloud highlights (Azure Blue `#0078D4`, Deep Navy `#001829`).
2. **Given** `lua/cumulus/theme/gcp.lua`,
   - **When** executing `colorscheme gcp-theme` or `require("cumulus.theme.gcp").load()`,
   - **Then** Neovim applies signature Google Cloud highlights (Google Blue `#4285F4`, Red `#EA4335`, Green `#34A853`, Yellow `#FBBC05`, Dark Slate `#17191C`).
3. **Given** `lua/cumulus/theme/oci.lua`,
   - **When** executing `colorscheme oci-theme` or `require("cumulus.theme.oci").load()`,
   - **Then** Neovim applies signature Oracle Cloud Infrastructure highlights (OCI Redwood Red `#C74634`, Amber `#F2994A`, Charcoal `#16191D`).
4. **Given** headless validation command `nvim --headless "+colorscheme azure-theme" "+colorscheme gcp-theme" "+colorscheme oci-theme" +qa`,
   - **When** executed after theme creation,
   - **Then** Neovim loads all three cloud themes cleanly with exit code 0.

## Tasks / Subtasks

- [x] Build Azure Theme Engine (`lua/cumulus/theme/azure.lua`) (AC: #1)
  - [x] Define Azure brand palette tokens (`azure_blue`, `azure_cyan`, `azure_navy`)
  - [x] Implement highlight generator function mapping editor, float, telescope, and statusline groups
- [x] Build GCP Theme Engine (`lua/cumulus/theme/gcp.lua`) (AC: #2)
  - [x] Define GCP brand palette tokens (`gcp_blue`, `gcp_red`, `gcp_green`, `gcp_yellow`, `gcp_dark`)
  - [x] Implement highlight generator function
- [x] Build OCI Theme Engine (`lua/cumulus/theme/oci.lua`) (AC: #3)
  - [x] Define OCI brand palette tokens (`oci_red`, `oci_amber`, `oci_charcoal`)
  - [x] Implement highlight generator function
- [x] Headless Validation (AC: #4)
  - [x] Verify each theme loads cleanly via headless command

## Dev Notes

- **Primary Pattern:** Match `lua/cumulus/theme/aws.lua` [aws.lua:1-153](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/theme/aws.lua#L1-L153).
- **Affected Directory:** `lua/cumulus/theme/`

### References

- [Epics Document: Epic 31](file://_bmad-output/planning-artifacts/epics.md#L968)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Built `lua/cumulus/theme/azure.lua` and `colors/azure-theme.vim`.
- Built `lua/cumulus/theme/gcp.lua` and `colors/gcp-theme.vim`.
- Built `lua/cumulus/theme/oci.lua` and `colors/oci-theme.vim`.
- Verified all 4 cloud themes load cleanly via headless command (exit code 0).

### File List

- `lua/cumulus/theme/azure.lua`
- `colors/azure-theme.vim`
- `lua/cumulus/theme/gcp.lua`
- `colors/gcp-theme.vim`
- `lua/cumulus/theme/oci.lua`
- `colors/oci-theme.vim`
- `_bmad-output/implementation-artifacts/31-1-multi-cloud-palette-engines.md`

