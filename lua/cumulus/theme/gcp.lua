-- Cumulus Google Cloud Platform (GCP) Theme Engine (Story 31.1)
local M = {}

M.opts = {
  transparent = false,
}

local palette = {
  gcp_blue = "#4285F4",
  gcp_red = "#EA4335",
  gcp_yellow = "#FBBC05",
  gcp_green = "#34A853",
  statusline_bg = "#111418",

  bg = "#17191C",
  bg_sidebar = "#121417",
  bg_float = "#22252A",
  bg_inactive = "#141619",
  bg_statusline = "#111418",
  bg_cursorline = "#262930",
  bg_visual = "#2B364A",
  bg_selection = "#2B364A",

  fg = "#E8EAED",
  fg_dim = "#9AA0A6",
  fg_gutter = "#3C4043",

  primary = "#4285F4",
  secondary = "#34A853",
  border = "#4285F4",
  comment = "#70757A",
  error = "#EA4335",

  orange = "#FF6D00",
  yellow = "#FBBC05",
  green = "#34A853",
  purple = "#A142F4",
  cyan = "#24C1E0",
  blue = "#4285F4",
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
  vim.g.colors_name = "gcp-theme"

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
  hi("CursorLineNr", { fg = palette.gcp_blue, bg = palette.bg_cursorline, bold = true })
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
  hi("FloatBorder", { fg = palette.gcp_blue, bg = palette.none })
  hi("FloatTitle", { fg = palette.gcp_blue, bg = bg_float, bold = true })
  hi("FloatFooter", { fg = palette.comment, bg = bg_float })

  -- Visual selection & Search
  hi("Visual", { bg = palette.bg_selection })
  hi("VisualNOS", { bg = palette.bg_visual })
  hi("Search", { fg = palette.bg, bg = palette.gcp_yellow })
  hi("IncSearch", { fg = palette.bg, bg = palette.gcp_blue })
  hi("CurSearch", { fg = palette.bg, bg = palette.gcp_yellow, bold = true })

  -- Statusline
  hi("StatusLine", { fg = palette.fg, bg = palette.statusline_bg })
  hi("StatusLineNC", { fg = palette.comment, bg = bg_sidebar })
  hi("ModeMsg", { fg = palette.gcp_blue, bold = true })
  hi("MsgArea", { fg = palette.fg, bg = bg })

  -- Tabline / Bufferline
  hi("TabLine", { fg = palette.comment, bg = palette.statusline_bg })
  hi("TabLineFill", { bg = palette.statusline_bg })
  hi("TabLineSel", { fg = palette.gcp_blue, bg = palette.bg_cursorline, bold = true })

  -- Syntax Highlighting
  hi("Comment", { fg = palette.comment, italic = true })
  hi("Constant", { fg = palette.gcp_yellow })
  hi("String", { fg = palette.gcp_green })
  hi("Character", { fg = palette.gcp_green })
  hi("Number", { fg = palette.orange })
  hi("Boolean", { fg = palette.orange })
  hi("Float", { fg = palette.orange })

  hi("Identifier", { fg = palette.fg })
  hi("Function", { fg = palette.gcp_blue })
  hi("Statement", { fg = palette.gcp_red, bold = true })
  hi("Conditional", { fg = palette.gcp_red })
  hi("Repeat", { fg = palette.gcp_red })
  hi("Label", { fg = palette.gcp_red })
  hi("Operator", { fg = palette.fg_dim })
  hi("Keyword", { fg = palette.gcp_blue, bold = true })
  hi("Exception", { fg = palette.error })

  hi("PreProc", { fg = palette.purple })
  hi("Include", { fg = palette.purple })
  hi("Define", { fg = palette.purple })
  hi("Macro", { fg = palette.purple })

  hi("Type", { fg = palette.cyan })
  hi("StorageClass", { fg = palette.gcp_blue })

  -- Diagnostics & UI
  hi("DiagnosticError", { fg = palette.error })
  hi("DiagnosticWarn", { fg = palette.yellow })
  hi("DiagnosticInfo", { fg = palette.gcp_blue })
  hi("DiagnosticHint", { fg = palette.cyan })

  -- Telescope
  hi("TelescopeNormal", { link = "NormalFloat" })
  hi("TelescopeBorder", { fg = palette.gcp_blue, bg = palette.none })
  hi("TelescopeSelection", { fg = palette.fg, bg = palette.bg_selection })
  hi("TelescopeMatching", { fg = palette.gcp_yellow, bold = true })

  -- Dashboard
  hi("SnacksDashboardHeader", { fg = palette.gcp_blue })
  hi("SnacksDashboardKey", { fg = palette.gcp_green })
  hi("SnacksDashboardDesc", { fg = palette.fg })
  hi("SnacksDashboardFooter", { fg = palette.comment, italic = true })
  hi("SnacksDashboardSpecial", { fg = palette.gcp_red })
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  M.load()
end

return M
