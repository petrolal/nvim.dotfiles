-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- CloudFormation filetype detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*/cloudformation/*.yml", "*/cloudformation/*.yaml", "*-cfn-*.yml", "*-cfn-*.yaml" },
  callback = function()
    vim.bo.filetype = "yaml.cloudformation"
  end,
})

-- Java build tools setup
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    -- Maven
    local ok_maven, maven = pcall(require, "util.maven")
    if ok_maven and maven.find_pom() and not maven.keymaps_registered then
      maven.setup()
    end

    -- Gradle
    local ok_gradle, gradle = pcall(require, "util.gradle")
    if ok_gradle and gradle.find_gradle() and not gradle.keymaps_registered then
      gradle.setup()
    end
  end,
})
