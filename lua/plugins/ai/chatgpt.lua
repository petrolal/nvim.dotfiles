return {
  {
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
      wk.add({
        { "<leader>a", group = "Code With AI" },
        { "<leader>ac", "<cmd>ChatGPT<CR>", desc = "Abrir Chat", mode = "n", silent = true },
      })
    end,
  },
}
