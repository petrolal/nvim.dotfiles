-- Cumulus Core Keymaps (Story 1.1 & Story 4.1)

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

-- JVM Build Tool Keymaps (<leader>j*) (Story 4.1)
map("n", "<leader>jm", function()
  require("cumulus.util.maven").run_maven_goal()
end, { desc = "Maven: Select Goal" })

map("n", "<leader>jg", function()
  require("cumulus.util.gradle").run_gradle_task()
end, { desc = "Gradle: Select Task" })

map("n", "<leader>jc", function()
  local maven = require("cumulus.util.maven")
  local gradle = require("cumulus.util.gradle")
  if maven.find_pom() then
    maven.run_maven_cmd(maven.get_mvn_cmd() .. " clean compile")
  elseif gradle.find_gradle() then
    gradle.run_gradle_cmd(gradle.get_gradle_cmd() .. " clean compile")
  else
    vim.notify("No pom.xml or build.gradle found in project", vim.log.levels.WARN)
  end
end, { desc = "JVM Build: Clean Compile" })

map("n", "<leader>jt", function()
  local maven = require("cumulus.util.maven")
  local gradle = require("cumulus.util.gradle")
  if maven.find_pom() then
    maven.run_maven_cmd(maven.get_mvn_cmd() .. " test")
  elseif gradle.find_gradle() then
    gradle.run_gradle_cmd(gradle.get_gradle_cmd() .. " test")
  else
    vim.notify("No pom.xml or build.gradle found in project", vim.log.levels.WARN)
  end
end, { desc = "JVM Build: Run Tests" })
