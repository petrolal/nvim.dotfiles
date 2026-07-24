return {
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = function()
      return {
        { "<leader>gg", false },
        { "<leader>Lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>L", group = "Lazy Tools" })
    end,
  },
}
