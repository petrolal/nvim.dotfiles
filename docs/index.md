# Cumulus Documentation Index

## Project Overview

- **Name:** Cumulus (`neovim-dotfiles`)
- **Type:** Standalone, independent Neovim distribution for Cloud, SRE, and DevOps workloads
- **Primary Language:** Lua (distribution core), Bash (bootstrap scripts)
- **Architecture:** Decoupled, modular namespace (`cumulus.*`) managed directly via `lazy.nvim`
- **Visual Identity:** AWS Theme (`#FF9900` AWS Orange accents over `#071521` AWS Navy)
- **Target Workloads:** Infrastructure-as-Code (Terraform / OpenTofu, CloudFormation, SAM), Configuration Management (Ansible), Containers & Kubernetes (Docker, Helm), JVM Services (Java/Kotlin Spring Boot), and Shell Scripting

## Quick Reference

- **Tech Stack:** `lazy.nvim` plugin manager; `terraform-ls`, `yamlls` (CFN), `ansiblels`, `dockerls`, `helm_ls`, `jdtls`, `kotlin-language-server`, `pyright`, `clangd` LSPs; `conform.nvim` formatting; `nvim-lint` diagnostics; `aws-theme` colorscheme
- **Entry Point:** `init.lua` → `lua/cumulus/core/options.lua` & `cumulus.plugins`
- **Architecture Pattern:** Modular namespace architecture (`cumulus.core`, `cumulus.plugins`, `cumulus.theme`, `cumulus.util`)

## Generated Documentation

- [Project Overview](./project-overview.md)
- [Technology Stack](./tech-stack.md) — Cloud/IaC tooling matrix, LSP/Linter/Formatter specifications, and JVM support
- [Architecture](./architecture.md) — Plugin loading model, `cumulus.*` namespace layout, AWS palette engine, and bootstrap flow
- [Source Tree Analysis](./source-tree-analysis.md) — Annotated directory tree
- [Development Guide](./development-guide.md) — Prerequisites, installation, validation commands, and style conventions

## Getting Started

1. Start with [project-overview.md](./project-overview.md) for the high-level architecture and vision.
2. Read [architecture.md](./architecture.md) to understand the `cumulus.*` namespace and zero-distro independence model.
3. Use [tech-stack.md](./tech-stack.md) for detailed tool pinning (Mason, LSP, linters, formatters).
4. Validate plugin spec changes with `nvim --headless "+Lazy check" +qa`.
