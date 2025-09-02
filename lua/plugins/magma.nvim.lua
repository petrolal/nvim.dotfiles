-- ~/.config/nvim/lua/plugins/init.lua
return {
  {
    "dccsillag/magma-nvim",
    build = ":UpdateRemotePlugins", -- ESSENCIAL: Executa esse comando após instalar/atualizar
    init = function()
      -- Configurações Básicas (ativas antes do plugin carregar)
      vim.g.magma_automatically_open_output = true
      vim.g.magma_image_provider = "kitty" -- Escolha 'ueberzug', 'kitty', 'wezterm' ou 'none'
      vim.g.magma_wrap_output = true
      vim.g.magma_output_window_borders = false
      vim.g.magma_save_path = vim.fn.expand("~/.jupyter/magma-nvim") -- Onde salvar os notebooks

      -- Configuração AVANÇADA: Se você estiver usando um container Docker,
      -- descomente e ajuste a linha abaixo com o token do seu Jupyter Lab
      -- vim.g.magma_jupyter_connection_string = "http://127.0.0.1:8888/?token=seu_token_aqui"
    end,
    config = function()
      -- Configurações que rodam após o plugin ser carregado
      -- Mapeamentos de teclas (Mantenha isso fora do init())
      vim.g.magma_automatically_open_output = true
      -- A URL geralmente é esta, com o token correto
      vim.g.magma_jupyter_connection_string = "http://127.0.0.1:8888/?token=abc123"
      local map = vim.keymap.set
      map("n", "<leader>ji", "<cmd>MagmaInit<cr>", { desc = "Magma: Init", silent = true })
      map("n", "<leader>je", "<cmd>MagmaEvaluateLine<cr>", { desc = "Magma: Eval Line", silent = true })
      map("v", "<leader>je", "<cmd>MagmaEvaluateVisual<cr>", { desc = "Magma: Eval Visual", silent = true })
      map("n", "<leader>jr", "<cmd>MagmaReevaluateCell<cr>", { desc = "Magma: Reeval Cell", silent = true })
      map("n", "<leader>jd", "<cmd>MagmaDelete<cr>", { desc = "Magma: Delete", silent = true })
      map("n", "<leader>jo", "<cmd>MagmaShowOutput<cr>", { desc = "Magma: Show Output", silent = true })
      map("n", "<leader>jc", "o# %%<Esc>", { desc = "Jupyter: New Cell Markdown" })
    end,
  },
}
