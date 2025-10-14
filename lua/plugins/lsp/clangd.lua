return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        clangd = function(_, opts)
          opts.capabilities = opts.capabilities or {}
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
  },
}
