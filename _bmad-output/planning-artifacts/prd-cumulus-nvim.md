# Product Requirement Document (PRD): Cumulus Neovim Distro

**Document Version:** 1.0.0  
**Status:** Approved for Architectural Design & Implementation  
**Author:** John (Product Manager)  
**Target Architect:** Winston (Architect Agent)  

---

## 1. Executive Summary & Vision

**Cumulus** is an independent, high-performance Neovim distribution purpose-built for Cloud Engineers, Site Reliability Engineers (SREs), and DevOps Practitioners.

Historically configured as a customized LazyVim starter ("Sentry-Wrench"), **Cumulus** is evolving into a completely autonomous, standalone Neovim distribution. It removes all runtime dependencies on `LazyVim/LazyVim`, while placing first-class Infrastructure-as-Code (IaC), cloud telemetry, containerization, and automation tools at the core of the editing experience—encapsulated in a signature **AWS Cloud Visual Theme**.

---

## 2. Target Persona & Core User Needs

### Primary Persona: Cloud & DevOps Engineer / SRE
* **Primary Workflows:** Authoring and maintaining Infrastructure as Code (Terraform/OpenTofu, CloudFormation, SAM), configuration management (Ansible), container definitions (Docker, Kubernetes manifests, Helm charts), and automation scripts (Bash, Python, Go).
* **Key Pain Points with Generic Distros:**
  * Generic distros prioritize WebDev (JS/TS, React, HTML/CSS) or systems programming (C/Rust), requiring extensive manual configuration for IaC.
  * Over-reliance on heavy framework abstractions (e.g., LazyVim layers) hides runtime lifecycle hooks, makes custom LSP/linter tuning fragile, and introduces unexpected upstream breaking changes.
  * Cluttered dashboards and inconsistent visual themes without specialized Cloud domain styling.

---

## 3. Product Pillars & Capabilities

### Pillar 1: First-Class Cloud & IaC Tooling
* **Terraform / OpenTofu:** Full LSP support (`terraform-ls`), automatic formatting (`terraform fmt`), HCL syntax highlighting via Treesitter, module autocomplete, and plan preview keymaps.
* **AWS CloudFormation / SAM:** YAML & JSON schema validation, `cfn-lint` integration, AWS pseudo-parameter autocompletion, and snippet engines for CloudFormation resources.
* **Ansible:** `ansible-lint` integration, YAML LSP configured for Ansible playbooks/roles, vault variable highlighting, and inventory navigation.
* **Kubernetes & Containers:** Helm syntax highlighting, `k8s` schema validation, Dockerfile LSP (`dockerls`), `docker-compose` support, and quick cluster context switches.
* **Cloud Telemetry & CLI Integration:** Quick terminal splits for AWS CLI (`aws`), `kubectl`, `terraform`, and `ansible-playbook`.

### Pillar 2: Distinctive AWS Theme Identity
* **Palette Restoration:** Restore and elevate the signature **AWS Theme** from git history (commit `d259abf` / `d491a72`):
  * **AWS Orange (`#FF9900`):** Core accents, active borders, cursorline match, highlight blocks, and primary focus indicators.
  * **AWS Navy (`#071521` / `#05101C`):** Deep dark background, clean sidebar contrasts (`#040D17`), and statusline (`#020A12`).
  * **Glassmorphism & Floating Window Precision:** Seamless `NormalFloat` and `FloatBorder` highlighting using `#FF9900` for crisp visual hierarchy without border color artifacts.
* **Custom Dashboard & Branding:** Clean startup screen branded as **Cumulus** with cloud telemetry shortcuts and quick session restore.

### Pillar 3: Complete Independence from LazyVim
* **Standalone Bootstrap:** Replace `LazyVim/LazyVim` import with direct `lazy.nvim` plugin management.
* **Custom Core Architecture:** Own all core options (`options.lua`), keymaps (`keymaps.lua`), autocmds (`autocmds.lua`), and plugin spec structures (`lua/cumulus/...`).
* **Zero External Distro Lock-in:** Eliminate implicit upstream LazyVim plugin imports and handlers.

---

## 4. Architectural Rules & Requirements for Architect (Winston)

When Winston (Architect) designs and implements the codebase changes, the following **non-negotiable rules** must be enforced:

1. **Namespace Restructuring (`cumulus.*`):**
   * All Lua modules must migrate from `config.*` or flat `plugins.*` to a clean namespace: `lua/cumulus/core/` (options, keymaps, autocmds), `lua/cumulus/plugins/` (specs), and `lua/cumulus/theme/` (AWS palette engine).
2. **LazyVim Decoupling Rule:**
   * Remove `lazyvim.json` and the `{ "LazyVim/LazyVim", import = "lazyvim.plugins" }` specification.
   * Bootstrap `lazy.nvim` natively in `init.lua` pointing directly to `cumulus.plugins`.
3. **IaC Default Pre-configuration:**
   * Mason and LSP specs MUST automatically ensure installation and setup of: `terraform-ls`, `tflint`, `ansible-language-server`, `ansible-lint`, `cfn-lint`, `yamlls`, `dockerls`, `helm_ls`, and `bashls`.
4. **AWS Theme First-Class Integration:**
   * Set `aws-theme` as the default colorscheme loaded on startup (`vim.cmd("colorscheme aws-theme")`).
   * Theme palette must reside in `lua/cumulus/theme/aws.lua` and expose highlight group bindings for LSP diagnostics, statusline (lualine/heirline), bufferline, telescope/fzf-lua, and flash/hop.
5. **Backwards-Compatible Developer Ergonomics:**
   * Preserve user keymaps for navigation and split management while removing LazyVim-specific dependency calls.
   * Provide a headless validation command script (`scripts/validate.sh` or `nvim --headless "+Lazy check"`) to guarantee zero startup errors.

---

## 5. Success Criteria

| Metric / Requirement | Target State |
| :--- | :--- |
| **Distro Name** | `Cumulus` |
| **LazyVim Dependency** | **0%** (Removed entirely from `init.lua`, `lazy-lock.json`, `lazyvim.json`) |
| **Default Theme** | AWS Theme (`#FF9900` / `#071521`) |
| **IaC Readiness** | Native LSP, Linter, Treesitter for Terraform, CloudFormation, Ansible out-of-the-box |
| **Startup Health** | `:checkhealth` passes cleanly with 0 plugin spec errors |

---

## 6. Next Steps for Implementation

1. **Hand-off to Architect (Winston):** Architect creates the technical design specification (`architecture-cumulus.md`) detailing the exact file tree, plugin spec breakdowns, LSP options, and theme engine structure.
2. **Epics & Story Breakdown:** PM converts PRD and Architecture spec into atomic implementation stories.
