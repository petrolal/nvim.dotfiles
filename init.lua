local config_bin = vim.fn.stdpath("config") .. "/remotes/bin"
local home = vim.fn.expand("~")
vim.env.PATH = config_bin
  .. ":"
  .. home
  .. "/.cargo/bin:"
  .. home
  .. "/.local/bin:"
  .. (vim.env.PATH or "")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
