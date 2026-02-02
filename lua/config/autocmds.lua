-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Setup Maven keymaps only in Maven projects
vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged", "VimEnter" }, {
  pattern = "*",
  callback = function()
    local ok, maven = pcall(require, "config.autocmds.maven")
    if ok and maven.find_pom() and not maven.keymaps_registered then
      -- Garante que which-key está carregado
      vim.schedule(function()
        if pcall(require, "which-key") then
          maven.setup()
          maven.keymaps_registered = true
        end
      end)
    end
  end,
})
