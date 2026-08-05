-- Cumulus Multi-Language DevOps LSP Stack (Epic 11 - Story 11.1 & 11.2)

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "go",
          "gomod",
          "gowork",
          "gotmpl",
          "python",
          "javascript",
          "typescript",
          "json",
          "xml",
          "bash",
        })
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
            },
          },
        },
        pyright = {},
        ts_ls = {},
        jsonls = {},
        lemminx = {},
        bashls = {
          filetypes = { "sh", "bash" },
        },
      },
    },
  },
}
