# Source Tree Analysis

Annotated directory tree for **Sentry-Wrench** (single-part repo, no monorepo/client-server split). Paths not listed below (`.git/`, `.state/`, `.nvimlog`, BMAD tooling directories) are excluded as non-config-relevant; BMAD directories are covered separately at the bottom.

```
neovim-dotfiles/
├── init.lua                          # Entry point. Bootstraps lazy.nvim, then requires config.lazy.
│
├── lua/
│   ├── config/                       # Files lazy.nvim auto-loads OUTSIDE the plugin-spec system
│   │   ├── lazy.lua                  #   Clones lazy.nvim if missing; defines the plugin spec import order
│   │   │                             #   (LazyVim's own specs, then this repo's lua/plugins/); rtp perf tweaks.
│   │   ├── options.lua               #   Loaded pre-startup. vim.g.lazyvim_colorscheme, nerd font flag,
│   │   │                             #   HRM/split-keyboard ergonomics (timeoutlen, mouse, relativenumber).
│   │   ├── keymaps.lua               #   Loaded on VeryLazy. Deltas only: jk/kj exit chords, centered
│   │   │                             #   scroll, <leader>w* window nav. Does not duplicate LazyVim keymaps.
│   │   └── autocmds.lua              #   Loaded on VeryLazy. Java/Kotlin autosave-on-focus-lost; dynamic
│   │                                 #   Maven/Gradle which-key registration gated on build-file presence.
│   │
│   ├── plugins/                      # Flat, filename-prefixed by domain. Each file = lazy.nvim spec table.
│   │   ├── editor-completion.lua     #   nvim-cmp: strips the "emoji" completion source.
│   │   ├── editor-snacks.lua         #   snacks.nvim: dashboard (custom ASCII banner + git-commit footer),
│   │   │                             #   file explorer (replaces netrw), picker, terminal keymaps.
│   │   ├── editor-telescope.lua      #   telescope.nvim: secondary picker, horizontal layout, "Find Plugin
│   │   │                             #   File" keymap scoped to lazy.nvim's plugin root.
│   │   ├── lsp-clangd.lua            #   clangd: background-index, clang-tidy, IWYU, UTF-16 offsets.
│   │   ├── lsp-java.lua              #   jdtls: Lombok agent injection (dual Mason path check), root_dir
│   │   │                             #   fallback, JavaSE-21 runtime pin, completion/import/codegen opts.
│   │   ├── lsp-kotlin.lua            #   kotlin-language-server: JAVA_HOME→Java21 pin (JDK-version-string
│   │   │                             #   crash workaround), disables documentHighlightProvider, cleans
│   │   │                             #   stray kls_database files.
│   │   ├── lsp-python.lua            #   pyright: workspace diagnostics, basic type checking, custom
│   │   │                             #   <leader>ci "add missing imports" code-action keymap.
│   │   ├── tools-cmake.lua           #   cmake-tools.nvim: build/ dir, compile_commands.json export,
│   │   │                             #   codelldb DAP wiring.
│   │   ├── tools-dap-cortex.lua      #   nvim-dap-cortex-debug: OpenOCD launch configs for ESP32 and
│   │   │                             #   generic ARM Cortex-M, shared across c/cpp filetypes.
│   │   ├── tools-dap-kotlin.lua      #   nvim-dap: kotlin adapter — launch main class (prompted) or
│   │   │                             #   attach to remote JVM on port 5005.
│   │   ├── tools-formatting.lua      #   conform.nvim: ktlint (kotlin), google-java-format (java),
│   │   │                             #   ruff_format+organize_imports (python), stylua (lua).
│   │   ├── tools-mason.lua           #   mason.nvim ensure_installed: shellcheck, flake8,
│   │   │                             #   google-java-format, jdtls, java-debug-adapter, java-test,
│   │   │                             #   kotlin-language-server, kotlin-debug-adapter, ktlint.
│   │   ├── ui-config.lua             #   LazyVim/LazyVim opts: colorscheme="sentry-blu", full custom
│   │   │                             #   diagnostic/git/kind icon set.
│   │   └── ui-noice.lua              #   noice.nvim: disables LSP progress spinner, minimal message view,
│   │                                 #   nui popupmenu backend.
│   │
│   ├── util/                         # Hand-rolled build-tool integrations (NOT lazy.nvim plugin specs).
│   │   │                             # Invoked from config/autocmds.lua's java/kotlin FileType autocmd.
│   │   ├── maven.lua                 #   find_pom (cwd→bufdir walk-up), get_mvn_cmd (prefers ./mvnw),
│   │   │                             #   run_maven_cmd (terminal split), get_maven_goals (introspects
│   │   │                             #   pom.xml for spring-boot/quarkus/surefire/failsafe/exec plugins),
│   │   │                             #   run_maven_goal (vim.ui.select picker).
│   │   └── gradle.lua                #   Mirrors maven.lua: find_gradle, get_gradle_cmd (prefers
│   │                                 #   ./gradlew), run_gradle_cmd, get_gradle_tasks (parses
│   │                                 #   `gradlew tasks --all` output), run_gradle_task (picker). Always
│   │                                 #   surfaces bootRun/bootRun --debug-jvm/bootJar (Spring Boot).
│   │
│   ├── themes/                       # Lua palette tables consumed by plugin opts (not colorscheme files).
│   │   ├── sentry-blu.lua            #   Active theme. Full highlight-group palette + M.load()/M.setup().
│   │   ├── sentry-red.lua            #   Alternate theme, same structure.
│   │   └── sentry_themes.lua         #   Shared red/blu color primitives table (bg/fg/primary/etc.), used
│   │                                 #   by plugin opts that need raw hex values (e.g. dashboard footer).
│   │
│   └── snippets/
│       └── cloudformation.lua        #   luasnip snippet for yaml filetype: `cft` trigger scaffolds an
│                                     #   AWSTemplateFormatVersion/Resources CFN skeleton.
│
├── colors/                           # Legacy Vim-script colorschemes (sourced via :colorscheme, not opts)
│   ├── sentry-blu.vim
│   ├── sentry-red.vim
│   └── aws-theme.vim
│
├── scripts/
│   └── install.sh                    # Bootstrap: pkg-mgr detection (apt/pacman/dnf), system deps + OpenJDK
│                                      # 21, global tool install (stylua/ruff/pynvim/neovim-npm), pinned
│                                      # Neovim download, clone-to-$XDG_CONFIG_HOME/nvim, headless
│                                      # Lazy sync + MasonInstall.
│
├── docs/                             # BMAD/AI-context documentation (this file's directory)
│   ├── index.md                      # Master entry point
│   ├── project-overview.md
│   ├── tech-stack.md                 # Cloud/IaC + Java/Kotlin stack, incl. Terraform/Ansible gaps
│   ├── architecture.md
│   ├── source-tree-analysis.md       # (this file)
│   ├── development-guide.md
│   └── project-scan-report.json      # BMAD document-project workflow state file
│
├── init.lua                          # (listed above — repeated here only for tree completeness at root)
├── lazy-lock.json                    # Plugin commit lockfile (75 plugins) — regenerated by Lazy, not hand-edited
├── lazyvim.json                      # Declares 35 enabled LazyVim extras (lang/coding/editor/dap/ui bundles)
├── stylua.toml                       # Lua formatter config: 2-space indent, 120-col width
├── .neoconf.json                     # neodev (Neovim API types) + neoconf (lua_ls) settings
├── README.md                         # Install instructions, links to docs/dependencies.md (not present)
└── LICENSE
```

