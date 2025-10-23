-- ~/.config/nvim/lua/plugins/java.lua
-- Lazy.nvim spec: Java + Spring Boot com nvim-java e Spring Initializr
-- Requisitos de sistema sugeridos: JDK 21, Maven, Gradle

return {
  {
    "nvim-java/nvim-java",
    ft = { "java" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "nvim-neotest/neotest",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local java = require("java")
      local function attach_keymaps(buf)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
        end

        local function with_jdtls(callback)
          return function()
            local ok, jdtls = pcall(require, "jdtls")
            if not ok then
              vim.notify("jdtls não carregado; abra um projeto Java com LSP ativo", vim.log.levels.WARN)
              return
            end
            callback(jdtls)
          end
        end

        local ok, wk = pcall(require, "which-key")
        if ok then
          wk.add({
            { "<leader>j", group = "+Java" },
            { "<leader>js", group = "+Serviços" },
            { "<leader>jt", group = "+Testes" },
            { "<leader>jb", group = "+Build" },
          }, { buffer = buf })
        end

        map("n", "<leader>jbo", with_jdtls(function(jdtls)
          if jdtls.organize_imports then
            jdtls.organize_imports()
          else
            vim.notify("Função organize_imports indisponível no jdtls atual", vim.log.levels.WARN)
          end
        end), "Organizar imports")

        map("n", "<leader>jbb", with_jdtls(function(jdtls)
          if jdtls.compile then
            jdtls.compile("full")
          else
            vim.notify("Função compile indisponível no jdtls atual", vim.log.levels.WARN)
          end
        end), "Build do projeto (compile full)")

        map("n", "<leader>jtr", java.test.run_current_method, "Rodar teste atual")
        map("n", "<leader>jtR", java.test.run_current_class, "Rodar testes da classe")
        map("n", "<leader>jtd", java.test.debug_current_method, "Debug teste atual")
        map("n", "<leader>jtD", java.test.debug_current_class, "Debug testes da classe")
        map("n", "<leader>jtv", java.test.view_last_report, "Abrir último relatório")

        map("n", "<leader>jsr", java.runner.built_in.run_app, "Rodar aplicação principal")
        map("n", "<leader>jss", java.runner.built_in.stop_app, "Parar aplicação")
        map("n", "<leader>jsl", java.runner.built_in.toggle_logs, "Alternar logs")
        map("n", "<leader>jsS", java.runner.built_in.switch_app, "Alternar aplicação ativa")

        map("n", "<leader>jbk", java.settings.change_runtime, "Selecionar runtime Java")
        map("n", "<leader>jdp", java.dap.config_dap, "Configurar DAP")
        map("n", "<leader>jpp", java.profile.ui, "Abrir painel de perfis")
      end

      java.setup({
        debug = { enabled = true },
        test = { enabled = true },
        spring_boot_tools = { enabled = true },
        -- Ajustes úteis do JDTLS
        jdtls = {
          java = {
            format = { enabled = true },
            configuration = { updateBuildConfiguration = "interactive" },
            contentProvider = { preferred = "fernflower" },
            completion = {
              favoriteStaticMembers = {
                "org.junit.jupiter.api.Assertions.*",
                "org.assertj.core.api.Assertions.*",
                "org.mockito.Mockito.*",
              },
            },
          },
        },
      })

      -- Keymaps por buffer quando abrir arquivo Java
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function(event)
          attach_keymaps(event.buf)
        end,
      })

      -- Aplica imediatamente quando o plugin for carregado em buffers Java existentes
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == "java" then
          attach_keymaps(buf)
        end
      end
    end,
  },
}
