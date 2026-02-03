local M = {}

-- Theme options (configure transparency)
M.opts = {
  transparent = false,  -- Set to true for terminal transparency
}

-- AWS-Inspired Elite Professional Palette
-- Micro-polished for maximum visual comfort and premium feel
local palette = {
  -- Background hierarchy (ink-like, neutral, layered)
  bg = "#121B25",
  bg_sidebar = "#0E1721",
  bg_float = "#141E28",         -- Glass effect: barely lighter, ultra-low saturation
  bg_inactive = "#0F1820",      -- Dimmed for inactive windows (backdrop)
  bg_statusline = "#0A1419",
  bg_cursorline = "#171F2D",
  bg_visual = "#1C2F3E",
  bg_selection = "#1C2F3E",
  
  -- Foreground (neutral, slightly warm)
  fg = "#D3DAE3",
  fg_dim = "#9FA8B3",
  fg_gutter = "#3A4A58",
  
  -- Orange (refined, softer)
  orange = "#E48A2A",
  orange_dim = "#CC7625",
  orange_soft = "#D9955C",
  orange_warm = "#D89548",
  
  -- Syntax colors (heavily desaturated)
  blue = "#5691B8",
  blue_light = "#6FA4C6",
  blue_dim = "#4A7F9E",
  cyan = "#5B9BA0",
  cyan_dim = "#4E868A",
  green = "#6DAA62",
  green_soft = "#7DB772",
  green_dim = "#5E9150",
  red = "#BE6060",
  red_dim = "#A85454",
  purple = "#9D7AB8",
  magenta = "#B879A8",
  yellow = "#CFA15A",
  
  -- Grays (neutral, no tint)
  gray = "#66707B",
  gray_dim = "#3C4751",
  gray_light = "#7A8694",
  comment = "#626C76",
  
  -- UI accents (refined)
  border = "#D97A1F",           -- Softer orange, guides without dominating
  border_dim = "#456C82",
  
  -- Git colors (muted, professional)
  git_add = "#6DAA62",
  git_change = "#6FA4C6",
  git_delete = "#BE6060",
  
  -- Diagnostic colors (calm authority)
  error = "#BE6060",
  warning = "#D9955C",
  info = "#5691B8",
  hint = "#5B9BA0",
  
  -- Special
  none = "NONE",
}

