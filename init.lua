local config_bin = vim.fn.stdpath("config") .. "/remotes/bin"
vim.env.PATH = config_bin
  .. ":"
  .. os.getenv("HOME")
  .. "/.cargo/bin:"
  .. os.getenv("HOME")
  .. "/.local/bin:"
  .. (vim.env.PATH or "")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
