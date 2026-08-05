# Cumulus Project Context

## Project Identity & Overview

**Cumulus** is an independent, standalone Neovim distribution engineered specifically for **Cloud Engineers, SREs, and DevOps Practitioners**.

* **Project Name:** Cumulus
* **Primary Workloads:** Infrastructure-as-Code (Terraform / OpenTofu, CloudFormation, SAM), Configuration Management (Ansible), Containers & Kubernetes (Docker, Helm), Shell Automation (Bash/Zsh), and JVM Services (Spring Boot Maven/Gradle).
* **Architecture Pattern:** Zero-framework, direct `lazy.nvim` plugin specification, modular namespace (`cumulus.*`).
* **Visual Theme:** Restored AWS Theme (Primary Accent: `#FF9900` AWS Orange, Dark Navy: `#071521`, Statusline: `#020A12`).

---

## Technical Stack & Tooling Matrix

| Domain | Language Server (LSP) | Diagnostic Linter | Formatter | Treesitter Parsers |
| :--- | :--- | :--- | :--- | :--- |
| **Terraform / OpenTofu** | `terraform-ls` | `tflint` | `terraform fmt` | `hcl`, `terraform` |
| **AWS CloudFormation** | `yamlls` (with CFN schema) | `cfn-lint` | `prettier` / `yamlfix` | `yaml`, `json` |
| **Ansible** | `ansible-language-server` | `ansible-lint` | `yamlfix` | `yaml` |
| **Containers / K8s** | `dockerls`, `helm_ls` | `hadolint`, `kube-linter` | `shfmt`, `yamlfix` | `dockerfile`, `helm`, `yaml` |
| **JVM (Java / Kotlin)** | `jdtls`, `kotlin-language-server` | N/A | `google-java-format`, `ktlint` | `java`, `kotlin` |

---

## Code Base Namespace & Architecture Rules

1. **Namespace Separation (`cumulus.*`):**
   * Core Vim settings: `lua/cumulus/core/options.lua`, `keymaps.lua`, `autocmds.lua`.
   * AWS Palette & Theme engine: `lua/cumulus/theme/aws.lua`.
   * Plugin specs: `lua/cumulus/plugins/` (`core-*`, `cloud-*`, `ui-*`, `tools-*`).
   * Utility modules: `lua/cumulus/util/` (`iac.lua`, `maven.lua`, `gradle.lua`).

2. **LazyVim Independence:**
   * Do not import `{ "LazyVim/LazyVim", import = "lazyvim.plugins" }` or rely on `lazyvim.json`.
   * `init.lua` bootstraps `lazy.nvim` and loads `cumulus.plugins` directly.

3. **Validation Invariants:**
   * Run `stylua` before committing Lua code (2-space indent, 120 column width).
   * Verify plugin changes with headless Lazy check: `nvim --headless "+Lazy check" +qa`.
