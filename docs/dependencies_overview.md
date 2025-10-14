# Dependências do TurasVim

Este arquivo consolida todas as dependências necessárias para executar esta configuração com recursos completos (LSP, DAP, IA, SSHFS, Maven etc.). Use junto com os scripts e instruções existentes para preparar novos ambientes.

## Versão do Neovim
- Neovim `v0.11.4` ou superior (`scripts/install.sh:5`); o instalador baixa esse release se ausente.

## Pacotes de Sistema
Instale antes de abrir o Neovim. Comandos de exemplo:

- **Ferramentas básicas**: `git`, `curl`/`wget`, `tar`, `unzip` (`scripts/install.sh:45`, `docs/dependencies.md:6`–`19`).
- **Busca**: `ripgrep`, `fd` ou `fd-find` (`docs/dependencies.md:14`–`19`).
- **Toolchain**: `build-essential` (Debian), `base-devel` (Arch) ou grupo `Development Tools` (Fedora) para compilar plugins nativos (`docs/dependencies.md:20`–`24`).
- **Hosts de linguagem**: `python3`, `python3-pip`, `nodejs`, `npm`, `cargo` (Rust) (`scripts/install.sh:45`–`66`, `docs/dependencies.md:26`–`30`).
- **Ferramentas remotas**: `openssh-client`, `sshfs`, `sshpass` (Debian), `openssh`, `sshfs` (Arch), `openssh-clients`, `fuse-sshfs` (Fedora). Habilite `user_allow_other` em `/etc/fuse.conf` para permitir montagens SSHFS com `allow_other` (`docs/dependencies.md:31`–`37`).
- **Integrações opcionais**: `lazygit`, `lazydocker` (instalador trata via pacote ou `go install`, `scripts/install.sh:48`–`75`, `docs/dependencies.md:38`–`41`).

## Ferramentas via Cargo
- `stylua` (formatador Lua) instalado com `cargo install stylua --locked`; requer Rust ativo (`scripts/install.sh:114`–`128`, `docs/dependencies.md:43`–`47`).

## Ferramentas Gerenciadas pelo Mason
Configuradas em `lua/plugins/tools/mason.lua`:
- Formatadores/linters: `stylua`, `shellcheck`, `shfmt`, `flake8`, `ruff`.
- LSP/Debug: `pyright`, `jdtls`, `java-debug-adapter`, `java-test`, `debugpy`.
- Formatador Java: `google-java-format`.
- `mason-lspconfig` garante `pyright` e `jdtls` instalados automaticamente (`lua/plugins/tools/mason.lua:5`–`28`).

## Requisitos Específicos por Linguagem
- **Java**: JDK configurado (`JAVA_HOME`) para rodar o `java` binário; opcionalmente `JDTLS_HOME`/`JDTLS_CONFIG_DIR` para apontar manualmente o language server. Mason cobre `jdtls`, `java-debug-adapter`, `java-test`, `google-java-format` (`lua/plugins/lang/java.lua:152`–`239`).
- **Python**: intérprete detectado via `$VIRTUAL_ENV`, `.venv/`, `python3` ou `python` presentes no `PATH` (`lua/plugins/lsp/python.lua:28`–`86`).

## Integrações Adicionais
- **ChatGPT.nvim**: defina `OPENAI_API_KEY` no ambiente para habilitar o modelo `gpt-4o-mini` (`lua/plugins/ai/chatgpt.lua:10`–`18`).
- **Remote SSHFS**: requer `sshfs`, chaves (padrão `~/.ssh/id_ed25519`) e montagem com `allow_other` (`lua/plugins/editor/remote-sshfs.lua:12`–`46`).
- **LazyGit/LazyDocker**: dependem dos executáveis `lazygit` e `lazydocker` no `PATH` (`lua/plugins/tools/lazygit.lua:3`–`16`, `lua/plugins/tools/lazydocker.lua:10`–`31`).

## Verificação Pós-Instalação
1. Sincronize e valide plugins: `nvim --headless "+Lazy sync | Lazy check" +qa` (`scripts/install.sh:147`–`153`).
2. Atualize ferramentas externas: `nvim --headless "+MasonUpdate" +qa`.
3. Dentro do Neovim: execute `:checkhealth` e `:Mason` para confirmar que todos os providers estão instalados (`docs/dependencies.md:56`–`66`).
4. Testes rápidos por domínio:
   - `<leader>mc` em um projeto Maven para checar `vim.system` e quickfix.
   - `<leader>rm` para validar SSHFS.
   - `:LspInfo` em projetos Java/Python/C++ para confirmar servidores.

Com estes pré-requisitos instalados, o TurasVim inicializa todos os LSPs, DAPs, integrações AI/Maven, ferramentas de formatação e recursos de UI sem pendências adicionais.
