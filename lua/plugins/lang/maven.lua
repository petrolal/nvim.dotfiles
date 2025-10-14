local is_windows = vim.fn.has("win32") == 1
local root_markers = { "pom.xml", "mvnw", "mvnw.cmd", ".mvn" }

local function find_project_root(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return nil
  end
  local path = vim.api.nvim_buf_get_name(bufnr)
  local start_dir = (path ~= "" and vim.fs.dirname(path)) or vim.loop.cwd()
  if not start_dir then
    return nil
  end

  local match = vim.fs.find(root_markers, { path = start_dir, upward = true })[1]
  if not match then
    return nil
  end

  if vim.fn.isdirectory(match) == 1 then
    return match
  end

  return vim.fs.dirname(match)
end

local function maven_executable(root)
  if root then
    local wrapper = is_windows and "mvnw.cmd" or "mvnw"
    local wrapper_path = vim.fs.joinpath(root, wrapper)
    if vim.fn.filereadable(wrapper_path) == 1 then
      return is_windows and "mvnw.cmd" or "./mvnw"
    end
  end
  return "mvn"
end

local function run_maven(opts)
  opts = opts or {}
  local root = find_project_root()
  if not root then
    vim.notify("Maven: nenhum pom.xml encontrado para determinar o projeto.", vim.log.levels.WARN)
    return
  end

  local exec = maven_executable(root)

  local parts = { exec }

  if opts.profiles and opts.profiles ~= "" then
    table.insert(parts, "-P" .. opts.profiles)
  end

  if opts.properties then
    if type(opts.properties) == "table" then
      for _, prop in ipairs(opts.properties) do
        table.insert(parts, prop)
      end
    else
      table.insert(parts, opts.properties)
    end
  end

  if opts.goals then
    local goals = opts.goals
    if type(goals) == "string" then
      goals = { goals }
    end
    vim.list_extend(parts, goals)
  end

  if opts.args then
    if type(opts.args) == "table" then
      vim.list_extend(parts, opts.args)
    else
      table.insert(parts, opts.args)
    end
  end

  local command = table.concat(parts, " ")
  vim.notify("Maven ▶ " .. command, vim.log.levels.INFO)

  vim.system(parts, { cwd = root, text = true }, function(result)
    local code = result.code or result.exit_code or 0
    local stdout = result.stdout or ""
    local stderr = result.stderr or ""
    local message = stderr ~= "" and stderr or stdout
    local lines = vim.split(message, "\n", { trimempty = true })
    if vim.tbl_isempty(lines) then
      lines = { "Sem saída." }
    end

    vim.schedule(function()
      if code == 0 then
        vim.notify("Maven ✓ " .. command, vim.log.levels.INFO)
      else
        vim.fn.setqflist({}, " ", {
          title = "Maven: " .. command,
          lines = lines,
        })
        vim.cmd.copen()
        vim.notify("Maven ✗ " .. command .. " (detalhes em :copen)", vim.log.levels.ERROR)
      end
    end)
  end)
end

local function run_lifecycle(goal)
  return function()
    run_maven({ goals = goal })
  end
end

local lifecycle_targets = {
  { label = "Validate", goal = "validate" },
  { label = "Clean", goal = "clean" },
  { label = "Compile", goal = "compile" },
  { label = "Test", goal = "test" },
  { label = "Package", goal = "package" },
  { label = "Verify", goal = "verify" },
  { label = "Install", goal = "install" },
  { label = "Deploy", goal = "deploy" },
}

local function select_lifecycle()
  vim.ui.select(lifecycle_targets, {
    prompt = "Selecione um objetivo do ciclo de vida Maven",
    format_item = function(item)
      return string.format("%s (%s)", item.label, item.goal)
    end,
  }, function(choice)
    if choice then
      run_maven({ goals = choice.goal })
    end
  end)
end

local function run_with_profiles()
  vim.ui.input({ prompt = "Perfis Maven (-P)" }, function(profile)
    if not profile or profile == "" then
      return
    end
    vim.ui.input({ prompt = "Objetivo Maven", default = "package" }, function(goal)
      if not goal or goal == "" then
        return
      end
      local goals = vim.split(goal, "%s+", { trimempty = true })
      run_maven({ goals = goals, profiles = profile })
    end)
  end)
end

local function run_custom()
  vim.ui.input({ prompt = "Argumentos Maven" }, function(input)
    if not input or input == "" then
      return
    end
    run_maven({ args = input })
  end)
end

local function run_spring_boot()
  run_maven({ goals = { "spring-boot:run" } })
end

local maven_mappings = {
  { "<leader>mc", run_lifecycle("clean"), "Maven: clean" },
  { "<leader>mb", run_lifecycle("package"), "Maven: package" },
  { "<leader>mt", run_lifecycle("test"), "Maven: test" },
  { "<leader>mi", run_lifecycle("install"), "Maven: install" },
  { "<leader>md", run_lifecycle("deploy"), "Maven: deploy" },
  { "<leader>ml", select_lifecycle, "Maven: selecionar objetivo" },
  { "<leader>mP", run_with_profiles, "Maven: executar com perfis" },
  { "<leader>mS", run_spring_boot, "Maven: spring-boot:run" },
  { "<leader>mE", run_custom, "Maven: comando personalizado" },
}

local function apply_buffer_keymaps(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if vim.b[bufnr].maven_keymaps_applied then
    return
  end
  for _, map in ipairs(maven_mappings) do
    vim.keymap.set("n", map[1], map[2], { buffer = bufnr, desc = map[3] })
  end
  vim.b[bufnr].maven_keymaps_applied = true
end

local function remove_buffer_keymaps(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.b[bufnr].maven_keymaps_applied then
    return
  end
  for _, map in ipairs(maven_mappings) do
    pcall(vim.keymap.del, "n", map[1], { buffer = bufnr })
  end
  vim.b[bufnr].maven_keymaps_applied = false
end

return {
  {
    "LazyVim/LazyVim",
    optional = true,
    init = function()
      local function maybe_apply(event)
        local buf = event.buf or vim.api.nvim_get_current_buf()
        if find_project_root(buf) then
          apply_buffer_keymaps(buf)
        else
          remove_buffer_keymaps(buf)
        end
      end

      local util_ok, util = pcall(require, "lazyvim.util")
      if util_ok and util.on_very_lazy then
        util.on_very_lazy(function()
          vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
            callback = maybe_apply,
          })
          vim.api.nvim_create_autocmd({ "BufDelete" }, {
            callback = function(event)
              vim.b[event.buf].maven_keymaps_applied = nil
            end,
          })
        end)
      else
        vim.api.nvim_create_autocmd("User", {
          pattern = "LazyVimVeryLazy",
          once = true,
          callback = function()
            vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
              callback = maybe_apply,
            })
            vim.api.nvim_create_autocmd({ "BufDelete" }, {
              callback = function(event)
                vim.b[event.buf].maven_keymaps_applied = nil
              end,
            })
          end,
        })
      end
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>m", group = "Maven" })
    end,
  },
}
