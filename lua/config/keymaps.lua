-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Maven/Gradle build tools setup - aguarda 2s para garantir que tudo carregou
vim.defer_fn(function()
  -- Maven
  local ok_maven, maven = pcall(require, "config.autocmds.maven")
  if ok_maven and maven.find_pom() and not maven.keymaps_registered then
    maven.setup()
  end
  
  -- Gradle  
  local ok_gradle, gradle = pcall(require, "config.autocmds.gradle")
  if ok_gradle and gradle.find_gradle() and not gradle.keymaps_registered then
    gradle.setup()
  end
end, 2000)
