-- Cumulus WhichKey Keybinding Helper Integration (Story 8.4, Story 10.1, Story 12.3, Story 20.1, Story 21.2, Story 23.2 & Story 24.2)

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      -- The "helix" preset caps the popup at height.max = 0.75 and
      -- width.max = 60. With this many top-level leader groups, that cap
      -- is too small: on an 80x24 terminal, the list overflows and later
      -- groups (e.g. "windows", "buffer") get silently cut off below the
      -- fold instead of scrolling into view, making them look like they
      -- vanished. Raise both caps so the whole group list fits on-screen
      -- while keeping the preset's bottom-right, rounded-border layout.
      win = {
        height = { min = 4, max = 0.9 },
        width = { min = 30, max = 80 },
      },
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
