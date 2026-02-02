local copilot_term

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
          "<leader>at",
          function()
            local Terminal = require("toggleterm.terminal").Terminal

            copilot_term = copilot_term
              or Terminal:new({
                cmd = "copilot",
                direction = "float",
                hidden = true,
                close_on_exit = true, -- ✅ ISSO resolve
                on_open = function(term)
                  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = term.bufnr, silent = true })
                end,
              })

            copilot_term:toggle()
          end,
          desc = "Copilot CLI",
        },
      }
    end,
  },
}
