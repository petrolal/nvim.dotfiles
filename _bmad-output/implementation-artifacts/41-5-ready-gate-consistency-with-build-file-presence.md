# Story 41.5: Ready-Gate Consistency with Build File Presence

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a JVM developer,
I want `<leader>cj`/`<leader>cx` to require both a matching filetype AND an actual `pom.xml`/`build.gradle(.kts)` in the project,
so that these Maven/Gradle-only build commands don't appear in every `.java`/`.kotlin`/`.groovy`/`.xml` buffer regardless of whether the project is a Maven/Gradle project at all.

## Acceptance Criteria

1. **Given** a `java`/`kotlin`/`groovy`/`xml` buffer opened in a project with **no** `pom.xml` and **no** `build.gradle(.kts)` anywhere in its search path, **when** keymaps are applied, **then** `<leader>cj`/`<leader>cx` do **not** appear for that buffer.
2. **Given** the same buffer, **when** a `pom.xml` or `build.gradle(.kts)` is later added to the project (or the buffer is re-applied after one is found), **then** `<leader>cj`/`<leader>cx` do appear, exactly as today.
3. **Given** any *other* registered stack in `lua/cumulus/core/keymaps.lua` that declares only `filetypes` with no `condition` (Terraform, Ansible, Docker, Helm, etc.), **when** this story's fix ships, **then** those stacks' visibility is completely unchanged — the fix must be additive/generic, not a hardcoded special case for the `<leader>cj`/`<leader>cx` stacks specifically.

## Root Cause (read this before touching anything)

In `lua/cumulus/core/lang-keymaps.lua`'s `apply()` (~line 61):

```lua
if matches_ft or matches_cond then
```

This is an **OR**. `matches_ft` becomes `true` whenever the buffer's filetype is in `stack.filetypes` — completely independent of `stack.condition`'s result. Because the `<leader>cj`/`<leader>cx` stacks in `keymaps.lua` (~line 74-207) declare **both** `filetypes = { "java", "kotlin", "groovy", "xml" }` (or `{"java","kotlin","groovy"}`) **and** a `condition` function that checks `maven.find_pom() or gradle.find_gradle()`, the `condition` is currently dead weight for gating purposes: any `java`/`kotlin`/`groovy`/`xml` buffer satisfies `matches_ft` on its own, so the keys register regardless of whether the project actually has a `pom.xml`/`build.gradle`. Combined with `ready_gate` becoming `true` almost immediately in any session (even the "nothing to sync" branch in `autocmds.lua` calls `mark_ready()`), the net effect today is: **`<leader>cj`/`<leader>cx` show up in any Java/Kotlin/Groovy/XML buffer in any project, Maven/Gradle or not.**

## Tasks / Subtasks

- [ ] Task 1: Fix the matcher combinator generically in `apply()` (AC: #1, #2, #3)
  - [ ] In `lua/cumulus/core/lang-keymaps.lua`'s `apply()`, replace the `if matches_ft or matches_cond then` line with logic that requires **both** to hold only when a stack declares **both** `filetypes` and `condition`; stacks with only one of the two keep today's behavior (effectively OR, since the missing side is always `false`). E.g.:
    ```lua
    local visible
    if stack.filetypes and stack.condition then
      visible = matches_ft and matches_cond
    else
      visible = matches_ft or matches_cond
    end
    if visible then
      -- existing vim.keymap.set loop
    end
    ```
  - [ ] Do **not** hardcode this to the `<leader>cj`/`<leader>cx` groups by name/group-string — the fix must live in the generic `apply()` combinator so it applies to any current or future stack that declares both `filetypes` and `condition`.
  - [ ] Confirm via `grep -n "condition = function" lua/cumulus/core/keymaps.lua` that, as of this writing, only the two `<leader>cj`/`<leader>cx` stacks (~line 77, ~line 212) declare `condition` — every other stack (Terraform `<leader>ct`, Ansible `<leader>cy`, Docker `<leader>cD`, Helm `<leader>ck`) declares only `filetypes`, so AC #3 is satisfied automatically by this generic fix, not by a separate code path.
- [ ] Task 2: Verify
  - [ ] Open a `.java` file in a directory tree with no `pom.xml`/`build.gradle` anywhere above it — confirm `<leader>cj`/`<leader>cx` are absent from the which-key popup and `vim.api.nvim_buf_get_keymap` for that buffer.
  - [ ] Open a `.java` file in a project that does have a `pom.xml` — confirm `<leader>cj`/`<leader>cx` still appear once sync completes, exactly as before this story.
  - [ ] Open a `.tf` (Terraform) file and confirm `<leader>ct` is unaffected (still shows purely by filetype, no regression from the combinator change).
  - [ ] Run `stylua lua` and `nvim --headless "+Lazy check" +qa`.

## Dev Notes

- **This story is independent of Stories 41.1-41.4** — it does not touch `build-sync-state.lua`, `maven.lua`, or `gradle.lua` at all. It can be implemented in any order relative to those.
- **`ready_gate` itself is not being removed or changed** — it still correctly hides `<leader>cj`/`<leader>cx` until the first sync attempt completes. This story only fixes the *separate* `matches_ft`/`matches_cond` combinator bug that makes `condition` a no-op once `ready_gate` is satisfied. Do not conflate the two mechanisms; they compose via the outer `if not (stack.ready_gate and not sync_state.ready) then` guard (~line 42), which is unaffected by this story.
- **Relevant existing code (read before editing):**
  - `lua/cumulus/core/lang-keymaps.lua:32-69` — `apply()` in full, including the `ready_gate` guard and the `matches_ft`/`matches_cond` block being fixed here.
  - `lua/cumulus/core/keymaps.lua:74-259` — both `<leader>cj` and `<leader>cx` `lang_keymaps.register({...})` calls, to confirm both declare `filetypes` and `condition`.
  - `lua/cumulus/core/keymaps.lua:261-300` — the other stacks (`<leader>ct`, `<leader>cy`, `<leader>cD`, `<leader>ck`), to confirm none declare `condition`.

### Project Structure Notes

- No new files. Single edit: `lua/cumulus/core/lang-keymaps.lua`'s `apply()`.
- 2-space indent, 120-column width per `stylua.toml`.

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 41: Maven/Gradle Sync Lifecycle Hardening / Story 41.5]
- [Source: lua/cumulus/core/lang-keymaps.lua]
- [Source: lua/cumulus/core/keymaps.lua]

## Git Intelligence Summary

- Commit `4137109` ("show java keybindgs after sync") is the commit that added `ready_gate` alongside the pre-existing `condition` functions on the `<leader>cj`/`<leader>cx` stacks — the OR-combinator bug predates that commit (the `condition` functions were already effectively dead-weight before `ready_gate` existed, for the same filetype-match reason), but `ready_gate`'s addition is what makes the practical impact worse (the group now reliably shows almost immediately in any session instead of only after a real sync).

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
