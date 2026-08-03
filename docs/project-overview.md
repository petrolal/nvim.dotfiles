# Project Overview

## What this is

**Sentry-Wrench** — a personal Neovim configuration built on **LazyVim** (`folke`'s Neovim distribution) and managed with `lazy.nvim`. It is not an application with its own runtime, API, or database; it is a curated set of Lua configuration files, custom colorschemes, and two hand-rolled build-tool integrations, all layered on top of LazyVim's defaults.

The maintainer uses this config for two primary workloads (see [tech-stack.md](./tech-stack.md) for full detail):

1. **Cloud / Infrastructure-as-Code** — Terraform, Ansible, AWS CloudFormation
2. **Java / Kotlin backend development** — Spring Boot services via Maven or Gradle

with secondary support for C/C++ (including Cortex-M/embedded debugging), Python, and Lua itself.

## Repository classification

- **Type:** Monolith, single-part (no client/server split, no monorepo workspace)
- **BMAD `project_type_id`:** closest fit is `cli`/config-repo — no API layer, no data models, no UI-component library, no deployment-config target of its own; "deployment" here means bootstrapping a workstation (`scripts/install.sh`), not shipping a service
- **Primary language:** Lua (Neovim config), plus a Bash bootstrap script
- **Entry point:** `init.lua` → `lua/config/lazy.lua` (bootstraps `lazy.nvim`, then loads LazyVim's plugin specs followed by this repo's `lua/plugins/`)

## Quick reference

| | |
|---|---|
| Distribution base | LazyVim (`{ "LazyVim/LazyVim", import = "lazyvim.plugins" }`) |
| Plugin manager | `lazy.nvim`, bootstrapped from `init.lua` |
| Formatting | `stylua` (2-space, 120-col) — see `stylua.toml` |
| Plugins locked | 75 (see `lazy-lock.json`) |
| LazyVim extras enabled | 35 — see `lazyvim.json` (`extras` array); notably `lang.java`, `lang.kotlin`, `lang.clangd`, `lang.cmake`, `lang.python`, `lang.yaml`, `lang.docker`, `dap.core`, `editor.snacks_picker`/`editor.telescope`, `ai.claudecode` |
| Active colorscheme | `sentry-blu` (custom, set in both `lua/config/options.lua` and `lua/plugins/ui-config.lua`) |
| Bootstrap script | `scripts/install.sh` — installs Neovim v0.11.4 (pinned), system deps, OpenJDK 21, clones this repo to `$XDG_CONFIG_HOME/nvim`, runs headless `Lazy sync` + `MasonInstall` |

## Repository structure at a glance

```
init.lua                 → require("config.lazy")
lua/config/               options.lua, keymaps.lua, autocmds.lua, lazy.lua (non-plugin-spec config)
lua/plugins/               one file per plugin/domain, prefixed editor-/lsp-/tools-/ui-
lua/util/                  maven.lua, gradle.lua — hand-rolled build-tool pickers
lua/themes/                sentry-blu.lua, sentry-red.lua (Lua palettes), sentry_themes.lua (shared palette table)
lua/snippets/               cloudformation.lua (luasnip CFN snippet)
colors/                     legacy Vim-script colorschemes
scripts/install.sh          bootstrap: package manager detection, Neovim install, config clone, Lazy/Mason sync
```

See [source-tree-analysis.md](./source-tree-analysis.md) for the fully annotated tree.

## Documentation set

- [Technology Stack](./tech-stack.md) — full breakdown of Cloud/IaC and Java/Kotlin tooling, including gaps (Terraform/Ansible have no dedicated LSP yet)
- [Architecture](./architecture.md) — plugin loading model, config layering, non-obvious workarounds (Kotlin JDK pin, Lombok jar resolution, colorscheme sync)
- [Source Tree Analysis](./source-tree-analysis.md) — annotated directory tree
- [Development Guide](./development-guide.md) — setup, validation commands, conventions

## Getting started (for an AI agent picking up this repo)

1. Read this file and [architecture.md](./architecture.md) first — they explain *why* the code is organized the way it is (LazyVim override model), not just *what* exists.
2. Before touching `lua/plugins/*.lua`, check the corresponding LazyVim default spec upstream — every file here is an override/extension, not a from-scratch config.
3. Run `nvim --headless "+Lazy sync | Lazy check" +qa` after any plugin-spec edit (see [development-guide.md](./development-guide.md)).
4. There is no unit test suite for this repo; correctness is verified by the headless Lazy check plus manually exercising the affected language's LSP/DAP/formatting in a real buffer.
