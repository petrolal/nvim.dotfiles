---
stepsCompleted:
  - step-01-validate-prerequisites
  - step-02-design-epics
  - step-03-create-stories
  - step-04-final-validation
inputDocuments:
  - _bmad-output/planning-artifacts/prd-cumulus-nvim.md
  - _bmad-output/planning-artifacts/architecture-cumulus.md
---

# Cumulus Neovim Distribution - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for Cumulus Neovim Distribution, decomposing the requirements from the PRD and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

FR1: The distribution must be rebranded to "Cumulus", replacing all previous "Sentry-Wrench" and generic dotfile naming references in documentation, dashboard, and initial runtime logs.
FR2: The distribution must run 100% independently of LazyVim/LazyVim, removing lazyvim.json and direct imports of lazyvim.plugins in init.lua.
FR3: Out-of-the-box support for HCL syntax highlighting, terraform-ls LSP, tflint diagnostic linting, and terraform_fmt auto-formatting on save.
FR4: Out-of-the-box schema validation for CloudFormation/SAM templates using yamlls and linting via cfn-lint.
FR5: Out-of-the-box support for Ansible playbooks with ansible-language-server and ansible-lint.
FR6: Out-of-the-box support for Dockerfile LSP (dockerls), Docker linting (hadolint), Helm charts (helm_ls), and Kubernetes manifest schema validation.
FR7: The default visual theme must be the restored AWS Theme (#FF9900 AWS Orange / #071521 AWS Navy) loaded programmatically at startup.
FR8: Core options, keymaps, autocmds, and plugin specifications must be organized cleanly under the lua/cumulus/ module namespace.

### NonFunctional Requirements

NFR1: Headless startup and plugin initialization must complete without errors or warnings.
NFR2: All Lua code must conform to 2-space indentation and 120-column line width per stylua.toml.
NFR3: Keymappings must preserve low-latency insert exit chords (jk, kj) and home-row mod friendly window navigation (<leader>w*).
NFR4: A headless validation command or script must verify zero spec syntax errors via nvim --headless "+Lazy check".

### Additional Requirements

AR1: Move all custom logic into lua/cumulus/core/, lua/cumulus/plugins/, lua/cumulus/theme/, and lua/cumulus/util/.
AR2: Mason configuration must automatically ensure installation of terraform-ls, tflint, ansible-language-server, ansible-lint, cfn-lint, yamlls, dockerls, helm_ls, bashls, shellcheck, and shfmt.
AR3: FloatBorder must use aws_orange (#FF9900) with background set to "NONE" to prevent float border artifacts.
AR4: Maintain maven.lua and gradle.lua build tool helpers under lua/cumulus/util/.

### UX Design Requirements

N/A (No separate UX Design Contract file; visual theme requirements captured in FR7 and AR3).

### FR Coverage Map

FR1: Epic 1 (Story 1.1, Story 1.2) - Rebrand branding & dashboard to Cumulus
FR2: Epic 1 (Story 1.2) - Pure lazy.nvim bootstrap, zero LazyVim dependency
FR3: Epic 3 (Story 3.1) - Terraform & OpenTofu LSP, linter, formatter, treesitter
FR4: Epic 3 (Story 3.2) - CloudFormation & SAM yamlls schemas & cfn-lint
FR5: Epic 3 (Story 3.2) - Ansible language server & ansible-lint
FR6: Epic 3 (Story 3.3) - Docker, Hadolint, Helm, and K8s manifest support
FR7: Epic 2 (Story 2.1, Story 2.2) - AWS Theme palette engine & UI integration
FR8: Epic 1 (Story 1.1) - Namespace modularization under lua/cumulus/

## Epic List

### Epic 1: Standalone Core Architecture & Decoupling from LazyVim
Establish the standalone `cumulus.core.*` namespace and decouple Neovim startup completely from `LazyVim/LazyVim`.
**FRs covered:** FR1, FR2, FR8, NFR1, NFR2, NFR3, AR1

### Epic 2: AWS Theme Engine & Visual System
Build the programmatic AWS Theme engine (`#FF9900` AWS Orange / `#071521` AWS Navy) and apply palette tokens across all UI components.
**FRs covered:** FR7, AR3

### Epic 3: First-Class Cloud & Infrastructure-as-Code (IaC) Stack
Deliver zero-config, out-of-the-box support for Terraform/OpenTofu, CloudFormation, Ansible, Docker, and Kubernetes/Helm.
**FRs covered:** FR3, FR4, FR5, FR6, AR2

### Epic 4: Developer Utilities & Automated Verification
Migrate build tool helpers to `cumulus.util.*` and implement automated headless verification tooling.
**FRs covered:** NFR4, AR4

---

## Epic 1: Standalone Core Architecture & Decoupling from LazyVim

Establish the standalone `cumulus.core.*` namespace and decouple Neovim startup completely from `LazyVim/LazyVim`.

### Story 1.1: Core Namespace & Option Decoupling

As a Cloud Engineer,  
I want options, keymaps, and autocmds loaded from `cumulus.core.*`,  
So that my editor defaults are independent of external distribution frameworks.

**Acceptance Criteria:**
- **Given** a clean Neovim launch,
- **When** `lua/cumulus/core/options.lua` is required,
- **Then** `timeoutlen=200`, `relativenumber=true`, `mouse="a"`, and `mapleader=" "` are active,
- **And** home-row mod exit chords (`jk`, `kj`) and split navigation keymaps (`<leader>w*`) in `lua/cumulus/core/keymaps.lua` function as expected.

### Story 1.2: Native Bootstrapper & LazyVim Decoupling

As a DevOps Developer,  
I want Neovim to bootstrap `lazy.nvim` directly loading `cumulus.plugins`,  
So that `LazyVim/LazyVim` and `lazyvim.json` are completely removed from the runtime lifecycle.

**Acceptance Criteria:**
- **Given** `init.lua`,
- **When** Neovim initializes without `lazyvim.json` on disk,
- **Then** `lazy.nvim` loads only `{ import = "cumulus.plugins" }`,
- **And** running `nvim --headless "+Lazy check" +qa` completes with zero errors.

---

## Epic 2: AWS Theme Engine & Visual System

Build the programmatic AWS Theme engine (`#FF9900` AWS Orange / `#071521` AWS Navy) and apply palette tokens across all UI components.

### Story 2.1: AWS Palette Engine & Highlight Generator

As a Cloud Specialist,  
I want the AWS palette and highlight generator defined in `lua/cumulus/theme/aws.lua`,  
So that my editor exhibits a cohesive AWS Cloud aesthetic with zero float border artifacts.

**Acceptance Criteria:**
- **Given** Neovim startup,
- **When** `colorscheme aws-theme` executes,
- **Then** `aws_orange` (`#FF9900`) highlights `CursorLineNr` and `FloatBorder`,
- **And** `FloatBorder` background is set to `"NONE"` to prevent float background bleeding artifacts.

### Story 2.2: Theme Plugin Integration & UI Statusline Styling

As a DevOps Engineer,  
I want Lualine, Bufferline, and Noice popups styled with the AWS theme palette,  
So that status information and UI dialogs match the primary AWS visual identity.

**Acceptance Criteria:**
- **Given** active buffers,
- **When** navigating between windows or triggering popups,
- **Then** Lualine statusline displays navy `#020A12` background with `#FF9900` accents,
- **And** active tabs in Bufferline display orange indicators.

---

## Epic 3: First-Class Cloud & Infrastructure-as-Code (IaC) Stack

Deliver zero-config, out-of-the-box support for Terraform/OpenTofu, CloudFormation, Ansible, Docker, and Kubernetes/Helm.

### Story 3.1: Terraform & OpenTofu Integration

As an SRE,  
I want native LSP, linter, formatter, and Treesitter support for Terraform,  
So that editing `.tf` and `.hcl` files provides instant diagnostics and auto-formatting on save.

**Acceptance Criteria:**
- **Given** a `.tf` file buffer,
- **When** saving the file,
- **Then** `terraform_fmt` auto-formats the document,
- **And** `terraform-ls` and `tflint` provide active diagnostics.

### Story 3.2: AWS CloudFormation & Ansible Integration

As a Cloud Architect,  
I want schema validation and linting for CloudFormation and Ansible playbooks,  
So that template errors and playbook syntax issues are caught before deployment.

**Acceptance Criteria:**
- **Given** a CloudFormation `.yaml` or Ansible playbook,
- **When** editing in Neovim,
- **Then** `yamlls` provides CloudFormation resource schema completions,
- **And** `cfn-lint` and `ansible-lint` report template errors in the diagnostic split.

### Story 3.3: Containers & Kubernetes (Docker & Helm)

As a DevOps Engineer,  
I want LSP and linting support for Dockerfiles and Helm charts,  
So that container manifests are validated automatically.

**Acceptance Criteria:**
- **Given** a `Dockerfile` or `Chart.yaml`,
- **When** editing the file,
- **Then** `dockerls` and `helm_ls` attach as language servers,
- **And** `hadolint` highlights Dockerfile syntax issues.

---

## Epic 4: Developer Utilities & Automated Verification

Migrate build tool helpers to `cumulus.util.*` and implement automated headless verification tooling.

### Story 4.1: Utility Namespace Migration

As a JVM & Cloud Developer,  
I want Maven and Gradle helpers located in `lua/cumulus/util/`,  
So that JVM build targets are accessible via `<leader>j*` keymaps.

**Acceptance Criteria:**
- **Given** a Java/Kotlin project with `pom.xml` or `build.gradle`,
- **When** pressing `<leader>j`,
- **Then** WhichKey registers Maven/Gradle build commands dynamically.

### Story 4.2: Automated Headless Validation Script

As a Distribution Maintainer,  
I want a headless validation script `scripts/validate.sh`,  
So that plugin spec errors can be verified automatically in CI/CD pipelines.

**Acceptance Criteria:**
- **Given** `scripts/validate.sh`,
- **When** running `./scripts/validate.sh` in terminal,
- **Then** `nvim --headless "+Lazy check" +qa` executes and returns exit code 0 on success.

---

## Epic 5: Enhanced UX, Search & Keymap Productivity

Integrate high-speed Ripgrep code search, Telescope fuzzy finders, and WhichKey visual keymap popups for enhanced developer ergonomics.

### Story 5.1: Telescope & Ripgrep Deep Integration

As a Developer,  
I want Telescope integrated with Ripgrep CLI arguments,  
So that I can perform live grep searches (`<leader>sg`) and fuzzy file finding across hidden files at high speed.

**Acceptance Criteria:**
- **Given** Neovim buffer,
- **When** pressing `<leader>sg` or `<leader>ff`,
- **Then** Telescope opens with Ripgrep arguments (`vimgrep_arguments`) searching codebase with `--smart-case` and `--hidden` flags.

### Story 5.2: WhichKey Modern Visual Keymap Guide

As a Developer,  
I want WhichKey popup guidance for `<leader>` commands,  
So that all keybindings across Cloud, JVM, and UI groups are discoverable interactively.

**Acceptance Criteria:**
- **Given** Neovim buffer,
- **When** pressing `<leader>`,
- **Then** WhichKey modern popup displays organized keymap groups (`<leader>f`, `<leader>s`, `<leader>c`, `<leader>j`, `<leader>w`, `<leader>l`).

---

## Epic 6: Advanced DAP Debugging UI & Git Version Control Integration

Enhance the debugging experience with DAP UI and integrate inline Git status, hunk actions, and gutter signs.

### Story 6.1: DAP UI & Virtual Text Integration

As a Developer,  
I want `nvim-dap-ui` and `nvim-dap-virtual-text` integrated,  
So that starting a debugging session automatically opens interactive panels for variables, breakpoints, call stacks, and inline variable values.

**Acceptance Criteria:**
- **Given** a DAP debugging session (Kotlin, Java, or Cortex C/C++),
- **When** debugging starts,
- **Then** DAP UI layout opens automatically and displays callstack and variable scopes,
- **And** closing DAP closes the UI panels cleanly.

### Story 6.2: Git Gutter Signs & Hunk Navigation

As a DevOps Engineer,  
I want `gitsigns.nvim` integrated,  
So that file modifications, additions, and deletions are visually displayed in the sign column with hunk navigation keymaps (`]c`, `[c`).

**Acceptance Criteria:**
- **Given** a git-tracked file buffer,
- **When** editing lines,
- **Then** `gitsigns` displays colored sign column indicators using AWS theme palette tokens,
- **And** `<leader>ghs` stages hunks, `<leader>ghr` resets hunks, and `<leader>gbl` blames lines.

---

## Epic 7: LazyVim Ergonomics & Extra Snacks Workflows

Integrate additional Snacks.nvim developer utilities: Zen mode (`<leader>z`), Scratchpad buffers (`<leader>.`), Notification history (`<leader>sn`), and LazyGit integration (`<leader>gg`).

### Story 7.1: Snacks Zen Mode & Scratchpad

As a Developer,  
I want Zen mode and Scratchpad shortcuts in `editor-snacks.lua`,  
So that I can enter distraction-free editing with `<leader>z` and create ephemeral scratch buffers with `<leader>.`.

**Acceptance Criteria:**
- **Given** Neovim buffer,
- **When** pressing `<leader>z` or `<leader>.`,
- **Then** `Snacks.zen()` toggles distraction-free mode and `Snacks.scratch()` opens an ephemeral scratchpad.

### Story 7.2: Snacks Notification History & LazyGit Terminal

As a DevOps Engineer,  
I want LazyGit terminal and notification history shortcuts,  
So that pressing `<leader>gg` launches LazyGit in a popup terminal and `<leader>sn` opens notification history.

**Acceptance Criteria:**
- **Given** Neovim buffer,
- **When** pressing `<leader>gg` or `<leader>sn`,
- **Then** `Snacks.terminal("lazygit")` opens LazyGit and `Snacks.notifier.show_history()` opens notification history.

---

## Epic 8: UX Layout, Iconography & Visual Information Architecture

Enhance Neovim UI components with rich Nerd Font iconography, active LSP status indicators, Devicons in Bufferline with buffer numbers, and memorable WhichKey group headers.

### Story 8.1: Dashboard Cloud Workload Launcher & Iconography

As a Cloud Engineer,  
I want a Cloud Workloads quick launcher on the Snacks dashboard,  
So that I can open Terraform workspaces, LazyDocker, and Ansible shortcuts directly from startup.

**Acceptance Criteria:**
- **Given** Neovim startup dashboard,
- **When** viewing the preset keys section,
- **Then** distinct Nerd Font icons (`󰅟`, `󰡨`, `󰞵`) and quick actions appear for Cloud Workloads.

### Story 8.2: Statusline Active LSP Pill & Mode Badges

As a DevOps Developer,  
I want Lualine to display active LSP server names and mode badges,  
So that I have instant visual feedback on attached language servers and diagnostic counts.

**Acceptance Criteria:**
- **Given** an open buffer with attached LSP,
- **When** navigating windows,
- **Then** Lualine displays mode badges (`󰋜 NORMAL`, `󰏫 INSERT`) and active LSP server names in the statusline.

### Story 8.3: Bufferline Devicons & Buffer Numbers

As a Developer,  
I want filetype icons and buffer numbers on Bufferline tabs,  
So that I can identify buffer file types at a glance and jump between buffers.

**Acceptance Criteria:**
- **Given** multiple open buffers,
- **When** viewing the tabline,
- **Then** Bufferline displays `nvim-web-devicons` and buffer numbers.

### Story 8.4: WhichKey Group Iconography

As a Developer,  
I want WhichKey group headers styled with Nerd Font icons,  
So that keymap popups are visually categorized (`󰉋` Files, `󰈞` Search, `󰅟` Cloud, `󰏗` JVM, `󰊢` Git).

**Acceptance Criteria:**
- **Given** Neovim buffer,
- **When** pressing `<leader>`,
- **Then** WhichKey popup displays iconic group labels.

---

## Epic 9: LazyVim Native Keymap Parity & Ergonomic Mappings

Integrate LazyVim default keymaps for buffer navigation (`<S-h>`, `<S-l>`, `<leader>bb`, `<leader>bo`), visual line movement (`J`, `K`), visual indent preservation (`<`, `>`), search centering (`n`, `N`), and LSP diagnostic/code actions (`[d`, `]d`, `<leader>ca`, `<leader>cr`).

### Story 9.1: Buffer & Window Navigation Ergonomics

As a Developer,  
I want `<S-h>`/`<S-l>` for buffer switching and `<C-h/j/k/l>` for window navigation,  
So that I can cycle buffers and navigate splits effortlessly without modifier overhead.

**Acceptance Criteria:**
- **Given** open buffer tabs,
- **When** pressing `<S-h>` or `<S-l>`,
- **Then** Neovim switches to previous or next buffer,
- **And** `<leader>bb` switches to alternate buffer and `<leader>bo` closes other buffers.

### Story 9.2: Visual Selection & Line Movement Chords

As a Developer,  
I want visual mode `J`/`K` to move lines and `<`/`>` to maintain visual selection,  
So that moving blocks of code up/down auto-indents and stays selected.

**Acceptance Criteria:**
- **Given** a visual selection,
- **When** pressing `J` or `K`,
- **Then** selected lines move down/up and auto-indent,
- **And** pressing `<` or `>` indents/outdents while preserving visual selection.

### Story 9.3: LSP Diagnostics & Symbol Navigation Chords

As a DevOps Engineer,  
I want `[d`/`]d` for diagnostic jumping, `<leader>ca` for Code Action, and `<leader>cr` for Rename,  
So that I can navigate errors and trigger LSP refactoring actions rapidly.

**Acceptance Criteria:**
- **Given** an LSP-attached buffer with diagnostics,
- **When** pressing `[d` or `]d`,
- **Then** cursor jumps to previous or next diagnostic,
- **And** `<leader>ca` opens LSP Code Actions and `<leader>cr` opens symbol rename dialog.

---

## Epic 10: Session Quit Menu & Advanced Git Workflow Suite

Implement LazyVim session/quit management under `<leader>q*` (`<leader>qq` Quit, `<leader>qs` Restore Session, `<leader>ql` Last Session) and expand the Git workflow suite under `<leader>g*` (`<leader>gb` Blame, `<leader>gd` Diff, `<leader>gl` Log, `<leader>gs` Status).

### Story 10.1: Session Quit Keymap Suite

As a Developer,  
I want `<leader>q*` session management and exit keymaps,  
So that I can quit Neovim (`<leader>qq`), force quit (`<leader>qQ`), and restore persistence sessions (`<leader>qs`).

**Acceptance Criteria:**
- **Given** Neovim workspace,
- **When** pressing `<leader>qq`, `<leader>qQ`, or `<leader>qs`,
- **Then** Neovim quits, force quits, or restores active session.

### Story 10.2: Advanced Git Workflow Suite

As a DevOps Engineer,  
I want complete Git controls under `<leader>g*`,  
So that I can blame lines (`<leader>gb`), preview diffs (`<leader>gd`), view commit logs (`<leader>gl`), and check git status (`<leader>gs`).

**Acceptance Criteria:**
- **Given** a git repository buffer,
- **When** pressing `<leader>gb`, `<leader>gd`, `<leader>gl`, or `<leader>gs`,
- **Then** inline line blame, diff view, git log picker, or status picker opens.

---

## Epic 11: Multi-Language DevOps LSP Stack (Go, Python, JS/TS, JSON, XML, YAML, Shell)

Expand LSP and Treesitter support to cover the core DevOps development stack: Go (`gopls`), Python (`pyright`), JavaScript/TypeScript (`ts_ls`), JSON (`jsonls`), XML (`lemminx`), YAML (`yamlls`), and Shell script (`bashls`).

### Story 11.1: Go, Python & JS/TS Language Servers

As a DevOps Engineer,  
I want `gopls`, `pyright`, and `ts_ls` LSP integration,  
So that I get full autocompletion, type checking, and navigation when editing Go microservices, Python scripts, and TS tools.

**Acceptance Criteria:**
- **Given** a `.go`, `.py`, `.js`, or `.ts` buffer,
- **When** attached to LSP,
- **Then** `gopls`, `pyright`, and `ts_ls` provide autocompletion, diagnostics, and hover definitions.

### Story 11.2: Data & Markup Specs (JSON, XML, YAML, Shell)

As a DevOps Engineer,  
I want `jsonls`, `lemminx`, `yamlls`, and `bashls` LSP servers configured,  
So that configuration files, Kubernetes specs, XML definitions, and bash scripts are validated with schemas.

**Acceptance Criteria:**
- **Given** `.json`, `.xml`, `.yaml`, or `.sh` files,
- **When** editing in buffer,
- **Then** `jsonls`, `lemminx`, `yamlls`, and `bashls` validate syntax and suggest schema-compliant attributes.

---

## Epic 12: Universal DAP Debugging Platform & Keymap Suite

Implement debugging adapters for Go (`delve`), Python (`debugpy`), JS/TS (`vscode-js-debug`), and Bash (`bash-debug-adapter`) with unified DAP launch keymaps (`<leader>db`, `<leader>dc`, `<leader>di`, `<leader>do`).

### Story 12.1: Go & Python Debug Adapter Integration

As a Developer,  
I want `nvim-dap-go` (`delve`) and `nvim-dap-python` (`debugpy`) integrated,  
So that I can set breakpoints and debug Go applications and Python scripts directly in Neovim.

**Acceptance Criteria:**
- **Given** a Go or Python file,
- **When** launching a debugging session,
- **Then** `delve` or `debugpy` attaches and DAP UI displays variables and stack frames.

### Story 12.2: JS/TS & Bash Debug Adapter Integration

As a DevOps Engineer,  
I want `vscode-js-debug` and `bash-debug-adapter` integrated,  
So that Node.js/TypeScript automation scripts and bash pipelines can be step-debugged.

**Acceptance Criteria:**
- **Given** a JS/TS or Shell script buffer,
- **When** launching debugger,
- **Then** Node or Bash debug adapter initiates stepping.

### Story 12.3: Central DAP Keymap Bindings & Controls

As a Developer,  
I want unified `<leader>d*` keymaps for breakpoint toggle (`<leader>db`), continue (`<leader>dc`), step into (`<leader>di`), step over (`<leader>do`), and step out (`<leader>dO`),  
So that I have a consistent debugging control interface across all languages.

**Acceptance Criteria:**
- **Given** any DAP-enabled buffer (Go, Python, Java, Kotlin, C/C++, JS, Bash),
- **When** pressing `<leader>db` or `<leader>dc`,
- **Then** breakpoints toggle and execution continues/steps cleanly.







