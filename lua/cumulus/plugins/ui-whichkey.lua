-- Cumulus WhichKey Keybinding Helper Integration

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>f", group = "file/find" },
        { "<leader>s", group = "search" },
        { "<leader>c", group = "cloud/iac" },
        { "<leader>j", group = "jvm build" },
        { "<leader>w", group = "windows" },
        { "<leader>l", group = "lsp/diagnostics" },
        { "<leader>u", group = "ui/toggle" },
        { "<leader>b", group = "buffer" },
      },
    },
  },
}
