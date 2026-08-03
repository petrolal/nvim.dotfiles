# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal Neovim configuration ("Sentry-Wrench") built on **LazyVim**, managed with `lazy.nvim`. It is not an application with its own test suite or build artifacts — "correctness" means the Lua specs load cleanly, plugins sync, and LSP/DAP/formatting tooling works for the configured languages (C/C++, Java, Kotlin, Python, Lua, plus Cortex-M/embedded debugging).

## Commands

- `stylua lua` — format all Lua modules (2-space indent, 120 col width, per `stylua.toml`). Run before every commit that touches Lua.
- `nvim --headless "+Lazy sync | Lazy check" +qa` — sync plugins and validate spec syntax without a UI. Use this after editing anything under `lua/plugins/`.
- `nvim --headless "+MasonUpdate" +qa` — refresh external LSP/DAP/formatter binaries after plugin changes.
- `nvim --headless "+MasonInstall <tool>" +qa` — install a specific Mason tool (see `lua/plugins/tools-mason.lua` for the ensure_installed list).
- Inside Neovim: `:checkhealth` to verify runtime dependencies end-to-end.

There is no unit test suite; "testing" a change means running the headless Lazy check above and then opening Neovim against a real project file for the affected language to confirm LSP/DAP/formatting behaves.

## Architecture

- `init.lua` → `lua/config/lazy.lua` bootstraps `lazy.nvim`, then loads `{ "LazyVim/LazyVim", import = "lazyvim.plugins" }` followed by `{ import = "plugins" }`. Everything in `lua/plugins/*.lua` is therefore an **override/extension of LazyVim's own plugin specs**, not a from-scratch config — read the corresponding LazyVim default before changing `opts`.
- `lua/config/` holds the three files `lazy.nvim` auto-loads outside the plugin spec system: `options.lua` (early, pre-startup), `keymaps.lua` and `autocmds.lua` (on `VeryLazy`). Comments in those files link to the LazyVim defaults they extend — don't duplicate LazyVim's own keymaps/autocmds, only add deltas.
- `lua/plugins/` is flat but filename-prefixed by domain: `editor-*`, `lsp-*`, `tools-*`, `ui-*`. Each file returns a `lazy.nvim` spec table (or a function-based `opts` override) targeting one plugin. Follow the existing naming when adding a new spec (`<domain>-<topic>.lua`).
- `lua/util/maven.lua` and `lua/util/gradle.lua` are hand-rolled build-tool integrations (not plugins) invoked from `lua/config/autocmds.lua`'s `FileType` autocmd for `java`/`kotlin`. They detect `pom.xml`/`build.gradle(.kts)` (walking up from cwd, falling back to the current buffer's directory), prefer the wrapper (`mvnw`/`gradlew`) over a global install, and run commands in a terminal split. Maven goals are also introspected from `pom.xml` content (e.g. presence of `spring-boot-maven-plugin` unlocks `spring-boot:run` in the picker). Which-key mappings for these live under `<leader>j` and are registered dynamically only when a matching build file is found in the current project.
- `lua/plugins/lsp-kotlin.lua` pins `kotlin-language-server` to a Java 21 JVM via `JAVA_HOME`, independent of the system default JDK — the bundled Kotlin compiler crashes on newer JDK version strings. If Kotlin LSP breaks, check this resolution logic first before assuming a Mason/upstream issue.
- `lua/plugins/lsp-java.lua` injects the Mason-installed Lombok agent jar into jdtls's JVM args (checked under both `mason/share/jdtls/lombok.jar` and `mason/packages/jdtls/lombok.jar`, since Mason has changed layout across versions).
- Custom colorschemes live in `colors/*.vim` (Vim-script, legacy/Sentry themes) and `lua/themes/*.lua` (Lua palette tables consumed by plugin `opts`, e.g. `ui-noice.lua`/`ui-config.lua`). The active scheme is `sentry-blu`, set in both `lua/config/options.lua` (`vim.g.lazyvim_colorscheme`) and `lua/plugins/ui-config.lua` (`opts.colorscheme`) — keep these two in sync if you change it.
- `scripts/install.sh` is the source of truth for bootstrap: detects the package manager (apt/pacman/dnf), installs a pinned Neovim release plus system deps (including OpenJDK 21 for the Kotlin LSP fix above), clones this repo into `$XDG_CONFIG_HOME/nvim`, then runs the same headless `Lazy sync` + `MasonInstall` commands listed above. Any new Mason tool added to `tools-mason.lua`'s `ensure_installed` should also be added to the `MasonInstall` line in `bootstrap_lazy_and_mason()` here.

## Conventions

- Two-space indentation, 120-char line width (`stylua.toml`); no tabs.
- New files go under `lua/<area>/<topic>.lua` with lowercase snake_case names.
- Order plugin-spec tables as: metadata, dependencies, opts, then keys/commands.
- Comment only non-obvious logic (workarounds, version-specific gotchas like the Kotlin JDK pin above); don't restate LazyVim defaults.
- Commits follow `<type>: <summary>` (`feature:`, `fix:`, `refactor:`, `docs:`), imperative and under ~60 chars, one feature/fix per commit.

## BMAD framework

This repo also has the BMAD agent-skill framework installed (`_bmad/`, `_bmad-output/`, `.claude/skills/bmad-*`, `.agent/skills/bmad-*`). Those directories are BMAD's own workflow/config files (agents, skill definitions, planning/implementation artifact output), separate from the Neovim config itself — treat them as tooling infrastructure, not code to refactor as part of Neovim-config changes, unless a task explicitly concerns BMAD.
