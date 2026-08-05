-- Cumulus Document Formatting Specs (Story 3.1 & FR3)

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
        kotlin = { "ktlint" },
        java = { "google-java-format" },
        python = { "ruff_format", "ruff_organize_imports" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
      format_on_save = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_fallback = true,
      },
    },
  },
}
