local M = {}

M.keymaps_registered = false

function M.find_gradle()
  local cwd = vim.fn.getcwd()
  local build_gradle = vim.fn.findfile("build.gradle", cwd .. ";")
  local build_gradle_kts = vim.fn.findfile("build.gradle.kts", cwd .. ";")
  
  -- Se não encontrou, tenta a partir do arquivo atual (caso esteja editando)
  if build_gradle == "" and build_gradle_kts == "" then
    local current_file = vim.fn.expand("%:p:h")
    if current_file ~= "" then
      build_gradle = vim.fn.findfile("build.gradle", current_file .. ";")
      build_gradle_kts = vim.fn.findfile("build.gradle.kts", current_file .. ";")
    end
  end
  
  return build_gradle ~= "" or build_gradle_kts ~= ""
end

function M.run_gradle_cmd(cmd)
  if not M.find_gradle() then
    vim.notify("No build.gradle or build.gradle.kts found in project", vim.log.levels.WARN)
    return
  end

  -- Cria split horizontal embaixo (como VSCode)
  vim.cmd("botright 15split")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)

  -- Abre terminal no buffer
  vim.fn.termopen(cmd, {
    on_exit = function()
      vim.notify("Gradle command finished", vim.log.levels.INFO)
    end,
  })

  -- Mapeia q para fechar
  vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = buf, silent = true })
  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = buf, silent = true })

  -- Entra no modo insert
  vim.cmd("startinsert")
end

function M.run_gradle_task()
  if not M.find_gradle() then
    vim.notify("No build.gradle or build.gradle.kts found in project", vim.log.levels.WARN)
    return
  end

  local tasks = {
    "clean",
    "build",
    "test",
    "assemble",
    "check",
    "bootRun",
    "bootJar",
    "dependencies",
    "tasks",
    "clean build",
    "clean test",
    "clean bootRun",
  }

  vim.ui.select(tasks, {
    prompt = "Select Gradle Task:",
    format_item = function(item)
      return "./gradlew " .. item
    end,
  }, function(choice)
    if choice then
      M.run_gradle_cmd("./gradlew " .. choice)
    end
  end)
end

function M.setup()
  local wk = require("which-key")

  wk.add({
    { "<leader>j", group = "Java", icon = "󰬷 " },
    { "<leader>jg", group = "Gradle", icon = " " },
    {
      "<leader>jgc",
      function()
        M.run_gradle_cmd("./gradlew clean")
      end,
      desc = "Gradle Clean",
      icon = "󰃢 ",
    },
    {
      "<leader>jgb",
      function()
        M.run_gradle_cmd("./gradlew build")
      end,
      desc = "Gradle Build",
      icon = " ",
    },
    {
      "<leader>jgt",
      function()
        M.run_gradle_cmd("./gradlew test")
      end,
      desc = "Gradle Test",
      icon = "󰙨 ",
    },
    {
      "<leader>jga",
      function()
        M.run_gradle_cmd("./gradlew assemble")
      end,
      desc = "Gradle Assemble",
      icon = "󰏗 ",
    },
    {
      "<leader>jgC",
      function()
        M.run_gradle_cmd("./gradlew check")
      end,
      desc = "Gradle Check",
      icon = "󰄬 ",
    },
    {
      "<leader>jgB",
      function()
        M.run_gradle_cmd("./gradlew clean build")
      end,
      desc = "Gradle Clean Build",
      icon = "󰚰 ",
    },
    {
      "<leader>jgr",
      function()
        M.run_gradle_cmd("./gradlew bootRun")
      end,
      desc = "Spring Boot Run",
      icon = " ",
    },
    {
      "<leader>jgj",
      function()
        M.run_gradle_cmd("./gradlew bootJar")
      end,
      desc = "Spring Boot Jar",
      icon = "󰡯 ",
    },
    {
      "<leader>jgd",
      function()
        M.run_gradle_cmd("./gradlew dependencies")
      end,
      desc = "Gradle Dependencies",
      icon = " ",
    },
    { "<leader>jgg", M.run_gradle_task, desc = "Gradle Tasks", icon = " " },
  })

  M.keymaps_registered = true
end

return M
