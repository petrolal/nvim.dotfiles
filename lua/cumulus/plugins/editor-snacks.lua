local banner = [[
 ██████╗██╗  ██╗███╗   ███╗██╗   ██╗██╗     ██╗██╗███████╗
██╔════╝██║  ██║████╗ ████║██║   ██║██║     ██║██║██╔════╝
██║     ██║  ██║██╔████╔██║██║   ██║██║     ██║██║███████╗
██║     ██║  ██║██║╚██╔╝██║██║   ██║██║     ██║██║╚════██║
╚██████╗╚█████╔╝██║ ╚═╝ ██║╚██████╔╝███████╗██║██║███████║
 ╚═════╝ ╚════╝ ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝╚═╝╚══════╝

                 ☁  Cloud Infrastructure & DevOps Neovim
]]

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function(_, opts)
      opts.styles = opts.styles or {}
      opts.styles.notification = vim.tbl_deep_extend("force", opts.styles.notification or {}, {
        title = " ☁ ",
      })
      opts.styles.notification_history = vim.tbl_deep_extend("force", opts.styles.notification_history or {}, {
        title = " ☁ Notifications ",
      })

      opts.picker = opts.picker or {}
      opts.picker.prompt = " ☁ >"

      opts.notifier = opts.notifier or {}
      opts.notifier.enabled = true
      opts.notifier.timeout = 3000

      opts.explorer = opts.explorer or {}
      opts.explorer.replace_netrw = true

      opts.image = opts.image or {}
      opts.image.enabled = true
      opts.image.doc = { inline = true }

      opts.dashboard = opts.dashboard or {}
      local opened_dir = false
      for _, arg in ipairs(vim.fn.argv() --[[@as string[] ]]) do
        if vim.fn.isdirectory(arg) == 1 then
          opened_dir = true
          break
        end
      end
      opts.dashboard.enabled = not opened_dir
      opts.dashboard.sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
        function()
          local commit = ""
          local handle = io.popen("git rev-parse --short HEAD 2>/dev/null")
          if handle then
            local raw = handle:read("*a")
            commit = (raw or ""):gsub("%s+", "")
            handle:close()
          end
          local date = os.date("%d/%m/%y")
          local version = "v1.0.0"
          return {
            align = "center",
            text = {
              {
                "CUMULUS • " .. version .. " • " .. commit .. " • " .. date,
                hl = "SnacksDashboardFooter",
              },
            },
          }
        end,
      }
      opts.dashboard.preset = opts.dashboard.preset or {}
      opts.dashboard.preset.header = banner
      opts.dashboard.preset.keys = {
        {
          icon = "󰈞 ",
          key = "f",
          desc = "Find File",
          action = function()
            Snacks.picker.files()
          end,
        },
        { icon = "󰝒 ", key = "n", desc = "New File", action = ":ene | startinsert" },
        {
          icon = "󰋚 ",
          key = "r",
          desc = "Recent Files",
          action = function()
            Snacks.picker.recent()
          end,
        },
        {
          icon = "󰍉 ",
          key = "g",
          desc = "Find Text (Grep)",
          action = function()
            Snacks.picker.grep()
          end,
        },
        {
          icon = "󱥸 ",
          key = "t",
          desc = "Terraform Workspace",
          action = function()
            Snacks.picker.files({ cwd = vim.fn.getcwd() })
          end,
        },
        {
          icon = "󰡨 ",
          key = "d",
          desc = "LazyDocker Terminal",
          action = function()
            Snacks.terminal("lazydocker")
          end,
        },
        {
          icon = "󰊢 ",
          key = "v",
          desc = "LazyGit Control",
          action = function()
            Snacks.terminal("lazygit")
          end,
        },
        {
          icon = "󰒓 ",
          key = "c",
          desc = "Config",
          action = function()
            Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
          end,
        },
        {
          icon = "󰦛 ",
          key = "s",
          desc = "Restore Session",
          action = function()
            local ok, persistence = pcall(require, "persistence")
            if ok then
              persistence.load()
            else
              vim.notify("persistence.nvim is not loaded", vim.log.levels.WARN)
            end
          end,
        },
        { icon = "󰏖 ", key = "l", desc = "Lazy", action = ":Lazy" },
        { icon = "󰗼 ", key = "q", desc = "Quit", action = ":confirm qa" },
      }
      return opts
    end,
    config = function(_, opts)
      require("snacks").setup(opts)
      vim.notify = function(msg, level, notify_opts)
        Snacks.notifier.notify(msg, level, notify_opts)
      end
    end,
    keys = {
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "File Explorer",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>sw",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>ld",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>ls",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },
      {
        "gd",
        function()
          if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
            Snacks.picker.lsp_definitions()
          else
            vim.cmd("normal! gd")
          end
        end,
        desc = "Goto Definition (Smart Fallback)",
      },
      {
        "gD",
        function()
          if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
            Snacks.picker.lsp_declarations()
          else
            vim.cmd("normal! gD")
          end
        end,
        desc = "Goto Declaration (Smart Fallback)",
      },
      {
        "gy",
        function()
          if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
            Snacks.picker.lsp_type_definitions()
          else
            vim.notify("No active LSP client for type definitions", vim.log.levels.WARN)
          end
        end,
        desc = "Goto Type Definition",
      },
      {
        "gi",
        function()
          if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
            Snacks.picker.lsp_implementations()
          else
            vim.notify("No active LSP client for implementations", vim.log.levels.WARN)
          end
        end,
        desc = "Goto Implementation",
      },
      {
        "gr",
        function()
          if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
            Snacks.picker.lsp_references()
          else
            Snacks.picker.grep_word()
          end
        end,
        desc = "References (Grep Fallback)",
      },
      {
        "<leader>od",
        function()
          Snacks.terminal("lazydocker")
        end,
        desc = "LazyDocker",
      },
      {
        "<leader>og",
        function()
          Snacks.terminal("lazygit")
        end,
        desc = "LazyGit",
      },
      {
        "<leader>gg",
        function()
          Snacks.terminal("lazygit")
        end,
        desc = "LazyGit",
      },
      {
        "<leader>gl",
        function()
          Snacks.picker.git_log()
        end,
        desc = "Git Log",
      },
      {
        "<leader>gL",
        function()
          Snacks.picker.git_log_file()
        end,
        desc = "Git Log (Current File)",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git Status",
      },
      {
        "<leader>gS",
        function()
          Snacks.picker.git_stash()
        end,
        desc = "Git Stash",
      },
      {
        "<leader>qq",
        "<cmd>qa<cr>",
        desc = "Quit All",
      },
      {
        "<leader>qQ",
        "<cmd>qa!<cr>",
        desc = "Force Quit All",
      },
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Toggle Zen Mode",
      },
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>sn",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      {
        "<C-/>",
        function()
          Snacks.terminal()
        end,
        desc = "Terminal",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },
}
