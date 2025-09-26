local lazydocker_term

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = function(_, opts)
      opts = opts or {}
      opts.shade_terminals = true
      opts.persist_size = true
      opts.start_in_insert = true
      return opts
    end,
    keys = function()
      return {
        {
          "<leader>ld",
          function()
            local Terminal = require("toggleterm.terminal").Terminal
            lazydocker_term = lazydocker_term
              or Terminal:new({
                cmd = "lazydocker",
                direction = "float",
                hidden = true,
                close_on_exit = false,
                on_open = function(term)
                  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = term.bufnr, silent = true })
                end,
              })
            lazydocker_term:toggle()
          end,
          desc = "LazyDocker",
        },
      }
    end,
  },
}

