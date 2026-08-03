# Architecture

## Overview

This repo is an **override/extension layer on top of LazyVim**, not a from-scratch Neovim config. Understanding that relationship is the single most important fact for working in this codebase: every file under `lua/plugins/` modifies or adds to a plugin spec that LazyVim already defines (or, for a handful of files, adds a plugin LazyVim doesn't ship at all). Before changing any `opts` table, check the corresponding LazyVim default at `LazyVim/LazyVim`'s `lua/lazyvim/plugins/`.

## Bootstrap and load order

```
init.lua
  └─ require("config.lazy")          -- lua/config/lazy.lua
       ├─ clones lazy.nvim if missing (git, --branch=stable)
       ├─ vim.opt.rtp:prepend(lazypath)
       └─ require("lazy").setup({
            spec = {
              { "LazyVim/LazyVim", import = "lazyvim.plugins" },  -- 1st: LazyVim's own specs
              { import = "plugins" },                             -- 2nd: lua/plugins/*.lua (this repo)
            },
            defaults = { lazy = false, version = false },
            performance = { rtp = { disabled_plugins = {...} } },
          })
```

Because `lua/plugins/` imports *after* `lazyvim.plugins`, every spec in this repo can merge into (`opts = function(_, opts) ... end`) or fully replace an already-registered LazyVim plugin. Most files here use the merge form to layer changes rather than clobber LazyVim's defaults.

Outside the `lazy.nvim` spec system, three files are loaded directly by lifecycle event, not plugin resolution:

| File | Loaded | Purpose |
|---|---|---|
| `lua/config/options.lua` | Before startup (pre-plugin) | `vim.g.lazyvim_colorscheme`, `vim.g.have_nerd_font`, and ergonomic settings (`timeoutlen=200`, `ttimeoutlen=10`, `mouse=a`, `relativenumber=true`) tuned for a split/HRM (home-row-mods) keyboard layout |
| `lua/config/keymaps.lua` | `VeryLazy` | Deltas only — `jk`/`kj` insert-mode exit chords, `<leader>d`/`<leader>u` centered scroll, `<leader>w{w,h,j,k,l}` window navigation. Does **not** redefine LazyVim's own keymaps |
| `lua/config/autocmds.lua` | `VeryLazy` | Java/Kotlin autosave-on-focus-lost, and the dynamic Maven/Gradle which-key registration described below |

## Plugin spec organization

`lua/plugins/` is flat, not nested, and relies on a filename prefix convention to communicate domain:

- `editor-*` — picker/explorer/navigation (`editor-snacks.lua`, `editor-telescope.lua`, `editor-completion.lua`)
- `lsp-*` — one file per language server (`lsp-clangd.lua`, `lsp-java.lua`, `lsp-kotlin.lua`, `lsp-python.lua`)
- `tools-*` — build tools, formatters, debuggers, Mason config (`tools-cmake.lua`, `tools-dap-cortex.lua`, `tools-dap-kotlin.lua`, `tools-formatting.lua`, `tools-mason.lua`)
- `ui-*` — cosmetic/UI plugin config (`ui-config.lua` for LazyVim's own icon/colorscheme opts, `ui-noice.lua`)

Each file returns a `lazy.nvim` spec table (a list with one or more `{ "author/plugin", opts = ..., keys = ..., config = ... }` entries). New files should follow `<domain>-<topic>.lua` and this ordering within the table: plugin name/metadata → `dependencies` → `opts` → `keys`/`commands`/`config`.

## Non-obvious workarounds (read before debugging these areas)

These are documented in-code as comments; they're surfaced here because they're easy to misdiagnose as unrelated bugs.

### Kotlin LSP crashes on newer JDKs — JAVA_HOME pin

`lua/plugins/lsp-kotlin.lua` glob-searches for a Java 21 install (`/usr/lib/jvm/java-21-openjdk*`, sdkman path, etc.) and sets `cmd_env = { JAVA_HOME = <path> }` for `kotlin_language_server`, **independent of the system default JDK**. Root cause: `kotlin-language-server` bundles Kotlin compiler 2.1.0, whose IntelliJ-derived `JavaVersion` parser cannot handle version strings from newer JDKs (e.g. Java 25's `"25.0.3"`) and crashes immediately on startup. `scripts/install.sh` installs OpenJDK 21 system-wide specifically to guarantee this glob finds a candidate. **If Kotlin LSP won't start, check this resolution logic before assuming a Mason or upstream KLS issue.**

The same file also disables `documentHighlightProvider` on attach (KLS + compiler 2.1 throws `UnsupportedOperationException`/JSON-RPC `-32603` on annotated classes) and deletes stray `kls_database*` files from the project root on attach.

### Lombok agent injection for jdtls

`lua/plugins/lsp-java.lua` wraps `opts.full_cmd` to append `--jvm-arg=-javaagent:<lombok.jar>` to jdtls's launch command. The Lombok jar path is checked at **both** `mason/share/jdtls/lombok.jar` and `mason/packages/jdtls/lombok.jar` because Mason has changed its package layout across versions — checking only one path silently breaks Lombok support after a Mason upgrade.

### Colorscheme set in two places

The active colorscheme (`sentry-blu`) must be kept in sync in **two** locations: `vim.g.lazyvim_colorscheme` in `lua/config/options.lua` (used by LazyVim's own bootstrap before plugins load) and `opts.colorscheme` in `lua/plugins/ui-config.lua` (the `LazyVim/LazyVim` plugin spec's own opts). Changing one without the other produces a mismatch between the splash-screen colorscheme and the one LazyVim's config module reports.

### Dynamic, build-file-gated keymaps

`lua/config/autocmds.lua` registers a `FileType` autocmd for `java`/`kotlin` that calls `util.maven.find_pom()` / `util.gradle.find_gradle()` and only registers the `<leader>jm*` (Maven) or `<leader>jg*` (Gradle) which-key groups if the corresponding build file is actually found (walking up from cwd, falling back to the current buffer's directory). This means the Maven/Gradle keymap groups are **absent** in Java/Kotlin buffers that aren't part of a Maven/Gradle project — this is intentional, not a bug, and both `util/maven.lua` and `util/gradle.lua` introspect the build file content to conditionally add Spring Boot/Quarkus-specific goals (e.g. `spring-boot:run` only appears if `pom.xml` contains `spring-boot-maven-plugin`).

## Data/config architecture (no database — config-as-code)

There is no database or persisted application state; the closest analogues are:

- **Plugin lockfile** (`lazy-lock.json`) — pins exact commits for all 75 plugins; regenerated by `Lazy sync`/`Lazy update`, not hand-edited
- **LazyVim extras toggle** (`lazyvim.json`'s `extras` array) — declarative list of upstream LazyVim plugin bundles to enable; edited via `:LazyExtras` in Neovim or by hand
- **Neoconf/neodev config** (`.neoconf.json`) — per-project `lua_ls` settings and Neovim API type awareness

## Testing strategy

There is no unit test suite. "Correctness" is verified two ways:

1. `nvim --headless "+Lazy sync | Lazy check" +qa` — confirms every plugin spec is syntactically valid Lua and resolves without error. Run this after any change under `lua/plugins/`.
2. Manual verification inside Neovim against a real project file for the affected language (`:checkhealth`, then open a `.java`/`.kt`/`.py`/`.c` file and confirm LSP attaches, diagnostics populate, formatting-on-save fires, and — for Java/Kotlin — the Maven/Gradle which-key group appears).

See [development-guide.md](./development-guide.md) for the full command list.

## Deployment / bootstrap architecture

`scripts/install.sh` is the source of truth for provisioning a new machine, not a CI/CD pipeline (there is no `.github/workflows/` in this repo). It:

1. Detects package manager (`apt`, `pacman`, or `dnf`) and installs system deps, including **OpenJDK 21** (required by the Kotlin LSP pin above) and dev CLIs (`ripgrep`, `fd`, `lazygit`, `lazydocker`, etc.)
2. Installs global formatting/tooling: `stylua` (via `cargo`), `ruff` (via `pip`), `pynvim` and the `neovim` npm package (Neovim providers)
3. Downloads and installs a pinned Neovim release (default `v0.11.4`, overridable via `NEOVIM_VERSION` env var)
4. Clones this repo into `$XDG_CONFIG_HOME/nvim` (backs up any pre-existing non-git config dir first; `git pull --ff-only` if already cloned)
5. Runs headless `Lazy! sync` then `MasonInstall` for every tool referenced by `tools-mason.lua`'s `ensure_installed` list plus the language servers configured elsewhere (`jdtls`, `kotlin-language-server`, `pyright`, etc.)

**Convention:** any new Mason tool added to `tools-mason.lua`'s `ensure_installed` should also be added to the `MasonInstall` line inside `bootstrap_lazy_and_mason()` in `install.sh`, or a fresh install will silently skip it until the next `:Lazy sync` inside Neovim itself.

> **Known issue found during this documentation pass:** several comment lines in `install_global_tools()` and `bootstrap_lazy_and_mason()` (`scripts/install.sh` lines ~127–175) use Lua-style `--` comments instead of Bash's `#`. Under `set -euo pipefail`, a bare `-- some text` line is executed as a command named `--`, which will fail with "command not found" and abort the script. This should be fixed (replace `--` with `#`) before relying on a fresh `install.sh` run.
