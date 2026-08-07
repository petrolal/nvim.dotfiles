-- Cumulus Cloud Theme Switcher & Persistence (Story 31.2)
--
-- Theme precedence: when cumulus.dotfiles is installed, its system-wide
-- theme picker (theme.sh/theme-picker.sh) is the single source of truth —
-- Neovim always follows the flavor it last set via
-- ~/.config/cumulus/theme/state (NVIM_COLORSCHEME=...). Only when that file
-- is absent (cumulus.dotfiles not installed) do we fall back to Neovim's own
-- internal state written by <leader>ut / M.set_theme().
local M = {}

local state_file = vim.fn.stdpath("state") .. "/cumulus_theme"
local dotfiles_state_file = vim.fn.expand("~/.config/cumulus/theme/state")

local themes = {
  { name = "aws-theme", label = "🟧 AWS Cloud Theme" },
  { name = "azure-theme", label = "🟦 Microsoft Azure Theme" },
  { name = "gcp-theme", label = "🟩 Google Cloud Platform (GCP) Theme" },
  { name = "oci-theme", label = "🟥 Oracle Cloud Infrastructure (OCI) Theme" },
}

-- Reads NVIM_COLORSCHEME=<value> out of cumulus.dotfiles' shared theme
-- state file (a simple KEY=VALUE file written by scripts/theme.sh).
-- Returns nil if the file doesn't exist or has no usable value, so callers
-- can fall back to Neovim's own internal theme state.
local function read_dotfiles_theme()
  if vim.fn.filereadable(dotfiles_state_file) ~= 1 then
    return nil
  end
  for _, line in ipairs(vim.fn.readfile(dotfiles_state_file)) do
    local key, value = line:match("^([%u_]+)=(.*)$")
    if key == "NVIM_COLORSCHEME" and value and value ~= "" then
      return value
    end
  end
  return nil
end

local function read_internal_theme()
  if vim.fn.filereadable(state_file) == 1 then
    local lines = vim.fn.readfile(state_file)
    if #lines > 0 and lines[1] ~= "" then
      return lines[1]
    end
  end
  return nil
end

function M.get_current_theme()
  return read_dotfiles_theme() or read_internal_theme() or "aws-theme"
end

function M.set_theme(theme_name)
  local ok, _ = pcall(vim.cmd, "colorscheme " .. theme_name)
  if ok then
    vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
    vim.fn.writefile({ theme_name }, state_file)
    vim.notify("Cloud theme set to: " .. theme_name, vim.log.levels.INFO)
    if read_dotfiles_theme() then
      vim.notify(
        "cumulus.dotfiles is installed: this choice is for the current session only — "
          .. "the dotfiles theme picker will take over again on next launch/refresh.",
        vim.log.levels.WARN
      )
    end
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
