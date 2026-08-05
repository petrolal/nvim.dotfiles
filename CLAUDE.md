# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) and AI agents working on **Cumulus**.

## What this repo is

**Cumulus** is an independent, high-performance Neovim distribution purpose-built for **Cloud Engineers, SREs, and DevOps Practitioners**. It provides first-class, out-of-the-box editing, LSP, linting, and formatting for Terraform/OpenTofu, AWS CloudFormation/SAM, Ansible, Docker, Kubernetes/Helm, and JVM automation scripts—styled with a signature **AWS Cloud Theme**.

It uses `lazy.nvim` directly as its native plugin manager under the `cumulus.*` namespace.

## Commands

- `stylua lua` — format all Lua modules (2-space indent, 120 col width, per `stylua.toml`). Run before every commit touching Lua.
- `nvim --headless "+Lazy check" +qa` — validate spec syntax without a UI. Use this after editing anything under `lua/cumulus/plugins/`.
- `nvim --headless "+MasonUpdate" +qa` — refresh external LSP/DAP/formatter binaries.
- `nvim --headless "+MasonInstall <tool>" +qa` — install a specific Mason tool (e.g., `terraform-ls`, `tflint`, `ansible-language-server`, `cfn-lint`, `dockerls`, `helm_ls`).
- Inside Neovim: `:checkhealth` to verify runtime dependencies end-to-end.

## Architecture

- `init.lua` → loads `cumulus.core.options`, bootstraps `lazy.nvim`, and loads `{ import = "cumulus.plugins" }`.
- `lua/cumulus/core/` holds options (`options.lua`), keymaps (`keymaps.lua`), and autocmds (`autocmds.lua`).
- `lua/cumulus/theme/` contains the AWS palette (`aws.lua`) and theme initialization engine.
- `lua/cumulus/plugins/` holds modular plugin specs (`core-*`, `cloud-*`, `ui-*`, `tools-*`).
- `lua/cumulus/util/` contains domain helpers for IaC execution and Maven/Gradle JVM build tools.

## Key Conventions

- Two-space indentation, 120-char line width (`stylua.toml`); no tabs.
- All new Lua modules live within the `cumulus` namespace (`lua/cumulus/<area>/<topic>.lua`).
- Active theme is `aws-theme` (`#FF9900` AWS Orange / `#071521` AWS Navy).
- Commits follow standard conventional commit prefixes (`feature:`, `fix:`, `refactor:`, `docs:`).

## BMAD Framework

This repo has the BMAD agent-skill framework installed (`_bmad/`, `_bmad-output/`, `.claude/skills/bmad-*`, `.agent/skills/bmad-*`). Planning and implementation artifacts are located in `_bmad-output/planning-artifacts/`.
