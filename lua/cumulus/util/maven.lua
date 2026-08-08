-- Cumulus Maven Utility Helper (Story 4.1 & AR4)

local M = {}

function M.find_pom()
  local cwd = vim.fn.getcwd()
  local pom = vim.fn.findfile("pom.xml", cwd .. ";")

  if pom == "" then
    local current_file = vim.fn.expand("%:p:h")
    if current_file ~= "" then
      pom = vim.fn.findfile("pom.xml", current_file .. ";")
    end
  end

  return pom ~= ""
end

function M.get_mvn_cmd()
  local cwd = vim.fn.getcwd()
  local mvnw = cwd .. "/mvnw"
  if vim.fn.filereadable(mvnw) == 1 then
    if vim.fn.executable(mvnw) == 0 then
      vim.fn.system({ "chmod", "+x", mvnw })
    end
    return "./mvnw"
  end
  return "mvn"
end

function M.run_maven_cmd(cmd)
  if not M.find_pom() then
    vim.notify("No pom.xml found in project", vim.log.levels.WARN)
    return
  end

  local base_cmd = M.get_mvn_cmd()
  if cmd:sub(1, 4) == "mvn " then
    cmd = base_cmd .. cmd:sub(4)
  end

  vim.cmd("botright 15split")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)

  vim.fn.termopen(cmd, {
    on_exit = function(_, code)
      local level = (code == 0) and vim.log.levels.INFO or vim.log.levels.ERROR
      vim.notify("Maven command exited with code " .. code, level)
    end,
  })

  vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = buf, silent = true })
  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = buf, silent = true })
  vim.cmd("startinsert")
end

-- Cold local-repo/offline-mirror resolution can legitimately take a while,
-- but a stuck mvn process (hung proxy auth, dead network) must not hide the
-- gated java/kotlin/maven keymaps (lang-keymaps.lua) forever.
local SYNC_TIMEOUT_MS = 120000

function M.sync_dependencies()
  local sync_state = require("cumulus.util.build-sync-state")

  if not M.find_pom() then
    return
  end

  local base_cmd = M.get_mvn_cmd()
  vim.notify("Maven: syncing dependencies...", vim.log.levels.INFO)
  local timed_out = false
  local timer = (vim.uv or vim.loop).new_timer()
  -- vim.system() throws synchronously (not via the callback) when the
  -- binary doesn't exist at all (ENOENT) -- e.g. no mvnw wrapper and mvn
  -- isn't on $PATH. pcall it so that shows up as a notification instead of
  -- an uncaught error breaking whatever autocmd triggered this.
  local ok, handle_or_err = pcall(vim.system, { base_cmd, "-q", "dependency:resolve" }, { text = true }, function(result)
    timer:stop()
    timer:close()
    vim.schedule(function()
      -- The java/kotlin/maven-related keymaps (lang-keymaps.lua) stay
      -- hidden until sync finishes -- mark ready on success, failure, and
      -- timeout so a broken/offline sync doesn't hide them forever.
      sync_state.mark_ready()
      if timed_out then
        vim.notify("Maven: dependency sync timed out after " .. (SYNC_TIMEOUT_MS / 1000) .. "s", vim.log.levels.ERROR)
      elseif result.code == 0 then
        vim.notify("Maven: dependencies synced", vim.log.levels.INFO)
      else
        local detail = (result.stderr ~= "" and result.stderr)
          or (result.stdout ~= "" and result.stdout)
          or ("exit code " .. result.code)
        vim.notify("Maven: dependency sync failed\n" .. detail, vim.log.levels.ERROR)
      end
    end)
  end)
  if ok then
    local handle = handle_or_err
    timer:start(
      SYNC_TIMEOUT_MS,
      0,
      vim.schedule_wrap(function()
        timed_out = true
        pcall(handle.kill, handle, "sigterm")
      end)
    )
  else
    timer:close()
    sync_state.mark_ready()
    vim.notify(
      "Maven: dependency sync failed to start (" .. base_cmd .. " not found)\n" .. tostring(handle_or_err),
      vim.log.levels.ERROR
    )
  end
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

  if pom_path ~= "" then
    local pom_content = table.concat(vim.fn.readfile(pom_path), "\n")
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

    table.insert(plugin_goals, "dependency:tree")
    table.insert(plugin_goals, "dependency:analyze")
    table.insert(plugin_goals, "dependency:resolve")
    table.insert(plugin_goals, "help:effective-pom")
    table.insert(plugin_goals, "help:active-profiles")

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
  local base_cmd = M.get_mvn_cmd()

  vim.ui.select(goals, {
    prompt = "Select Maven Goal:",
    format_item = function(item)
      return base_cmd .. " " .. item
    end,
  }, function(choice)
    if choice then
      M.run_maven_cmd(base_cmd .. " " .. choice)
    end
  end)
end

return M
