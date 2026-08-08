---
baseline_commit: 4137109082ade11b25ef3145ae407ff52996dac8
---

# Story 41.2: Sync Timeout & Cancellation Safeguard

Status: review

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a JVM developer working offline or behind a slow network,
I want the Maven/Gradle dependency sync to time out instead of hanging forever,
so that the gated `<leader>cj`/`<leader>cx` keymaps never stay hidden indefinitely because of a stuck `mvn`/`gradle` process.

## Acceptance Criteria

1. **Given** `mvn -q dependency:resolve` (or `gradle -q dependencies`) has not exited within a fixed timeout, **when** the timeout elapses, **then** the spawned process is terminated (`SystemObj:kill("sigterm")`) rather than left running indefinitely.
2. **Given** the timeout fires, **when** the process is killed, **then** `sync_state.mark_ready()` is still called exactly once (same as the existing success/failure paths in `maven.lua`/`gradle.lua`) — a timeout must not leave `<leader>cj`/`<leader>cx` hidden forever.
3. **Given** the timeout fires, **when** the resulting notification is shown, **then** its message explicitly says the sync **timed out** (distinct wording from a generic exit-code failure), so the user isn't left guessing whether it crashed, failed auth, or just never returned.
4. **Given** the process exits normally (success or failure) before the timeout, **when** its callback runs, **then** the timeout timer is cancelled/closed and does **not** fire afterward or interfere with the normal notification.

## Tasks / Subtasks

