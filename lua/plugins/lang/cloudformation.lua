return {
  -- Add CloudFormation support via cfn-lint
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        yaml = { "cfnlint" },
        ["yaml.cloudformation"] = { "cfnlint" },
      },
      linters = {
        cfnlint = {
          cmd = "cfn-lint",
          stdin = false,
          args = { "--format", "parseable" },
          stream = "stdout",
          ignore_exitcode = true,
          parser = require("lint.parser").from_pattern(
            [[^[^:]+:(%d+):(%d+):%d+:%d+:([WEI])(%d+):(.+)$]],
            { "lnum", "col", "severity", "code", "message" },
            {
              E = vim.diagnostic.severity.ERROR,
              W = vim.diagnostic.severity.WARN,
              I = vim.diagnostic.severity.INFO,
            }
          ),
        },
      },
    },
  },

  -- Configure none-ls for CloudFormation
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local null_ls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        null_ls.builtins.diagnostics.cfn_lint.with({
          extra_filetypes = { "yaml.cloudformation", "yaml" },
        }),
      })
    end,
  },
}