-- Helper function to set highlights
local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Apply colorscheme
function M.load()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  
  vim.o.termguicolors = true
  vim.g.colors_name = "aws-theme"
  
  -- Force rounded borders globally (premium feel)
  vim.o.winborder = "rounded"
  
  -- Smart background logic for transparency
  local bg = M.opts.transparent and palette.none or palette.bg
  local bg_inactive = M.opts.transparent and palette.none or palette.bg_inactive
  local bg_sidebar = M.opts.transparent and "#0D1620" or palette.bg_sidebar  -- Keep slight tint for depth
  local bg_float = M.opts.transparent and "#162230" or palette.bg_float      -- Subtle glass, never NONE
  
  -- Editor highlights (neutral, calm, ink-like)
  hi("Normal", { fg = palette.fg, bg = bg })
  hi("NormalNC", { fg = palette.fg_dim, bg = bg_inactive })  -- Dimmed inactive windows (backdrop)
  hi("Cursor", { fg = palette.bg, bg = palette.fg })
  hi("lCursor", { fg = palette.bg, bg = palette.fg })
  hi("CursorLine", { bg = palette.bg_cursorline })
  hi("CursorLineNr", { fg = palette.orange, bg = palette.bg_cursorline })
  hi("LineNr", { fg = palette.fg_gutter, bg = bg })
  hi("SignColumn", { fg = palette.fg_gutter, bg = bg })
  hi("EndOfBuffer", { fg = palette.gray_dim, bg = bg })
  hi("VertSplit", { fg = palette.gray_dim, bg = bg })
  hi("WinSeparator", { fg = palette.gray_dim, bg = bg })
  hi("Folded", { fg = palette.gray_light, bg = palette.bg_cursorline })
  hi("FoldColumn", { fg = palette.gray_dim, bg = bg })
  hi("ColorColumn", { bg = palette.bg_cursorline })
  
  -- Floating windows (elevated glass panels - CRITICAL: borders must match float bg)
  hi("NormalFloat", { fg = palette.fg, bg = bg_float })
  hi("FloatBorder", { fg = palette.border, bg = bg_float })  -- MUST match NormalFloat.bg
  hi("FloatTitle", { fg = palette.orange, bg = bg_float, bold = true })
  hi("FloatFooter", { fg = palette.blue_light, bg = bg_float })
  
  -- Visual selection (smooth, not harsh)
  hi("Visual", { bg = palette.bg_selection })
  hi("VisualNOS", { bg = palette.bg_visual })
  
  -- Search (visible but not blinding)
  hi("Search", { fg = palette.bg, bg = palette.orange_soft })
  hi("IncSearch", { fg = palette.bg, bg = palette.orange })
  hi("CurSearch", { fg = palette.bg, bg = palette.orange, bold = true })
  hi("Substitute", { fg = palette.bg, bg = palette.red })
  
  -- Statusline (premium JetBrains-style)
  hi("StatusLine", { fg = palette.fg, bg = palette.bg_statusline })
  hi("StatusLineNC", { fg = palette.gray, bg = bg_sidebar })
  hi("ModeMsg", { fg = palette.orange })
  hi("MsgArea", { fg = palette.fg, bg = bg })
  
  -- Tabline (minimal, clean)
  hi("TabLine", { fg = palette.gray, bg = palette.bg_statusline })
  hi("TabLineFill", { bg = palette.bg_statusline })
  hi("TabLineSel", { fg = palette.orange, bg = palette.bg_cursorline })
  
  -- Popup menu (consistent glass effect)
  hi("Pmenu", { fg = palette.fg, bg = bg_float })
  hi("PmenuSel", { fg = palette.fg, bg = palette.bg_selection })
  hi("PmenuSbar", { bg = palette.gray_dim })
  hi("PmenuThumb", { bg = palette.orange_dim })
  hi("PmenuKind", { fg = palette.blue_light })
  hi("PmenuKindSel", { fg = palette.orange, bg = palette.bg_selection })
  hi("PmenuExtra", { fg = palette.gray })
  hi("PmenuExtraSel", { fg = palette.fg_dim, bg = palette.bg_selection })
  
  -- Miscellaneous
  hi("Conceal", { fg = palette.gray })
  hi("Directory", { fg = palette.blue })
  hi("SpecialKey", { fg = palette.gray_dim })
  hi("Title", { fg = palette.orange, bold = true })
  hi("ErrorMsg", { fg = palette.error })
  hi("WarningMsg", { fg = palette.warning })
  hi("MoreMsg", { fg = palette.blue })
  hi("Question", { fg = palette.blue })
  hi("NonText", { fg = palette.gray_dim })
  hi("Whitespace", { fg = palette.gray_dim })
  hi("MatchParen", { fg = palette.orange_warm, bg = palette.bg_cursorline })
  hi("WildMenu", { fg = palette.bg, bg = palette.orange })
  
  -- Diffs (muted, professional)
  hi("DiffAdd", { fg = palette.git_add, bg = bg })
  hi("DiffChange", { fg = palette.git_change, bg = bg })
  hi("DiffDelete", { fg = palette.git_delete, bg = bg })
  hi("DiffText", { fg = palette.yellow, bg = palette.bg_visual })
  
  -- Spelling
  hi("SpellBad", { sp = palette.error, undercurl = true })
  hi("SpellCap", { sp = palette.warning, undercurl = true })
  hi("SpellLocal", { sp = palette.info, undercurl = true })
  hi("SpellRare", { sp = palette.hint, undercurl = true })
  
  -- Syntax highlighting (refined, professional)
  hi("Comment", { fg = palette.comment, italic = true })
  hi("Constant", { fg = palette.orange_soft })
  hi("String", { fg = palette.green })
  hi("Character", { fg = palette.green_soft })
  hi("Number", { fg = palette.orange_soft })
  hi("Boolean", { fg = palette.orange_dim })
  hi("Float", { fg = palette.orange_soft })
  
  hi("Identifier", { fg = palette.fg })
  hi("Function", { fg = palette.blue_light })
  
  hi("Statement", { fg = palette.orange })
  hi("Conditional", { fg = palette.orange })
  hi("Repeat", { fg = palette.orange })
  hi("Label", { fg = palette.orange })
  hi("Operator", { fg = palette.fg_dim })
  hi("Keyword", { fg = palette.orange })
  hi("Exception", { fg = palette.red })
  
  hi("PreProc", { fg = palette.magenta })
  hi("Include", { fg = palette.magenta })
  hi("Define", { fg = palette.magenta })
  hi("Macro", { fg = palette.magenta })
  hi("PreCondit", { fg = palette.magenta })
  
  hi("Type", { fg = palette.cyan })
  hi("StorageClass", { fg = palette.cyan_dim })
  hi("Structure", { fg = palette.cyan })
  hi("Typedef", { fg = palette.cyan })
  
  hi("Special", { fg = palette.purple })
  hi("SpecialChar", { fg = palette.purple })
  hi("Tag", { fg = palette.blue })
  hi("Delimiter", { fg = palette.fg_dim })
  hi("SpecialComment", { fg = palette.gray_light, italic = true })
  hi("Debug", { fg = palette.red })
  
  hi("Underlined", { fg = palette.blue, underline = true })
  hi("Ignore", { fg = palette.gray_dim })
  hi("Error", { fg = palette.error })
  hi("Todo", { fg = palette.bg, bg = palette.orange })
  
  -- Treesitter (refined, disciplined)
  hi("@variable", { fg = palette.fg })
  hi("@variable.builtin", { fg = palette.cyan_dim })
  hi("@variable.parameter", { fg = palette.fg_dim })
  hi("@variable.member", { fg = palette.fg })
  
  hi("@constant", { fg = palette.orange_soft })
  hi("@constant.builtin", { fg = palette.orange_dim })
  hi("@constant.macro", { fg = palette.magenta })
  
  hi("@module", { fg = palette.cyan })
  hi("@label", { fg = palette.orange })
  
  hi("@string", { fg = palette.green })
  hi("@string.regex", { fg = palette.green_soft })
  hi("@string.escape", { fg = palette.purple })
  hi("@string.special", { fg = palette.purple })
  
  hi("@character", { fg = palette.green_soft })
  hi("@character.special", { fg = palette.purple })
  
  hi("@number", { fg = palette.orange_soft })
  hi("@boolean", { fg = palette.orange_dim })
  hi("@float", { fg = palette.orange_soft })
  
  hi("@function", { fg = palette.blue_light })
  hi("@function.builtin", { fg = palette.blue })
  hi("@function.macro", { fg = palette.magenta })
  hi("@function.method", { fg = palette.blue_light })
  
  hi("@constructor", { fg = palette.cyan })
  hi("@operator", { fg = palette.fg_dim })
  
  hi("@keyword", { fg = palette.orange })
  hi("@keyword.function", { fg = palette.orange })
  hi("@keyword.operator", { fg = palette.orange })
  hi("@keyword.return", { fg = palette.orange })
  hi("@keyword.conditional", { fg = palette.orange })
  hi("@keyword.repeat", { fg = palette.orange })
  hi("@keyword.import", { fg = palette.magenta })
  hi("@keyword.exception", { fg = palette.red })
  
  hi("@type", { fg = palette.cyan })
  hi("@type.builtin", { fg = palette.cyan_dim })
  hi("@type.qualifier", { fg = palette.orange_dim })
  
  hi("@attribute", { fg = palette.purple })
  hi("@property", { fg = palette.fg })
  
  hi("@comment", { fg = palette.comment, italic = true })
  hi("@comment.todo", { fg = palette.bg, bg = palette.orange })
  hi("@comment.warning", { fg = palette.bg, bg = palette.warning })
  hi("@comment.note", { fg = palette.bg, bg = palette.info })
  hi("@comment.error", { fg = palette.bg, bg = palette.error })
  
  hi("@tag", { fg = palette.blue })
  hi("@tag.attribute", { fg = palette.cyan_dim })
  hi("@tag.delimiter", { fg = palette.gray })
  
  hi("@markup.heading", { fg = palette.orange, bold = true })
  hi("@markup.strong", { bold = true })
  hi("@markup.italic", { italic = true })
  hi("@markup.strikethrough", { strikethrough = true })
  hi("@markup.underline", { underline = true })
  hi("@markup.link", { fg = palette.blue, underline = true })
  hi("@markup.raw", { fg = palette.green })
  hi("@markup.list", { fg = palette.orange })
  hi("@markup.quote", { fg = palette.gray_light, italic = true })
  
  hi("@diff.plus", { fg = palette.git_add })
  hi("@diff.minus", { fg = palette.git_delete })
  hi("@diff.delta", { fg = palette.git_change })
  
  -- LSP
  hi("LspReferenceText", { bg = palette.bg_visual })
  hi("LspReferenceRead", { bg = palette.bg_visual })
  hi("LspReferenceWrite", { bg = palette.bg_visual })
  
  hi("LspSignatureActiveParameter", { fg = palette.orange, bold = true })
  hi("LspCodeLens", { fg = palette.comment, italic = true })
  hi("LspInlayHint", { fg = palette.gray_dim, bg = palette.none, italic = true })
  
  hi("LspInfoBorder", { link = "FloatBorder" })
  hi("LspInfoTitle", { link = "FloatTitle" })
  
  -- LSP Diagnostics (calm authority, not screaming)
  hi("DiagnosticError", { fg = palette.error })
  hi("DiagnosticWarn", { fg = palette.warning })
  hi("DiagnosticInfo", { fg = palette.info })
  hi("DiagnosticHint", { fg = palette.hint })
  
  hi("DiagnosticVirtualTextError", { fg = palette.error, bg = palette.none })
  hi("DiagnosticVirtualTextWarn", { fg = palette.warning, bg = palette.none })
  hi("DiagnosticVirtualTextInfo", { fg = palette.info, bg = palette.none })
  hi("DiagnosticVirtualTextHint", { fg = palette.hint, bg = palette.none })
  
  hi("DiagnosticUnderlineError", { sp = palette.error, undercurl = true })
  hi("DiagnosticUnderlineWarn", { sp = palette.warning, undercurl = true })
  hi("DiagnosticUnderlineInfo", { sp = palette.info, undercurl = true })
  hi("DiagnosticUnderlineHint", { sp = palette.hint, undercurl = true })
  
  hi("DiagnosticSignError", { fg = palette.error, bg = bg })
  hi("DiagnosticSignWarn", { fg = palette.warning, bg = bg })
  hi("DiagnosticSignInfo", { fg = palette.info, bg = bg })
  hi("DiagnosticSignHint", { fg = palette.hint, bg = bg })
  
  -- Telescope (premium glass UI, consistent)
  hi("TelescopeNormal", { link = "NormalFloat" })
  hi("TelescopePromptNormal", { link = "NormalFloat" })
  hi("TelescopeResultsNormal", { link = "NormalFloat" })
  hi("TelescopePreviewNormal", { link = "NormalFloat" })
  
  hi("TelescopeBorder", { link = "FloatBorder" })
  hi("TelescopePromptBorder", { link = "FloatBorder" })
  hi("TelescopeResultsBorder", { link = "FloatBorder" })
  hi("TelescopePreviewBorder", { link = "FloatBorder" })
  
  hi("TelescopeTitle", { link = "FloatTitle" })
  hi("TelescopePromptTitle", { link = "FloatTitle" })
  hi("TelescopeResultsTitle", { link = "FloatTitle" })
  hi("TelescopePreviewTitle", { link = "FloatTitle" })
  
  hi("TelescopeSelection", { fg = palette.fg, bg = palette.bg_selection })
  hi("TelescopeSelectionCaret", { fg = palette.orange, bg = palette.bg_selection })
  hi("TelescopeMultiSelection", { fg = palette.blue, bg = palette.bg_visual })
  
  hi("TelescopeMatching", { fg = palette.orange, bold = true })
  hi("TelescopePromptPrefix", { fg = palette.orange })
  
  -- Neo-tree / NvimTree (sidebar with depth - keep slight tint for layering)
  hi("NeoTreeNormal", { fg = palette.fg, bg = bg_sidebar })
  hi("NeoTreeNormalNC", { fg = palette.fg_dim, bg = bg_sidebar })
  hi("NeoTreeDirectoryIcon", { fg = palette.blue })
  hi("NeoTreeDirectoryName", { fg = palette.blue })
  hi("NeoTreeFileName", { fg = palette.fg })
  hi("NeoTreeFileIcon", { fg = palette.fg_dim })
  hi("NeoTreeRootName", { fg = palette.orange, bold = true })
  hi("NeoTreeGitAdded", { fg = palette.git_add })
  hi("NeoTreeGitModified", { fg = palette.git_change })
  hi("NeoTreeGitDeleted", { fg = palette.git_delete })
  hi("NeoTreeGitUntracked", { fg = palette.gray })
  hi("NeoTreeIndentMarker", { fg = palette.gray_dim })
  hi("NeoTreeSymbolicLinkTarget", { fg = palette.cyan })
  hi("NeoTreeWinSeparator", { fg = palette.gray_dim, bg = bg })
  
  hi("NeoTreeFloatNormal", { link = "NormalFloat" })
  hi("NeoTreeFloatBorder", { link = "FloatBorder" })
  hi("NeoTreeFloatTitle", { link = "FloatTitle" })
  hi("NeoTreeTitleBar", { link = "FloatTitle" })
  
  hi("NvimTreeNormal", { fg = palette.fg, bg = bg_sidebar })
  hi("NvimTreeFolderIcon", { fg = palette.blue })
  hi("NvimTreeFolderName", { fg = palette.blue })
  hi("NvimTreeOpenedFolderName", { fg = palette.blue_light })
  hi("NvimTreeRootFolder", { fg = palette.orange, bold = true })
  hi("NvimTreeSpecialFile", { fg = palette.purple })
  hi("NvimTreeGitNew", { fg = palette.git_add })
  hi("NvimTreeGitDirty", { fg = palette.git_change })
  hi("NvimTreeGitDeleted", { fg = palette.git_delete })
  hi("NvimTreeIndentMarker", { fg = palette.gray_dim })
  hi("NvimTreeWinSeparator", { fg = palette.gray_dim, bg = bg })
  
  -- Git signs (muted, professional)
  hi("GitSignsAdd", { fg = palette.git_add, bg = bg })
  hi("GitSignsChange", { fg = palette.git_change, bg = palette.none })
  hi("GitSignsDelete", { fg = palette.git_delete, bg = palette.none })
  hi("GitSignsCurrentLineBlame", { fg = palette.comment, italic = true })
  
  -- WhichKey (explicit override for lightweight glass)
  hi("WhichKeyFloat", { link = "NormalFloat" })     -- Glass background
  hi("WhichKeyNormal", { link = "NormalFloat" })    -- Ensure consistency
  hi("WhichKeyBorder", { link = "FloatBorder" })    -- Soft orange border
  hi("WhichKeyTitle", { link = "FloatTitle" })
  hi("WhichKey", { fg = palette.orange, bold = true })
  hi("WhichKeyGroup", { fg = palette.blue_light })  -- Brighter for hierarchy
  hi("WhichKeyDesc", { fg = palette.fg })
  hi("WhichKeySeparator", { fg = palette.gray })
  hi("WhichKeyValue", { fg = palette.cyan_dim })
  
  -- CMP (completion - consistent glass)
  hi("CmpNormal", { link = "NormalFloat" })
  hi("CmpBorder", { link = "FloatBorder" })
  hi("CmpDocNormal", { link = "NormalFloat" })
  hi("CmpDocBorder", { link = "FloatBorder" })
  
  hi("CmpItemAbbrDeprecated", { fg = palette.gray, strikethrough = true })
  hi("CmpItemAbbrMatch", { fg = palette.orange, bold = true })
  hi("CmpItemAbbrMatchFuzzy", { fg = palette.orange_soft })
  hi("CmpItemKindDefault", { fg = palette.fg_dim })
  hi("CmpItemMenu", { fg = palette.comment, italic = true })
  hi("CmpItemSelected", { fg = palette.fg, bg = palette.bg_selection })
  
  hi("CmpItemKindVariable", { fg = palette.fg })
  hi("CmpItemKindFunction", { fg = palette.blue_light })
  hi("CmpItemKindMethod", { fg = palette.blue_light })
  hi("CmpItemKindClass", { fg = palette.cyan })
  hi("CmpItemKindInterface", { fg = palette.cyan })
  hi("CmpItemKindStruct", { fg = palette.cyan })
  hi("CmpItemKindModule", { fg = palette.cyan })
  hi("CmpItemKindKeyword", { fg = palette.orange })
  hi("CmpItemKindProperty", { fg = palette.fg })
  hi("CmpItemKindField", { fg = palette.fg })
  hi("CmpItemKindEnum", { fg = palette.cyan })
  hi("CmpItemKindSnippet", { fg = palette.purple })
  hi("CmpItemKindText", { fg = palette.fg_dim })
  hi("CmpItemKindFile", { fg = palette.blue })
  hi("CmpItemKindFolder", { fg = palette.blue })
  hi("CmpItemKindConstant", { fg = palette.orange_soft })
  hi("CmpItemKindOperator", { fg = palette.fg_dim })
  hi("CmpItemKindTypeParameter", { fg = palette.cyan_dim })
  
  -- Indent Blankline (subtle)
  hi("IblIndent", { fg = palette.gray_dim })
  hi("IblScope", { fg = palette.gray })
  hi("IndentBlanklineChar", { fg = palette.gray_dim })
  hi("IndentBlanklineContextChar", { fg = palette.gray })
  
  -- Dashboard / Alpha
  hi("DashboardHeader", { fg = palette.orange })
  hi("DashboardCenter", { fg = palette.blue })
  hi("DashboardFooter", { fg = palette.comment, italic = true })
  hi("DashboardShortCut", { fg = palette.orange })
  
  hi("AlphaHeader", { fg = palette.orange })
  hi("AlphaButtons", { fg = palette.blue })
  hi("AlphaFooter", { fg = palette.comment, italic = true })
  hi("AlphaShortcut", { fg = palette.orange })
  
  -- Notify (consistent glass)
  hi("NotifyBackground", { link = "NormalFloat" })
  hi("NotifyERRORBorder", { fg = palette.error, bg = bg_float })
  hi("NotifyWARNBorder", { fg = palette.warning, bg = bg_float })
  hi("NotifyINFOBorder", { fg = palette.info, bg = bg_float })
  hi("NotifyDEBUGBorder", { fg = palette.gray, bg = bg_float })
  hi("NotifyTRACEBorder", { fg = palette.purple, bg = bg_float })
  hi("NotifyERRORTitle", { fg = palette.error })
  hi("NotifyWARNTitle", { fg = palette.warning })
  hi("NotifyINFOTitle", { fg = palette.info })
  hi("NotifyDEBUGTitle", { fg = palette.gray })
  hi("NotifyTRACETitle", { fg = palette.purple })
  
  -- Lazy.nvim (consistent glass)
  hi("LazyNormal", { link = "NormalFloat" })
  hi("LazyBorder", { link = "FloatBorder" })
  hi("LazyButton", { fg = palette.fg_dim, bg = palette.bg_visual })
  hi("LazyButtonActive", { fg = palette.fg, bg = palette.orange })
  hi("LazyH1", { fg = palette.fg, bg = palette.orange, bold = true })
  hi("LazyH2", { fg = palette.orange })
  hi("LazySpecial", { fg = palette.blue })
  hi("LazyProgressDone", { fg = palette.orange })
  hi("LazyProgressTodo", { fg = palette.gray_dim })
  
  -- Mason (consistent glass)
  hi("MasonNormal", { link = "NormalFloat" })
  hi("MasonBorder", { link = "FloatBorder" })
  hi("MasonHeader", { fg = palette.fg, bg = palette.orange, bold = true })
  hi("MasonHeaderSecondary", { fg = palette.fg, bg = palette.blue })
  hi("MasonHighlight", { fg = palette.orange })
  hi("MasonHighlightBlock", { fg = palette.fg, bg = palette.orange })
  hi("MasonHighlightBlockBold", { fg = palette.fg, bg = palette.orange, bold = true })
  hi("MasonMuted", { fg = palette.gray })
  hi("MasonMutedBlock", { bg = palette.bg_visual })
  
  -- Noice (consistent glass)
  hi("NoiceCmdlinePopup", { link = "NormalFloat" })
  hi("NoiceCmdlinePopupBorder", { link = "FloatBorder" })
  hi("NoiceCmdlinePopupTitle", { link = "FloatTitle" })
  hi("NoiceConfirm", { link = "NormalFloat" })
  hi("NoiceConfirmBorder", { link = "FloatBorder" })
  hi("NoiceCmdlineIcon", { fg = palette.orange })
  hi("NoiceCmdlinePrompt", { fg = palette.orange })
  
  -- Navic (subtle breadcrumbs)
  hi("NavicIconsFile", { fg = palette.blue })
  hi("NavicIconsModule", { fg = palette.cyan })
  hi("NavicIconsNamespace", { fg = palette.cyan })
  hi("NavicIconsPackage", { fg = palette.cyan })
  hi("NavicIconsClass", { fg = palette.cyan })
  hi("NavicIconsMethod", { fg = palette.blue_light })
  hi("NavicIconsProperty", { fg = palette.fg })
  hi("NavicIconsField", { fg = palette.fg })
  hi("NavicIconsConstructor", { fg = palette.cyan })
  hi("NavicIconsEnum", { fg = palette.cyan })
  hi("NavicIconsInterface", { fg = palette.cyan })
  hi("NavicIconsFunction", { fg = palette.blue_light })
  hi("NavicIconsVariable", { fg = palette.fg })
  hi("NavicIconsConstant", { fg = palette.orange_soft })
  hi("NavicIconsString", { fg = palette.green })
  hi("NavicIconsNumber", { fg = palette.orange_soft })
  hi("NavicIconsBoolean", { fg = palette.orange_dim })
  hi("NavicIconsArray", { fg = palette.fg })
  hi("NavicIconsObject", { fg = palette.fg })
  hi("NavicIconsKey", { fg = palette.fg })
  hi("NavicIconsNull", { fg = palette.gray })
  hi("NavicIconsEnumMember", { fg = palette.orange_soft })
  hi("NavicIconsStruct", { fg = palette.cyan })
  hi("NavicIconsEvent", { fg = palette.purple })
  hi("NavicIconsOperator", { fg = palette.fg_dim })
  hi("NavicIconsTypeParameter", { fg = palette.cyan_dim })
  hi("NavicText", { fg = palette.fg_dim })
  hi("NavicSeparator", { fg = palette.gray })
  
  -- Trouble (consistent glass)
  hi("TroubleNormal", { link = "NormalFloat" })
  hi("TroubleBorder", { link = "FloatBorder" })
  hi("TroubleText", { fg = palette.fg })
  hi("TroubleCount", { fg = palette.orange })
  
  -- Illuminate (subtle)
  hi("IlluminatedWordText", { bg = palette.bg_visual })
  hi("IlluminatedWordRead", { bg = palette.bg_visual })
  hi("IlluminatedWordWrite", { bg = palette.bg_visual })
  
  -- Hop / Flash (disciplined orange)
  hi("HopNextKey", { fg = palette.orange, bold = true })
  hi("HopNextKey1", { fg = palette.blue_light, bold = true })
  hi("HopNextKey2", { fg = palette.blue })
  hi("HopUnmatched", { fg = palette.gray_dim })
  
  hi("FlashBackdrop", { fg = palette.gray_dim })
  hi("FlashLabel", { fg = palette.bg, bg = palette.orange, bold = true })
  hi("FlashMatch", { fg = palette.blue_light })
  hi("FlashCurrent", { fg = palette.orange })
  
  -- Mini.nvim
  hi("MiniIndentscopeSymbol", { fg = palette.orange })
  hi("MiniJump", { fg = palette.bg, bg = palette.orange, bold = true })
  hi("MiniStarterHeader", { fg = palette.orange })
  hi("MiniStarterFooter", { fg = palette.comment, italic = true })
  hi("MiniStarterCurrent", { fg = palette.fg })
  hi("MiniStarterSection", { fg = palette.blue })
  hi("MiniStarterItem", { fg = palette.fg })
  hi("MiniStarterQuery", { fg = palette.orange })
  
  -- Aerial (sidebar consistency)
  hi("AerialNormal", { fg = palette.fg, bg = palette.bg_sidebar })
  hi("AerialLine", { bg = palette.bg_selection })
  hi("AerialGuide", { fg = palette.gray_dim })
  
  -- BufferLine (premium JetBrains-style tabs)
  hi("BufferLineFill", { bg = palette.bg_statusline })
  hi("BufferLineBackground", { fg = palette.gray, bg = palette.bg_statusline })
  hi("BufferLineBufferSelected", { fg = palette.orange, bg = palette.bg })
  hi("BufferLineBufferVisible", { fg = palette.fg_dim, bg = palette.bg_sidebar })
  hi("BufferLineError", { fg = palette.error, bg = palette.bg_statusline })
  hi("BufferLineErrorSelected", { fg = palette.error, bg = palette.bg })
  hi("BufferLineWarning", { fg = palette.warning, bg = palette.bg_statusline })
  hi("BufferLineWarningSelected", { fg = palette.warning, bg = palette.bg })
  hi("BufferLineInfo", { fg = palette.info, bg = palette.bg_statusline })
  hi("BufferLineInfoSelected", { fg = palette.info, bg = palette.bg })
  hi("BufferLineModified", { fg = palette.git_change, bg = palette.bg_statusline })
  hi("BufferLineModifiedSelected", { fg = palette.git_change, bg = palette.bg })
  hi("BufferLineTab", { fg = palette.gray, bg = palette.bg_statusline })
  hi("BufferLineTabSelected", { fg = palette.orange, bg = palette.bg })
  hi("BufferLineSeparator", { fg = palette.gray_dim, bg = palette.bg_statusline })
  hi("BufferLineIndicatorSelected", { fg = palette.orange, bg = palette.bg })
  
  -- Gitsigns (muted previews)
  hi("GitSignsAddPreview", { fg = palette.git_add, bg = palette.bg_visual })
  hi("GitSignsDeletePreview", { fg = palette.git_delete, bg = palette.bg_visual })
  
  -- Terminal colors (desaturated, professional)
  vim.g.terminal_color_0 = palette.bg
  vim.g.terminal_color_1 = palette.red
  vim.g.terminal_color_2 = palette.green
  vim.g.terminal_color_3 = palette.yellow
  vim.g.terminal_color_4 = palette.blue
  vim.g.terminal_color_5 = palette.purple
  vim.g.terminal_color_6 = palette.cyan
  vim.g.terminal_color_7 = palette.fg
  vim.g.terminal_color_8 = palette.gray
  vim.g.terminal_color_9 = palette.red_dim
  vim.g.terminal_color_10 = palette.green_soft
  vim.g.terminal_color_11 = palette.orange_soft
  vim.g.terminal_color_12 = palette.blue_light
  vim.g.terminal_color_13 = palette.magenta
  vim.g.terminal_color_14 = palette.cyan_dim
  vim.g.terminal_color_15 = palette.fg_dim
end

-- Setup function to configure theme options
function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  M.load()
end

M.load()

return M
