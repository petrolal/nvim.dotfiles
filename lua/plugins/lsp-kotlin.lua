-- kotlin-language-server bundles kotlin-compiler 2.1.0, whose IntelliJ JavaVersion
-- parser cannot handle newer JDK version strings (e.g. Java 25's "25.0.3"), causing
-- an immediate crash on startup. Resolve a Java 21 install (provisioned by
-- scripts/install.sh via openjdk-21-jdk/jdk21-openjdk/java-21-openjdk) and pin the
-- server to it via JAVA_HOME, regardless of the system-wide default JDK.
local function find_java21_home()
  local candidates = vim.fn.glob("/usr/lib/jvm/java-21-openjdk*", false, true)
  return candidates[1]
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
        },
      },
    },
  },
}
