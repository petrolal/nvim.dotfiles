-- Cumulus Cloud Theme Switcher & Persistence (Story 31.2)
local M = {}

local state_file = vim.fn.stdpath("state") .. "/cumulus_theme"

local themes = {
  { name = "aws-theme", label = "🟧 AWS Cloud Theme" },
  { name = "azure-theme", label = "🟦 Microsoft Azure Theme" },
  { name = "gcp-theme", label = "🟩 Google Cloud Platform (GCP) Theme" },
  { name = "oci-theme", label = "🟥 Oracle Cloud Infrastructure (OCI) Theme" },
}

function M.get_current_theme()
  if vim.fn.filereadable(state_file) == 1 then
    local lines = vim.fn.readfile(state_file)
    if #lines > 0 and lines[1] ~= "" then
      return lines[1]
    end
  end
  return "aws-theme"
end

function M.set_theme(theme_name)
  local ok, _ = pcall(vim.cmd, "colorscheme " .. theme_name)
  if ok then
    vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
    vim.fn.writefile({ theme_name }, state_file)
    vim.notify("Cloud theme set to: " .. theme_name, vim.log.levels.INFO)
  else
    vim.notify("Failed to set colorscheme: " .. theme_name, vim.log.levels.ERROR)
  end
end

function M.select_theme()
  local items = {}
  for i, t in ipairs(themes) do
    table.insert(items, string.format("%d. %s", i, t.label))
  end

  vim.ui.select(items, {
    prompt = " Select Cumulus Cloud Theme: ",
  }, function(choice, index)
    if choice and index then
      M.set_theme(themes[index].name)
    end
  end)
end

function M.load_saved_theme()
  local theme = M.get_current_theme()
  pcall(vim.cmd, "colorscheme " .. theme)
end

return M
