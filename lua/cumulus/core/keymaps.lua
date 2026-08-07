-- Cumulus Core Keymaps (Story 1.1, Story 4.1 & Epic 9)

local map = vim.keymap.set

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

-- Per-language <leader>c* subgroups (Story 34.1): build/lint/format commands
-- for a given language stack only appear as buffer-local keymaps while
-- editing a matching filetype, so <leader>c no longer mixes e.g. Maven
-- keymaps into a Python or Terraform buffer's popup. See lang-keymaps.lua.
local lang_keymaps = require("cumulus.core.lang-keymaps")

lang_keymaps.register({
  filetypes = { "java", "kotlin", "groovy" },
  group = "<leader>cj",
  label = "java/jvm build",
  icon = "󰬷 ",
  keys = {
    {
      "<leader>cjm",
      function()
        require("cumulus.util.maven").run_maven_goal()
      end,
      "Maven: Select Goal",
    },
    {
      "<leader>cjg",
      function()
        require("cumulus.util.gradle").run_gradle_task()
      end,
      "Gradle: Select Task",
    },
    {
      "<leader>cjc",
      function()
        local maven = require("cumulus.util.maven")
        local gradle = require("cumulus.util.gradle")
        if maven.find_pom() then
          maven.run_maven_cmd(maven.get_mvn_cmd() .. " clean compile")
        elseif gradle.find_gradle() then
          gradle.run_gradle_cmd(gradle.get_gradle_cmd() .. " clean compile")
        else
          vim.notify("No pom.xml or build.gradle found in project", vim.log.levels.WARN)
        end
      end,
      "Build Project (Clean Compile)",
    },
    {
      "<leader>cjt",
      function()
        local maven = require("cumulus.util.maven")
        local gradle = require("cumulus.util.gradle")
        if maven.find_pom() then
          maven.run_maven_cmd(maven.get_mvn_cmd() .. " test")
        elseif gradle.find_gradle() then
          gradle.run_gradle_cmd(gradle.get_gradle_cmd() .. " test")
        else
          vim.notify("No pom.xml or build.gradle found in project", vim.log.levels.WARN)
        end
      end,
      "JVM Build: Run Tests",
    },
  },
})

lang_keymaps.register({
  filetypes = { "terraform", "terraform-vars", "hcl" },
  group = "<leader>ct",
  label = "terraform/opentofu",
  icon = "󱁢 ",
  keys = {
    { "<leader>ctv", "<cmd>!terraform validate<cr>", "Terraform: Validate" },
    { "<leader>ctp", "<cmd>!terraform plan<cr>", "Terraform: Plan" },
    { "<leader>ctf", "<cmd>!terraform fmt<cr>", "Terraform: Format" },
  },
})

lang_keymaps.register({
  filetypes = { "yaml.ansible", "ansible" },
  group = "<leader>cy",
  label = "ansible",
  icon = "󰚰 ",
  keys = {
    { "<leader>cya", "<cmd>!ansible-lint %<cr>", "Ansible: Lint Playbook" },
    { "<leader>cys", "<cmd>!ansible-playbook --syntax-check %<cr>", "Ansible: Syntax Check" },
  },
})

lang_keymaps.register({
  filetypes = { "dockerfile" },
  group = "<leader>cd",
  label = "docker",
  icon = "󰡨 ",
  keys = {
    { "<leader>cdb", "<cmd>!docker build -t %:h:t .<cr>", "Docker: Build Image" },
    { "<leader>cdl", "<cmd>!hadolint %<cr>", "Docker: Lint Dockerfile" },
  },
})

lang_keymaps.register({
  filetypes = { "helm" },
  group = "<leader>ck",
  label = "helm/k8s",
  icon = "󱃾 ",
  keys = {
    { "<leader>ckl", "<cmd>!helm lint %:h<cr>", "Helm: Lint Chart" },
    { "<leader>ckt", "<cmd>!helm template %:h<cr>", "Helm: Render Template" },
  },
})

lang_keymaps.setup()

-- Session & Quit Keymaps (Story 10.1 & Story 29.1)
map("n", "<leader>qq", "<cmd>confirm qa<cr>", { desc = "Quit Neovim (Confirm)" })
map("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Force Quit Neovim (No Save)" })

-- Cloud Theme Switcher Keymap (Story 31.2)
map("n", "<leader>ut", function()
  require("cumulus.theme").select_theme()
end, { desc = "Select Cloud Theme (AWS/Azure/GCP/OCI)" })

-- Universal File Operations: Save, Save All, Save As (Epic 33)
local function save_current_file()
  vim.cmd("update")
  local name = vim.fn.expand("%:t")
  if name == "" then
    name = "[No Name]"
  end
  vim.notify("Saved " .. name, vim.log.levels.INFO)
end

map({ "n", "i" }, "<C-s>", save_current_file, { desc = "Save Current File" })
map("n", "<leader>fs", save_current_file, { desc = "Save Current File" })

map("n", "<leader>fa", function()
  vim.cmd("wall")
  vim.notify("Saved all modified files", vim.log.levels.INFO)
end, { desc = "Save All Files" })

map("n", "<leader>fS", function()
  local current = vim.fn.expand("%:p")
  vim.ui.input({ prompt = " Save As: ", default = current }, function(input)
    if input and #input > 0 then
      vim.cmd("saveas! " .. vim.fn.fnameescape(input))
      vim.notify("Saved as: " .. input, vim.log.levels.INFO)
    end
  end)
end, { desc = "Save As..." })



