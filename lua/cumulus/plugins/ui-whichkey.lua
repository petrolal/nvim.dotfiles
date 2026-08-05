-- Cumulus WhichKey Keybinding Helper Integration (Story 8.4, Story 10.1, Story 12.3, Story 20.1, Story 21.2, Story 23.2 & Story 24.2)

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>f", group = "file/find", icon = "󰈞 " },
        { "<leader>s", group = "search", icon = "󰍉 " },
        { "<leader>t", group = "telescope search", icon = "󰈞 " },
        { "<leader>c", group = "code/build/lsp", icon = "󰅍 " },
        { "<leader>w", group = "windows", icon = "󰖲 " },
        { "<leader>l", group = "lsp/mason", icon = "󰒓 " },
        { "<leader>g", group = "git control", icon = "󰊢 " },
        { "<leader>q", group = "quit/session", icon = "󰗼 " },
        { "<leader>d", group = "debug/dap", icon = "󰃤 " },
        { "<leader>o", group = "devtools/workloads", icon = "󰒓 " },
        { "<leader>u", group = "ui/toggles", icon = "󰔡 " },
        { "<leader>b", group = "buffer", icon = "󰓩 " },
      },
    },
  },
}
