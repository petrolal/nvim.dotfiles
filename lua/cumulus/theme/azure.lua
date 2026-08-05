-- Cumulus Microsoft Azure Theme Engine (Story 31.1)
local M = {}

M.opts = {
  transparent = false,
}

local palette = {
  azure_blue = "#0078D4",
  azure_cyan = "#00BCF2",
  azure_navy = "#001829",
  statusline_bg = "#00101C",

  bg = "#001829",
  bg_sidebar = "#001220",
  bg_float = "#002238",
  bg_inactive = "#001424",
  bg_statusline = "#00101C",
  bg_cursorline = "#002B47",
  bg_visual = "#003A60",
  bg_selection = "#003A60",

  fg = "#E2F1FF",
  fg_dim = "#8CBBD9",
  fg_gutter = "#234D6B",

  primary = "#0078D4",
  secondary = "#00BCF2",
  border = "#0078D4",
  comment = "#5C82A6",
  error = "#F87171",

  orange = "#FF8C00",
  yellow = "#FACE15",
  green = "#10B981",
  purple = "#C084FC",
  cyan = "#00BCF2",
  blue = "#0078D4",
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
  vim.g.colors_name = "azure-theme"

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
  hi("CursorLineNr", { fg = palette.azure_cyan, bg = palette.bg_cursorline, bold = true })
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
  hi("FloatBorder", { fg = palette.azure_blue, bg = palette.none })
  hi("FloatTitle", { fg = palette.azure_cyan, bg = bg_float, bold = true })
  hi("FloatFooter", { fg = palette.comment, bg = bg_float })

  -- Visual selection & Search
  hi("Visual", { bg = palette.bg_selection })
  hi("VisualNOS", { bg = palette.bg_visual })
  hi("Search", { fg = palette.bg, bg = palette.azure_cyan })
  hi("IncSearch", { fg = palette.bg, bg = palette.primary })
  hi("CurSearch", { fg = palette.bg, bg = palette.azure_cyan, bold = true })

  -- Statusline
  hi("StatusLine", { fg = palette.fg, bg = palette.statusline_bg })
  hi("StatusLineNC", { fg = palette.comment, bg = bg_sidebar })
  hi("ModeMsg", { fg = palette.azure_cyan, bold = true })
  hi("MsgArea", { fg = palette.fg, bg = bg })

  -- Tabline / Bufferline
  hi("TabLine", { fg = palette.comment, bg = palette.statusline_bg })
  hi("TabLineFill", { bg = palette.statusline_bg })
  hi("TabLineSel", { fg = palette.azure_cyan, bg = palette.bg_cursorline, bold = true })

  -- Syntax Highlighting
  hi("Comment", { fg = palette.comment, italic = true })
  hi("Constant", { fg = palette.yellow })
  hi("String", { fg = palette.green })
  hi("Character", { fg = palette.green })
  hi("Number", { fg = palette.orange })
  hi("Boolean", { fg = palette.orange })
  hi("Float", { fg = palette.orange })

  hi("Identifier", { fg = palette.fg })
  hi("Function", { fg = palette.azure_cyan })
  hi("Statement", { fg = palette.primary, bold = true })
  hi("Conditional", { fg = palette.primary })
  hi("Repeat", { fg = palette.primary })
  hi("Label", { fg = palette.primary })
  hi("Operator", { fg = palette.fg_dim })
  hi("Keyword", { fg = palette.primary, bold = true })
  hi("Exception", { fg = palette.error })

  hi("PreProc", { fg = palette.purple })
  hi("Include", { fg = palette.purple })
  hi("Define", { fg = palette.purple })
  hi("Macro", { fg = palette.purple })

  hi("Type", { fg = palette.cyan })
  hi("StorageClass", { fg = palette.primary })

  -- Diagnostics & UI
  hi("DiagnosticError", { fg = palette.error })
  hi("DiagnosticWarn", { fg = palette.yellow })
  hi("DiagnosticInfo", { fg = palette.secondary })
  hi("DiagnosticHint", { fg = palette.cyan })

  -- Telescope
  hi("TelescopeNormal", { link = "NormalFloat" })
  hi("TelescopeBorder", { fg = palette.azure_blue, bg = palette.none })
  hi("TelescopeSelection", { fg = palette.fg, bg = palette.bg_selection })
  hi("TelescopeMatching", { fg = palette.azure_cyan, bold = true })

  -- Dashboard
  hi("SnacksDashboardHeader", { fg = palette.azure_blue })
  hi("SnacksDashboardKey", { fg = palette.azure_cyan })
  hi("SnacksDashboardDesc", { fg = palette.fg })
  hi("SnacksDashboardFooter", { fg = palette.comment, italic = true })
  hi("SnacksDashboardSpecial", { fg = palette.azure_cyan })
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  M.load()
end

return M
