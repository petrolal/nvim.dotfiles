-- Cumulus WhichKey Keybinding Helper Integration (Story 8.4, Story 10.1 & Story 12.3)

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>f", group = "file/find", icon = "󰉋 " },
        { "<leader>s", group = "search", icon = "󰈞 " },
        { "<leader>c", group = "cloud/iac", icon = "󰅟 " },
        { "<leader>j", group = "jvm build", icon = "󰏗 " },
        { "<leader>w", group = "windows", icon = "󰓩 " },
        { "<leader>l", group = "lsp/diagnostics", icon = "󰅍 " },
        { "<leader>g", group = "git control", icon = "󰊢 " },
        { "<leader>q", group = "quit/session", icon = "󰗼 " },
        { "<leader>d", group = "debug/dap", icon = "󰃤 " },
        { "<leader>u", group = "ui/toggle", icon = "󰂚 " },
        { "<leader>b", group = "buffer", icon = "󰈔 " },
      },
    },
  },
}
