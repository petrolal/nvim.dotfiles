-- Session restore helper: works around persistence.nvim/mksession not
-- knowing how to serialize the Snacks explorer (it's a picker, not a real
-- file buffer). If the explorer is open when a session is saved, mksession
-- writes its window as a blank `enew` buffer, so restoring a session brings
-- back the layout but not the explorer itself. We record whether the
-- explorer was open in a small marker file (it must survive the process
-- restart between saving and loading a session) and reopen it after load.

local M = {}

local function marker_path()
  local key = vim.fn.getcwd():gsub("[\\/:]", "%%")
  return vim.fn.stdpath("state") .. "/cumulus_explorer_open_" .. key
end

local function remember_explorer_state()
  local ok, picker_mod = pcall(require, "snacks.picker")
  local explorer = ok and picker_mod.get({ source = "explorer" })[1] or nil

  local path = marker_path()
  if explorer then
    explorer:close()
    vim.fn.writefile({}, path)
  else
    pcall(vim.fn.delete, path)
  end
end

local function reopen_explorer_if_needed()
  local path = marker_path()
  if vim.fn.filereadable(path) == 1 then
    pcall(vim.fn.delete, path)
    vim.schedule(function()
      Snacks.explorer()
    end)
  end
end

--- Registers autocmds that close the Snacks explorer before persistence.nvim
--- saves a session (mksession can't serialize it -- it's a picker, not a
--- real file buffer -- so leaving it open causes the window to come back
--- as a blank `enew` buffer) and reopen it after a session is loaded.
function M.setup()
  local group = vim.api.nvim_create_augroup("cumulus_session_explorer", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "PersistenceSavePre",
    callback = remember_explorer_state,
  })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "PersistenceLoadPost",
    callback = reopen_explorer_if_needed,
  })
end

return M

