return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "chipsenkbeil/distant.nvim",
        branch = "v0.3",
        config = function()
          require("distant"):setup({})
        end,
      },
    }, -- add
    keys = function(_, keys)
      keys = keys or {}
      table.insert(keys, 1, {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugin File",
      })
      -- atalho para o menu de remotes
      table.insert(keys, {
        "<leader>sr",
        function()
          vim.cmd("RemoteMenu")
        end,
        desc = "Remotes (menu)",
      })
      table.insert(keys, {
        "<leader>sa",
        function()
          vim.cmd("RemoteAdd")
        end,
        desc = "Remotes (adicionar)",
      })
      return keys
    end,
    opts = function(_, opts)
      opts.defaults = opts.defaults or {}
      opts.defaults.layout_strategy = "horizontal"
      opts.defaults.layout_config = vim.tbl_deep_extend("force", opts.defaults.layout_config or {}, {
        prompt_position = "top",
      })
      opts.defaults.sorting_strategy = "ascending"
      opts.defaults.winblend = 0
      return opts
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("remotes.manager").setup() -- integra aqui
    end,
  },
}
