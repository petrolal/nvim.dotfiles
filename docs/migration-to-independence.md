# BMAD Specification: Migration to LazyVim Independence

**Document ID:** `DOC-002-INDEPENDENCE`  
**Status:** Planning / Execution  
**Target:** Transition from LazyVim layer to a zero-framework, standalone Neovim distribution.

---

## 1. Executive Summary & Objective

The goal of this migration is to decouple our Neovim distribution from LazyVim's high-level abstractions (`LazyVim.config`, `LazyVim.util`, implicit defaults). By taking direct control over core configuration, plugin specification, LSP orchestration, and UI, we achieve:

- **Complete Stability:** Zero breaking changes from upstream LazyVim framework updates.
- **Performance Optimization:** Direct Lua calls instead of LazyVim wrapper layers.
- **Full Architecture Ownership:** Unambiguous BMAD module definitions where every line of code is explicitly owned.

---

## 2. Architecture Comparison Matrix

| Subsystem | Current (LazyVim Abstraction) | Independent Target Architecture |
| :--- | :--- | :--- |
| **Bootstrapper** | `LazyVim.config.init` + `lazy.nvim` | Pure `lazy.nvim` setup |
| **Options/Keys** | LazyVim default overlays | `lua/config/options.lua` & `lua/config/keymaps.lua` |
| **LSP Management** | `LazyVim.lsp` / `lazyvim.plugins.lsp` | Direct `nvim-lspconfig` + `mason-lspconfig` |
| **Formatting** | `LazyVim.format` wrapper | Native `conform.nvim` (`BufWritePre` hook) |
| **Completion** | LazyVim pre-configured `nvim-cmp` / `blink.cmp` | Explicit `nvim-cmp` or `blink.cmp` module |
| **Utility API** | `LazyVim.*` helper functions | Native Neovim Lua API (`vim.api.*`, `vim.uv.*`) |

---

## 3. Migration Phasing & Module Breakdown

### Phase 1: Audit & Abstraction Inventory (Breakdown)

- [ ] Catalog all active plugins (`:Lazy`) and mark LazyVim-managed plugins.
- [ ] Scan codebase for `LazyVim.` calls using rip-grep:

  ```bash
  rg "LazyVim\." lua/
  ```

- [ ] Audit custom overrides in `lua/plugins/*.lua` to identify implicit LazyVim dependencies.

---

### Phase 2: Core Infrastructure Decoupling (Architecture)

Replace LazyVim bootstrapper entrypoints with native Lua initialization.

#### Target: `lua/config/lazy.lua`

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Load all BMAD plugin modules
  },
  defaults = { lazy = true },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "matchit", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
```

---

### Phase 3: Module Migration (Module Standard)

Migrate sub-systems in order of precedence:

#### Step 3.1: LSP & Mason (`lua/plugins/lsp.lua`)

- Replace `LazyVim.lsp` setup with explicit `LspAttach` autocmd.
- Configure `nvim-lspconfig` and `mason-lspconfig` manually.

#### Step 3.2: Formatting & Linting (`lua/plugins/formatting.lua`)

- Configure `conform.nvim` explicitly:

  ```lua
  return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
  }
  ```

#### Step 3.3: UI & Navigation (`lua/plugins/ui.lua`, `lua/plugins/telescope.lua`)

- Explicitly declare `lualine.nvim`, `bufferline.nvim`, and your picker (`telescope` or `fzf-lua`) without relying on LazyVim color/layout defaults.

---

### Phase 4: API Cleanup & Verification (Documentation)

Replace all legacy LazyVim calls with standard Neovim / Lua idioms:

| Remove (LazyVim API) | Replace With (Native API) |
| :--- | :--- |
| `LazyVim.has("plugin.nvim")` | `pcall(require, "plugin")` or `Lazy` spec status |
| `LazyVim.lsp.on_attach(...)` | `vim.api.nvim_create_autocmd("LspAttach", ...)` |
| `LazyVim.opts("plugin")` | Standard plugin `opts` / `config` functions |
| `LazyVim.info(...)` | `vim.notify(..., vim.log.levels.INFO)` |

---

## 4. Verification Checklist

Before declaring independence complete, ensure:

- [ ] Zero errors on startup with a clean `nvim` launch.
- [ ] `:checkhealth` reports no missing dependencies or broken hooks.
- [ ] LSP completion, diagnostics, hover (`K`), and code actions (`<leader>ca`) function cleanly.
- [ ] Format on save works across all target languages.
- [ ] All custom keymaps in `lua/config/keymaps.lua` remain active and non-conflicting.
