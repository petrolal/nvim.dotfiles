# Cumulus Neovim Distribution

**Cumulus** is an independent, high-performance Neovim distribution engineered specifically for **Cloud Engineers, Site Reliability Engineers (SREs), and DevOps Practitioners**.

---

## ⚡ Key Capabilities

* ☁️ **Infrastructure-as-Code First-Class Citizen:** Pre-configured LSP, diagnostic linting, syntax highlighting, and formatting for **Terraform / OpenTofu**, **AWS CloudFormation / SAM**, **Ansible**, **Docker**, and **Kubernetes / Helm**.
* 🎨 **AWS Signature Theme:** Programmatically loaded AWS Cloud Theme featuring `#FF9900` AWS Orange accents, deep navy backgrounds (`#071521`), and glassmorphism window splits.
* 🚀 **Zero-Framework Autonomy:** Built directly on native `lazy.nvim` plugin specifications with zero external distribution framework dependencies.
* ☕ **JVM & Automation Tooling:** Integrated support for Maven, Gradle, Java, Kotlin, Python, and Bash automation scripts.

> [!NOTE]
> **Ecosystem Terminology:**
> - **`lazy.nvim`**: Neovim's plugin manager loaded via `lua/cumulus/core/lazy.lua`.
> - **`lazy-lock.json`**: Auto-generated lockfile pinning git commit SHAs for reproducible builds (unrelated to lazygit).
> - **`lazygit`**: Optional terminal TUI for Git launched via `<leader>og`.


---

## 🛠️ Quick Installation

Run the bootstrap script:

```bash
curl -fsSL https://raw.githubusercontent.com/petrolal/neovim-dotfiles/main/scripts/install.sh | bash
```

Or pass `NEOVIM_VERSION` to specify a release:

```bash
curl -fsSL https://raw.githubusercontent.com/petrolal/neovim-dotfiles/main/scripts/install.sh | NEOVIM_VERSION=0.10.2 bash
```

---

## 🔍 Validation & Health

After launching Neovim, verify your environment and dependencies:

```vim
:checkhealth
:MasonInstall terraform-ls tflint ansible-language-server ansible-lint cfn-lint dockerls helm_ls yamlls bashls
```

---

## 📖 Documentation

* [Project Overview](docs/project-overview.md)
* [Technology Stack & Tooling](docs/tech-stack.md)
* [System Architecture & Namespace](docs/architecture.md)
* [Development & Validation Guide](docs/development-guide.md)

---

## 👤 Author & Maintainer

* **Lucas H N A Petrola** (`petrolal`) — Lead Developer & Architect.
