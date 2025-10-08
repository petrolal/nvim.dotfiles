# TurasVim Context

## Purpose
LazyVim-based Neovim setup branded TurasVim. Prioritizes remote development helpers and AI-assisted editing while keeping most upstream defaults intact.

## Layout Notes
- `init.lua` amends `$PATH` for Cargo and local bins before delegating bootstrap to `lua/config/lazy.lua`.
- `lua/config/` holds lightweight stubs (`options.lua`, `keymaps.lua`, `autocmds.lua`) so core overrides remain discoverable.
- Topic-focused plugin specs live under `lua/plugins/` (`ai`, `editor`, `lang`, `lsp`, `tools`, `ui`), with `lua/plugins/init.lua` importing each subtree.
- Remote helpers live in `lua/remotes/manager.lua`; bundled `distant-*` binaries ship under `remotes/bin/` and are surfaced through custom commands.
- Repo metadata: `AGENTS.md` (contributor guide), `lazy-lock.json` (plugin pins), `stylua.toml` (formatting), `lazyvim.json` (upstream extras manifest), `chatgpt_code_actions.json` (command palette presets).

## Plugin Inventory & Roles
- **AI**: `jackMort/ChatGPT.nvim` (`lua/plugins/ai/chatgpt.lua`) reads `$OPENAI_API_KEY`, registers `<leader>a` group for chat actions.
- **Completion**: `hrsh7th/nvim-cmp` override (`lua/plugins/editor/completion.lua`) drops the `emoji` source.
- **Finder**: `nvim-telescope/telescope.nvim` (`lua/plugins/editor/telescope.lua`) bundles `chipsenkbeil/distant.nvim`, adds remote menu shortcuts `<leader>sr`/`<leader>sa`, e registra `require("remotes.manager").setup()`.
- **Languages**: Lazy extras para JSON (`lua/plugins/lang/json.lua`); ajustes de LSP para Pyright e Clangd (`lua/plugins/lsp/python.lua`, `lua/plugins/lsp/clangd.lua`).
- **Tooling**: Mason garante Stylua, linters de shell, analisadores Python e `debugpy` (`lua/plugins/tools/mason.lua`); LazyGit em `<leader>lg` (`lua/plugins/tools/lazygit.lua`); LazyDocker em terminal flutuante ToggleTerm `<leader>lo` (`lua/plugins/tools/lazydocker.lua`).
- **UI**: Tokyo Night transparente (`lua/plugins/ui/theme.lua`); dashboard Alpha com arte ASCII, atalhos de remote e info de git/build (`lua/plugins/ui/dashboard.lua`).

## Distant Integration
- Dependência declarada em `lua/plugins/editor/telescope.lua` carrega `chipsenkbeil/distant.nvim` e chama `require("remotes.manager").setup()`.
- `lua/remotes/manager.lua` gerencia senhas, instalação remota, cache de hosts (`stdpath('data')/distant_remotes.json`) e spinner/notify customizados.
- `ensure_remote_and_then()` verifica se o remoto possui `distant`; se não, exige `sshpass`, envia o binário de `remotes/bin/` via `scp` e instala em `/usr/local/bin` ou `$HOME/.local/bin` executando `remote_install_script()`.
- `launch_distant()` ajusta `DISTANT_MANAGER` para o socket padrão 0.20.x, força lazy-load de `distant.nvim` se necessário e tenta `:DistantLaunch ssh://host` com fallback para `require("distant").setup({ manager = { log_level = "trace" } })`.
- Comandos expostos: `:DistantSmartConnect host` (verifica/instala e conecta), `:RemoteAdd`, `:RemoteMenu`; o picker do menu permite conectar (`<CR>`), adicionar (`a`/`<C-a>`), remover (`d`/`<C-d>`) e renomear (`r`/`<C-r>`) entradas.
- Dependências externas: `sshpass` local para uploads autenticados; `plenary.nvim` para I/O; bunded `distant-*` bins escolhidos por `local_distant_path()`.

## Configuration Highlights
- `lua/config/lazy.lua` clona `lazy.nvim` se ausente, importa LazyVim + specs locais, habilita checagem automática de updates e remove plugins RTP herdados.
- Pyright detecta virtualenvs, ajusta `defaultInterpreterPath` e oferece `<leader>ci` para imports ausentes; Clangd expõe `utf-16` offset encoding.
- ToggleTerm cria terminal flutuante persistente para LazyDocker, ajustando `<Esc>` em modo terminal para sair de insert.
- Remote manager suporta feedback assíncrono via spinners e integra-se ao dashboard Alpha e atalhos Telescope.

## Workflows
- Plugin sync: `nvim --headless "+Lazy sync" +qa`; verificação: `nvim --headless "+Lazy check" +qa`.
- Formatação: `stylua lua` (indentação 2 espaços, 120 colunas).
- Remote commands: `:RemoteMenu` e `:RemoteAdd` para gerenciar hosts antes de `:DistantSmartConnect` ou `:RemoteMenu` + `<CR>`.
- Branches limpos: sempre criar branch nova, manter mudanças no `lazy-lock.json` intencionais e registrar checks headless em PRs.

## Agent Cautions
- Não edite binários em `remotes/` salvo atualização planejada.
- Preserve descrições/labels em português (atalhos Dashboard, keymaps).
- Ao tocar specs compartilhados (ex. `lua/plugins/lsp`), cruze com extras listados em `lazyvim.json` para evitar conflitos.