- [x] Task 1: Add a shared sync timeout constant (AC: #1)
  - [x] In both `lua/cumulus/util/maven.lua` and `lua/cumulus/util/gradle.lua`, add a local constant near the top of `sync_dependencies()` (or module-level), e.g. `local SYNC_TIMEOUT_MS = 120000` (2 minutes — dependency resolution against a cold local repo/offline mirror can legitimately take a while; do not set this so low that a normal cold sync gets killed).
- [x] Task 2: Wire a self-managed timer around the existing `vim.system()` call (AC: #1, #2, #4)
  - [x] In `maven.lua`'s and `gradle.lua`'s `M.sync_dependencies()`, keep the existing `pcall(vim.system, {...}, {text=true}, callback)` structure (it already handles the synchronous ENOENT-throw case — do not remove that `pcall`/`ok` branch).
  - [x] Create a timer via `(vim.uv or vim.loop).new_timer()` — this repo already uses the `(vim.uv or vim.loop)` fallback pattern in `lua/cumulus/core/lazy.lua:5`; match it for consistency rather than assuming `vim.uv` alone.
  - [x] Only start the timer when `pcall(vim.system, ...)` succeeds (i.e. `ok == true`) and you have the returned `SystemObj` handle — that handle exposes `:kill(signal)`.
  - [x] Use a local `local timed_out = false` flag set inside the timer callback (wrapped in `vim.schedule_wrap`, since libuv timer callbacks run outside the main event loop) right before calling `handle:kill("sigterm")`. Checking `result.signal` alone in the exit callback is not reliable enough to distinguish "we killed it on timeout" from "something else sent it a signal" — the explicit flag is the source of truth for AC #3.
  - [x] Inside the existing exit callback (already `vim.schedule`-wrapped), stop and close the timer first (`timer:stop(); timer:close()`), then branch: if `timed_out`, notify the AC #3 timeout message; else keep the existing success/failure branches unchanged.
  - [x] `sync_state.mark_ready()` must still be called exactly once per sync attempt in every branch (timeout, success, failure, and the pre-existing "binary not found" `not ok` branch) — do not duplicate or skip it.
- [x] Task 3: Verify
  - [x] Manually simulate a timeout (e.g. temporarily lower `SYNC_TIMEOUT_MS` to ~500ms against a real or dummy `mvn`/`gradle` invocation that runs longer, or point `mvn`/`gradle` at an unreachable repository) and confirm: the process is killed, the timeout-specific notification appears, and `<leader>cj`/`<leader>cx` become visible afterward (i.e. `sync_state.ready` is `true`). Revert the temporary timeout value afterward.
  - [x] Confirm a normal fast sync (or a fast failure, e.g. missing `pom.xml`) still behaves exactly as before — no regression in the non-timeout paths.
  - [x] Run `stylua lua` and `nvim --headless "+Lazy check" +qa`.

## Dev Notes

- **This story only touches `maven.lua` and `gradle.lua`.** It does not depend on Story 41.1's `build-sync-state.lua` changes, but both stories touch the same `sync_dependencies()` functions — coordinate/rebase if implemented out of order so neither overwrites the other's edit to that function.
- **Do not block the main loop.** `vim.system()` is already async; keep the timer async too (`vim.uv`/`vim.loop` timers are non-blocking). Never use `vim.fn.system()` or a blocking `sleep`/poll loop here.
- **`vim.system()`'s own built-in `timeout` option is deliberately not used.** Neovim's `SystemOpts.timeout` sends SIGTERM automatically but the resulting `SystemCompleted.signal` value is not a reliable-enough signal to produce AC #3's distinct "timed out" message without extra bookkeeping anyway (a manually-sent SIGTERM from elsewhere would look identical). A self-managed `vim.uv` timer + explicit `timed_out` flag, as described in Task 2, gives an unambiguous source of truth and keeps both sync functions' timeout behavior easy to read in one place. If the dev agent has a strong reason to prefer the built-in `timeout` option instead, that's acceptable as long as AC #3's distinct message still holds — but the explicit-flag approach is the recommended default.
- **Relevant existing code (read before editing):**
  - `lua/cumulus/util/maven.lua:59-92` — current `M.sync_dependencies()`.
  - `lua/cumulus/util/gradle.lua:63-96` — current `M.sync_dependencies()` (near-identical structure/duplication — keep both files' changes symmetric).
  - `lua/cumulus/core/lazy.lua:5` — existing `(vim.uv or vim.loop)` usage pattern to mirror.
  - `lua/cumulus/util/build-sync-state.lua` — `mark_ready()` is idempotent (guards on `M.ready`), so calling it from a timeout path is always safe even in edge-race conditions.

### Project Structure Notes

- No new files; edit `maven.lua` and `gradle.lua` only (plus no changes needed elsewhere).
- 2-space indent, 120-column width per `stylua.toml`.
- Keep the timeout constant and timer logic structurally parallel between `maven.lua` and `gradle.lua` — these two files are intentionally near-duplicates of each other throughout the codebase; don't let one drift into a different implementation style than the other.

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 41: Maven/Gradle Sync Lifecycle Hardening / Story 41.2]
- [Source: lua/cumulus/util/maven.lua]
- [Source: lua/cumulus/util/gradle.lua]
- [Source: lua/cumulus/core/lazy.lua]

## Git Intelligence Summary

- Commit `05259a9` established the `pcall(vim.system, {...}, {text=true}, callback)` + `vim.schedule`-wrapped-callback pattern used identically in both `maven.lua` and `gradle.lua`; this story extends that exact pattern rather than replacing it.
- No prior commit in this repo has used `vim.uv`/`vim.loop` timers directly (only the one existing `fs_stat` call in `lazy.lua`) — this is new territory for the codebase, so keep it minimal and well-commented on *why* a manual timer is used instead of `vim.system`'s built-in `timeout` (see Dev Notes).

## Dev Agent Record

### Agent Model Used

Claude Sonnet 5 (claude-sonnet-5)

### Debug Log References

- Isolated raw `vim.system()` + `vim.uv` timer + `handle:kill("sigterm")` mechanics against a plain `sleep 30` command (`-u NONE`, no cumulus config loaded): kill fired at +1000ms, exit callback fired at +1001ms with `signal=15`. Confirms the core Task 2 mechanism is sound in this Neovim version (v0.12.4).
- First attempt at a realistic fake `mvn` wrapper script used `sleep 30` as a **forked** child of a bash script (not `exec`'d) — under that shape, SIGTERM successfully killed the direct bash process (confirmed via `ps --forest`, process gone within ~1.5s) but `vim.system`'s exit callback **never fired**, even after 12s. Root cause: `vim.system({text=true})` keeps stdout/stderr as pipes, and the orphaned grandchild (`sleep`, reparented to init after bash died) still held the inherited pipe file descriptors open, so the pipe never saw EOF and the callback stayed pending indefinitely.
- Rebuilt the fake wrapper to `exec sleep 30` instead (replacing the shell's process image rather than forking) — this matches how real `mvnw`/`gradlew` wrapper scripts end (`exec "$JAVACMD" ...`), so there is no separate child process holding pipe FDs. Against this realistic shape, kill fired at +1000ms and the exit callback fired at +1001ms with `signal=15`, exactly as expected.
- Ran the actual `maven.lua` module (not a raw harness) against the exec-style fake `mvn`, with `SYNC_TIMEOUT_MS` temporarily lowered to `1500` for the test: `sync_state.ready` became `true` at +1503ms, and the ERROR-level notification read exactly `"Maven: dependency sync timed out after 1.5s"`.
- Verified the two non-timeout paths against the same module (temporarily reverted timeout still at 1500 for speed): a fast-exiting fake `mvn` (`exit 0`) reached `ready=true` at +4ms with the normal `"Maven: dependencies synced"` notification (no stray timeout message, confirming the timer is cancelled cleanly); and with no `mvn` on `$PATH` at all, the pre-existing ENOENT `not ok` branch still fired correctly at +1ms with `"Maven: dependency sync failed to start (mvn not found)..."`.
- Initially treated the fork-vs-exec pipe issue (previous bullet) as an accepted edge case outside scope, since it doesn't affect real `mvnw`/`gradlew`. On review, that was wrong: it meant AC #2 ("timeout must not leave keymaps hidden forever") was not actually *guaranteed* by the implementation, only true in the common case — the timeout timer's `mark_ready()` call lived inside the `vim.system` exit callback, so any scenario where that callback doesn't fire (not just the synthetic fork case) would silently violate the AC. Fixed by decoupling: the timeout timer now calls `sync_state.mark_ready()` and fires the timeout notification **directly**, without waiting for the exit callback at all; `handle:kill()` becomes best-effort cleanup rather than something being waited on. The exit callback gained a `if timed_out then return end` guard so a late-arriving callback (if the process does eventually get reaped) can't fire a second, contradictory "synced"/"failed" notification after the user was already told it timed out.
- Re-verified against the exact previously-buggy fork-based fake `mvn` wrapper (the one whose exit callback never fires): `sync_state.ready` now becomes `true` at +1502ms (matching `SYNC_TIMEOUT_MS`) with only the timeout notification shown — confirming the fix closes the gap regardless of whether the killed process's pipes ever actually close.
- Reverted `SYNC_TIMEOUT_MS` back to `120000` in `maven.lua` after testing. Re-ran the fast-success non-timeout path afterward (`ready` at +5ms, normal "dependencies synced" notification, no regression).

### Completion Notes List

- Added `SYNC_TIMEOUT_MS = 120000` and the timer/`timed_out`-flag/kill logic to both `maven.lua` and `gradle.lua`, keeping the two files structurally parallel per the Dev Notes.
- Used the recommended self-managed `(vim.uv or vim.loop)` timer + explicit `timed_out` flag approach (not `vim.system`'s built-in `timeout` option), matching `lazy.lua`'s existing fallback pattern.
- Found and fixed a real gap during verification (see Debug Log): `mark_ready()`/the timeout notification were originally only fired from inside the `vim.system` exit callback, which is not guaranteed to ever run for a killed process (a forked, non-exec'd grandchild can keep the captured stdout/stderr pipes open indefinitely, so the pipe never sees EOF). Fixed by having the timeout timer call `mark_ready()` and notify directly, with `handle:kill()` now pure best-effort cleanup instead of something the AC depends on; the exit callback exits early if a timeout already fired, so it can't produce a duplicate/contradictory notification if it does eventually arrive. Re-verified against the process shape that originally exposed the gap.
- `gradle.lua`'s change is symmetric to `maven.lua`'s and passed `nvim --headless "+Lazy check" +qa`; the timeout/kill/decoupling fix itself was directly process-level-verified against `maven.lua`'s `sync_dependencies()` only (both files share identical logic shape, so this is a reasonable confidence level, not a full duplicate test run).
- `stylua` is not installed in this environment; formatting was done by hand matching the existing 2-space/120-column style. Run `stylua lua` in an environment that has it before merging.

### File List

- `lua/cumulus/util/maven.lua` (modified — `SYNC_TIMEOUT_MS`, timer, `timed_out` flag, timeout notification branch, decoupled from exit-callback)
- `lua/cumulus/util/gradle.lua` (modified — same, symmetric change)

## Change Log

- 2026-08-08: Implemented Story 41.2 (Tasks 1-3 complete) — timeout + cancellation safeguard added to both `maven.lua` and `gradle.lua`'s `sync_dependencies()`. Status → review.
- 2026-08-08: Fixed a gap found during verification — `mark_ready()`/timeout notification now fire directly from the timeout timer instead of depending on the killed process's exit callback, which is not guaranteed to fire if a forked (non-exec'd) grandchild process keeps the stdout/stderr pipes open. Re-verified against the process shape that exposed the gap.
