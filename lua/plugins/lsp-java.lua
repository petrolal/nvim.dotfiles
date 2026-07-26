return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- 1. Ensure Lombok agent is passed to jdtls JVM args to prevent missing Lombok symbol errors
      local lombok_path = vim.fn.expand("~/.local/share/nvim/mason/share/jdtls/lombok.jar")
      if vim.fn.filereadable(lombok_path) == 0 then
        lombok_path = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/lombok.jar")
      end

      if vim.fn.filereadable(lombok_path) == 1 then
        local orig_full_cmd = opts.full_cmd
        opts.full_cmd = function(options)
          local cmd = orig_full_cmd and orig_full_cmd(options) or { "jdtls" }
          local has_lombok = false
          for _, arg in ipairs(cmd) do
            if type(arg) == "string" and arg:find("lombok.jar") then
              has_lombok = true
              break
            end
          end
          if not has_lombok then
            table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_path)
          end
          return cmd
        end
      end

      -- 2. Configure Java Runtimes & JDTLS options
      local java21_path = "/usr/lib/jvm/java-21-openjdk-amd64"
      local runtimes = {}
      if vim.fn.isdirectory(java21_path) == 1 then
        table.insert(runtimes, {
          name = "JavaSE-21",
          path = java21_path,
          default = true,
        })
      end

      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          configuration = {
            runtimes = runtimes,
          },
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
            },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },
        },
      })
    end,
  },
}
