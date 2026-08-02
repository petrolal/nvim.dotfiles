-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Insert mode exit chords (HRM / combo friendly)
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("i", "kj", "<ESC>", { desc = "Exit insert mode" })

-- Leader alternatives for scrolling (avoids holding Ctrl with Home Row Mods)
map("n", "<leader>d", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<leader>u", "<C-u>zz", { desc = "Scroll up and center" })

-- Leader alternatives for window navigation
map("n", "<leader>ww", "<C-w>w", { desc = "Cycle windows" })
map("n", "<leader>wh", "<C-w>h", { desc = "Focus left window" })
map("n", "<leader>wj", "<C-w>j", { desc = "Focus lower window" })
map("n", "<leader>wk", "<C-w>k", { desc = "Focus upper window" })
map("n", "<leader>wl", "<C-w>l", { desc = "Focus right window" })

