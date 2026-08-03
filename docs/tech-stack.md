# Technology Stack

This document catalogs every language/tool stack this Neovim configuration is built to support, and — critically — distinguishes stacks with **dedicated LSP/DAP/formatter wiring** in `lua/plugins/` from stacks that only get **generic editing support** via LazyVim's stock extras. Read this before assuming a capability exists; several of the target stacks below have real gaps.

## Primary target workloads

Per the maintainer, this config serves two concrete workloads:

1. **Cloud / Infrastructure-as-Code** — Terraform, Ansible, AWS CloudFormation
2. **Java / Kotlin backend development** — Spring Boot services (Maven and Gradle)

Everything else (C/C++, embedded, Python, Lua) is secondary/general-purpose support inherited from LazyVim or added for specific hardware work.

---

## 1. Cloud / Infrastructure-as-Code

| Tool | Status | Where |
|---|---|---|
| **AWS CloudFormation** | Snippet only | `lua/snippets/cloudformation.lua` — a `luasnip` snippet (trigger `cft`) that scaffolds a CFN template (`AWSTemplateFormatVersion`, `Description`, `Resources:` skeleton) for `yaml` filetype. No CloudFormation-specific linter/LSP (e.g. `cfn-lint`) is configured. |
| **YAML (generic)** | LazyVim extra | `lazyvim.json` enables `lazyvim.plugins.extras.lang.yaml`, which provides `yamlls` (schema-aware completion/validation) — this is what backs editing of CloudFormation/Ansible/generic YAML files, not a CFN- or Ansible-specific server. |
| **Terraform** | ⚠️ Not configured | No `terraform-ls` entry in `lua/plugins/tools-mason.lua`'s `ensure_installed`, no `lua/plugins/lsp-terraform.lua` or equivalent, and no `lang.terraform` extra in `lazyvim.json`. `.tf`/`.tfvars` files currently get **no LSP** (no completion, validation, or formatting) — only generic Treesitter highlighting if a `hcl` parser happens to be installed. This is a gap if Terraform work is expected.|
| **Ansible** | ⚠️ Not configured | No `ansible-language-server` in Mason's `ensure_installed`, no dedicated plugin spec. Ansible playbooks are edited as plain YAML via `yamlls` — no Ansible-specific module/role-name completion, `ansible-lint` integration, or inventory awareness. |
| **Docker** | LazyVim extra | `lazyvim.plugins.extras.lang.docker` — provides `dockerls` and `docker-compose-language-service` for `Dockerfile`/`docker-compose.yml`. |
| **SQL** | LazyVim extra | `lazyvim.plugins.extras.lang.sql`. |
| **TOML / JSON** | LazyVim extras | `lazyvim.plugins.extras.lang.toml`, `lazyvim.plugins.extras.lang.json`. |

**Net effect:** CloudFormation authoring gets a snippet + generic YAML LSP; Terraform and Ansible currently get **plain-text-with-YAML/HCL-highlighting only** — there is no validation, completion, or formatting pipeline for either. To close this gap, the pattern to follow is the same one used for Java/Kotlin below: add `terraform-ls` / `ansible-language-server` to `tools-mason.lua`'s `ensure_installed`, then add a `lua/plugins/lsp-terraform.lua` / `lsp-ansible.lua` file registering the server with `neovim/nvim-lspconfig`'s `opts.servers` table (mirroring `lsp-clangd.lua` / `lsp-python.lua`).

## 2. Java / Kotlin — Spring Boot

This is the most fully-built-out stack in the config: LSP, DAP, formatting, and hand-rolled build-tool integration all exist.

