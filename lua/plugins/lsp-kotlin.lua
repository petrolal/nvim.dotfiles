-- kotlin-language-server bundles kotlin-compiler 2.1.0, whose IntelliJ JavaVersion
-- parser cannot handle newer JDK version strings (e.g. Java 25's "25.0.3"), causing
-- an immediate crash on startup. Resolve a Java 21 install (provisioned by
-- scripts/install.sh via openjdk-21-jdk/jdk21-openjdk/java-21-openjdk) and pin the
-- server to it via JAVA_HOME, regardless of the system-wide default JDK.
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

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_language_server = {
          cmd_env = (function()
            local java21_home = find_java21_home()
            if not java21_home then
              return nil
            end
            return { JAVA_HOME = java21_home }
          end)(),
          on_attach = function(client, _)
            -- kotlin-language-server's documentHighlight implementation crashes in Kotlin Compiler 2.1
            -- with UnsupportedOperationException (JSON-RPC error -32603) on annotated classes.
            client.server_capabilities.documentHighlightProvider = false
          end,
          settings = {
            kotlin = {
              -- Redirect database/cache storage path to stdpath("cache") instead of project root
              storagePath = vim.fn.stdpath("cache") .. "/kotlin-language-server",
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
