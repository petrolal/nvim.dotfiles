local banner = [[
███████╗███████╗███╗   ██╗████████╗██████╗ ██╗   ██╗     ██╗    ██╗██████╗ ███████╗███╗   ██╗ ██████╗██╗  ██╗
██╔════╝██╔════╝████╗  ██║╚══██╔══╝██╔══██╗╚██╗ ██╔╝     ██║    ██║██╔══██╗██╔════╝████╗  ██║██╔════╝██║  ██║
███████╗█████╗  ██╔██╗ ██║   ██║   ██████╔╝ ╚████╔╝█████╗██║ █╗ ██║██████╔╝█████╗  ██╔██╗ ██║██║     ███████║
╚════██║██╔══╝  ██║╚██╗██║   ██║   ██╔══██╗  ╚██╔╝ ╚════╝██║███╗██║██╔══██╗██╔══╝  ██║╚██╗██║██║     ██║  ██║
███████║███████╗██║ ╚████║   ██║   ██║  ██║   ██║        ╚███╔███╔╝██║  ██║███████╗██║ ╚████║╚██████╗██║  ██║
╚══════╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝         ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═══╝

                                                                              Heavy load commin' throught!
]]

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function(_, opts)
      opts.dashboard = opts.dashboard or {}
      opts.dashboard.enabled = true
      opts.dashboard.sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
        function()
          local is_blu = vim.g.colors_name == "sentry-blu"
          local commit = ""
          local handle = io.popen("git rev-parse --short HEAD 2>/dev/null")
          if handle then
            commit = handle:read("*a"):gsub("%s+", "")
            handle:close()
          end
          local date = os.date("%d/%m/%y")
          local version = "v1.0.0"
          return {
            align = "center",
            text = {
              { "SENTRY-WRENCH [" .. (is_blu and (is_blu and "BLU" or "RED") or "RED") .. "] • " .. version .. " • " .. commit .. " • " .. date, hl = "SnacksDashboardFooter" },
            },
          }
        end,
      }
      opts.dashboard.preset = opts.dashboard.preset or {}
      opts.dashboard.preset.header = banner
      opts.dashboard.preset.keys = {
        { icon = " ", key = "f", desc = "Find File", action = function() Snacks.picker.files() end },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = "󰄉 ", key = "r", desc = "Recent Files", action = function() Snacks.picker.recent() end },
        { icon = " ", key = "g", desc = "Find Text", action = function() Snacks.picker.grep() end },
        { icon = " ", key = "c", desc = "Config", action = function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end },
        { icon = " ", key = "s", desc = "Restore Session", action = ':lua require("persistence").load()' },
        { icon = "󱔗 ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      }
      return opts
    end,
    keys = {
      -- Explorer
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      -- Picker
      { "<leader><space>", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>ld", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      -- Terminals
      { "<leader>Ld", function() Snacks.terminal("lazydocker") end, desc = "LazyDocker" },
      { "<leader>at", function() Snacks.terminal("copilot") end, desc = "Copilot CLI" },
      { "<C-/>", function() Snacks.terminal() end, desc = "Terminal" },
      -- Other
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "LazyGit" },
    },
  },
}
