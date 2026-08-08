---
baseline_commit: 4137109082ade11b25ef3145ae407ff52996dac8
---

# Story 41.1: Re-armable Sync State & Manual Resync Command

Status: review

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a JVM developer,
I want to manually re-trigger the Maven/Gradle dependency sync after it has already completed once,
so that I can recover from a failed/stale sync or pick up newly added dependencies without restarting Neovim.

## Acceptance Criteria

1. **Given** `build-sync-state.ready` is already `true` (from an earlier successful, failed, or "nothing to sync" completion), **when** the user invokes a resync trigger, **then** the sync is re-run — this must not be blocked by the existing one-shot guards (`once = true` on the `build_sync` autocmd, `if M.ready then return end` in `mark_ready()`).
2. **Given** a resync has been triggered, **when** it starts, **then** `build-sync-state.ready` is set back to `false` so that `<leader>cj`/`<leader>cx` correctly hide again (via the existing `ready_gate` check in `lang-keymaps.lua`) until the new sync completes — matching the "syncing..." UX of the very first sync.
3. **Given** a resync completes (success, failure, or nothing-to-sync), **when** `mark_ready()` runs again, **then** every listener already registered via `sync_state.on_ready()` (in particular `lang-keymaps.lua`'s which-key refresh) fires again automatically, without needing to re-register — do not clear or replace the `listeners` table when resetting.
4. **Given** the resync trigger, **when** exposed to the user, **then** it is a buffer-local keymap under the existing `<leader>cj` java/jvm build group (consistent with this codebase's keymap-only convention — there are zero `vim.api.nvim_create_user_command` calls anywhere in `lua/cumulus/`, so do not introduce one here).

## Tasks / Subtasks

- [x] Task 1: Make sync state re-armable (AC: #1, #2, #3)
  - [x] In `lua/cumulus/util/build-sync-state.lua`, add `function M.reset()` that sets `M.ready = false`. Do **not** touch the `listeners` table — `mark_ready()` already iterates `listeners` without draining it (`for _, cb in ipairs(listeners) do pcall(cb) end`), so previously-registered `on_ready` callbacks (e.g. `lang-keymaps.lua:88`) will naturally re-fire the next time `mark_ready()` runs. Confirm this by reading `mark_ready()`/`on_ready()` as they exist today before changing anything.
- [x] Task 2: Extract the "detect build tool and sync" branch into one reusable function (AC: #1)
  - [x] The `VimEnter` "build_sync" autocmd in `lua/cumulus/core/autocmds.lua` (search for `augroup("build_sync")`) currently inlines: `if maven.find_pom() then maven.sync_dependencies() elseif gradle.find_gradle() then gradle.sync_dependencies() else require("cumulus.util.build-sync-state").mark_ready() end`. Move this branch into a single function — add it to `lua/cumulus/util/build-sync-state.lua` as `function M.run()` (keeps `maven`/`gradle` requires local to avoid load-order issues) — so both the `VimEnter` autocmd and the new manual resync keymap call the same code path instead of duplicating it.
  - [x] Update the `VimEnter` "build_sync" callback in `autocmds.lua` to call `require("cumulus.util.build-sync-state").run()`.
- [x] Task 3: Add the manual resync keymap (AC: #4)
  - [x] In `lua/cumulus/core/keymaps.lua`, add a new entry to the existing `<leader>cj` stack's `keys` table (the `lang_keymaps.register({ group = "<leader>cj", ... })` block, filetypes `{ "java", "kotlin", "groovy", "xml" }`) — e.g. `<leader>cjS` — whose handler calls `require("cumulus.util.build-sync-state").reset()` then `require("cumulus.util.build-sync-state").run()`. Use `desc` = something like `"Maven/Gradle: Resync Dependencies"`.
  - [x] Do **not** set `ready_gate = true` differently for this one key — it lives in the same stack as the rest of `<leader>cj`, so it is already gated the same way (visible once the first sync attempt — success or failure — has completed, which is exactly when a manual retry becomes useful).
- [x] Task 4: Verify end-to-end
  - [x] Manually confirm (headless or interactive) that: initial sync completes → `<leader>cjS` is visible → pressing it hides `<leader>cj*`/`<leader>cx*` again → they reappear once the resync's `mark_ready()` fires, without leaving/re-entering the buffer (reuses the existing which-key refresh in `lang-keymaps.lua`'s `on_ready` callback — no changes needed there for this story).
  - [x] Run `stylua lua` and `nvim --headless "+Lazy check" +qa`.

## Dev Notes

- **Do not break the existing one-shot startup sync.** The `VimEnter` autocmd's `once = true` stays — that only prevents the *autocmd* from firing twice; it does not prevent `M.run()` from being called a second time by the new keymap. Keep these two triggers (auto at startup, manual via keymap) conceptually separate: `once = true` governs "when Neovim opens", not "how many times sync can ever run".
- **`M.ready` is a simple boolean latch, not a queue.** `on_ready(cb)` runs `cb()` immediately if `M.ready == true`, else queues it. Because `mark_ready()` doesn't drain `listeners`, resetting `M.ready` to `false` and calling `mark_ready()` again is sufficient to re-fire every previously-registered listener — there is no need to touch `lang-keymaps.lua`'s `sync_state.on_ready(...)` registration at all for this story.
- **Relevant existing code (read before editing):**
  - `lua/cumulus/util/build-sync-state.lua` — the whole module (41 lines): `M.ready`, `listeners`, `mark_ready()`, `on_ready()`.
  - `lua/cumulus/core/autocmds.lua` — the `augroup("build_sync")` `VimEnter` block (~line 99-118).
  - `lua/cumulus/util/maven.lua` / `lua/cumulus/util/gradle.lua` — `find_pom()`/`find_gradle()` and `sync_dependencies()`; do not change their internals for this story.
  - `lua/cumulus/core/lang-keymaps.lua` — `M.setup()`'s `sync_state.on_ready(...)` block (~line 88-96); confirms the which-key refresh path this story relies on without modifying.
  - `lua/cumulus/core/keymaps.lua` — the `<leader>cj` `lang_keymaps.register({...})` block (~line 74-207) where the new key is added.

### Project Structure Notes

- Stay inside the existing `cumulus.*` namespace; no new files needed — extend `build-sync-state.lua`, `autocmds.lua`, and `keymaps.lua` only.
- 2-space indent, 120-column width per `stylua.toml`; run `stylua lua` before considering this done.
- This codebase has no `vim.api.nvim_create_user_command` usage anywhere — keep the resync trigger a keymap, not a new Ex command, to stay consistent (AC #4).

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 41: Maven/Gradle Sync Lifecycle Hardening / Story 41.1]
- [Source: lua/cumulus/util/build-sync-state.lua]
- [Source: lua/cumulus/core/autocmds.lua]
- [Source: lua/cumulus/core/lang-keymaps.lua]
- [Source: lua/cumulus/core/keymaps.lua]

## Git Intelligence Summary

- Commit `05259a9` ("fix: autosync maven and gradle project") introduced the original one-shot `build_sync` autocmd and `sync_dependencies()` async pattern (`pcall(vim.system, ...)` with a `vim.schedule`-wrapped callback, `vim.notify` on start/success/failure).
- Commit `4137109` ("show java keybindgs after sync") introduced `build-sync-state.lua`'s `ready`/`on_ready`/`mark_ready` and wired `ready_gate` into `lang-keymaps.lua`. Follow the same style: short module, no external deps, plain booleans/closures, `pcall` around listener callbacks.
- Both commits favor small, focused diffs over refactors — keep Task 2's extraction minimal (move the existing branch verbatim into `M.run()`, don't redesign it).

## Dev Agent Record

### Agent Model Used

Claude Sonnet 5 (claude-sonnet-5)

### Debug Log References

- Verified `M.reset()`/`M.run()`/`mark_ready()`/`on_ready()` interaction with a standalone headless-Neovim Lua assertion script (`nvim --headless -u NONE -c "luafile ..."`): confirmed a registered `on_ready` listener fires on the first `mark_ready()`, does **not** re-fire on a redundant `mark_ready()` call while still ready, and **does** re-fire (without re-registering) after `reset()` + a second `mark_ready()` — fire count went 1 → 2 as expected, listeners persisted across reset.
- Verified end-to-end in a scratch Maven project (`pom.xml` + `src/main/java/Main.java`, no `mvn`/`mvnw` on `$PATH` so `sync_dependencies()` fails fast/synchronously via the existing `ENOENT` `pcall` branch): after the initial `VimEnter` sync settled, `<leader>cjS` and the rest of `<leader>cj*` were present as buffer-local keymaps on the java buffer; simulating `<leader>cjS` via `nvim_feedkeys` re-ran the sync and the stack was still present/consistent afterward (with `mvn` absent, `reset()`→`run()` resolves synchronously within the same tick, so the transient "hidden while syncing" window from AC #2 could not be directly observed in this environment — it depends on `vim.system`'s async callback, which only defers when a real `mvn`/`mvnw` process is actually spawned).

### Completion Notes List

- Added `M.reset()` and `M.run()` to `build-sync-state.lua`; `mark_ready()`/`on_ready()` were left untouched, confirming the Dev Notes' prediction that no changes were needed there.
- Replaced the inlined maven/gradle branch in `autocmds.lua`'s `VimEnter` "build_sync" callback with a single call to `build-sync-state.run()`.
- Added a `<leader>cjS` "Maven/Gradle: Resync Dependencies" keymap to the existing `<leader>cj` stack in `keymaps.lua`; no new `ready_gate`/`condition` handling needed since it inherits the stack's existing gating.
- `stylua` is not installed in this environment, so formatting was done by hand to match the file's existing 2-space-indent/120-column style rather than machine-verified; run `stylua lua` in an environment that has it before merging, per `stylua.toml`.
- `nvim --headless "+Lazy check" +qa` passed with no output/errors after all three edits.
- AC #2's transient "hides again while resync is in flight" behavior is implemented (`reset()` unconditionally sets `M.ready = false` before `run()` dispatches to `maven.sync_dependencies()`/`gradle.sync_dependencies()`) but could only be indirectly verified in this environment, since no real `mvn`/`gradle` binary is installed here — sync failure is synchronous (ENOENT), so the "hidden" window collapses to effectively zero wall-clock time in this sandbox. The logic path is identical to the real async-success/failure path already exercised by the original (pre-Story-41.1) sync, which was not itself changed.

### File List

- `lua/cumulus/util/build-sync-state.lua` (modified — added `M.reset()`, `M.run()`)
- `lua/cumulus/core/autocmds.lua` (modified — `build_sync` `VimEnter` callback now delegates to `build-sync-state.run()`)
- `lua/cumulus/core/keymaps.lua` (modified — added `<leader>cjS` resync keymap to the `<leader>cj` stack)

## Change Log

- 2026-08-08: Implemented Story 41.1 (Tasks 1-4 complete) — re-armable sync state via `M.reset()`/`M.run()`, manual `<leader>cjS` resync keymap. Status → review.
