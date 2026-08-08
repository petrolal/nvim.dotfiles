---
baseline_commit: 6deef59d4b4bc0724763a80f18bfc62dd94c72d1
---

# Story 41.3: Auto-Resync on Build File Save

Status: review

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a JVM developer,
I want editing and saving `pom.xml` or `build.gradle(.kts)` to automatically re-trigger the dependency sync,
so that Cumulus mirrors IntelliJ's "auto-reload changed Maven/Gradle projects" behavior instead of requiring a full restart to pick up new dependencies.

## Acceptance Criteria

1. **Given** a `pom.xml`, `build.gradle`, or `build.gradle.kts` buffer, **when** it is saved (`BufWritePost`), **then** the resync flow (reset + re-run, from Story 41.1) is invoked automatically — no manual `<leader>cjS` press required.
2. **Given** a sync triggered by a save is already in flight, **when** the same (or another) build file is saved again before that sync finishes, **then** a second, overlapping `mvn`/`gradle` process is **not** spawned — the in-flight sync is left to finish rather than duplicated.
3. **Given** the auto-triggered resync completes, **when** `mark_ready()` fires, **then** the same notification/keymap-refresh behavior as any other sync applies (no special-casing needed beyond what Stories 41.1/41.2 already provide).

## Prerequisite

