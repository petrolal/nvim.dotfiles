---
stepsCompleted: [1, 2]
inputDocuments: []
workflowType: 'research'
lastStep: 2
research_type: 'technical'
research_topic: 'Neovim post-LazyVim architecture with Java/Kotlin/Spring Boot and cloud tooling'
research_goals: 'Design a hand-rolled, distro-free Neovim config to replace LazyVim, driven by full control (no upstream churn), startup performance, and simplicity/understandability. Migration follows a gradual strangler-fig path (replace LazyVim defaults incrementally in-place, drop the LazyVim import last). Scope covers plugin manager choice, LSP/DAP/formatter wiring without LazyVim opts-merging, config module architecture patterns, a feature-parity/migration-risk audit, and ensuring Java/Kotlin/Spring Boot + cloud tooling support survives the move.'
user_name: 'Petrolal'
date: '2026-08-02'
web_research_enabled: true
source_verification: true
---

# Research Report: technical

**Date:** 2026-08-02
**Author:** Petrolal
**Research Type:** technical

---

## Research Overview

[Research overview and methodology will be appended here]

---

## Technical Research Scope Confirmation

**Research Topic:** Neovim post-LazyVim architecture with Java/Kotlin/Spring Boot and cloud tooling
**Research Goals:** Design a hand-rolled, distro-free Neovim config to replace LazyVim, driven by full control (no upstream churn), startup performance, and simplicity/understandability. Migration follows a gradual strangler-fig path (replace LazyVim defaults incrementally in-place, drop the LazyVim import last). Scope covers plugin manager choice, LSP/DAP/formatter wiring without LazyVim opts-merging, config module architecture patterns, a feature-parity/migration-risk audit, and ensuring Java/Kotlin/Spring Boot + cloud tooling support survives the move.

**Technical Research Scope:**

- Architecture Analysis - design patterns, frameworks, system architecture
- Implementation Approaches - development methodologies, coding patterns
- Technology Stack - languages, frameworks, tools, platforms
- Integration Patterns - APIs, protocols, interoperability
- Performance Considerations - scalability, optimization, patterns

**Research Methodology:**

- Current web data with rigorous source verification
- Multi-source validation for critical technical claims
- Confidence level framework for uncertain information
- Comprehensive technical coverage with architecture-specific insights

**Scope Confirmed:** 2026-08-02

---

## Technology Stack Analysis

### Configuration & Plugin-Manager Languages

_Config Language:_ Lua is the only realistic choice for a hand-rolled config in 2026 — it is a real programming language with modules, error handling (`pcall`), and data structures, and is what Neovim's own APIs (`vim.lsp`, `vim.diagnostic`, `vim.pack`) are built around. VimScript survives only for legacy plugin compatibility shims.
_Target Languages (this repo):_ Java and Kotlin remain the dominant JVM languages the config must serve, both via Gradle/Maven builds, with Spring Boot as the primary framework target.
_Source: https://m4xshen.dev/posts/build-your-modern-neovim-config-in-lua_

### Plugin Manager Landscape

_lazy.nvim (current):_ Ships a purpose-built DSL for lazy loading and dependency resolution; a typical LazyVim-style setup benchmarks around **94ms** startup with ~30 plugins loaded, largely because of deferred/event-based loading.
_vim.pack (native, shipped in Neovim 0.12):_ Built into Neovim core as of v0.12, git-based, zero third-party dependencies, config stored in `nvim-pack-lock.json`, managed via `vim.pack.add()` and `:Pack install/update`. **It has no built-in lazy-loading machinery** — timing/deferred loading has to be hand-wired (e.g. via autocmds/`vim.schedule`), which is exactly the kind of code a "leave LazyVim" migration would need to own.
_mini.deps:_ Originally designed as a candidate for Neovim's own built-in manager; comparable minimalist philosophy to vim.pack but still a third-party dependency — largely superseded in relevance now that vim.pack exists natively.
_Startup delta:_ Minimal hand-rolled configs (whether on lazy.nvim configured minimally, or vim.pack) report **13–45ms** startup vs LazyVim's ~94ms — roughly a 2–7x improvement, at the cost of losing LazyVim's pre-built lazy-loading and default plugin curation.
_Source: https://fredrikaverpil.github.io/blog/2026/04/15/from-lazy.nvim-to-vim.pack/, https://samuellawrentz.com/blog/neovim-vim-pack-vs-lazy-nvim/, https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack, https://aliquote.org/post/speed-up-neovim/_

### LSP / DAP / Formatter Frameworks (replacing LazyVim's opts-merge layer)

