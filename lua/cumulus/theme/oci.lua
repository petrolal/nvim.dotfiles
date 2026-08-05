-- Cumulus Oracle Cloud Infrastructure (OCI) Theme Engine (Story 31.1)
local M = {}

M.opts = {
  transparent = false,
}

local palette = {
  oci_red = "#C74634",
  oci_amber = "#F2994A",
  oci_charcoal = "#16191D",
  statusline_bg = "#0F1114",

  bg = "#16191D",
  bg_sidebar = "#111317",
  bg_float = "#20242A",
  bg_inactive = "#131519",
  bg_statusline = "#0F1114",
  bg_cursorline = "#262C34",
  bg_visual = "#3E2522",
  bg_selection = "#3E2522",

  fg = "#ECEEF0",
  fg_dim = "#9CA3AF",
  fg_gutter = "#374151",

  primary = "#C74634",
  secondary = "#F2994A",
  border = "#C74634",
  comment = "#6B7280",
  error = "#EF4444",

  orange = "#F97316",
  yellow = "#F59E0B",
  green = "#10B981",
  purple = "#A855F7",
  cyan = "#06B6D4",
  blue = "#3B82F6",
  none = "NONE",
}

M.palette = palette

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

function M.load()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "oci-theme"

  local bg = M.opts.transparent and palette.none or palette.bg
  local bg_inactive = M.opts.transparent and palette.none or palette.bg_inactive
  local bg_sidebar = M.opts.transparent and palette.none or palette.bg_sidebar
  local bg_float = M.opts.transparent and palette.none or palette.bg_float

  -- Editor highlights
  hi("Normal", { fg = palette.fg, bg = bg })
  hi("NormalNC", { fg = palette.fg_dim, bg = bg_inactive })
  hi("Cursor", { fg = palette.bg, bg = palette.primary })
  hi("lCursor", { fg = palette.bg, bg = palette.primary })
  hi("CursorLine", { bg = palette.bg_cursorline })
  hi("CursorLineNr", { fg = palette.oci_amber, bg = palette.bg_cursorline, bold = true })
  hi("LineNr", { fg = palette.fg_gutter, bg = bg })
  hi("SignColumn", { fg = palette.fg_gutter, bg = bg })
  hi("EndOfBuffer", { fg = palette.bg_cursorline, bg = bg })
  hi("VertSplit", { fg = palette.bg_cursorline, bg = bg })
  hi("WinSeparator", { fg = palette.bg_cursorline, bg = bg })
  hi("Folded", { fg = palette.comment, bg = palette.bg_cursorline })
  hi("FoldColumn", { fg = palette.fg_gutter, bg = bg })
  hi("ColorColumn", { bg = palette.bg_cursorline })

  -- Floating windows
  hi("NormalFloat", { fg = palette.fg, bg = bg_float })
  hi("FloatBorder", { fg = palette.oci_red, bg = palette.none })
  hi("FloatTitle", { fg = palette.oci_amber, bg = bg_float, bold = true })
  hi("FloatFooter", { fg = palette.comment, bg = bg_float })

  -- Visual selection & Search
  hi("Visual", { bg = palette.bg_selection })
  hi("VisualNOS", { bg = palette.bg_visual })
  hi("Search", { fg = palette.bg, bg = palette.oci_amber })
  hi("IncSearch", { fg = palette.bg, bg = palette.oci_red })
  hi("CurSearch", { fg = palette.bg, bg = palette.oci_amber, bold = true })

  -- Statusline
  hi("StatusLine", { fg = palette.fg, bg = palette.statusline_bg })
  hi("StatusLineNC", { fg = palette.comment, bg = bg_sidebar })
  hi("ModeMsg", { fg = palette.oci_amber, bold = true })
  hi("MsgArea", { fg = palette.fg, bg = bg })

  -- Tabline / Bufferline
  hi("TabLine", { fg = palette.comment, bg = palette.statusline_bg })
  hi("TabLineFill", { bg = palette.statusline_bg })
  hi("TabLineSel", { fg = palette.oci_amber, bg = palette.bg_cursorline, bold = true })

  -- Syntax Highlighting
  hi("Comment", { fg = palette.comment, italic = true })
  hi("Constant", { fg = palette.yellow })
  hi("String", { fg = palette.green })
  hi("Character", { fg = palette.green })
  hi("Number", { fg = palette.orange })
  hi("Boolean", { fg = palette.orange })
  hi("Float", { fg = palette.orange })

  hi("Identifier", { fg = palette.fg })
  hi("Function", { fg = palette.secondary })
  hi("Statement", { fg = palette.oci_red, bold = true })
  hi("Conditional", { fg = palette.oci_red })
  hi("Repeat", { fg = palette.oci_red })
  hi("Label", { fg = palette.oci_red })
  hi("Operator", { fg = palette.fg_dim })
  hi("Keyword", { fg = palette.oci_red, bold = true })
  hi("Exception", { fg = palette.error })

  hi("PreProc", { fg = palette.purple })
  hi("Include", { fg = palette.purple })
  hi("Define", { fg = palette.purple })
  hi("Macro", { fg = palette.purple })

  hi("Type", { fg = palette.cyan })
  hi("StorageClass", { fg = palette.oci_red })

  -- Diagnostics & UI
  hi("DiagnosticError", { fg = palette.error })
  hi("DiagnosticWarn", { fg = palette.yellow })
  hi("DiagnosticInfo", { fg = palette.secondary })
  hi("DiagnosticHint", { fg = palette.cyan })

  -- Telescope
  hi("TelescopeNormal", { link = "NormalFloat" })
  hi("TelescopeBorder", { fg = palette.oci_red, bg = palette.none })
  hi("TelescopeSelection", { fg = palette.fg, bg = palette.bg_selection })
  hi("TelescopeMatching", { fg = palette.oci_amber, bold = true })

  -- Dashboard
  hi("SnacksDashboardHeader", { fg = palette.oci_red })
  hi("SnacksDashboardKey", { fg = palette.oci_amber })
  hi("SnacksDashboardDesc", { fg = palette.fg })
  hi("SnacksDashboardFooter", { fg = palette.comment, italic = true })
  hi("SnacksDashboardSpecial", { fg = palette.oci_red })
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  M.load()
end

return M
