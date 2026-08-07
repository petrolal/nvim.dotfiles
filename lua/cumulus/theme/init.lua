-- Cumulus Cloud Theme Switcher & Persistence (Story 31.2)
--
-- Single source of truth: ~/.config/cumulus/theme/state, written and read
-- by cumulus.dotfiles' scripts/theme.sh (NVIM_COLORSCHEME=<colorscheme>).
-- Neovim has no separate internal theme state file anymore — every read
-- and write goes through this shared state file so the system-wide theme
-- picker and Neovim's own <leader>ut picker always agree.
local M = {}

local state_file = vim.fn.expand("~/.config/cumulus/theme/state")

local themes = {
  { name = "aws-theme", label = "🟧 AWS Cloud Theme" },
  { name = "azure-theme", label = "🟦 Microsoft Azure Theme" },
  { name = "gcp-theme", label = "🟩 Google Cloud Platform (GCP) Theme" },
  { name = "oci-theme", label = "🟥 Oracle Cloud Infrastructure (OCI) Theme" },
}

-- Reads NVIM_COLORSCHEME=<value> out of the shared theme state file (a
-- simple KEY=VALUE file written by scripts/theme.sh). Returns nil if the
-- file doesn't exist or has no usable value.
local function read_state()
  if vim.fn.filereadable(state_file) ~= 1 then
    return nil
  end
  local values = {}
  for _, line in ipairs(vim.fn.readfile(state_file)) do
    local key, value = line:match("^([%u_]+)=(.*)$")
    if key then
      values[key] = value
    end
  end
  return values
end

function M.get_current_theme()
  local values = read_state()
  if values and values.NVIM_COLORSCHEME and values.NVIM_COLORSCHEME ~= "" then
    return values.NVIM_COLORSCHEME
  end
  return "aws-theme"
end

function M.set_theme(theme_name)
  local ok, _ = pcall(vim.cmd, "colorscheme " .. theme_name)
  if ok then
    -- Preserve any other keys already in the shared state file (FLAVOR,
    -- MODE, WALLPAPER, ...) written by cumulus.dotfiles; only overwrite
    -- NVIM_COLORSCHEME so the desktop-wide theme picker isn't clobbered.
    local values = read_state() or {}
    values.NVIM_COLORSCHEME = theme_name
    vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
    local order = { "FLAVOR", "MODE", "WALLPAPER", "WALLPAPER_SOURCE", "INTERVAL", "NVIM_COLORSCHEME" }
    local lines = {}
    for _, key in ipairs(order) do
      if values[key] ~= nil then
        table.insert(lines, key .. "=" .. values[key])
      end
    end
    vim.fn.writefile(lines, state_file)
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
