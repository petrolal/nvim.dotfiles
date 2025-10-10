-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Added terraform auto discover
vim.filetype.add({
  extension = {
    tf = "terraform",
    tfvars = "terraform",
    hcl = "hcl",
    nomad = "hcl",
  },
  filename = {
    [".terraformrc"] = "hcl",
    ["terraform.rc"] = "hcl",
  },
})
