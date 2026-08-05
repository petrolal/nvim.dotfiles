-- Cumulus Mason Package Management (AR2 & Epic 3)

return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "terraform-ls",
        "tflint",
        "ansible-language-server",
        "ansible-lint",
        "cfn-lint",
        "yamlls",
        "dockerls",
        "hadolint",
        "helm-ls",
        "bash-language-server",
        "shellcheck",
        "shfmt",
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
