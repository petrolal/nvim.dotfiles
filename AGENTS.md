# Repository Guidelines

## Project Structure & Module Organization
`init.lua` bootstraps LazyVim and hands off plugin loading to `lua/config/lazy.lua`. Runtime tweaks stay in `lua/config`, where `options.lua`, `keymaps.lua`, and `autocmds.lua` should remain focused so downstream overrides are easy to locate. Plugin specs live in topical files under `lua/plugins` (for example `lua/plugins/core.lua`, `lua/plugins/lsp.lua`), keeping each integration self-contained. Lock state is recorded in `lazy-lock.json`, while root-level `stylua.toml` governs formatting. Use the `remotes/` snapshots for reference only—do not edit them directly.

## Build, Test, and Development Commands
- `nvim --headless "+Lazy sync" +qa` installs new plugins and aligns versions with `lazy-lock.json`.
- `nvim --headless "+Lazy check" +qa` validates specs and reports missing dependencies.
- `stylua lua` formats all Lua sources according to the shared style.
Run the first two commands after modifying plugin specs or lockfiles, and rerun `stylua` before staging changes.

## Coding Style & Naming Conventions
Indent with two spaces, wrap lines under 120 characters, and prefer table-based plugin declarations. File and module names stay lowercase with underscores (`lua/plugins/languages.lua`). Place option overrides adjacent to the plugin they affect and document non-obvious defaults with brief comments only when necessary.

## Testing Guidelines
Automated tests are not available, so rely on Lazy health checks. After material changes, execute `nvim --headless "+Lazy sync | Lazy check" +qa` to confirm the configuration loads cleanly. For keymaps or UI tweaks, open Neovim interactively and verify the affected workflows, noting any messages surfaced in `:messages`.

## Commit & Pull Request Guidelines
Use the `<type>: <summary>` convention (`fix:`, `feature:`, `hotfix:`) observed in the log. Pull requests should describe motivation, summarize configuration impacts, list headless commands run, and attach screenshots when behavior changes. Keep diffs scoped to the touched module and explain any lockfile updates.

## Agent Workflow Tips
Start from a fresh branch per task, and avoid touching `lazy-lock.json` unless intentionally updating plugin versions. Cross-check related specs when editing shared modules like `lua/plugins/core.lua` to prevent regressions. Capture reproduction steps and command output in PR descriptions to accelerate reviews.
