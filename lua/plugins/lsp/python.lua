return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local join = vim.fs.joinpath
      local is_windows = vim.loop.os_uname().sysname:find("Windows") ~= nil
      local scripts_dir = is_windows and "Scripts" or "bin"
      local python_cmd = is_windows and "python.exe" or "python"

      local function is_executable(cmd)
        return type(cmd) == "string" and cmd ~= "" and vim.fn.executable(cmd) == 1
      end

      local function detect_python_env(workspace)
        local env = vim.env.VIRTUAL_ENV
        if env and env ~= "" then
          local python = join(env, scripts_dir, python_cmd)
          if is_executable(python) then
            return {
              python = python,
              venvPath = vim.fn.fnamemodify(env, ":h"),
              venv = vim.fn.fnamemodify(env, ":t"),
            }
          end
        end

        local project_venv = join(workspace, ".venv")
        local project_python = join(project_venv, scripts_dir, python_cmd)
        if vim.fn.isdirectory(project_venv) == 1 and is_executable(project_python) then
          return {
            python = project_python,
            venvPath = workspace,
            venv = ".venv",
          }
        end

        local python3 = vim.fn.exepath("python3")
        if is_executable(python3) then
          return { python = python3 }
        end

        local python = vim.fn.exepath("python")
        if is_executable(python) then
          return { python = python }
        end

        return { python = "python" }
      end

      opts.servers = opts.servers or {}
      opts.servers.pyright = nil

      opts.setup = opts.setup or {}
      opts.setup.basedpyright = function(_, server_opts)
        local workspace = server_opts.root_dir or vim.loop.cwd()
        local env = detect_python_env(workspace)

        server_opts.settings = server_opts.settings or {}
        local python_settings = {
          pythonPath = env.python,
          defaultInterpreterPath = env.python,
        }

        if env.venvPath then
          python_settings.venvPath = env.venvPath
        end

        if env.venv then
          python_settings.venv = env.venv
        end

        server_opts.settings.python = vim.tbl_deep_extend(
          "force",
          server_opts.settings.python or {},
          python_settings
        )
      end

      opts.servers.basedpyright = vim.tbl_deep_extend("force", opts.servers.basedpyright or {}, {
        settings = {
          python = {
            analysis = {
              autoImportCompletions = true,
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              typeCheckingMode = "standard",
              useLibraryCodeForTypes = true,
            },
          },
        },
      })
    end,
  },
}
