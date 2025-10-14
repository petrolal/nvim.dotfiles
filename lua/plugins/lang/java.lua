local root_markers = {
  "gradlew",
  "mvnw",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  ".git",
}

local function detect_os_config()
  local system = vim.loop.os_uname().sysname
  if system:find("Windows", 1, true) then
    return "win"
  end
  if system == "Darwin" then
    return "mac"
  end
  return "linux"
end

local missing_packages = {}
local warned = {}

local function lsp_clients(filter)
  local get = vim.lsp and (vim.lsp.get_clients or vim.lsp.get_active_clients)
  if not get then
    return {}
  end
  return get(filter)
end

local function supports_main_class_resolution(client)
  if not client or type(client.server_capabilities) ~= "table" then
    return false
  end
  local provider = client.server_capabilities.executeCommandProvider
  if type(provider) ~= "table" then
    return false
  end
  local commands = provider.commands
  if type(commands) ~= "table" then
    return false
  end
  return vim.tbl_contains(commands, "vscode.java.resolveMainClass")
end

local function bundles_equal(a, b)
  if a == b then
    return true
  end
  if type(a) ~= "table" or type(b) ~= "table" then
    return false
  end
  if #a ~= #b then
    return false
  end
  local seen = {}
  for _, path in ipairs(a) do
    seen[path] = (seen[path] or 0) + 1
  end
  for _, path in ipairs(b) do
    if not seen[path] then
      return false
    end
    seen[path] = seen[path] - 1
    if seen[path] == 0 then
      seen[path] = nil
    end
  end
  return next(seen) == nil
end

local function mason_package_path(name)
  local ok, registry = pcall(require, "mason-registry")
  if ok then
    if registry.has_package(name) then
      local pkg = registry.get_package(name)
      if type(pkg) == "table" and type(pkg.is_installed) == "function" and type(pkg.get_install_path) == "function" then
        if pkg:is_installed() then
          return pkg:get_install_path()
        end
        if not missing_packages[name] then
          vim.notify_once(
            string.format("Instale o pacote Mason '%s' para habilitar recursos Java.", name),
            vim.log.levels.WARN
          )
          missing_packages[name] = true
        end
        return nil
      end
    end
  end

  local mason_dir = vim.fn.stdpath("data")
  local fallback = vim.fs.joinpath(mason_dir, "mason", "packages", name)
  if vim.fn.isdirectory(fallback) == 1 then
    return fallback
  end

  if not missing_packages[name] then
    vim.notify_once(string.format("Não foi possível localizar o pacote Mason '%s'.", name), vim.log.levels.WARN)
    missing_packages[name] = true
  end
  return nil
end

local function jdtls_install_path()
  local mason_path = mason_package_path("jdtls")
  if mason_path then
    return mason_path
  end

  local env_path = vim.env.JDTLS_HOME
  if env_path and env_path ~= "" and vim.fn.isdirectory(env_path) == 1 then
    return env_path
  end

  return nil
end

local function collect_bundles()
  local bundles = {}

  local debug_path = mason_package_path("java-debug-adapter")
  if debug_path then
    local plugin_pattern = vim.fs.joinpath(debug_path, "extension", "server", "com.microsoft.java.debug.plugin-*.jar")
    for _, jar in ipairs(vim.fn.glob(plugin_pattern, true, true)) do
      table.insert(bundles, jar)
    end
  end

  local test_path = mason_package_path("java-test")
  if test_path then
    local test_pattern = vim.fs.joinpath(test_path, "extension", "server", "*.jar")
    vim.list_extend(bundles, vim.fn.glob(test_pattern, true, true))
  end

  local extra_bundles = vim.env.JDTLS_BUNDLES
  if extra_bundles and extra_bundles ~= "" then
    for path in extra_bundles:gmatch("[^:;]+") do
      local trimmed = vim.trim(path)
      if trimmed ~= "" and vim.fn.filereadable(trimmed) == 1 then
        table.insert(bundles, trimmed)
      end
    end
  end

  return bundles
end

local function jdtls_cmd(workspace)
  local java_home = vim.env.JAVA_HOME and vim.fs.joinpath(vim.env.JAVA_HOME, "bin", "java") or nil
  local java = java_home or vim.fn.exepath("java")
  if java == "" then
    return nil
  end

  local jdtls_path = jdtls_install_path()
  if not jdtls_path then
    return nil
  end

  local launcher = vim.fn.glob(vim.fs.joinpath(jdtls_path, "plugins", "org.eclipse.equinox.launcher_*.jar"), true, true)
  if not launcher or #launcher == 0 then
    if not warned.launcher then
      vim.notify_once(
        "Launcher do jdtls não encontrado. Ajuste a variável de ambiente JDTLS_HOME ou instale via Mason.",
        vim.log.levels.WARN
      )
      warned.launcher = true
    end
    return nil
  end

  local config_dir = vim.env.JDTLS_CONFIG_DIR or vim.fs.joinpath(jdtls_path, "config_" .. detect_os_config())
  if vim.fn.isdirectory(config_dir) == 0 then
    if not warned.config then
      vim.notify_once(
        "Diretório de configuração do jdtls não encontrado. Ajuste JDTLS_CONFIG_DIR.",
        vim.log.levels.WARN
      )
      warned.config = true
    end
    return nil
  end

  return {
    java,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    launcher[1],
    "-configuration",
    config_dir,
    "-data",
    workspace,
  }