| Concern | Tool | Config |
|---|---|---|
| Java LSP | `jdtls` via `mfussenegger/nvim-jdtls` | `lua/plugins/lsp-java.lua` — injects Mason's Lombok agent jar as a `--jvm-arg=-javaagent:` flag (checked at both legacy and current Mason path layouts), adds a root_dir fallback for standalone files, pins Java runtime to JavaSE-21 at `/usr/lib/jvm/java-21-openjdk-amd64`, and configures completion favorites (JUnit 5, Hamcrest, Mockito static imports), import organization thresholds, and a `toString()` code-gen template. |
| Kotlin LSP | `kotlin-language-server` via `nvim-lspconfig` | `lua/plugins/lsp-kotlin.lua` — **pins `JAVA_HOME` to a discovered Java 21 install** (glob-searches common JDK install paths) because the bundled Kotlin compiler (2.1.0) crashes parsing newer JDK version strings (e.g. Java 25's `"25.0.3"`). Also disables `documentHighlightProvider` (crashes on annotated classes in this KLS/compiler combo) and cleans up stray `kls_database*` files from the project root on attach. |
| Java debugging | `java-debug-adapter`, `java-test` (Mason) | Wired through `nvim-jdtls`'s DAP integration (installed via Mason, no separate plugin file). |
| Kotlin debugging | `kotlin-debug-adapter` | `lua/plugins/tools-dap-kotlin.lua` — registers the `kotlin` DAP adapter/configurations: launch a main class (prompted via `vim.ui.input`) or attach to a remote JVM on port 5005 (matching the Spring Boot debug keymap below). |
| Java formatting | `google-java-format` | `lua/plugins/tools-formatting.lua` via `conform.nvim`; also auto-triggered by the `FocusLost`/`BufLeave` autosave autocmd in `lua/config/autocmds.lua` for `*.java`. |
| Kotlin formatting | `ktlint` | Same `conform.nvim` config; same autosave autocmd covers `*.kt`/`*.kts`. |
| Maven integration | Hand-rolled | `lua/util/maven.lua` — detects `pom.xml` (cwd then buffer dir), prefers `./mvnw` over global `mvn`, introspects `pom.xml` content to conditionally surface `spring-boot:run`/`spring-boot:build-image` (if `spring-boot-maven-plugin` present), `quarkus:dev` (if Quarkus plugin present), `failsafe`/`surefire` goals, etc. Runs in a terminal split. |
| Gradle integration | Hand-rolled | `lua/util/gradle.lua` — mirrors the Maven module: detects `build.gradle`/`build.gradle.kts`, prefers `./gradlew`, dynamically fetches `./gradlew tasks --all` for a task picker, always exposes `bootRun`/`bootRun --debug-jvm`/`bootJar` (Spring Boot Gradle plugin tasks). |
| Keymaps | Which-key, dynamic | `lua/config/autocmds.lua`'s `FileType` autocmd for `java`/`kotlin` registers `<leader>jm*` (Maven) and `<leader>jg*` (Gradle) groups **only when the corresponding build file is found** in the project. Includes one-key Spring Boot run (`<leader>jmr`/`<leader>jgr`) and remote-debug launch on port 5005 (`<leader>jmD`/`<leader>jgD`), matching the Kotlin DAP attach config above. |
| Mason tools ensured | `jdtls`, `java-debug-adapter`, `java-test`, `kotlin-language-server`, `kotlin-debug-adapter`, `ktlint`, `google-java-format` | `lua/plugins/tools-mason.lua`. |
| LazyVim extras | `lazyvim.plugins.extras.lang.java`, `lazyvim.plugins.extras.lang.kotlin` | `lazyvim.json` — baseline LazyVim support this config then layers the above onto. |

Bootstrap: `scripts/install.sh` installs **OpenJDK 21** system-wide (`openjdk-21-jdk` / `jdk21-openjdk` / `java-21-openjdk` depending on distro) specifically to satisfy the Kotlin LSP's JDK-21 pin described above — this is a hard dependency, not incidental.

## 3. C / C++ and embedded (secondary)

| Concern | Tool | Config |
|---|---|---|
| C/C++ LSP | `clangd` | `lua/plugins/lsp-clangd.lua` — background indexing, clang-tidy, IWYU header insertion, detailed completion style, UTF-16 offset encoding capability. |
| CMake | `Civitasv/cmake-tools.nvim` | `lua/plugins/tools-cmake.lua` — build dir `build/`, exports `compile_commands.json`, DAP configuration wired to `codelldb`. |
| Embedded/Cortex-M debugging | `nvim-dap-cortex-debug` (OpenOCD) | `lua/plugins/tools-dap-cortex.lua` — preconfigured launch targets for ESP32 (`xtensa-esp32-elf` toolchain) and generic ARM Cortex-M, shared between `c` and `cpp` DAP configurations. |
| LazyVim extras | `lang.clangd`, `lang.cmake`, `dap.core`, `dap.nlua` | `lazyvim.json`. |

## 4. Python (secondary)

| Concern | Tool | Config |
|---|---|---|
| LSP | `pyright` | `lua/plugins/lsp-python.lua` — workspace-wide diagnostics, basic type checking, plus a custom `<leader>ci` keymap scoped to the `pyright` client that runs the `source.addMissingImports` code action. |
| Formatting | `ruff_format`, `ruff_organize_imports` | `lua/plugins/tools-formatting.lua`. |
| Linting (bootstrap-installed) | `flake8`, `shellcheck` | Installed via Mason (`tools-mason.lua`) and pre-installed by `scripts/install.sh`, but not currently wired to a linter plugin — likely intended for `none-ls`/LazyVim's `lsp.none-ls` extra (enabled in `lazyvim.json`) to pick up automatically. |
| LazyVim extra | `lang.python` | `lazyvim.json`. |

## 5. Lua (config language itself)

| Concern | Tool | Config |
|---|---|---|
| Formatting | `stylua` | 2-space indent, 120-col width — `stylua.toml`, wired into `conform.nvim` in `tools-formatting.lua`. |
| LSP awareness | `neodev`/`neoconf` | `.neoconf.json` enables `neodev` library completion (for Neovim API + plugin types) and `lua_ls` via `neoconf`. |

## Editor/UI layer (stack-agnostic)

Not a "target workload" but relevant context: `snacks.nvim` (dashboard, file explorer, picker, terminal — `editor-snacks.lua`), `telescope.nvim` (secondary picker, `editor-telescope.lua`), `noice.nvim` (LSP UI/cmdline — `ui-noice.lua`), and two custom colorschemes (`sentry-blu` default, `sentry-red`) under `lua/themes/` and `colors/`.

## Summary table

| Stack | LSP | Formatter | Debugger | Build-tool integration | Status |
|---|---|---|---|---|---|
| Java (Spring Boot) | ✅ jdtls | ✅ google-java-format | ✅ java-debug-adapter | ✅ Maven (hand-rolled) | Fully wired |
| Kotlin (Spring Boot) | ✅ kotlin-language-server (JDK21-pinned) | ✅ ktlint | ✅ kotlin-debug-adapter | ✅ Gradle (hand-rolled) | Fully wired |
| CloudFormation | ⚠️ generic yamlls only | ❌ none | ❌ n/a | ❌ n/a | Snippet only |
| Terraform | ❌ none | ❌ none | ❌ n/a | ❌ n/a | **Not configured** |
| Ansible | ⚠️ generic yamlls only | ❌ none | ❌ n/a | ❌ n/a | **Not configured** |
| C/C++ | ✅ clangd | ⚠️ LazyVim default | ✅ codelldb + cortex-debug | ✅ CMake | Fully wired |
| Python | ✅ pyright | ✅ ruff | ⚠️ LazyVim default (debugpy) | n/a | Fully wired |
