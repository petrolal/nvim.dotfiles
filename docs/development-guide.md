# Development Guide

## Prerequisites

- Neovim **v0.11.4** (pinned in `scripts/install.sh` via `MIN_NEOVIM_VERSION`; override with `NEOVIM_VERSION=x.y.z`)
- `git`, `curl` — bootstrap and plugin cloning
- `ripgrep`, `fd` — used by pickers (snacks/telescope)
- **OpenJDK 21** — hard requirement for the Kotlin LSP JAVA_HOME pin (see [architecture.md](./architecture.md#kotlin-lsp-crashes-on-newer-jdks--java_home-pin)); `install.sh` installs this automatically per distro (`openjdk-21-jdk` / `jdk21-openjdk` / `java-21-openjdk`)
- `cargo` (Rust) — for `stylua`
- `python3`/`pip`, `node`/`npm` — for `ruff`, `pynvim`, and the `neovim` npm package (Neovim Python/Node providers)

## Installation

Automated bootstrap (detects apt/pacman/dnf, installs Neovim + deps, clones this repo, syncs plugins):

```bash
curl -fsSL https://raw.githubusercontent.com/petrolal/nvim.dotfiles/main/scripts/install.sh | bash
```

Pin a different Neovim version:

```bash
curl -fsSL https://raw.githubusercontent.com/petrolal/nvim.dotfiles/main/scripts/install.sh | NEOVIM_VERSION=0.10.2 bash
```

Manual/first-launch follow-up (per `README.md`):

```vim
:checkhealth
:MasonInstall shellcheck shfmt flake8 pyright ruff debugpy
```

## Local development workflow

| Task | Command |
|---|---|
| Format all Lua | `stylua lua` — run before every commit that touches Lua (2-space indent, 120-col width per `stylua.toml`) |
| Validate plugin specs after editing `lua/plugins/` | `nvim --headless "+Lazy sync | Lazy check" +qa` |
| Refresh Mason-installed LSP/DAP/formatter binaries | `nvim --headless "+MasonUpdate" +qa` |
| Install one specific Mason tool | `nvim --headless "+MasonInstall <tool>" +qa` (see `lua/plugins/tools-mason.lua`'s `ensure_installed` for the current baseline list) |
| Full runtime dependency check | `:checkhealth` inside Neovim |

## Testing approach

There is **no unit test suite** — this is a Neovim configuration, not an application with its own logic to unit-test. "Testing" a change means:

1. Run the headless Lazy check above (`Lazy sync | Lazy check`) to confirm every spec loads without syntax/resolution errors.
2. Open Neovim against a real project file for the language you touched, and confirm the affected behavior directly:
   - **Java:** open a `.java` file in a Maven or Gradle project, confirm `jdtls` attaches, Lombok symbols resolve, and `<leader>jm*`/`<leader>jg*` which-key groups appear (only when `pom.xml`/`build.gradle(.kts)` is present)
   - **Kotlin:** open a `.kt` file, confirm `kotlin-language-server` attaches without crashing (JDK version issue) and hover/completion work
   - **Python:** confirm `pyright` diagnostics populate and `<leader>ci` (add missing imports) works
   - **C/C++:** confirm `clangd` attaches and, for CMake projects, `compile_commands.json` is generated under `build/`
   - **Formatting:** save a file in an affected filetype and confirm `conform.nvim` formats on save (ktlint/google-java-format/ruff/stylua per filetype)

## Build process

There is no build step for the config itself. For the languages it supports, builds are delegated to the project's own tooling, surfaced through this repo's keymaps:

- **Maven** — `<leader>jm{c,C,t,p,i,I,v,r,D,d,m}` (clean/compile/test/package/install/clean-install/verify/spring-boot:run/debug/dependency-tree/goal-picker), implemented in `lua/util/maven.lua`
- **Gradle** — `<leader>jg{c,b,t,a,C,B,r,D,j,d,g}` (clean/build/test/assemble/check/clean-build/bootRun/bootRun-debug/bootJar/dependencies/task-picker), implemented in `lua/util/gradle.lua`
- **CMake** — via `cmake-tools.nvim` commands (`lua/plugins/tools-cmake.lua`), build directory `build/`

Both Maven and Gradle wrappers (`mvnw`/`gradlew`) are preferred over a global install when present in the project root.

## Deployment

Not applicable in the traditional sense — this repo's only "deployment" target is a developer's own workstation, via `scripts/install.sh` (see [architecture.md](./architecture.md#deployment--bootstrap-architecture)). There is no CI/CD pipeline (no `.github/workflows/` present).

## Conventions

- Two-space indentation, 120-char line width (`stylua.toml`); no tabs.
- New plugin spec files go under `lua/plugins/<domain>-<topic>.lua`, lowercase snake/kebab-case, prefixed by domain (`editor-`, `lsp-`, `tools-`, `ui-`).
- New non-plugin Lua modules go under `lua/<area>/<topic>.lua` (see `lua/util/`).
- Order plugin-spec tables as: metadata/dependencies → `opts` → `keys`/`commands`.
- Comment only non-obvious logic (workarounds, version-specific gotchas — see the Kotlin/Lombok examples in `architecture.md`); don't restate what LazyVim already does by default.
- Commits follow `<type>: <summary>` (`feature:`, `fix:`, `refactor:`, `docs:`), imperative mood, under ~60 chars, one feature/fix per commit.

## Contribution guidelines

No `CONTRIBUTING.md` exists in this repo at the time of writing. The single listed contributor is Lucas H N A Petrola (Main developer), per `README.md`.
