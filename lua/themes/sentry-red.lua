local M = {}

M.opts = {
  transparent = false,
}

local palette = {
  bg = "#2D1B18",
  bg_sidebar = "#251614",
  bg_float = "#35211E",
  bg_inactive = "#281816",
  bg_statusline = "#1F1210",
  bg_cursorline = "#3D2521",
  bg_visual = "#4D332D",
  bg_selection = "#4D332D",

  fg = "#F0EAD6",
  fg_dim = "#C0B8A0",
  fg_gutter = "#5A3A35",

  primary = "#D35400",   -- Laranja Team RED
  secondary = "#F1C40F", -- Amarelo Munição
  border = "#8E44AD",    -- Acento
  comment = "#7F8C8D",
  error = "#C0392B",

  -- Derived colors for compatibility with aws-theme structure
  blue = "#3498DB",
  cyan = "#1ABC9C",
  green = "#2ECC71",
  purple = "#9B59B6",
  magenta = "#8E44AD",
  none = "NONE",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

function M.load()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "sentry-red"

  local bg = M.opts.transparent and palette.none or palette.bg
  local bg_inactive = M.opts.transparent and palette.none or palette.bg_inactive
  local bg_sidebar = M.opts.transparent and palette.bg_sidebar or palette.bg_sidebar
  local bg_float = M.opts.transparent and palette.bg_float or palette.bg_float

  -- Editor highlights
  hi("Normal", { fg = palette.fg, bg = bg })
  hi("NormalNC", { fg = palette.fg_dim, bg = bg_inactive })
  hi("Cursor", { fg = palette.bg, bg = palette.fg })
  hi("lCursor", { fg = palette.bg, bg = palette.fg })
  hi("CursorLine", { bg = palette.bg_cursorline })
  hi("CursorLineNr", { fg = palette.primary, bg = palette.bg_cursorline })
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
  hi("FloatBorder", { fg = palette.border, bg = bg_float })
  hi("FloatTitle", { fg = palette.primary, bg = bg_float, bold = true })
  hi("FloatFooter", { fg = palette.comment, bg = bg_float })

  -- Visual selection
  hi("Visual", { bg = palette.bg_selection })
  hi("VisualNOS", { bg = palette.bg_visual })

  -- Search
  hi("Search", { fg = palette.bg, bg = palette.secondary })
  hi("IncSearch", { fg = palette.bg, bg = palette.primary })
  hi("CurSearch", { fg = palette.bg, bg = palette.primary, bold = true })
  hi("Substitute", { fg = palette.bg, bg = palette.error })

  -- Statusline
  hi("StatusLine", { fg = palette.fg, bg = palette.bg_statusline })
  hi("StatusLineNC", { fg = palette.comment, bg = bg_sidebar })
  hi("ModeMsg", { fg = palette.primary })
  hi("MsgArea", { fg = palette.fg, bg = bg })

  -- Tabline
  hi("TabLine", { fg = palette.comment, bg = palette.bg_statusline })
  hi("TabLineFill", { bg = palette.bg_statusline })
  hi("TabLineSel", { fg = palette.primary, bg = palette.bg_cursorline })

  -- Popup menu
  hi("Pmenu", { fg = palette.fg, bg = bg_float })
  hi("PmenuSel", { fg = palette.fg, bg = palette.bg_selection })
  hi("PmenuSbar", { bg = palette.bg_cursorline })
  hi("PmenuThumb", { bg = palette.primary })

  -- Miscellaneous
  hi("Conceal", { fg = palette.comment })
  hi("Directory", { fg = palette.blue })
  hi("Title", { fg = palette.primary, bold = true })
  hi("ErrorMsg", { fg = palette.error })
  hi("WarningMsg", { fg = palette.secondary })
  hi("MatchParen", { fg = palette.secondary, bg = palette.bg_cursorline, bold = true })

  -- Syntax highlighting (CRITICAL: keywords, static, volatile, const use primary)
  hi("Comment", { fg = palette.comment, italic = true })
  hi("Constant", { fg = palette.secondary })
  hi("String", { fg = palette.green })
  hi("Character", { fg = palette.green })
  hi("Number", { fg = palette.secondary })
  hi("Boolean", { fg = palette.secondary })
  hi("Float", { fg = palette.secondary })

  hi("Identifier", { fg = palette.fg })
  hi("Function", { fg = palette.blue })

  hi("Statement", { fg = palette.primary })
  hi("Conditional", { fg = palette.primary })
  hi("Repeat", { fg = palette.primary })
  hi("Label", { fg = palette.primary })
  hi("Operator", { fg = palette.fg_dim })
  hi("Keyword", { fg = palette.primary }) -- static, volatile, const fall under Keyword/StorageClass
  hi("Exception", { fg = palette.error })

  hi("PreProc", { fg = palette.purple })
  hi("Include", { fg = palette.purple })
  hi("Define", { fg = palette.purple })
  hi("Macro", { fg = palette.purple })
  hi("PreCondit", { fg = palette.purple })

  hi("Type", { fg = palette.cyan })
  hi("StorageClass", { fg = palette.primary }) -- const, static, volatile
  hi("Structure", { fg = palette.cyan })
  hi("Typedef", { fg = palette.cyan })

  hi("Special", { fg = palette.secondary })
  hi("SpecialChar", { fg = palette.secondary })
  hi("Tag", { fg = palette.primary })
  hi("Delimiter", { fg = palette.fg_dim })
  hi("Debug", { fg = palette.error })

  hi("Underlined", { fg = palette.blue, underline = true })
  hi("Ignore", { fg = palette.comment })
  hi("Error", { fg = palette.error })
  hi("Todo", { fg = palette.bg, bg = palette.primary })

  -- Treesitter
  hi("@variable", { fg = palette.fg })
  hi("@variable.builtin", { fg = palette.cyan })
  hi("@variable.parameter", { fg = palette.fg_dim })
  hi("@variable.member", { fg = palette.fg })

  hi("@constant", { fg = palette.secondary })
  hi("@constant.builtin", { fg = palette.secondary })
  hi("@constant.macro", { fg = palette.purple })

  hi("@module", { fg = palette.cyan })
  hi("@label", { fg = palette.primary })

  hi("@string", { fg = palette.green })
  hi("@string.regex", { fg = palette.green })
  hi("@string.escape", { fg = palette.secondary })

  hi("@number", { fg = palette.secondary })
  hi("@boolean", { fg = palette.secondary })
  hi("@float", { fg = palette.secondary })

  hi("@function", { fg = palette.blue })
  hi("@function.builtin", { fg = palette.blue })
  hi("@function.macro", { fg = palette.purple })

  hi("@operator", { fg = palette.fg_dim })

  hi("@keyword", { fg = palette.primary })
  hi("@keyword.function", { fg = palette.primary })
  hi("@keyword.operator", { fg = palette.primary })
  hi("@keyword.return", { fg = palette.primary })
  hi("@keyword.conditional", { fg = palette.primary })
  hi("@keyword.repeat", { fg = palette.primary })
  hi("@keyword.import", { fg = palette.purple })
  hi("@keyword.exception", { fg = palette.error })

  hi("@type", { fg = palette.cyan })
  hi("@type.builtin", { fg = palette.cyan })
  hi("@type.qualifier", { fg = palette.primary }) -- const, static, volatile

  hi("@property", { fg = palette.fg })
  hi("@comment", { fg = palette.comment, italic = true })

  -- LSP
  hi("DiagnosticError", { fg = palette.error })
  hi("DiagnosticWarn", { fg = palette.secondary })
  hi("DiagnosticInfo", { fg = palette.blue })
  hi("DiagnosticHint", { fg = palette.cyan })

  -- Telescope
  hi("TelescopeNormal", { link = "NormalFloat" })
  hi("TelescopeBorder", { link = "FloatBorder" })
  hi("TelescopeSelection", { fg = palette.fg, bg = palette.bg_selection })
  hi("TelescopeMatching", { fg = palette.primary, bold = true })

  -- Neo-tree
  hi("NeoTreeNormal", { fg = palette.fg, bg = bg_sidebar })
  hi("NeoTreeNormalNC", { fg = palette.fg_dim, bg = bg_sidebar })
  hi("NeoTreeRootName", { fg = palette.primary, bold = true })
  hi("NeoTreeDirectoryName", { fg = palette.primary })
  hi("NeoTreeFileName", { fg = palette.fg })
  hi("NeoTreeFileIcon", { fg = palette.primary }) -- Ícones de arquivo em laranja
  hi("NeoTreeDirectoryIcon", { fg = palette.primary }) -- Ícones de pasta em laranja
  hi("NeoTreeGitAdded", { fg = palette.primary }) -- Engrenagem em laranja
  hi("NeoTreeGitModified", { fg = palette.secondary }) -- Chave inglesa em amarelo munição
  hi("NeoTreeGitDeleted", { fg = palette.error })

  -- Dashboard
  hi("AlphaHeader", { fg = palette.primary })
  hi("AlphaButtons", { fg = palette.fg })
  hi("AlphaFooter", { fg = palette.comment, italic = true })
  hi("AlphaShortcut", { fg = palette.secondary })
  hi("AlphaIcon", { fg = palette.primary })

  -- Lualine / Statusline (Overrides)
  hi("LualineIcons", { fg = palette.primary })
  hi("LualineStatus", { fg = palette.secondary })
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  M.load()
end

return M
