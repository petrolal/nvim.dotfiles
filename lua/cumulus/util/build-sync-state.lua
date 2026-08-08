-- Cumulus Build Sync Readiness State
--
-- Tracks whether the one-time Maven/Gradle dependency sync (see
-- lua/cumulus/core/autocmds.lua's "build_sync" VimEnter autocmd and
-- maven.sync_dependencies()/gradle.sync_dependencies()) has finished for
-- this session, so the java/kotlin/maven-related keymaps in
-- lua/cumulus/core/lang-keymaps.lua can stay hidden until dependencies are
-- actually resolved -- matching the "keybindings only show after sync
-- completes" behavior.

local M = {}

M.ready = false

local listeners = {}

--- Mark the sync as finished (success, failure, or "nothing to sync") and
--- fire every listener registered via on_ready(). Safe to call more than
--- once -- only the first call has any effect.
function M.mark_ready()
  if M.ready then
    return
  end
  M.ready = true
  for _, cb in ipairs(listeners) do
    pcall(cb)
  end
end

--- Register a callback to run once sync is ready. If it's already ready,
--- runs immediately (synchronously).
function M.on_ready(cb)
  if M.ready then
    cb()
  else
    table.insert(listeners, cb)
  end
end

return M
