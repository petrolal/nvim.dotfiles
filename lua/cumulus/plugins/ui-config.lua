return {
  -- UI diagnostics and icons configuration
  {
    "folke/trouble.nvim",
    opts = {
      icons = {
        diagnostics = {
          Error = "󱗼 ",
          Warn = "󱁊 ",
          Hint = "󱁐 ",
          Info = "󰠮 ",
        },
      },
    },
  },
}
