# Story 30.1: WhichKey Nerd Font v3 Icon Standardization

Status: done

## Story

As a UX Designer,  
I want raw emojis in `ui-whichkey.lua` (such as `🔭 `) replaced with high-clarity Nerd Font v3 icons (`󰈞 `),  
so that WhichKey group menus render cleanly without font underline artifacts or misaligned text heights.

## Acceptance Criteria

1. **Given** `lua/cumulus/plugins/ui-whichkey.lua`,
   - **When** WhichKey initializes group headers,
   - **Then** all group icons use valid Nerd Font v3 glyphs, and raw emojis (e.g. `🔭 `) are completely removed.
2. **Given** WhichKey popup window,
   - **When** pressing `<leader>`,
   - **Then** all group headers render uniform Nerd Font v3 icons without font underline glitches or character clipping.
3. **Given** headless validation command `nvim --headless "+Lazy check" +qa`,
   - **When** executed after changes,
   - **Then** Neovim completes plugin validation with exit code 0 and zero errors.

## Tasks / Subtasks

- [x] Standardize icons in `lua/cumulus/plugins/ui-whichkey.lua` (AC: #1, #2)
  - [x] Replace `{ "<leader>t", group = "telescope search", icon = "🔭 " }` with `{ "<leader>t", group = "telescope search", icon = "󰈞 " }`
  - [x] Verify all 12 group headers use clean Nerd Font v3 glyphs
- [x] Headless Validation (AC: #3)
  - [x] Run `nvim --headless "+Lazy check" +qa` to confirm zero spec syntax errors

## Dev Notes

- **Primary Goal:** Eliminate font rendering glitches and underline artifacts caused by raw Unicode emoji fallbacks.
- **Affected Files:**
  - `lua/cumulus/plugins/ui-whichkey.lua` [ui-whichkey.lua:9-22](file:///home/petrolal/Projects/Linux/neovim-dotfiles/lua/cumulus/plugins/ui-whichkey.lua#L9-L22)

### References

- [Epics Document: Epic 30](file://_bmad-output/planning-artifacts/epics.md#L946)
- [Sprint Status](file://_bmad-output/implementation-artifacts/sprint-status.yaml)

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash (High)

### Debug Log References

### Completion Notes List

- Replaced raw emoji icon in `lua/cumulus/plugins/ui-whichkey.lua` with Nerd Font v3 icon (`󰈞 `).
- Confirmed zero errors via `nvim --headless "+Lazy check" +qa`.

### File List

- `lua/cumulus/plugins/ui-whichkey.lua`
- `_bmad-output/implementation-artifacts/30-1-whichkey-nerd-font-v3-icon-standardization.md`

