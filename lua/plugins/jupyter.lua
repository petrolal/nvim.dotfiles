-- lua/plugins/jupyter.lua
return {
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    ft = { "python", "markdown", "quarto", "julia", "r" },
    init = function()
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_image_provider = "image.nvim"
    end,
    config = function()
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- Grupo <leader>j no which-key
      map("n", "<leader>ji", ":MoltenInit<CR>", vim.tbl_extend("force", opts, { desc = "Init kernel" }))
      map("n", "<leader>jc", ":MoltenEvaluateCell<CR>", vim.tbl_extend("force", opts, { desc = "Eval cell" }))
      map("n", "<leader>jl", ":MoltenEvaluateLine<CR>", vim.tbl_extend("force", opts, { desc = "Eval line" }))
      map(
        "v",
        "<leader>js",
        ":<C-u>MoltenEvaluateVisual<CR>",
        vim.tbl_extend("force", opts, { desc = "Eval selection" })
      )
      map("n", "<leader>jo", ":MoltenShowOutput<CR>", vim.tbl_extend("force", opts, { desc = "Show output" }))
      map("n", "<leader>jC", ":MoltenDelete<CR>", vim.tbl_extend("force", opts, { desc = "Clear outputs" }))
    end,
    dependencies = {
      "3rd/image.nvim", -- opcional: suporte a imagens inline
    },
  },
  {
    "lkhphuc/jupyter-kernel.nvim",
    ft = { "python", "julia", "r" },
    config = function()
      require("jupyter-kernel").setup({
        auto_start_kernel = true,
        default_kernel = "nvim-jupyter",
        use_widgets = true,
      })
    end,
  },
}
