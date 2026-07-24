return {
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerBuild" },
    opts = {
      templates = { "builtin" },
      strategy = "terminal",
    },
    keys = {
      { "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Overseer" },
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run Task" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Build Task" },
      { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Action" },
      { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Info" },
    },
  },
}
