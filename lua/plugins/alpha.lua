local banner = [[
████████╗ ██████╗ ██╗   ██╗██████╗  █████╗ ███████╗██╗   ██╗██╗███╗   ███╗
╚══██╔══╝██╔═══██╗██║   ██║██╔══██╗██╔══██╗██╔════╝██║   ██║██║████╗ ████║
   ██║   ██║   ██║██║   ██║██████╔╝███████║███████╗██║   ██║██║██╔████╔██║
   ██║   ██║   ██║██║   ██║██╔══██╗██╔══██║╚════██║╚██╗ ██╔╝██║██║╚██╔╝██║
   ██║   ╚██████╔╝╚██████╔╝██║  ██║██║  ██║███████║ ╚████╔╝ ██║██║ ╚═╝ ██║
   ╚═╝    ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
                                                  [ トゥレット ヴィム ]
]]

return {
  -- Disable snacks from dashboard
  { "folke/snacks.nvim", opts = { dashboard = { enabled = false } } },

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    enabled = true,
    init = false,
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = banner
      dashboard.section.header.val = vim.split(logo, "\n")
    -- stylua: ignore
    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file",       "<cmd> lua LazyVim.pick()() <cr>"),
      dashboard.button("n", " " .. " New file",        [[<cmd> ene <BAR> startinsert <cr>]]),
      dashboard.button("r", " " .. " Recent files",    [[<cmd> lua LazyVim.pick("oldfiles")() <cr>]]),
      dashboard.button("g", " " .. " Find text",       [[<cmd> lua LazyVim.pick("live_grep")() <cr>]]),
      dashboard.button("c", " " .. " Config",          "<cmd> lua LazyVim.pick.config_files()() <cr>"),
      dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
      dashboard.button("x", " " .. " Lazy Extras",     "<cmd> LazyExtras <cr>"),
      dashboard.button("l", "󰒲 " .. " Lazy",            "<cmd> Lazy <cr>"),
      dashboard.button("a", "󰚩 " .. " ChatGPT",         "<cmd>ChatGPT<CR>"),
      dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
    }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"

      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          once = true,
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      -- Função para pegar o commit hash (opcional)
      local function get_git_commit()
        local handle = io.popen("git rev-parse --short HEAD 2>/dev/null")
        if handle then
          local result = handle:read("*a")
          handle:close()
          return result:gsub("%s+", "") or "unknown"
        end
        return "unknown"
      end

      local function get_git_version()
        local handle = io.popen("git describe --tags --abbrev=0 2>/dev/null")
        if handle then
          local result = handle:read("*a")
          handle:close()
          result = result:gsub("%s+", "")
          return result ~= "" and result or "v0.0.0"
        end
        return "v0.0.0"
      end

      -- Footer com versão do Git e Neovim
      dashboard.section.footer.val = {
        "Tourasvim "
          .. get_git_version()
          .. " • Neovim "
          .. vim.version().major
          .. "."
          .. vim.version().minor
          .. " • "
          .. get_git_commit():sub(1, 7)
          .. " • "
          .. os.date("%d/%m/%y"),
      }

      dashboard.section.footer.opts = {
        position = "center", -- ✅ Centralizar footer
        hl = "AlphaFooter",
      }

      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "LazyVimStarted",
        callback = function()
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
