# Cumulus Technology Stack & Tooling Matrix

## System Stack Overview

Cumulus integrates a specialized suite of Neovim plugins, language servers, diagnostic linters, formatters, and Treesitter parsers tailored for Cloud, SRE, and DevOps automation workflows.

---

## Domain Tooling Breakdown

### 1. Terraform & OpenTofu
* **Language Server:** `terraform-ls` (`nvim-lspconfig`)
* **Linter:** `tflint` (`nvim-lint`)
* **Formatter:** `terraform_fmt` (`conform.nvim`)
* **Treesitter Parsers:** `hcl`, `terraform`

### 2. AWS CloudFormation & SAM
* **Language Server:** `yamlls` configured with AWS CloudFormation schema mapping
* **Linter:** `cfn-lint` (`nvim-lint`)
* **Formatter:** `prettier` / `yamlfix` (`conform.nvim`)
* **Treesitter Parsers:** `yaml`, `json`

### 3. Ansible
* **Language Server:** `ansible-language-server` (`ansiblels`)
* **Linter:** `ansible-lint` (`nvim-lint`)
* **Formatter:** `yamlfix` (`conform.nvim`)
* **Treesitter Parsers:** `yaml`

### 4. Containers & Kubernetes
* **Language Servers:** `dockerls`, `helm_ls`
* **Linters:** `hadolint`, `kube-linter`
* **Formatters:** `shfmt`, `yamlfix`
* **Treesitter Parsers:** `dockerfile`, `helm`, `yaml`

### 5. Shell & Scripting
* **Language Server:** `bashls`
* **Linter:** `shellcheck`
* **Formatter:** `shfmt`
* **Treesitter Parsers:** `bash`

### 6. JVM Services (Java & Kotlin)
* **Language Servers:** `jdtls` (with Lombok agent injection), `kotlin-language-server` (pinned to Java 21 JVM)
* **Formatters:** `google-java-format`, `ktlint`
* **Build Integration:** Native Maven (`lua/cumulus/util/maven.lua`) and Gradle (`lua/cumulus/util/gradle.lua`) pickers

---

## Mason Ensure-Installed Pinning List

The following binaries are automatically pinned and managed via Mason (`cumulus.plugins.core-mason`):

```lua
ensure_installed = {
  -- IaC & Cloud
  "terraform-ls",
  "tflint",
  "ansible-language-server",
  "ansible-lint",
  "cfn-lint",
  "yamlls",

  -- Containers & K8s
  "dockerls",
  "hadolint",
  "helm_ls",

  -- Shell & Utilities
  "bashls",
  "shellcheck",
  "shfmt",
  "stylua",

  -- JVM & Scripting
  "jdtls",
  "kotlin-language-server",
  "pyright",
  "ruff",
}
```
