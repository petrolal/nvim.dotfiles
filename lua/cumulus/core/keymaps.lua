-- Cumulus Core Keymaps (Story 1.1, Story 4.1 & Epic 9)

local map = vim.keymap.set

-- Insert mode exit chords (HRM / combo friendly)
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("i", "kj", "<ESC>", { desc = "Exit insert mode" })

-- Leader alternatives for scrolling (avoids holding Ctrl with Home Row Mods)
map("n", "<leader>d", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<leader>u", "<C-u>zz", { desc = "Scroll up and center" })

-- Buffer & Window Navigation Ergonomics (Story 9.1)
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<C-h>", "<C-w>h", { desc = "Focus Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus Upper Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus Right Window" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Alternate Buffer" })
map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.bo[buf].buflisted then
      pcall(vim.api.nvim_buf_delete, buf, { force = false })
    end
  end
end, { desc = "Close Other Buffers" })

-- Leader alternatives for window navigation
map("n", "<leader>ww", "<C-w>w", { desc = "Cycle windows" })
map("n", "<leader>wh", "<C-w>h", { desc = "Focus left window" })
map("n", "<leader>wj", "<C-w>j", { desc = "Focus lower window" })
map("n", "<leader>wk", "<C-w>k", { desc = "Focus upper window" })
map("n", "<leader>wl", "<C-w>l", { desc = "Focus right window" })

-- Visual Selection & Line Movement Chords (Story 9.2)
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move Up" })
map("v", "<", "<gv", { desc = "Outdent and Reselect" })
map("v", ">", ">gv", { desc = "Indent and Reselect" })
map("n", "n", "nzzzv", { desc = "Next Search Centered" })
map("n", "N", "Nzzzv", { desc = "Prev Search Centered" })

-- LSP Diagnostics & Symbol Navigation Chords (Story 9.3 & Story 13.2)
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev Diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next Diagnostic" })
map("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev Error" })
map("n", "]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next Error" })
map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "Code Action" })
map("n", "<leader>cr", function() vim.lsp.buf.rename() end, { desc = "Rename Symbol" })

-- Code & Build Tool Keymaps (<leader>c*) (Story 4.1 & Story 24.2)
map("n", "<leader>cm", function()
  require("cumulus.util.maven").run_maven_goal()
end, { desc = "Maven: Select Goal" })

map("n", "<leader>cg", function()
  require("cumulus.util.gradle").run_gradle_task()
end, { desc = "Gradle: Select Task" })

map("n", "<leader>cc", function()
  local maven = require("cumulus.util.maven")
  local gradle = require("cumulus.util.gradle")
  if maven.find_pom() then
    maven.run_maven_cmd(maven.get_mvn_cmd() .. " clean compile")
  elseif gradle.find_gradle() then
    gradle.run_gradle_cmd(gradle.get_gradle_cmd() .. " clean compile")
  else
    vim.notify("No pom.xml or build.gradle found in project", vim.log.levels.WARN)
  end
end, { desc = "Build Project (Clean Compile)" })

map("n", "<leader>ct", function()
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

-- Session & Quit Keymaps (Story 10.1 & Story 29.1)
map("n", "<leader>qq", "<cmd>confirm qa<cr>", { desc = "Quit Neovim (Confirm)" })
map("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Force Quit Neovim (No Save)" })

-- Cloud Theme Switcher Keymap (Story 31.2)
map("n", "<leader>ut", function()
  require("cumulus.theme").select_theme()
end, { desc = "Select Cloud Theme (AWS/Azure/GCP/OCI)" })


