return {

  -- tweak Telescope defaults and add a keymap for plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = function(_, keys)
      return vim.list_extend({
        {
          "<leader>fp",
          function()
            require("telescope.builtin").find_files({
              cwd = require("lazy.core.config").options.root,
            })
          end,
          desc = "Find Plugin File",
        },
      }, keys)
    end,
    opts = function(_, opts)
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      })
    end,
  },
}
