return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "shellcheck",
        "flake8",
        "ruff",
        "debugpy",
        "jdtls",
        "java-debug-adapter",
        "java-test",
        "google-java-format",
      })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "pyright",
      })
    end,
  },
}
