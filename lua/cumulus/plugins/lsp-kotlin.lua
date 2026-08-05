local function find_java21_home()
  local patterns = {
    "/usr/lib/jvm/java-21-openjdk*",
    "/usr/lib/jvm/java-21*",
    "/usr/lib/jvm/jdk-21*",
    vim.fn.expand("~/.sdkman/candidates/java/21*"),
    "/usr/lib/jvm/default-java",
  }
  for _, pat in ipairs(patterns) do
    local candidates = vim.fn.glob(pat, false, true)
    if #candidates > 0 and vim.fn.isdirectory(candidates[1]) == 1 then
      return candidates[1]
    end
  end
  return nil
end

local storage_path = vim.fn.stdpath("cache") .. "/kotlin-language-server"
vim.fn.mkdir(storage_path, "p")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_language_server = {
          init_options = {
            storagePath = storage_path,
          },
          cmd_env = (function()
            local java21_home = find_java21_home()
            if not java21_home then
              return nil
            end
            return { JAVA_HOME = java21_home }
          end)(),
          on_attach = function(client, _)
            client.server_capabilities.documentHighlightProvider = false

            local root = client.config.root_dir or vim.fn.getcwd()
            if root and root ~= "" then
              local kls_files = vim.fn.glob(root .. "/kls_database*", false, true)
              for _, f in ipairs(kls_files) do
                vim.fn.delete(f)
              end
            end
          end,
          settings = {
            kotlin = {
              storagePath = storage_path,
              compiler = {
                jvm = {
                  target = "21",
                },
              },
              hints = {
                typeHints = true,
                parameterHints = true,
                chainedMemberFunctionHints = true,
              },
            },
          },
        },
      },
    },
  },
}
