-- Cumulus Core Options (Story 1.1 & Story 2.1)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.have_nerd_font = true

-- Load persisted Cloud Theme (Story 31.2)
vim.schedule(function()
  require("cumulus.theme").load_saved_theme()
end)
