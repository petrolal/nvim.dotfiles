return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
      },
      setup = {
        pyright = function(_, server_opts)
          local on_attach = server_opts.on_attach
          server_opts.on_attach = function(client, bufnr)
            if on_attach then
              on_attach(client, bufnr)
            end
            if client.name == "pyright" then
              vim.keymap.set("n", "<leader>ci", function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.addMissingImports", "source.addMissingImports.py" },
                    diagnostics = {},
                  },
                })
              end, { buffer = bufnr, desc = "Python: Add Missing Imports" })
            end
          end
        end,
      },
    },
  },
}
