-- Cumulus AWS Theme Engine (Story 2.1)
local M = {}

M.opts = {
  transparent = false,
}

local palette = {
  aws_orange = "#FF9900",
  aws_navy = "#071521",
  statusline_bg = "#020A12",

  bg = "#071521",
  bg_sidebar = "#040D15",
  bg_float = "#0E1C28",
  bg_inactive = "#050F18",
  bg_statusline = "#020A12",
  bg_cursorline = "#122232",
  bg_visual = "#1E3850",
  bg_selection = "#1E3850",

  fg = "#E0E6ED",
  fg_dim = "#94A3B8",
  fg_gutter = "#2E4057",

  primary = "#FF9900",
  secondary = "#38BDF8",
  border = "#FF9900",
  comment = "#64748B",
  error = "#EF4444",

  orange = "#FF9900",
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
  vim.g.colors_name = "aws-theme"

  local bg = M.opts.transparent and palette.none or palette.bg
  local bg_inactive = M.opts.transparent and palette.none or palette.bg_inactive
  local bg_sidebar = M.opts.transparent and palette.bg_sidebar or palette.bg_sidebar
  local bg_float = M.opts.transparent and palette.bg_float or palette.bg_float

  -- Editor highlights
  hi("Normal", { fg = palette.fg, bg = bg })
  hi("NormalNC", { fg = palette.fg_dim, bg = bg_inactive })
  hi("Cursor", { fg = palette.bg, bg = palette.primary })
  hi("lCursor", { fg = palette.bg, bg = palette.primary })
  hi("CursorLine", { bg = palette.bg_cursorline })
  hi("CursorLineNr", { fg = palette.aws_orange, bg = palette.bg_cursorline, bold = true })
  hi("LineNr", { fg = palette.fg_gutter, bg = bg })
  hi("SignColumn", { fg = palette.fg_gutter, bg = bg })
  hi("EndOfBuffer", { fg = palette.bg_cursorline, bg = bg })
  hi("VertSplit", { fg = palette.bg_cursorline, bg = bg })
  hi("WinSeparator", { fg = palette.bg_cursorline, bg = bg })
  hi("Folded", { fg = palette.comment, bg = palette.bg_cursorline })
  hi("FoldColumn", { fg = palette.fg_gutter, bg = bg })
  hi("ColorColumn", { bg = palette.bg_cursorline })

  -- Floating windows (FloatBorder bg set to "NONE" per AR3 / Story 2.1 AC2)
  hi("NormalFloat", { fg = palette.fg, bg = bg_float })
  hi("FloatBorder", { fg = palette.aws_orange, bg = palette.none })
  hi("FloatTitle", { fg = palette.aws_orange, bg = bg_float, bold = true })
  hi("FloatFooter", { fg = palette.comment, bg = bg_float })

  -- Visual selection & Search
  hi("Visual", { bg = palette.bg_selection })
  hi("VisualNOS", { bg = palette.bg_visual })
  hi("Search", { fg = palette.bg, bg = palette.aws_orange })
  hi("IncSearch", { fg = palette.bg, bg = palette.secondary })
  hi("CurSearch", { fg = palette.bg, bg = palette.aws_orange, bold = true })

  -- Statusline
  hi("StatusLine", { fg = palette.fg, bg = palette.statusline_bg })
  hi("StatusLineNC", { fg = palette.comment, bg = bg_sidebar })
  hi("ModeMsg", { fg = palette.aws_orange, bold = true })
  hi("MsgArea", { fg = palette.fg, bg = bg })

  -- Tabline / Bufferline
  hi("TabLine", { fg = palette.comment, bg = palette.statusline_bg })
  hi("TabLineFill", { bg = palette.statusline_bg })
  hi("TabLineSel", { fg = palette.aws_orange, bg = palette.bg_cursorline, bold = true })

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
  hi("Statement", { fg = palette.aws_orange, bold = true })
  hi("Conditional", { fg = palette.aws_orange })
  hi("Repeat", { fg = palette.aws_orange })
  hi("Label", { fg = palette.aws_orange })
  hi("Operator", { fg = palette.fg_dim })
  hi("Keyword", { fg = palette.aws_orange, bold = true })
  hi("Exception", { fg = palette.error })

  hi("PreProc", { fg = palette.purple })
  hi("Include", { fg = palette.purple })
  hi("Define", { fg = palette.purple })
  hi("Macro", { fg = palette.purple })

  hi("Type", { fg = palette.cyan })
  hi("StorageClass", { fg = palette.aws_orange })

  -- Diagnostics & UI
  hi("DiagnosticError", { fg = palette.error })
  hi("DiagnosticWarn", { fg = palette.yellow })
  hi("DiagnosticInfo", { fg = palette.secondary })
  hi("DiagnosticHint", { fg = palette.cyan })

  -- Telescope
  hi("TelescopeNormal", { link = "NormalFloat" })
  hi("TelescopeBorder", { fg = palette.aws_orange, bg = palette.none })
  hi("TelescopeSelection", { fg = palette.fg, bg = palette.bg_selection })
  hi("TelescopeMatching", { fg = palette.aws_orange, bold = true })

  -- Dashboard
  hi("SnacksDashboardHeader", { fg = palette.aws_orange })
  hi("SnacksDashboardKey", { fg = palette.secondary })
  hi("SnacksDashboardDesc", { fg = palette.fg })
  hi("SnacksDashboardFooter", { fg = palette.comment, italic = true })
  hi("SnacksDashboardSpecial", { fg = palette.aws_orange })
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  M.load()
end

return M
