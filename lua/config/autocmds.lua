-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Auto-save Java & Kotlin files on FocusLost or BufLeave to trigger ktlint & google-java-format
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  pattern = { "*.kt", "*.java", "*.kts" },
  callback = function(event)
    if vim.bo[event.buf].modified and vim.bo[event.buf].buftype == "" then
      vim.api.nvim_buf_call(event.buf, function()
        vim.cmd("silent! write")
      end)
    end
  end,
})

-- Java and Kotlin build tools setup (Maven & Gradle)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "java", "kotlin" },
  callback = function()
    local ok_maven, maven = pcall(require, "util.maven")
    local ok_gradle, gradle = pcall(require, "util.gradle")
    local ok_wk, wk = pcall(require, "which-key")

    if not ok_wk then
      return
    end

    -- Maven mappings
    if ok_maven and maven.find_pom() then
      wk.add({
        { "<leader>j", group = "Java/JVM", icon = "󰬷 " },
        { "<leader>jm", group = "Maven", icon = " " },
        {
          "<leader>jmc",
          function()
            maven.run_maven_cmd("mvn clean")
          end,
          desc = "Maven Clean",
          icon = "󰃢 ",
        },
        {
          "<leader>jmC",
          function()
            maven.run_maven_cmd("mvn compile")
          end,
          desc = "Maven Compile",
          icon = " ",
        },
        {
          "<leader>jmt",
          function()
            maven.run_maven_cmd("mvn test")
          end,
          desc = "Maven Test",
          icon = "󰙨 ",
        },
        {
          "<leader>jmp",
          function()
            maven.run_maven_cmd("mvn package")
          end,
          desc = "Maven Package",
          icon = "󰏗 ",
        },
        {
          "<leader>jmi",
          function()
            maven.run_maven_cmd("mvn install")
          end,
          desc = "Maven Install",
          icon = " ",
        },
        {
          "<leader>jmI",
          function()
            maven.run_maven_cmd("mvn clean install")
          end,
          desc = "Maven Clean Install",
          icon = "󰚰 ",
        },
        {
          "<leader>jmv",
          function()
            maven.run_maven_cmd("mvn verify")
          end,
          desc = "Maven Verify",
          icon = "󰄬 ",
        },
        {
          "<leader>jmr",
          function()
            maven.run_maven_cmd("mvn spring-boot:run")
          end,
          desc = "Spring Boot Run",
          icon = " ",
        },
        {
          "<leader>jmD",
          function()
            maven.run_maven_cmd(
              'mvn spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=*:5005"'
            )
          end,
          desc = "Spring Boot Debug (Port 5005)",
          icon = " ",
        },
        {
          "<leader>jmd",
          function()
            maven.run_maven_cmd("mvn dependency:tree")
          end,
          desc = "Maven Dependency Tree",
          icon = " ",
        },
        { "<leader>jmm", maven.run_maven_goal, desc = "Maven Goals", icon = " " },
      })
    end

    -- Gradle mappings
    if ok_gradle and gradle.find_gradle() then
      wk.add({
        { "<leader>j", group = "Java/JVM", icon = "󰬷 " },
        { "<leader>jg", group = "Gradle", icon = " " },
        {
          "<leader>jgc",
          function()
            gradle.run_gradle_cmd("./gradlew clean")
          end,
          desc = "Gradle Clean",
          icon = "󰃢 ",
        },
        {
          "<leader>jgb",
          function()
            gradle.run_gradle_cmd("./gradlew build")
          end,
          desc = "Gradle Build",
          icon = " ",
        },
        {
          "<leader>jgt",
          function()
            gradle.run_gradle_cmd("./gradlew test")
          end,
          desc = "Gradle Test",
          icon = "󰙨 ",
        },
        {
          "<leader>jga",
          function()
            gradle.run_gradle_cmd("./gradlew assemble")
          end,
          desc = "Gradle Assemble",
          icon = "󰏗 ",
        },
        {
          "<leader>jgC",
          function()
            gradle.run_gradle_cmd("./gradlew check")
          end,
          desc = "Gradle Check",
          icon = "󰄬 ",
        },
        {
          "<leader>jgB",
          function()
            gradle.run_gradle_cmd("./gradlew clean build")
          end,
          desc = "Gradle Clean Build",
          icon = "󰚰 ",
        },
        {
          "<leader>jgr",
          function()
            gradle.run_gradle_cmd("./gradlew bootRun")
          end,
          desc = "Spring Boot Run",
          icon = " ",
        },
        {
          "<leader>jgD",
          function()
            gradle.run_gradle_cmd("./gradlew bootRun --debug-jvm")
          end,
          desc = "Spring Boot Debug (Port 5005)",
          icon = " ",
        },
        {
          "<leader>jgj",
          function()
            gradle.run_gradle_cmd("./gradlew bootJar")
          end,
          desc = "Spring Boot Jar",
          icon = "󰡯 ",
        },
        {
          "<leader>jgd",
          function()
            gradle.run_gradle_cmd("./gradlew dependencies")
          end,
          desc = "Gradle Dependencies",
          icon = " ",
        },
        { "<leader>jgg", gradle.run_gradle_task, desc = "Gradle Tasks", icon = " " },
      })
    end
  end,
})
