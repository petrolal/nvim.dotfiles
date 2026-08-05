-- Cumulus Core Options (Story 1.1 & Story 2.1)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.have_nerd_font = true

-- Ergonomic keyboard settings (HRM, combos, mouse emulation)
vim.opt.timeoutlen = 200
vim.opt.ttimeoutlen = 10
vim.opt.mouse = "a"
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.confirm = true

-- Load persisted Cloud Theme (Story 31.2)
vim.schedule(function()
  require("cumulus.theme").load_saved_theme()
end)