end

local function setup_jdtls()
  local jdtls = require("jdtls")
  local jdtls_setup = require("jdtls.setup")

  local root_dir = jdtls_setup.find_root(root_markers)
  if not root_dir then
    return
  end

  local project_name = vim.fs.basename(root_dir)
  local workspace_root = vim.fs.joinpath(vim.fn.stdpath("data"), "jdtls", project_name)
  vim.fn.mkdir(workspace_root, "p")

  local cmd = jdtls_cmd(workspace_root)
  if not cmd then
    vim.notify_once(
      "Java Language Server não encontrado. Verifique o JAVA_HOME e a instalação do jdtls.",
      vim.log.levels.WARN
    )
    return
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp then
    capabilities = cmp_lsp.default_capabilities(capabilities)
  end

  local extended_capabilities = jdtls.extendedClientCapabilities
  extended_capabilities.resolveAdditionalTextEditsSupport = true

  local bundles = collect_bundles()

  local config = {
    cmd = cmd,
    root_dir = root_dir,
    capabilities = capabilities,
    settings = {
      java = {
        configuration = {
          updateBuildConfiguration = "interactive",
        },
        completion = {
          favoriteStaticMembers = {
            "org.assertj.core.api.Assertions.*",
            "org.mockito.Mockito.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.eclipse.jdt.ls.core.internal.handlers.CompletionProposalHandler.getDistinctImports",
          },
          filteredTypes = {
            "com.sun.*",
            "sun.*",
            "jdk.*",
            "org.graalvm.*",
          },
        },
        contentProvider = { preferred = "fernflower" },
        eclipse = { downloadSources = true },
        flags = {
          allow_incremental_sync = true,
        },
        signatureHelp = { enabled = true },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
      },
    },
    init_options = {
      bundles = bundles,
      extendedClientCapabilities = extended_capabilities,
    },
    on_attach = function(client, bufnr)
      local util_ok, util = pcall(require, "lazyvim.util")
      if util_ok and util.lsp and util.lsp.on_attach then
        util.lsp.on_attach(client, bufnr)
      end

      jdtls_setup.add_commands()
      jdtls.setup_dap({ hotcodereplace = "auto" })
      local dap_ok, jdtls_dap = pcall(require, "jdtls.dap")
      if dap_ok then
        if supports_main_class_resolution(client) then
          vim.schedule(function()
            local ok_main, err = pcall(jdtls_dap.setup_dap_main_class_configs)
            if not ok_main and not warned.dap then
              vim.notify_once("DAP Java: " .. err, vim.log.levels.WARN)
              warned.dap = true
            end
          end)
        elseif not warned.main_class then
          vim.notify_once(
            "Servidor Java não suporta descoberta de main class (vscode.java.resolveMainClass). Atualize o jdtls.",
            vim.log.levels.INFO
          )
          warned.main_class = true
        end
      end

      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      map("n", "<leader>jo", jdtls.organize_imports, "Java: organizar imports")
      map("n", "<leader>jv", function()
        jdtls.extract_variable(true)
      end, "Java: extrair variável")
      map("n", "<leader>jc", function()
        jdtls.test_class({ config_overrides = { noDebug = true } })
      end, "Java: testar classe")
      map("n", "<leader>jn", function()
        jdtls.test_nearest_method({ config_overrides = { noDebug = true } })
      end, "Java: testar método")
      map("n", "<leader>jC", function()
        jdtls.test_class()
      end, "Java: depurar classe")
      map("n", "<leader>jN", function()
        jdtls.test_nearest_method()
      end, "Java: depurar método")
      map("v", "<leader>jm", function()
        jdtls.extract_method(true)
      end, "Java: extrair método")
      map("n", "<leader>jR", function()
        jdtls.rename_file()
      end, "Java: renomear arquivo")
    end,
  }

  local existing_client
  for _, client in ipairs(lsp_clients({ name = "jdtls" })) do
    if client.config and client.config.root_dir == root_dir then
      existing_client = client
      break
    end
  end

  if existing_client then
    local current_bundles = {}
    if existing_client.config and existing_client.config.init_options then
      current_bundles = existing_client.config.init_options.bundles or {}
    end
    if not bundles_equal(current_bundles, bundles) then
      existing_client.stop()
      existing_client = nil
    end
  end

  jdtls.start_or_attach(config)
end

return {
  { import = "lazyvim.plugins.extras.lang.java" },
  { import = "lazyvim.plugins.extras.dap.core" },
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = setup_jdtls,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.java = { "google-java-format" }
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>j", group = "java" })
    end,
  },
}
