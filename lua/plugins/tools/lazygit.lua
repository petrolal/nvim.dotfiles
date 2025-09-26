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
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Abrir LazyGit" },
      }
    end,
  },
}
