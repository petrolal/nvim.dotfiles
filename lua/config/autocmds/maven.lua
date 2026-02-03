local M = {}

M.keymaps_registered = false

function M.find_pom()
  local cwd = vim.fn.getcwd()
  local pom = vim.fn.findfile("pom.xml", cwd .. ";")
  
  -- Se não encontrou, tenta a partir do arquivo atual (caso esteja editando)
  if pom == "" then
    local current_file = vim.fn.expand("%:p:h")
    if current_file ~= "" then
      pom = vim.fn.findfile("pom.xml", current_file .. ";")
    end
  end
  
  return pom ~= ""
end

function M.run_maven_cmd(cmd)
  if not M.find_pom() then
    vim.notify("No pom.xml found in project", vim.log.levels.WARN)
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
      vim.notify("Maven command finished", vim.log.levels.INFO)
    end,
  })

  -- Mapeia q para fechar
  vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = buf, silent = true })
  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = buf, silent = true })

  -- Entra no modo insert
  vim.cmd("startinsert")
end

function M.get_maven_goals()
  local cwd = vim.fn.getcwd()
  local pom_path = vim.fn.findfile("pom.xml", cwd .. ";")
  
  if pom_path == "" then
    local current_file = vim.fn.expand("%:p:h")
    if current_file ~= "" then
      pom_path = vim.fn.findfile("pom.xml", current_file .. ";")
    end
  end

  -- Goals básicos do Maven
  local goals = {
    "clean",
    "validate",
    "compile",
    "test",
    "package",
    "verify",
    "install",
    "deploy",
    "clean compile",
    "clean test",
    "clean package",
    "clean install",
    "clean verify",
  }

  -- Lê o pom.xml para detectar plugins
  if pom_path ~= "" then
    local pom_content = table.concat(vim.fn.readfile(pom_path), "\n")
    
    -- Detecta plugins conhecidos e adiciona goals específicos
    local plugin_goals = {}
    
    if pom_content:match("spring%-boot%-maven%-plugin") then
      table.insert(plugin_goals, "spring-boot:run")
      table.insert(plugin_goals, "spring-boot:build-image")
      table.insert(plugin_goals, "spring-boot:repackage")
    end
    
    if pom_content:match("quarkus%-maven%-plugin") then
      table.insert(plugin_goals, "quarkus:dev")
      table.insert(plugin_goals, "quarkus:build")
      table.insert(plugin_goals, "quarkus:test")
    end
    
    if pom_content:match("maven%-surefire%-plugin") or pom_content:match("<test") then
      table.insert(plugin_goals, "test-compile")
      table.insert(plugin_goals, "surefire:test")
    end
    
    if pom_content:match("maven%-failsafe%-plugin") then
      table.insert(plugin_goals, "failsafe:integration-test")
      table.insert(plugin_goals, "verify")
    end
    
    if pom_content:match("exec%-maven%-plugin") then
      table.insert(plugin_goals, "exec:java")
      table.insert(plugin_goals, "exec:exec")
    end
    
    -- Adiciona goals de dependências (sempre úteis)
    table.insert(plugin_goals, "dependency:tree")
    table.insert(plugin_goals, "dependency:analyze")
    table.insert(plugin_goals, "dependency:resolve")
    
    -- Adiciona goals de help
    table.insert(plugin_goals, "help:effective-pom")
    table.insert(plugin_goals, "help:active-profiles")
    
    -- Merge com goals básicos
    for _, goal in ipairs(plugin_goals) do
      table.insert(goals, goal)
    end
  end

  return goals
end

function M.run_maven_goal()
  if not M.find_pom() then
    vim.notify("No pom.xml found in project", vim.log.levels.WARN)
    return
  end

  vim.notify("Loading Maven goals...", vim.log.levels.INFO)
  
  local goals = M.get_maven_goals()

  vim.ui.select(goals, {
    prompt = "Select Maven Goal:",
    format_item = function(item)
      return "mvn " .. item
    end,
  }, function(choice)
    if choice then
      M.run_maven_cmd("mvn " .. choice)
    end
  end)
end

function M.setup()
  local wk = require("which-key")
  
  wk.add({
    { "<leader>j", group = "Java", icon = "󰬷 " },
    { "<leader>jm", group = "Maven", icon = " " },
    { "<leader>jmc", function() M.run_maven_cmd("mvn clean") end, desc = "Maven Clean", icon = "󰃢 " },
    { "<leader>jmC", function() M.run_maven_cmd("mvn compile") end, desc = "Maven Compile", icon = " " },
    { "<leader>jmt", function() M.run_maven_cmd("mvn test") end, desc = "Maven Test", icon = "󰙨 " },
    { "<leader>jmp", function() M.run_maven_cmd("mvn package") end, desc = "Maven Package", icon = "󰏗 " },
    { "<leader>jmi", function() M.run_maven_cmd("mvn install") end, desc = "Maven Install", icon = " " },
    { "<leader>jmI", function() M.run_maven_cmd("mvn clean install") end, desc = "Maven Clean Install", icon = "󰚰 " },
    { "<leader>jmv", function() M.run_maven_cmd("mvn verify") end, desc = "Maven Verify", icon = "󰄬 " },
    { "<leader>jmr", function() M.run_maven_cmd("mvn spring-boot:run") end, desc = "Spring Boot Run", icon = " " },
    { "<leader>jmd", function() M.run_maven_cmd("mvn dependency:tree") end, desc = "Maven Dependency Tree", icon = " " },
    { "<leader>jmm", M.run_maven_goal, desc = "Maven Goals", icon = " " },
  })
  
  M.keymaps_registered = true
end

return M
