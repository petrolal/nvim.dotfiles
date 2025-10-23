local map = vim.keymap.set

local java = require("java").setup({
  spring_boot_tools = { enabled = true },
  debug = { enabled = true },
  test = { enabled = true },
})

map("n", "<leader>jr", java.codeAction.organizeImports, { desc = "Organizar imports" })
map("n", "<leader>jb", java.build.project, { desc = "Build Java" })
map("n", "<leader>jd", java.debug.test_class, { desc = "Debug Teste da Classe" })
map("n", "<leader>jt", java.test.run, { desc = "Rodar Teste Atual" })
map("n", "<leader>js", java.spring.boot.run, { desc = "Rodar Spring Boot" })
