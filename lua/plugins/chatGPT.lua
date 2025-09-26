-- lua/plugins/chatgpt-keymaps.lua
return {
  "jackMort/ChatGPT.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "folke/which-key.nvim",
  },
  config = function()
    require("chatgpt").setup({
      api_key_cmd = "echo $OPENAI_API_KEY",
      openai_params = { model = "gpt-4o-mini", max_tokens = 800 },
    })

    local wk = require("which-key")

    -- which-key v3: use .add (novo spec)
    wk.add({
      { "<leader>a", group = "Code With AI" },

      -- modo NORMAL
      { "<leader>ac", "<cmd>ChatGPT<CR>", desc = "Abrir Chat", mode = "n", silent = true },
      -- abaixo são atalhos que fazem mais sentido com seleção, mas oferecemos também no normal
      { "<leader>ae", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explicar Código", mode = "n", silent = true },
      { "<leader>at", "<cmd>ChatGPTRun add_tests<CR>", desc = "Gerar Testes", mode = "n", silent = true },
      { "<leader>ao", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Otimizar Código", mode = "n", silent = true },
      { "<leader>ad", "<cmd>ChatGPTRun docstring<CR>", desc = "Gerar Docstring", mode = "n", silent = true },
      { "<leader>af", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Corrigir Bugs", mode = "n", silent = true },

      -- modo VISUAL (seleciona o trecho e dispara)
      { "<leader>ae", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explicar Código", mode = "v", silent = true },
      { "<leader>at", "<cmd>ChatGPTRun add_tests<CR>", desc = "Gerar Testes", mode = "v", silent = true },
      { "<leader>ao", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Otimizar Código", mode = "v", silent = true },
      { "<leader>ad", "<cmd>ChatGPTRun docstring<CR>", desc = "Gerar Docstring", mode = "v", silent = true },
      { "<leader>af", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Corrigir Bugs", mode = "v", silent = true },

      -- Edição via instrução (normal e visual)
      {
        "<leader>ae",
        "<cmd>ChatGPTEditWithInstruction<CR>",
        desc = "Editar com Prompt",
        mode = { "n", "v" },
        silent = true,
      },
    })
  end,
}
