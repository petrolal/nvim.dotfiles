return {
  {
    "jkeresman01/spring-initializr.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      require("spring-initializr").setup({
        mappings = {
          generate = "<leader>sg", -- abrir janela de geração
          add_dep = "<leader>sa", -- adicionar dependência
          remove_dep = "<leader>sr",
        },
      })
    end,
  },
}
