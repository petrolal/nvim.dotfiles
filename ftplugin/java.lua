-- Java JDTLS Ftplugin Auto-Launcher (Story 4.1 & Story 13.3)

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

local config = {
  cmd = { "jdtls" },
  root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
}

jdtls.start_or_attach(config)