_Native LSP (`vim.lsp.config` / `vim.lsp.enable`):_ As of Neovim 0.11, LSP servers can be configured **100% independently of nvim-lspconfig**. Neovim auto-discovers `lsp/*.lua` files on the runtimepath — `vim.lsp.enable('jdtls')` looks for `lsp/jdtls.lua` (conventionally under `~/.config/nvim/lsp/` or `after/lsp/`) and merges it automatically; no plugin, no LazyVim `opts` table needed. This directly replaces what `lua/plugins/lsp-*.lua` currently does through LazyVim's `nvim-lspconfig` `opts.servers` merge convention.
_DAP:_ `nvim-dap` + `mason-nvim-dap.nvim` remain the standard, framework-agnostic — they were never LazyVim-specific, so this repo's `tools-dap-*.lua` files port with minimal change (drop the `opts` table shape, call `require("dap")` config directly, same as today).
_Formatters:_ `conform.nvim` is framework-agnostic too; the LazyVim-specific part is only the `opts.formatters_by_ft` merge — calling `require("conform").setup({ formatters_by_ft = {...} })` directly replaces it 1:1.
_Mason glue:_ Load order matters regardless of distro: `mason.nvim` → `mason-lspconfig`/manual `vim.lsp.enable` → `conform.nvim`/`mason-nvim-dap`. Bridge plugins (`mason-bridge.nvim`, `mason-conform`) exist to auto-register installed tools into conform/dap without hand-written tables, which could reduce the amount of glue code this repo needs to hand-roll.
_Source: https://lugh.ch/switching-to-neovim-native-lsp.html, https://0xunicorn.com/neovim-native-lsp-config/, https://github.com/jay-babu/mason-nvim-dap.nvim, https://github.com/mason-org/mason.nvim_

### State, Caching & Local Storage

Not a traditional "database" concern, but the equivalent for an editor config: Mason's package registry cache, jdtls's per-project workspace/index cache, `kotlin-language-server`'s JVM-side caches, and Neovim's own `shada`/session files. None of this is LazyVim-coupled — it lives under `stdpath("data")`/`stdpath("state")` regardless of plugin manager, so it carries over unchanged in a migration. Worth auditing only if startup-time profiling later points to cold-cache LSP indexing as a bottleneck.

### Java / Kotlin / Spring Boot Toolchain

_Java:_ `nvim-jdtls` (already used in this repo) remains the standard for jdtls integration; `nvim-java` is a higher-level alternative but is explicitly **mutually exclusive** with `nvim-jdtls` — cannot run both. Given this repo already has a working, hand-tuned `lua/plugins/lsp-java.lua` (Lombok agent injection), staying on `nvim-jdtls` is the lower-risk path.
_Kotlin:_ `kotlin-language-server` remains the backbone; this repo's existing JDK-21 pin workaround (`lua/plugins/lsp-kotlin.lua`) is a `JAVA_HOME`-level fix, independent of LazyVim, and ports as-is.
_Spring Boot:_ Two community plugins target this specifically — `springboot-nvim` (project scaffolding via start.spring.io, class/interface/enum generation) and `spring-boot.nvim` (depends on `nvim-jdtls`, can use Mason or the VSCode Spring Boot extension's language server). Neither is currently in this repo's plugin set; both are candidates to evaluate during the migration since they add IDE-grade Spring Boot support (project init, boilerplate generation) that raw jdtls does not provide.
_Source: https://github.com/elmcgill/springboot-nvim, https://github.com/JavaHello/spring-boot.nvim, https://sngeth.com/kotlin/2024/11/17/spring-boot-kotlin/_

### Cloud Infrastructure & Deployment Tooling

_DevOps-focused plugins:_ `devops-tools.nvim` bundles Docker, Helm, Terraform, and kubectl integration in one plugin. More specialized alternatives exist per-tool: `kubectl.nvim` (cluster inspection/management — pods, deployments, services — from inside Neovim), `terraform.nvim` (state inspection with a Telescope-backed resource browser, plus format/validate). None of these are LazyVim-specific; they're plain plugin specs and port unchanged. This is new territory for the current config (no cloud tooling exists yet in `lua/plugins/`), so this is additive scope rather than a migration risk.
_Source: https://github.com/azratul/devops-tools.nvim, https://github.com/Ramilito/kubectl.nvim, https://github.com/dakota-m/terraform.nvim_

### Technology Adoption Trends

_Native LSP over nvim-lspconfig:_ The clear 2026 trend is Neovim absorbing what plugins used to provide — `vim.lsp.config`/`vim.lsp.enable` (0.11) and `vim.pack` (0.12) both reduce the argument for pulling in nvim-lspconfig or a third-party plugin manager purely for LSP server setup.
_Distro vs hand-rolled tradeoff is explicit, not hidden:_ Multiple 2026 sources frame the vim.pack/lazy.nvim choice explicitly as "simplicity + zero deps" vs "lazy-loading + curation," matching this repo's stated goals (control, performance, understandability) squarely toward the hand-rolled/native side, accepting that lazy-loading orchestration becomes this repo's own responsibility.
_Mutual exclusivity and glue-plugin risk:_ Bridge/glue plugins (mason-bridge, nvim-java vs nvim-jdtls) show the ecosystem still has sharp edges around "pick one path, don't mix" — a real migration-risk item to carry into the feature-parity audit.
_Source: https://lugh.ch/switching-to-neovim-native-lsp.html, https://fredrikaverpil.github.io/blog/2026/04/15/from-lazy.nvim-to-vim.pack/_

---

<!-- Content will be appended sequentially through research workflow steps -->
