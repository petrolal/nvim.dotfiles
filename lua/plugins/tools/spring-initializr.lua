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
      { "<leader>asg", "<cmd>SpringInitializr<CR>", desc = "Abrir Spring Initializr" },
      { "<leader>asG", "<cmd>SpringGenerateProject<CR>", desc = "Gerar projeto Spring" },
    },
    config = function()
      require("spring-initializr").setup()
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>j", group = "+Java" },
        { "<leader>js", group = "+Spring Initializr" },
      })
    end,
  },
}
