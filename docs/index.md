# Project Documentation Index

## Project Overview

- **Name:** Sentry-Wrench (neovim-dotfiles)
- **Type:** Monolith, single-part Neovim configuration built on LazyVim
- **Primary Language:** Lua (config), Bash (bootstrap script)
- **Architecture:** Plugin-spec override/extension layer on top of `LazyVim/LazyVim`, managed by `lazy.nvim`
- **Target workloads:** Cloud/IaC (Terraform, Ansible, CloudFormation) and Java/Kotlin Spring Boot development; secondary C/C++/embedded and Python support

## Quick Reference

- **Tech Stack:** LazyVim + `lazy.nvim`; jdtls/kotlin-language-server/pyright/clangd LSPs; conform.nvim formatting; nvim-dap + cortex-debug debugging; hand-rolled Maven/Gradle integration — see [tech-stack.md](./tech-stack.md) for the full, gap-annotated breakdown
- **Entry Point:** `init.lua` → `lua/config/lazy.lua`
- **Architecture Pattern:** Config-as-code, event/spec-driven plugin loading (see [architecture.md](./architecture.md))

## Generated Documentation

- [Project Overview](./project-overview.md)
- [Technology Stack](./tech-stack.md) — Cloud/IaC (Terraform ⚠️ / Ansible ⚠️ / CloudFormation) + Java/Kotlin Spring Boot, with an explicit gap analysis
- [Architecture](./architecture.md) — plugin loading model, non-obvious workarounds (Kotlin JDK pin, Lombok jar resolution, colorscheme sync), bootstrap/deployment architecture
- [Source Tree Analysis](./source-tree-analysis.md) — fully annotated directory tree
- [Development Guide](./development-guide.md) — prerequisites, install, validation commands, testing approach, conventions

Not generated (not applicable to this repo — no API layer, no data models, no UI-component library, no multi-part structure): API Contracts, Data Models, Component Inventory, Integration Architecture.

## Existing Documentation

- [README.md](../README.md) — Quick install, manual setup pointer to `docs/dependencies.md` (referenced but not present in this repo — a documentation gap worth closing)

## Getting Started

1. Start with [project-overview.md](./project-overview.md) for the big picture, then [architecture.md](./architecture.md) for *why* the code is organized the way it is.
2. Before editing anything under `lua/plugins/`, read the matching upstream LazyVim default spec — every file here overrides or extends LazyVim, it doesn't replace it wholesale.
3. Use [tech-stack.md](./tech-stack.md) to know exactly which stacks have real LSP/DAP/formatter support today (Java/Kotlin, C/C++, Python) versus which are still gaps (Terraform, Ansible — currently generic-YAML-only).
4. Validate any plugin-spec change with `nvim --headless "+Lazy sync | Lazy check" +qa` — see [development-guide.md](./development-guide.md) for the full command set.
5. There is no unit test suite; verify changes by exercising the real LSP/DAP/formatting behavior for the affected language in a live buffer.

## For BMAD brownfield planning

When creating a brownfield PRD or planning new work in this repo (e.g. adding Terraform/Ansible LSP support per the gap identified in `tech-stack.md`), point the PRD workflow at this file (`docs/index.md`) as the primary context source.
