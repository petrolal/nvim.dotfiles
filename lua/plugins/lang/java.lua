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
        callback = function()
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true, desc = desc })
          end
          local j = require("java")

          -- grupos no which-key (buffer-local)
          local wk = require("which-key")
          wk.add({
            { "<leader>j", group = "+Java" },
            { "<leader>js", group = "+Spring Boot" },
            { "<leader>jt", group = "+Testes" },
            { "<leader>jb", group = "+Build" },
          }, { buffer = 0 })

          -- Build / code actions
          map("n", "<leader>jbo", j.codeAction.organizeImports, "Organizar imports")
          map("n", "<leader>jbb", j.build.project, "Build do projeto")

          -- Testes
          map("n", "<leader>jtr", j.test.nearest_method, "Rodar teste atual")
          map("n", "<leader>jtR", j.test.nearest_class, "Rodar testes da classe")
          map("n", "<leader>jtd", j.debug.test_nearest_method, "Debug teste atual")
          map("n", "<leader>jtD", j.debug.test_class, "Debug testes da classe")

          -- Spring Boot
          map("n", "<leader>jsr", j.spring.boot.run, "Rodar Spring Boot")
          map("n", "<leader>jsd", j.spring.boot.debug, "Debug Spring Boot")
          map("n", "<leader>jss", j.spring.boot.stop, "Parar Spring Boot")
        end,
      })
    end,
  },
}
