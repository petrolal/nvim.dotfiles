# Cumulus Source Tree Analysis

## Annotated Directory Structure

```
.
├── init.lua                        # Entry point: options, lazy.nvim bootstrap, imports cumulus.plugins
├── project-context.md              # Global BMAD AI context definition for Cumulus
├── CLAUDE.md                       # Developer & AI assistant guidance
├── README.md                       # Main user landing page and quick install instructions
├── stylua.toml                     # Lua code style rules (2-space, 120 width)
├── lazy-lock.json                  # Pinned plugin commit lockfile
├── scripts/
│   ├── install.sh                  # Workstation bootstrap script
│   └── validate.sh                 # Headless verification script
├── _bmad-output/
│   └── planning-artifacts/         # PRD, Architecture, and Epics planning documents
│       ├── prd-cumulus-nvim.md
│       ├── architecture-cumulus.md
│       └── epics.md
├── docs/                           # Official system documentation set
│   ├── index.md
│   ├── project-overview.md
│   ├── tech-stack.md
│   ├── architecture.md
│   ├── development-guide.md
│   └── source-tree-analysis.md
└── lua/
    └── cumulus/
        ├── init.lua                # Entry setup module
        ├── core/                   # Independent options, keymaps, autocmds
        │   ├── options.lua
        │   ├── keymaps.lua
        │   └── autocmds.lua
        ├── theme/                  # AWS Palette & theme initialization
        │   ├── init.lua
        │   └── aws.lua
        ├── plugins/                # Modular plugin specifications
        │   ├── core-treesitter.lua
        │   ├── core-mason.lua
        │   ├── core-lsp.lua
        │   ├── cloud-terraform.lua
        │   ├── cloud-aws.lua
        │   ├── cloud-ansible.lua
        │   ├── cloud-k8s.lua
        │   ├── tools-formatting.lua
        │   ├── tools-linting.lua
        │   └── ui-*.lua
        └── util/                   # Domain utilities (IaC runners, Maven/Gradle JVM tools)
            ├── iac.lua
            ├── maven.lua
            └── gradle.lua
```
