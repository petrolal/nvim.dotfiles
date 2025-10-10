# TurasVim Context

## Purpose
LazyVim-based Neovim setup branded TurasVim. Prioritizes remote development helpers and AI-assisted editing while keeping most upstream defaults intact.

## Layout Notes
- `init.lua` amends `$PATH` for Cargo and local bins before delegating bootstrap to `lua/config/lazy.lua`.
- `lua/config/` holds lightweight stubs (`options.lua`, `keymaps.lua`, `autocmds.lua`) so core overrides remain discoverable.
- Topic-focused plugin specs live under `lua/plugins/` (`ai`, `editor`, `lang`, `lsp`, `tools`, `ui`), with `lua/plugins/init.lua` importing each subtree.
- Montagens remotas via SSHFS usam `nosduco/remote-sshfs.nvim` (`lua/plugins/editor/remote-sshfs.lua`), armazenando pontos em `~/remotes`.
- Repo metadata: `AGENTS.md` (contributor guide), `lazy-lock.json` (plugin pins), `stylua.toml` (formatting), `lazyvim.json` (upstream extras manifest), `chatgpt_code_actions.json` (command palette presets).

## Plugin Inventory & Roles
- **AI**: `jackMort/ChatGPT.nvim` (`lua/plugins/ai/chatgpt.lua`) reads `$OPENAI_API_KEY`, registers `<leader>a` group for chat actions.
- **Completion**: `hrsh7th/nvim-cmp` override (`lua/plugins/editor/completion.lua`) drops the `emoji` source.
- **Finder**: `nvim-telescope/telescope.nvim` (`lua/plugins/editor/telescope.lua`) adiciona `<leader>fp` para buscar arquivos de plugins dentro do diretório de Lazy.
- **Remote**: `nosduco/remote-sshfs.nvim` (`lua/plugins/editor/remote-sshfs.lua`) monta hosts via SSHFS e expõe UI em `<leader>rm`/`<leader>ru`.
- **Languages**: Lazy extras para JSON (`lua/plugins/lang/json.lua`); ajustes de LSP para Pyright e Clangd (`lua/plugins/lsp/python.lua`, `lua/plugins/lsp/clangd.lua`).
- **Tooling**: Mason garante Stylua, linters de shell, analisadores Python e `debugpy` (`lua/plugins/tools/mason.lua`); LazyGit em `<leader>lg` (`lua/plugins/tools/lazygit.lua`); LazyDocker em terminal flutuante ToggleTerm `<leader>lo` (`lua/plugins/tools/lazydocker.lua`).
- **UI**: Tokyo Night transparente (`lua/plugins/ui/theme.lua`); dashboard Alpha com arte ASCII e atalhos para fluxos locais (`lua/plugins/ui/dashboard.lua`).

## Remote Workflow
- SSHFS monta remotos sob `~/remotes`; conexões padrão podem ser definidas em `vim.g.remote_sshfs_connections`.
- `<leader>rm` abre o seletor `remote-sshfs` (interface Telescope); `<leader>ru` desmonta o host ativo.
- `vim.g.remote_sshfs_opts` permite sobrescrever opções passadas ao `sshfs` (ex.: identidade customizada).

## Configuration Highlights
- `lua/config/lazy.lua` clona `lazy.nvim` se ausente, importa LazyVim + specs locais, habilita checagem automática de updates e remove plugins RTP herdados.
- Pyright detecta virtualenvs, ajusta `defaultInterpreterPath` e oferece `<leader>ci` para imports ausentes; Clangd expõe `utf-16` offset encoding.
- ToggleTerm cria terminal flutuante persistente para LazyDocker, ajustando `<Esc>` em modo terminal para sair de insert.

## Workflows
- Plugin sync: `nvim --headless "+Lazy sync" +qa`; verificação: `nvim --headless "+Lazy check" +qa`.
- Formatação: `stylua lua` (indentação 2 espaços, 120 colunas).
- Remote mounts: `<leader>rm` para abrir o seletor, `<leader>ru` para desmontar o host atual.
- Branches limpos: sempre criar branch nova, manter mudanças no `lazy-lock.json` intencionais e registrar checks headless em PRs.

## Agent Cautions
- Preserve descrições/labels em português (atalhos Dashboard, keymaps).
- Ao tocar specs compartilhados (ex. `lua/plugins/lsp`), cruze com extras listados em `lazyvim.json` para evitar conflitos.

## Keybindings
- `<leader>a` agrupa ações de IA (Which-Key: “Code With AI”); `<leader>ac` abre `:ChatGPT`.
- `<leader>fp` busca arquivos de plugins.
- `<leader>rm` abre o seletor de conexões SSHFS; `<leader>ru` desmonta o SSHFS ativo.
- `<leader>lg` abre LazyGit e substitui o binding padrão `<leader>gg`.
- `<leader>lo` alterna um terminal flutuante com LazyDocker; dentro do terminal `<Esc>` volta ao modo normal.
- `<leader>ci` aplica imports faltantes quando Pyright está anexado ao buffer atual.
- Dashboard Alpha replica atalhos principais (ex.: `a` ChatGPT) para acesso rápido na tela inicial.

## Dependencies
- **Base tooling**: `git`, `curl` ou `wget`, utilitário de compressão (`tar`/`unzip`), `rg` (ripgrep), `fd`.
- **Providers**: `python3`/`pip3`, `node`/`npm`, `cargo`, `make`, `gcc` para compilação de plugins/LSP.
- **Remotos & UX**: `ssh`, `sshfs`/`fusermount`, `lazygit`, `lazydocker`.
- **Formatação/LSP**: `stylua` global ou via Mason; Mason garante `shellcheck`, `shfmt`, `flake8`, `pyright`, `ruff`, `debugpy` sob demanda.
- Todos os itens acima já existem na máquina atual (`command -v` confirmou); ferramentas Mason são instaladas dentro de `~/.local/share/nvim/mason` quando acionadas.
