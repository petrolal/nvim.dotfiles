-- carrega env path do distant
vim.env.PATH = os.getenv("HOME") .. "/.cargo/bin:" .. os.getenv("HOME") .. "/.local/bin:" .. (vim.env.PATH or "")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
