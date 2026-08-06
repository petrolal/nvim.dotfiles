-- Cumulus Mason Package Management (AR2, Epic 3, Epic 11 & Epic 12)

-- NOTE: plain mason.nvim's setup() has no "ensure_installed" option -- that
-- field is only understood by the separate mason-tool-installer.nvim
-- plugin. Without it, this list was silently ignored and none of these
-- tools (including cfn-lint / ansible-lint) were ever actually installed,
-- causing nvim-lint to fail when it tried to run them.
local ensure_installed = {
  "terraform-ls",
  "tflint",
  "ansible-language-server",
  "ansible-lint",
  "cfn-lint",
  "yaml-language-server",
  "dockerls",
  "hadolint",
  "helm-ls",
  "gopls",
  "delve",
  "pyright",
  "debugpy",
  "typescript-language-server",
  "json-lsp",
  "lemminx",
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
}

return {
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = ensure_installed,
      auto_update = false,
      run_on_start = true,
    },
  },
}
