# Visão Geral do TurasVim

Este documento resume a configuração Neovim deste repositório para ajudar na navegação rápida e na compreensão dos principais componentes.

## Estrutura do Projeto
- `init.lua` ajusta o `PATH` para incluir binários locais e inicializa LazyVim através de `config.lazy`.
- `lua/config/` concentra opções, autocmds e keymaps adicionais. O módulo `options/terraform_discover.lua` amplia a detecção de filetype para Terraform/HCL.
- `lua/plugins/` agrupa especificações por domínio (AI, editor, linguagens, LSP, ferramentas, UI), importadas por `lua/plugins/init.lua`.
- `docs/` armazena documentação complementar; `scripts/install.sh` é o bootstrap oficial.

## Fluxo de Inicialização
1. `config.lazy` garante a presença de `lazy.nvim` (ramo `stable`) e o adiciona ao runtime path.
2. LazyVim e os plugins locais são carregados, com `lazy = false` para specs próprias e um verificador periódico de updates.
3. Plugins RTP redundantes (ex.: `gzip`, `tarPlugin`) são desativados para reduzir o tempo de carregamento.

## Destaques de Configuração
- Opções adicionais de filetype para Terraform/HCL (`lua/config/options/terraform_discover.lua`).
- Keymaps e autocmds permanecem delegados aos padrões LazyVim, prontos para extensões futuras.
- Ambiente `PATH` inclui `~/.cargo/bin` e `~/.local/bin`, permitindo que binaries instalados pelo usuário sejam encontrados pelo Neovim.

## Plugins em Foco
### AI
- `jackMort/ChatGPT.nvim` (`lua/plugins/ai/chatgpt.lua`): usa `gpt-4o-mini`, leitura da chave via `OPENAI_API_KEY` e atalhos which-key em `<leader>a`.

### Ferramentas de Edição
- `remote-sshfs.nvim` monta conexões em `~/remotes`, carrega extensão Telescope e oferece atalhos `<leader>rm`/`<leader>ru` para conectar/desmontar.
- Ajustes no `telescope.nvim` priorizam layout horizontal, prompt no topo e mapeamento `<leader>fp` para procurar arquivos dentro do diretório de plugins Lazy.

### Suporte a Linguagens
- Java (`lua/plugins/lang/java.lua`): integra `nvim-jdtls` com descoberta de `JAVA_HOME/JDTLS_HOME`, bundles de debug/teste via Mason e keymaps `<leader>j…` para operações de linguagem e DAP.
- Maven (`lua/plugins/lang/maven.lua`): terminal flutuante com `toggleterm`, seleção interativa de goals/perfis e atalhos `<leader>m…`.
- Python (`lua/plugins/lsp/python.lua`): detecção automática de virtualenv (`$VIRTUAL_ENV` ou `.venv`), configuração do Pyright e code action para importar dependências ausentes.
- Clangd (`lua/plugins/lsp/clangd.lua`): ajusta `offsetEncoding` para `utf-16`, evitando warnings em servidores baseados em clangd.

### Ferramentas Auxiliares
- Mason garante instalação de formatadores/linters essenciais (stylua, shellcheck, ruff) e toolchain Java (jdtls, debug/test, google-java-format).
- Integrações opcionais com LazyGit/LazyDocker via `toggleterm` e atalhos dedicados.

## Interface & UX
- Dashboard personalizado com `alpha-nvim` (`lua/plugins/ui/dashboard.lua`): banner “TurasVim”, atalhos para ações frequentes, rodapé com versão Git/Neovim e data atual.
- Tema `OneDark` transparente (`lua/plugins/ui/theme.lua`), carregado via `navarasu/onedark.nvim` com ajuste `style = "darker"`, transparência para janelas laterais e integração com o Lualine.

## Fluxo de Desenvolvimento
- `scripts/install.sh` instala dependências de sistema (apt/pacman/dnf), baixa Neovim (>= 0.11.4), garante `cargo`/`stylua`, clona este repo e executa `nvim --headless "+Lazy sync | Lazy check" +qa` no final.
- `docs/dependencies.md` lista pacotes obrigatórios (git/curl, ripgrep/fd, toolchain, sshfs, lazygit/lazydocker) e orienta verificações pós-instalação.

## Recomendações de Verificação
- Sincronizar e validar specs: `nvim --headless "+Lazy sync | Lazy check" +qa`.
- Atualizar ferramentas Mason: `nvim --headless "+MasonUpdate" +qa`.
- Dentro do Neovim, rodar `:checkhealth` e `:Mason` para confirmar dependências em novos ambientes.
