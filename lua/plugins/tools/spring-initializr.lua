return {
  {
    "jkeresman01/spring-initializr.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
    },
    -- keymaps GLOBAIS (Lazy carrega o plugin ao pressionar a tecla)
    keys = {
      { "<leader>jsg", "<cmd>SpringInitializr<CR>", desc = "Abrir Spring Initializr" },
      { "<leader>jsG", "<cmd>SpringGenerateProject<CR>", desc = "Gerar projeto Spring" },
    },
    -- registra grupos no which-key na inicialização
    init = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>j", group = "Projetos" },
        { "<leader>js", group = "Spring Initializr" },
      })
    end,
    config = function()
      require("spring-initializr").setup()
    end,
  },
}
