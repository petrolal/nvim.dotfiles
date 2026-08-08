-- Cumulus Diagnostic Linting Specs (Story 3.1, 3.2, 3.3)

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        terraform = { "tflint" },
        tf = { "tflint" },
        yaml = { "cfn_lint", "ansible_lint" },
        dockerfile = { "hadolint" },
        kotlin = { "ktlint" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("cumulus_lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
