local banner = [[
 ██████╗███████╗███╗   ██╗████████╗██████╗ ██╗   ██╗██╗   ██╗██╗███╗   ███╗
██╔════╝██╔════╝████╗  ██║╚══██╔══╝██╔══██╗╚██╗ ██╔╝██║   ██║██║████╗ ████║
███████╗█████╗  ██╔██╗ ██║   ██║   ██████╔╝ ╚████╔╝ ██║   ██║██║██╔████╔██║
╚════██║██╔══╝  ██║╚██╗██║   ██║   ██╔══██╗  ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
███████║███████╗██║ ╚████║   ██║   ██║  ██║   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
╚══════╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝

                                            Heavy load commin' throught!
]]

return {
  -- Disable snacks dashboard since alpha handles start screen
  { "folke/snacks.nvim", opts = { dashboard = { enabled = false } } },

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    init = false,
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = vim.split(banner, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("f", "󰠮  Find file", "<cmd> lua LazyVim.pick()() <cr>"),
        dashboard.button("n", "󱙲  New file", [[<cmd> ene <BAR> startinsert <cr>]]),
        dashboard.button("r", "󱋡  Recent files", [[<cmd> lua LazyVim.pick("oldfiles")() <cr>]]),
        dashboard.button("g", "󱁐  Find text", [[<cmd> lua LazyVim.pick("live_grep")() <cr>]]),
        dashboard.button("c", "󱁊  Config", "<cmd> lua LazyVim.pick.config_files()() <cr>"),
        dashboard.button("s", "󱔐  Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
        dashboard.button("x", "󱓞  Lazy Extras", "<cmd> LazyExtras <cr>"),
        dashboard.button("l", "󰒲  Lazy", "<cmd> Lazy <cr>"),
        dashboard.button("q", "󱗼  Quit", "<cmd> qa <cr>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
        -- Aplicar AlphaIcon aos ícones (primeiros caracteres antes do texto)
        if button.val and #button.val > 0 then
          button.opts.hl = {
            { "AlphaIcon", 0, 3 }, -- Ícone (assumindo 3 bytes para o caractere nerd font + espaço)
            { "AlphaButtons", 4, #button.val }, -- Texto
          }
        end
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- Definir cores baseadas no colorscheme ativo (RED ou BLU)
      local is_blu = vim.g.colors_name == "sentry-blu"
      local primary = is_blu and "#2A7EBF" or "#D35400"
      local secondary = is_blu and "#2ECC71" or "#F1C40F"
      local fg = is_blu and "#D1D9E0" or "#F0EAD6"

      -- Definir destaques personalizados para o dashboard SentryVim (Industrial TF2)
      vim.api.nvim_set_hl(0, "AlphaHeader", { fg = primary })
      vim.api.nvim_set_hl(0, "AlphaButtons", { fg = fg })
      vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = secondary })
      vim.api.nvim_set_hl(0, "AlphaIcon", { fg = primary })
      vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#7F8C8D", italic = true })

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

      local function get_git_commit()
        local handle = io.popen("git rev-parse --short HEAD 2>/dev/null")
        if not handle then
          return "unknown"
        end
        local result = handle:read("*a")
        handle:close()
        return result:gsub("%s+", "") or "unknown"
      end

      local function get_git_version()
        local handle = io.popen("git describe --tags --abbrev=0 2>/dev/null")
        if not handle then
          return "v0.0.0"
        end
        local result = handle:read("*a")
        handle:close()
        result = result:gsub("%s+", "")
        return result ~= "" and result or "v0.0.0"
      end

      dashboard.section.footer.val = {
        "SentryVim "
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
        position = "center",
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
