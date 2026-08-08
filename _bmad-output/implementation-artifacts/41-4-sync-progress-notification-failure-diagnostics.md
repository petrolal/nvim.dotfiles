# Story 41.4: Sync Progress Notification & Failure Diagnostics

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a JVM developer,
I want a persistent, updating notification while the dependency sync is running, and surfaced errors when internal sync callbacks fail,
so that a hung or errored sync is distinguishable from a silently succeeding one.

## Acceptance Criteria

1. **Given** a sync is in progress, **when** the start/heartbeat/completion notifications fire, **then** they all share one stable notification `id` (via `vim.notify(msg, level, { id = ... })`) so they collapse into a single updating toast instead of stacking multiple separate ones.
2. **Given** a sync is still running several seconds after it started, **when** enough time has passed, **then** the notification visibly updates (e.g. elapsed-seconds heartbeat) — a static, never-changing "syncing..." message is not sufficient, because it would look identical whether the process is healthy-but-slow or silently hung.
3. **Given** an error is raised inside a `pcall`-wrapped callback in the sync/ready-notification path (`build-sync-state.lua`'s `mark_ready()` listener loop, and `lang-keymaps.lua`'s `stack.condition` check), **when** that `pcall` fails, **then** the error is surfaced via `vim.notify(..., vim.log.levels.WARN)` instead of being silently discarded — today both call sites do `pcall(cb)` / `pcall(stack.condition, buf)` and drop the error entirely on failure.

## Tasks / Subtasks

- [ ] Task 1: Collapse sync notifications into one updating toast (AC: #1, #2)
  - [ ] In `lua/cumulus/util/maven.lua`, add a stable id, e.g. `local NOTIFY_ID = "cumulus_maven_sync"`; in `lua/cumulus/util/gradle.lua`, `local NOTIFY_ID = "cumulus_gradle_sync"` (distinct per tool — even though in practice only one of the two runs per project, keeping them distinct avoids any cross-tool notification collision).
  - [ ] Pass `{ id = NOTIFY_ID }` as the third argument on every `vim.notify` call already present in `sync_dependencies()` (start, success, failure) — this project's `vim.notify` is globally bound to `Snacks.notifier.notify` (see `lua/cumulus/plugins/editor-snacks.lua:154-155`), whose `notify()` accepts `opts.id` and replaces the existing notification with that id rather than stacking a new one (`snacks.nvim`'s `notifier.lua` around its `notify`/`queue` handling confirms `id`-based replace semantics) — verify this behavior interactively before relying on it, since Snacks' exact replace semantics should be confirmed against the installed version rather than assumed from memory.
  - [ ] Add a heartbeat: using `(vim.uv or vim.loop).new_timer()` (a **second**, independent timer from Story 41.2's timeout timer — do not conflate the two), fire every ~5000ms while the sync is still running, calling `vim.notify("Maven: syncing dependencies... (" .. elapsed_seconds .. "s)", vim.log.levels.INFO, { id = NOTIFY_ID })` with the same `NOTIFY_ID`. Track elapsed time with `local started = (vim.uv or vim.loop).now()` at sync start.
  - [ ] Stop and close the heartbeat timer in the same exit-callback branch where Story 41.2's timeout timer is stopped — both timers must be cleaned up together whenever the process actually exits (success, failure, or gets killed on timeout), so neither leaks or fires after completion.
- [ ] Task 2: Surface swallowed pcall errors (AC: #3)
  - [ ] In `lua/cumulus/util/build-sync-state.lua`'s `mark_ready()`, change `for _, cb in ipairs(listeners) do pcall(cb) end` to capture the failure: `local ok, err = pcall(cb); if not ok then vim.notify("Cumulus: build-sync-state on_ready listener failed: " .. tostring(err), vim.log.levels.WARN) end`.
  - [ ] In `lua/cumulus/core/lang-keymaps.lua`'s `apply()`, change `local ok, res = pcall(stack.condition, buf)` so that on failure it also notifies: `if not ok then vim.notify("Cumulus: lang-keymaps condition for " .. tostring(stack.group) .. " failed: " .. tostring(res), vim.log.levels.WARN) end` (keep the existing `if ok and res then matches_cond = true end` behavior unchanged for the success path).
- [ ] Task 3: Verify
  - [ ] Trigger a sync and confirm only one notification toast is visible at a time for it (not one-per-message stacked).
  - [ ] Force a slow sync (or temporarily shorten the heartbeat interval for testing) and confirm the toast's elapsed-time text updates in place.
  - [ ] Temporarily make a `stack.condition` function `error(...)` and confirm a WARN notification appears instead of the failure being silent.
  - [ ] Run `stylua lua` and `nvim --headless "+Lazy check" +qa`.

## Dev Notes

- **Coordinate with Story 41.2**: both stories touch `sync_dependencies()` in `maven.lua`/`gradle.lua` and both introduce a `(vim.uv or vim.loop).new_timer()`. If implemented separately, the second implementer must merge cleanly with the first's timer rather than clobbering it — there will be **two** timers per sync call (one timeout-kill timer from 41.2, one heartbeat-notify timer from this story), both created/stopped/closed in the same function.
- **`vim.notify` is globally Snacks-backed in this project** (`lua/cumulus/plugins/editor-snacks.lua:154-155`, `opts.notifier.timeout = 3000` at line 31) — do not assume default Neovim `vim.notify` semantics (which has no concept of `id`-based replace); this only works because of that override. If the dev agent later finds Snacks' `notify()` doesn't support `id` the way expected, fall back to at minimum ensuring the start/success/failure messages are worded so a user can tell which sync attempt they belong to (e.g. include a timestamp), rather than silently dropping AC #1.
- **Relevant existing code (read before editing):**
  - `lua/cumulus/util/maven.lua:59-92`, `lua/cumulus/util/gradle.lua:63-96` — the notify call sites.
  - `lua/cumulus/util/build-sync-state.lua:20-28` — `mark_ready()`'s listener loop.
  - `lua/cumulus/core/lang-keymaps.lua:53-59` — `apply()`'s `stack.condition` pcall.
  - `lua/cumulus/plugins/editor-snacks.lua:29-31,154-155` — the Snacks notifier config and `vim.notify` override.

### Project Structure Notes

- No new files. Edits: `lua/cumulus/util/maven.lua`, `lua/cumulus/util/gradle.lua`, `lua/cumulus/util/build-sync-state.lua`, `lua/cumulus/core/lang-keymaps.lua`.
- 2-space indent, 120-column width per `stylua.toml`.

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 41: Maven/Gradle Sync Lifecycle Hardening / Story 41.4]
- [Source: lua/cumulus/plugins/editor-snacks.lua]
- [Source: lua/cumulus/util/build-sync-state.lua]
- [Source: lua/cumulus/core/lang-keymaps.lua]
- [Source: _bmad-output/implementation-artifacts/41-2-sync-timeout-cancellation-safeguard.md]

## Git Intelligence Summary

- Commit `4137109`'s `build-sync-state.lua` already documents (in its own comment) the intent to fail open rather than closed ("mark ready on both success and failure so a broken/offline sync doesn't hide them forever") — this story's error-surfacing must preserve that same fail-open guarantee; notify on `pcall` failure but never let a failed listener prevent the others from running or leave `M.ready` in a bad state.

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
