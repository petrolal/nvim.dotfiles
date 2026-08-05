-- Cumulus Telescope & Ripgrep Integration

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>tf",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find Files (Telescope)",
      },
      {
        "<leader>tg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Ripgrep Live Search (Telescope)",
      },
      {
        "<leader>tp",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugin File (Telescope)",
      },
      {
        "<leader>tw",
        function()
          require("telescope.builtin").grep_string()
        end,
        desc = "Ripgrep Word Under Cursor (Telescope)",
      },
      {
        "<leader>sb",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        desc = "Fuzzy Search Current Buffer",
      },
      {
        "<leader>sh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Help Tags",
      },
      {
        "<leader>sk",
        function()
          require("telescope.builtin").keymaps()
        end,
        desc = "Telescope Keymaps",
      },
    },
    opts = function(_, opts)
      opts.defaults = opts.defaults or {}
      opts.defaults.layout_strategy = "horizontal"
      opts.defaults.layout_config = vim.tbl_deep_extend("force", opts.defaults.layout_config or {}, {
        prompt_position = "top",
      })
      opts.defaults.sorting_strategy = "ascending"
      opts.defaults.winblend = 0
      opts.defaults.vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob",
        "!**/.git/*",
      }
      return opts
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
    end,
  },
}
