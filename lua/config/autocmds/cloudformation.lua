vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*/cloudformation/*.yml", "*/cloudformation/*.yaml", "*-cfn-*.yml", "*-cfn-*.yaml" },
  callback = function()
    vim.bo.filetype = "yaml.cloudformation"
  end,
})
