local M = {}

M.opts = {
  transparent = false,
}

local palette = {
  bg = "#151B23",
  bg_sidebar = "#0D1117",
  bg_float = "#1C2128",
  bg_inactive = "#0F1419",
  bg_statusline = "#0A0E14",
  bg_cursorline = "#21262D",
  bg_visual = "#263545",
  bg_selection = "#263545",

  fg = "#D1D9E0",
  fg_dim = "#9BA3AF",
  fg_gutter = "#30363D",

  primary = "#2A7EBF",   -- Azul Team BLU
  secondary = "#45B7A0", -- Verde Diagnóstico Teal (menos saturado)
  border = "#34495E",    -- Cinza Azulado
  comment = "#5D6D7E",
  error = "#E67E22",

  -- Derived colors for compatibility with aws-theme structure
  orange = "#E67E22",
  yellow = "#F1C40F",
  green = "#45B7A0",
  purple = "#9B59B6",
  magenta = "#8E44AD",
  cyan = "#1ABC9C",
  blue = "#3498DB",
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
  vim.g.colors_name = "sentry-blu"

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
  hi("Directory", { fg = palette.primary })
  hi("Title", { fg = palette.primary, bold = true })
  hi("ErrorMsg", { fg = palette.error })
  hi("WarningMsg", { fg = palette.secondary })
  hi("MatchParen", { fg = palette.secondary, bg = palette.bg_cursorline, bold = true })

  -- Syntax highlighting (CRITICAL: keywords, static, volatile, const use primary)
  hi("Comment", { fg = palette.comment, italic = true })
  hi("Constant", { fg = palette.secondary })
  hi("String", { fg = palette.secondary })
  hi("Character", { fg = palette.secondary })
  hi("Number", { fg = palette.secondary })
  hi("Boolean", { fg = palette.secondary })
  hi("Float", { fg = palette.secondary })

  hi("Identifier", { fg = palette.fg })
  hi("Function", { fg = palette.primary })

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

  hi("Underlined", { fg = palette.primary, underline = true })
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

  hi("@string", { fg = palette.secondary })
  hi("@string.regex", { fg = palette.secondary })
  hi("@string.escape", { fg = palette.secondary })

  hi("@number", { fg = palette.secondary })
  hi("@boolean", { fg = palette.secondary })
  hi("@float", { fg = palette.secondary })

  hi("@function", { fg = palette.primary })
  hi("@function.builtin", { fg = palette.primary })
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
  hi("DiagnosticInfo", { fg = palette.primary })
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
  hi("NeoTreeFileIcon", { fg = palette.primary }) -- Ícones de arquivo em azul
  hi("NeoTreeDirectoryIcon", { fg = palette.primary }) -- Ícones de pasta em azul
  hi("NeoTreeGitAdded", { fg = palette.primary }) -- Engrenagem em azul
  hi("NeoTreeGitModified", { fg = palette.secondary }) -- Chave inglesa em verde diagnóstico
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

  -- Lazy / Mason / WhichKey (UI states)
  hi("LazyButtonActive", { fg = palette.bg, bg = palette.secondary })
  hi("LazyH1", { fg = palette.bg, bg = palette.primary })
  hi("LazySpecial", { fg = palette.secondary })
  hi("MasonHeader", { fg = palette.bg, bg = palette.primary })
  hi("MasonHighlight", { fg = palette.secondary })
  hi("MasonHighlightBlock", { fg = palette.bg, bg = palette.secondary })
  hi("WhichKey", { fg = palette.secondary })
  hi("WhichKeyGroup", { fg = palette.primary })
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  M.load()
end

return M
