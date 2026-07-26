return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "shellcheck",
        "flake8",
        "google-java-format",
        "jdtls",
        "java-debug-adapter",
        "java-test",
        "kotlin-language-server",
        "kotlin-debug-adapter",
        "ktlint",
      })
    end,
  },
}
