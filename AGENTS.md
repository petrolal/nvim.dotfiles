# Repository Guidelines

## Project Structure & Module Organization
- `init.lua` bootstraps LazyVim and loads local modules.
- `lua/config` holds runtime behavior (`options.lua`, `keymaps.lua`, `autocmds.lua`, plus module-specific toggles under `options/`).
- `lua/plugins` is split by domain (`ai`, `editor`, `lang`, `lsp`, `tools`, `ui`); keep new specs inside the closest matching folder.
- `docs/dependencies.md` lists required system packages; update it whenever bootstrap prerequisites change.
- `scripts/install.sh` provisions Neovim and dependencies; treat it as the source of truth for bootstrap logic.

## Build, Test, and Development Commands
- `bash scripts/install.sh` installs the pinned Neovim release and clones the config for fresh environments.
- `nvim --headless "+Lazy sync | Lazy check" +qa` refreshes plugins and validates spec syntax without launching the UI.
- `nvim --headless "+MasonUpdate" +qa` ensures external LSP/DAP tools stay current after plugin changes.
- `stylua lua` formats all Lua modules using the repo settings; run before every commit that touches Lua.

## Coding Style & Naming Conventions
- Follow `stylua.toml`: two-space indentation, 120-character line width, spaces over tabs.
- Organize new Lua files under `lua/<area>/<topic>.lua`; prefer lowercase snake_case for filenames and local identifiers.
- Keep module tables returned from plugin specs ordered: metadata, dependencies, opts, then keys/commands for clarity.
- Document non-obvious logic with concise English comments; avoid duplicating LazyVim defaults unless overridden.

## Testing Guidelines
- After significant changes, run `nvim --headless "+Lazy sync | Lazy check" +qa` to catch plugin regressions early.
- Launch Neovim and execute `:checkhealth` to verify runtime dependencies; attach outputs to bugfix PRs when relevant.
- For Mason-managed tooling, run `:MasonInstall`/`:MasonUpdate` interactively to validate new language support paths.

## Commit & Pull Request Guidelines
- Follow the conventional `<type>: <summary>` format used in history (`feature:`, `fix:`, `docs:`); keep summaries imperative and under 60 characters.
- Scope commits narrowly (one feature or fix), and mention user-facing changes in the body when needed.
- PRs should describe motivation, highlight affected plugins or configs, and link related issues; include reproduction steps or screenshots for UX tweaks.
- Before requesting review, confirm stylua formatting and successful headless Lazy checks; note any skipped verifications explicitly.
