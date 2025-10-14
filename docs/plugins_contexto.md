# Contexto de Plugins do TurasVim

Este guia descreve como os principais plugins e ajustes personalizados desta configuração LazyVim trabalham em conjunto. Use-o como referência rápida ao revisar ou estender a configuração.

## Carregamento e Estrutura
- `lua/config/lazy.lua` garante a presença do `lazy.nvim` (ramo `stable`), adiciona-o ao runtime path e importa tanto os plugins padrões do LazyVim quanto os módulos locais.
- Os specs locais estão organizados em `lua/plugins/<domínio>`. Cada arquivo retorna uma tabela de specs segmentada por tema (AI, editor, linguagens, LSP, ferramentas, UI), importada por `lua/plugins/init.lua`.
- As opções adicionais de runtime ficam em `lua/config/options/`, atualmente focadas em autodetectar tipos Terraform/HCL (`terraform_discover.lua`).

## AI
- **ChatGPT.nvim** (`lua/plugins/ai/chatgpt.lua`)
  - Lê a chave via `OPENAI_API_KEY` (`api_key_cmd = "echo $OPENAI_API_KEY"`).
  - Ajusta o modelo para `gpt-4o-mini` com limite de 800 tokens por resposta.
  - Integração com `which-key` cria o grupo `<leader>a` e o atalho `<leader>ac` para abrir o chat em modo normal.

## Ferramentas de Edição
- **nvim-cmp** (`lua/plugins/editor/completion.lua`)
  - Remove a fonte `emoji` da lista de completions, evitando ruído em ambientes de código.
- **Telescope** (`lua/plugins/editor/telescope.lua`)
  - Força layout horizontal, prompt no topo e ordenação ascendente.
  - Define `winblend = 0` para preservar contraste.
  - Acrescenta `<leader>fp` para buscar arquivos dentro do diretório raíz do Lazy (plugins instalados).
- **remote-sshfs.nvim** (`lua/plugins/editor/remote-sshfs.lua`)
  - Garante diretório `~/remotes` e monta conexões com opções extras (`allow_other`, `reconnect`, cache).
  - Carrega extensão Telescope se disponível, expondo seleção interativa de hosts.
  - Mapeia `<leader>rm` para conectar via Telescope e `<leader>ru` para desmontar (fallback para comando `RemoteSSHFSDisconnect`).

## Suporte a Linguagens
- **JSON** (`lua/plugins/lang/json.lua`)
  - Habilita o extra oficial do LazyVim para suporte expandido a JSON.
- **Java** (`lua/plugins/lang/java.lua`)
  - Detecta `jdtls` via Mason ou variáveis `JDTLS_HOME`/`JDTLS_CONFIG_DIR` e prepara o comando de arranque.
  - Coleta bundles do `java-debug-adapter` e `java-test` automaticamente; aceita caminhos extra em `JDTLS_BUNDLES`.
  - Integra capacidades do `cmp_nvim_lsp`, ativa DAP (`jdtls.dap`) e registra keymaps `<leader>j…` para organização de imports, extração de código, testes e depuração.
  - Reinicia o cliente LSP se os bundles mudarem para garantir sincronização.
- **Maven** (`lua/plugins/lang/maven.lua`)
  - Executa `mvn`/`./mvnw` via `vim.system`, trabalhando no diretório raiz detectado (busca `pom.xml`, `.mvn`, wrappers).
  - Notifica início e término; abre o quickfix automaticamente com o log se o comando falhar.
  - Oferece seletores interativos para metas do ciclo de vida, perfis, comandos customizados e execução `spring-boot:run`, com atalhos agrupados em `<leader>m`.

## LSP
- **clangd** (`lua/plugins/lsp/clangd.lua`)
  - Ajusta `offsetEncoding` para `utf-16`, prevenindo avisos em servidores clangd mais recentes.
- **pyright** (`lua/plugins/lsp/python.lua`)
  - Prioriza `VIRTUAL_ENV` atual; se ausente, procura `.venv` no workspace.
  - Regride para `python3` ou `python` via `exepath` se nenhum virtualenv for encontrado.
  - Atualiza `defaultInterpreterPath`, `venvPath` e `venv` nas `settings.python` enviadas ao servidor.
  - Adiciona atalho `<leader>ci` para aplicar automaticamente code actions de importação ausente (`source.addMissingImports`).

## Ferramentas Auxiliares
- **Mason** (`lua/plugins/tools/mason.lua`)
  - Garante a instalação de `stylua`, `shellcheck`, `shfmt`, `flake8`, `pyright`, `ruff`, `debugpy`, além do stack Java (`jdtls`, `java-debug-adapter`, `java-test`, `google-java-format`).
  - Pede explicitamente `pyright` e `jdtls` no `mason-lspconfig` para provisionamento automático dos servidores LSP.
- **LazyGit** (`lua/plugins/tools/lazygit.lua`)
  - Mantém comandos `:LazyGit*` carregados sob demanda.
  - Move o atalho para `<leader>Lg`, preservando o `<leader>l` padrão do Lazy e desativando `<leader>gg`.
- **LazyDocker via toggleterm** (`lua/plugins/tools/lazydocker.lua`)
  - Reutiliza toggleterm e inicializa o terminal `lazydocker` com toggle em `<leader>Ld`.
  - Insere mapeamento `<Esc>` em modo terminal para facilitar o retorno ao modo normal.

## Interface & UX
- **Dashboard** (`lua/plugins/ui/dashboard.lua`)
  - Usa `alpha-nvim` com banner ASCII “TurasVim”, botões para ações frequentes (Lazy, ChatGPT, sessão, etc.) e rodapé que exibe versão do TurasVim (tag Git), versão do Neovim, hash curto e data atual.
  - Fecha a janela `lazy` automaticamente se o dashboard abrir primeiro, reabrindo o Lazy após `AlphaReady` quando apropriado.
- **Tema OneDark** (`lua/plugins/ui/theme.lua`)
  - Define `onedark` como colorscheme padrão do LazyVim.
  - Configura `navarasu/onedark.nvim` com estilo `darker`, transparência global e cores de terminal habilitadas, carregando o tema na inicialização.

## Fluxo de Bootstrap e Manutenção
- **Installer** (`scripts/install.sh`)
  - Detecta `apt`, `pacman` ou `dnf` e instala dependências do sistema (git, curl/wget, ripgrep, fd, toolchains, openssh, lazygit/lazydocker, etc.).
  - Baixa Neovim >= 0.11.4, instala `stylua` via cargo e clona este repositório em `~/.config/nvim`.
  - Finaliza com `nvim --headless "+Lazy sync | Lazy check" +qa` para sincronizar plugins.
- **Verificações sugeridas**
  - Atualizar plugins: `nvim --headless "+Lazy sync | Lazy check" +qa`.
  - Atualizar ferramentas externas: `nvim --headless "+MasonUpdate" +qa`.
  - Dentro do Neovim, checar `:checkhealth`, `:Mason` e testar keymaps específicos (por exemplo `<leader>rm`, `<leader>ci`, `<leader>jo`).

## Referências Complementares
- Use `docs/config_overview.md` para um resumo de alto nível da arquitetura.
- Consulte `docs/dependencies.md` para instruções detalhadas de pacotes necessários por distro.
