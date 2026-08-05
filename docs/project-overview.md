# Cumulus Project Overview

## What Cumulus Is

**Cumulus** is an independent, high-performance Neovim distribution engineered specifically for **Cloud Engineers, Site Reliability Engineers (SREs), and DevOps Practitioners**.

Cumulus operates as a completely autonomous, zero-framework Neovim distribution managed directly with `lazy.nvim`. It encapsulates core editing, LSP orchestration, diagnostic linting, and visual aesthetics into a clean, maintainable `cumulus.*` namespace.

---

## Primary Workloads & Use Cases

1. **Infrastructure as Code (IaC):**
   * **Terraform / OpenTofu:** Full LSP support (`terraform-ls`), diagnostic linting (`tflint`), HCL Treesitter parsing, and auto-formatting (`terraform fmt`).
   * **AWS CloudFormation / SAM:** Schema-assisted validation (`yamlls`), template linting (`cfn-lint`), and pseudo-parameter completions.
2. **Configuration Management & Orchestration:**
   * **Ansible:** Playbook linting (`ansible-lint`), YAML LSP (`ansible-language-server`), vault variable highlighting.
   * **Kubernetes & Containers:** Dockerfile LSP (`dockerls`), Docker linting (`hadolint`), Helm chart support (`helm_ls`), and manifest validation.
3. **Backend & Automation Development:**
   * **JVM Services:** Java/Kotlin Spring Boot integration (Maven & Gradle wrappers, `jdtls`, `kotlin-language-server`).
   * **Scripting:** Bash/Zsh (`bashls`, `shellcheck`, `shfmt`), Python (`pyright`, `ruff`), and Lua configuration.

---

## Core Pillars & Architectural Principles

* **Zero External Framework Dependency:** Direct `lazy.nvim` native bootstrap without external distribution wrappers.
* **AWS Cloud Signature Theme:** Built-in AWS Palette (`#FF9900` AWS Orange / `#071521` AWS Navy) loaded programmatically on startup.
* **Modular Namespace (`cumulus.*`):** Strict directory separation:
  * `lua/cumulus/core/` (options, keymaps, autocmds)
  * `lua/cumulus/theme/` (AWS palette engine)
  * `lua/cumulus/plugins/` (modular specs for core, cloud, ui, tools)
  * `lua/cumulus/util/` (IaC & build tool helpers)

---

## Repository Structure at a Glance

```
init.lua                 → loads cumulus.core.options, bootstraps lazy.nvim, imports cumulus.plugins
lua/cumulus/core/        options.lua, keymaps.lua, autocmds.lua
lua/cumulus/theme/       aws.lua (AWS palette & highlight generator), init.lua
lua/cumulus/plugins/     core-*, cloud-*, ui-*, tools-* plugin specifications
lua/cumulus/util/        iac.lua, maven.lua, gradle.lua
scripts/install.sh       System dependency bootstrap script
```
