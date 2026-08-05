-- Cumulus Core LSP Engine (Epic 3)

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      servers = {},
    },
    config = function(_, opts)
      local configs = require("lspconfig.configs")
      if opts.servers then
        for server, server_opts in pairs(opts.servers) do
          if configs[server] then
            configs[server].setup(server_opts or {})
          end
        end
      end
    end,
  },
}
