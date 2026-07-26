return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        kotlin = { "ktlint" },
        java = { "google-java-format" },
        python = { "ruff_format", "ruff_organize_imports" },
        lua = { "stylua" },
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
