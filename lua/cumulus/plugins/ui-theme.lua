-- Cumulus UI Theme & Statusline Integration Specs (Story 2.2)

return {
  -- AWS Theme entry spec
  {
    "cumulus/aws-theme",
    virtual = true,
    lazy = false,
    priority = 1000,
    config = function()
      require("cumulus.theme.aws").load()
    end,
  },

  -- Lualine statusline with AWS Navy statusline background (#020A12) & AWS Orange accents (#FF9900)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local aws = require("cumulus.theme.aws").palette
      local aws_lualine_theme = {
        normal = {
          a = { fg = aws.bg, bg = aws.aws_orange, bold = true },
          b = { fg = aws.fg, bg = aws.bg_cursorline },
          c = { fg = aws.fg_dim, bg = aws.statusline_bg },
        },
        insert = {
          a = { fg = aws.bg, bg = aws.secondary, bold = true },
          b = { fg = aws.fg, bg = aws.bg_cursorline },
          c = { fg = aws.fg_dim, bg = aws.statusline_bg },
        },
        visual = {
          a = { fg = aws.bg, bg = aws.purple, bold = true },
          b = { fg = aws.fg, bg = aws.bg_cursorline },
          c = { fg = aws.fg_dim, bg = aws.statusline_bg },
        },
        replace = {
          a = { fg = aws.bg, bg = aws.error, bold = true },
          b = { fg = aws.fg, bg = aws.bg_cursorline },
          c = { fg = aws.fg_dim, bg = aws.statusline_bg },
        },
        inactive = {
          a = { fg = aws.fg_dim, bg = aws.statusline_bg },
          b = { fg = aws.fg_dim, bg = aws.statusline_bg },
          c = { fg = aws.fg_dim, bg = aws.statusline_bg },
        },
      }

      return {
        options = {
          theme = aws_lualine_theme,
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },

  -- Bufferline with AWS Orange active indicators (#FF9900)
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = function()
      local aws = require("cumulus.theme.aws").palette
      return {
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          indicator = {
            icon = "▎",
            style = "icon",
          },
          separator_style = "thin",
        },
        highlights = {
          buffer_selected = {
            fg = aws.aws_orange,
            bold = true,
          },
          indicator_selected = {
            fg = aws.aws_orange,
            bg = aws.aws_orange,
          },
        },
      }
    end,
  },
}
