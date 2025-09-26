# Repository Guidelines

## Project Structure & Module Organization
`init.lua` bootstraps LazyVim by delegating to `lua/config/lazy.lua`. Core runtime tweaks live under `lua/config` (`options.lua`, `keymaps.lua`, `autocmds.lua`) and should stay minimal so overrides remain discoverable. Plugin specs are grouped in `lua/plugins`, one topic per file (`core.lua`, `lsp.lua`, `languages.lua`, etc.) to keep diffs focused; follow that pattern when adding new integrations. Lockfile updates belong in `lazy-lock.json`, while formatting rules sit in `stylua.toml`.

## Build, Test, and Development Commands
- `nvim --headless "+Lazy sync" +qa` installs or updates plugins after dependency changes.
- `nvim --headless "+Lazy check" +qa` validates plugin specs and reports missing dependencies.
- `stylua lua` applies consistent formatting across all Lua modules before committing.

## Coding Style & Naming Conventions
Use two-space indentation and keep lines under 120 characters per `stylua.toml`. Module names and filenames stay lowercase with words separated by underscores (`chatGPT.lua` mirrors upstream naming). Prefer descriptive, table-based plugin specs and keep option overrides close to the plugin definition they affect. Run `stylua` locally or configure an editor-on-save hook to maintain style parity.

## Testing Guidelines
Automated tests are not present, so rely on headless health checks. After significant changes, run `nvim --headless "+Lazy sync | Lazy check" +qa` to ensure the config loads cleanly. For keymap or UI adjustments, open Neovim normally and exercise the affected workflows; capture any errors surfaced in `:messages` when filing reviews.

## Commit & Pull Request Guidelines
Follow the existing `<type>: <summary>` convention (`fix:`, `feature:`, `hotfix:`) observed in Git history. Each PR should explain the motivation, outline configuration impacts, and link related issues or screenshots when behavior changes. Include a quick verification note (e.g., commands run) and keep diffs scoped to the relevant module to simplify review.

## Agent Workflow Tips
Check out a fresh branch for every change and keep `lazy-lock.json` adjustments intentional—document why plugin version bumps are required. When touching shared modules like `lua/plugins/core.lua`, call out interplay with other plugin specs to avoid regressions. EOF
