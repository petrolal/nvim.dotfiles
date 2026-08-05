# Cumulus Neovim Distribution

**Cumulus** is an independent, high-performance Neovim distribution engineered specifically for **Cloud Engineers, Site Reliability Engineers (SREs), and DevOps Practitioners**.

---

## ⚡ Key Capabilities

* ☁️ **Infrastructure-as-Code First-Class Citizen:** Pre-configured LSP, diagnostic linting, syntax highlighting, and formatting for **Terraform / OpenTofu**, **AWS CloudFormation / SAM**, **Ansible**, **Docker**, and **Kubernetes / Helm**.
* 🎨 **AWS Signature Theme:** Programmatically loaded AWS Cloud Theme featuring `#FF9900` AWS Orange accents, deep navy backgrounds (`#071521`), and glassmorphism window splits.
* 🚀 **Zero-Framework Autonomy:** Built directly on `lazy.nvim` with zero runtime dependency on external distribution wrappers (e.g. LazyVim).
* ☕ **JVM & Automation Tooling:** Integrated support for Maven, Gradle, Java, Kotlin, Python, and Bash automation scripts.

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