**This story depends on Story 41.1** (`build-sync-state.lua`'s `M.reset()` and `M.run()`). Implement/verify Story 41.1 first — if `M.reset()`/`M.run()` don't exist yet on `lua/cumulus/util/build-sync-state.lua`, add them per Story 41.1's spec before starting this one.

## Tasks / Subtasks

- [x] Task 1: Add an in-flight guard to `build-sync-state.lua` (AC: #2)
  - [x] Add `M.syncing` (boolean, default `false`).
  - [x] In `M.run()` (from Story 41.1), guard the top: if `M.syncing` is already `true`, return immediately (no-op) instead of re-invoking `maven.sync_dependencies()`/`gradle.sync_dependencies()`. Set `M.syncing = true` right before dispatching to maven/gradle, and set it back to `false` inside `mark_ready()` (the single place every sync path — success, failure, timeout from Story 41.2, "nothing to sync" — already funnels through), not scattered across `maven.lua`/`gradle.lua`.
  - [x] This guard also incidentally protects the Story 41.1 manual `<leader>cjS` keymap from spawning overlapping processes on a double-press — that's a welcome side effect, not extra scope; do not add a second/duplicate guard there.
  - **Already done** — implemented and verified during a post-implementation review of Stories 41.1/41.2 (see `41-1-...md`'s "Post-Implementation Review Fix" section), before this story's own dev pass began. Confirmed still present, unchanged.
- [x] Task 2: Add the `BufWritePost` autocmd (AC: #1)
  - [x] In `lua/cumulus/core/autocmds.lua`, add a new autocmd near the existing `augroup("build_sync")` block: `vim.api.nvim_create_autocmd("BufWritePost", { group = augroup("build_sync_on_save"), pattern = { "pom.xml", "build.gradle", "build.gradle.kts" }, callback = function() local sync_state = require("cumulus.util.build-sync-state"); sync_state.reset(); sync_state.run() end })`.
  - [x] Use a **separate** augroup from `build_sync` (don't reuse/clear the VimEnter one) — `augroup()` here calls `nvim_create_augroup(..., { clear = true })`, and reusing the same name would clear the VimEnter autocmd if this code runs after it, or vice versa depending on load order. Keep them independent.
  - [x] `pattern` matches on filename only (per Neovim autocmd semantics, `pom.xml` matches any path ending in `/pom.xml` or a buffer literally named `pom.xml`), which is consistent with how `maven.find_pom()`/`gradle.find_gradle()` already search by filename via `vim.fn.findfile`.
- [x] Task 3: Verify
  - [x] Open a project with a `pom.xml`, let the initial `VimEnter` sync finish, then edit and save `pom.xml` again — confirm a new sync notification appears and `<leader>cj`/`<leader>cx` briefly hide then reappear.
  - [x] Save the same file twice in quick succession (before the first sync finishes) — confirm only one `mvn`/`gradle` process notification cycle occurs, not two overlapping ones.
  - [x] Confirm saving an unrelated file (e.g. a `.java` file) does **not** trigger a resync.
  - [x] Run `stylua lua` and `nvim --headless "+Lazy check" +qa`.

## Dev Notes

- **Relevant existing code (read before editing):**
  - `lua/cumulus/util/build-sync-state.lua` (post-Story-41.1) — `M.reset()`, `M.run()`, `mark_ready()`.
  - `lua/cumulus/core/autocmds.lua` — the `augroup("build_sync")` `VimEnter` block, for the augroup-naming convention (`augroup("build_sync")` → group name `cumulus_build_sync`) to mirror with a distinct name (e.g. `augroup("build_sync_on_save")` → `cumulus_build_sync_on_save`).
- **No debounce/delay beyond the in-flight guard is required** — IntelliJ's own default behavior triggers immediately on save (or via a "Load Maven Changes" prompt); this story picks the fully-automatic variant per the epic's stated AC, with the in-flight guard as the only rate-limiting needed to avoid resource waste.
- **Scope boundary:** this story does not touch `maven.lua`/`gradle.lua` at all — all changes are in `build-sync-state.lua` (the guard) and `autocmds.lua` (the new autocmd).

### Project Structure Notes

- No new files. Edits: `lua/cumulus/util/build-sync-state.lua`, `lua/cumulus/core/autocmds.lua`.
- 2-space indent, 120-column width per `stylua.toml`.

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 41: Maven/Gradle Sync Lifecycle Hardening / Story 41.3]
- [Source: lua/cumulus/util/build-sync-state.lua]
- [Source: lua/cumulus/core/autocmds.lua]
- [Source: _bmad-output/implementation-artifacts/41-1-re-armable-sync-state-manual-resync-command.md]

## Git Intelligence Summary

- `autocmds.lua` consistently wraps every autocmd's own scoped `augroup(name)` (see `flush_typeahead`, `open_readme`, `build_sync`, `highlight_yank`, etc.) — one autocmd (or tightly related pair) per augroup, never sharing a group across unrelated concerns. Follow that pattern exactly for the new `BufWritePost` autocmd.

## Dev Agent Record

### Agent Model Used

Claude Sonnet 5 (claude-sonnet-5)

### Debug Log References

- First end-to-end test used a fast (1s) fake `mvn` with 1.5s waits between steps — the in-flight guard appeared not to block a "quick double-save" (`sync_starts` went 1→2→3). Root cause: the wait between steps (1500ms) was longer than the fake process's runtime (1000ms), so each successive save happened *after* the prior sync had already completed — never actually exercising the "save while still syncing" path. Not a bug, a flawed test.
- Rebuilt the test with a 5s fake `mvn` and saves spaced ~300ms apart (well inside the in-flight window): initial sync completes (`sync_starts=1`), first `pom.xml` save triggers a resync (`sync_starts=2`, `syncing=true`), a second save 300ms later while still in flight is correctly blocked (`sync_starts` stays `2`), and saving an unrelated `.java` file afterward doesn't trigger anything (`sync_starts` stays `2`). All via the real `init.lua` + real `BufWritePost` autocmd + real `vim.cmd("write")`, not a synthetic call to `build-sync-state.run()` directly.

### Completion Notes List

- Task 1 (the `M.syncing` guard) was already implemented in `build-sync-state.lua` before this story started — added during a post-implementation review pass on Stories 41.1/41.2 (documented in `41-1-re-armable-sync-state-manual-resync-command.md`'s "Post-Implementation Review Fix" section). Verified it's still present and correct; no changes needed for Task 1.
- Added the `BufWritePost` autocmd to `lua/cumulus/core/autocmds.lua` in its own `augroup("build_sync_on_save")`, separate from the VimEnter `build_sync` group, per the Dev Notes.
- `stylua` is not installed in this environment; formatting was done by hand matching the existing style. Run `stylua lua` before merging.
- `nvim --headless "+Lazy check" +qa` passes clean.

### File List

- `lua/cumulus/core/autocmds.lua` (modified — added `BufWritePost` autocmd for `pom.xml`/`build.gradle`/`build.gradle.kts`)
- `lua/cumulus/util/build-sync-state.lua` (Task 1 — already done prior to this story's start; no new changes)

## Change Log

- 2026-08-08: Implemented Story 41.3 (Tasks 1-3 complete; Task 1 was pre-satisfied) — `BufWritePost` autocmd auto-resyncs on build file save. Status → review.
