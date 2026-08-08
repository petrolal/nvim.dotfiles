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

--- Re-arm the state for a manual resync (see keymaps.lua's <leader>cjS).
--- Deliberately does NOT touch `listeners` -- mark_ready() iterates that
--- table without draining it, so every callback already registered via
--- on_ready() (e.g. lang-keymaps.lua's which-key refresh) fires again on
--- the next mark_ready() with no need to re-register.
function M.reset()
  M.ready = false
end

--- Detect the project's build tool and (re)run its dependency sync, or mark
--- ready immediately if there's nothing to sync. Single source of truth for
--- both the one-time VimEnter sync (autocmds.lua) and the manual resync
--- keymap, so the branch only lives in one place.
function M.run()
  local maven = require("cumulus.util.maven")
  local gradle = require("cumulus.util.gradle")
  if maven.find_pom() then
    maven.sync_dependencies()
  elseif gradle.find_gradle() then
    gradle.sync_dependencies()
  else
    -- Nothing to sync -- don't leave the gated java/kotlin/maven keymaps
    -- (lang-keymaps.lua) hidden forever waiting on a sync that will never
    -- run.
    M.mark_ready()
  end
end

return M
