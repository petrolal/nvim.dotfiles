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

  -- Verifica se gradlew existe e é executável
  local gradlew = vim.fn.getcwd() .. "/gradlew"
  local gradlew_exists = vim.fn.filereadable(gradlew) == 1
  local gradlew_executable = vim.fn.executable(gradlew) == 1
  
  -- Se gradlew existe mas não é executável, torna executável
  if gradlew_exists and not gradlew_executable then
    vim.fn.system("chmod +x " .. gradlew)
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

function M.get_gradle_tasks()
  local gradlew = vim.fn.getcwd() .. "/gradlew"
  local gradlew_exists = vim.fn.filereadable(gradlew) == 1
  
  if gradlew_exists then
    local gradlew_executable = vim.fn.executable(gradlew) == 1
    if not gradlew_executable then
      vim.fn.system("chmod +x " .. gradlew)
    end
  end

  local cmd = gradlew_exists and "./gradlew tasks --all" or "gradle tasks --all"
  local output = vim.fn.system(cmd)
  
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to fetch Gradle tasks", vim.log.levels.ERROR)
    return {}
  end

  local tasks = {}
  local in_tasks_section = false
  
  for line in output:gmatch("[^\r\n]+") do
    if line:match("^%-%-%-%-") or line:match("^All tasks") or line:match("^Build tasks") or line:match("^[A-Z][a-z]+ tasks") then
      in_tasks_section = true
    elseif line:match("^$") or line:match("^To see all tasks") then
      in_tasks_section = false
    elseif in_tasks_section then
      local task = line:match("^(%S+)%s*%-")
      if task and not task:match("^%-") and not task:match("^To") and not task:match("^Pattern") then
        table.insert(tasks, task)
      end
    end
  end

  -- Remove duplicatas
  local unique_tasks = {}
  local seen = {}
  for _, task in ipairs(tasks) do
    if not seen[task] then
      table.insert(unique_tasks, task)
      seen[task] = true
    end
  end

  -- Adiciona combinações úteis
  if #unique_tasks > 0 then
    table.insert(unique_tasks, 1, "clean build")
    table.insert(unique_tasks, 1, "clean test")
  end

  return unique_tasks
end

function M.run_gradle_task()
  if not M.find_gradle() then
    vim.notify("No build.gradle or build.gradle.kts found in project", vim.log.levels.WARN)
    return
  end

  vim.notify("Loading Gradle tasks...", vim.log.levels.INFO)
  
  local tasks = M.get_gradle_tasks()
  
  if #tasks == 0 then
    vim.notify("No Gradle tasks found", vim.log.levels.WARN)
    return
  end

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