## Critical directories explained

| Path | Why it's critical |
|---|---|
| `lua/config/` | The only three files outside the `lazy.nvim` spec system — miss these and you'll misunderstand how options/keymaps/autocmds actually get loaded (event-based, not spec-based). |
| `lua/plugins/` | Every behavioral change to LazyVim lives here. Always cross-reference the matching upstream LazyVim spec before editing `opts`. |
| `lua/util/` | The two files here are the only non-plugin, hand-written Lua modules in the repo — genuinely custom logic (Maven/Gradle detection) rather than plugin configuration. |
| `lua/themes/` vs `colors/` | Two parallel theming systems: `lua/themes/*.lua` are palette tables consumed programmatically by plugin `opts` (e.g. dashboard footer color), while `colors/*.vim` are traditional `:colorscheme`-loadable Vim-script files. Keep both in sync when adjusting the active palette. |
| `scripts/install.sh` | The only "deployment" artifact in this repo — it provisions a *workstation*, not a running service. Contains a hard dependency (OpenJDK 21) required by the Kotlin LSP workaround in `lsp-kotlin.lua`. |

## Entry points

- **Neovim startup:** `init.lua` (single line: `require("config.lazy")`)
- **Bootstrap a new machine:** `scripts/install.sh` (piped from a raw GitHub URL per `README.md`)
- **Plugin/LSP sync (headless):** `nvim --headless "+Lazy sync | Lazy check" +qa` — see [development-guide.md](./development-guide.md)

## Integration points

Single-part repo — no cross-service integration. The closest analogue to an "integration point" is the Java/Kotlin build-tool layer: `lua/config/autocmds.lua`'s `FileType` autocmd wires `lua/util/maven.lua` / `lua/util/gradle.lua` into which-key, gated on build-file presence detected by each module.

## BMAD tooling directories (excluded from the tree above)

`_bmad/`, `_bmad-output/`, `.claude/skills/bmad-*`, `.agent/skills/bmad-*` are the BMAD agent-skill framework's own workflow/config/output files — infrastructure for AI-assisted planning, not part of the Neovim configuration itself. Treat as out of scope for Neovim-config changes unless a task explicitly concerns BMAD.
