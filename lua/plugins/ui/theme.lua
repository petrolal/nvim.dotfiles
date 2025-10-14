return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },

  {
    "navarasu/onedark.nvim",
    priority = 1000,
    opts = {
      style = "cool",
      transparent = true,
      term_colors = true,
      lualine = {
        transparent = true,
      },
    },
    config = function(_, opts)
      local onedark = require("onedark")
      onedark.setup(opts)
      onedark.load()
    end,
  },
}
