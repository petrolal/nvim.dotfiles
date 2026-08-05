-- Cumulus Healthcheck Module (Story 27.2)

local M = {}

function M.check()
  vim.health.start("Cumulus Search Engine Backends")

  if vim.fn.executable("rg") == 1 then
    vim.health.ok("ripgrep (rg) binary is installed and executable")
  else
    vim.health.warn("ripgrep (rg) binary not found on $PATH. Telescope live_grep requires ripgrep.")
  end

  if vim.fn.executable("fd") == 1 then
    vim.health.ok("fd binary is installed and executable")
  else
    vim.health.info("fd binary not found on $PATH (optional high-speed file finder)")
  end

  if vim.fn.executable("git") == 1 then
    vim.health.ok("git binary is installed and executable")
  else
    vim.health.warn("git binary not found on $PATH")
  end
end

return M
