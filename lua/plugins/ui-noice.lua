return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        progress = { enabled = false }, -- Disable progress animations
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.set_hl_from_snippet"] = true,
          ["nvim-dex.lsp.hover"] = true,
        },
      },
      messages = {
        enabled = true,
        view = "mini", -- Minimalist view
      },
      popupmenu = {
        enabled = true,
        backend = "nui", -- Faster than cmp for some cases
      },
      views = {
        mini = {
          win_options = {
            winblend = 0,
          },
        },
      },
    },
  },
}
