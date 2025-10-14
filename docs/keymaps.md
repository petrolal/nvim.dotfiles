# Keymaps Personalizadas do TurasVim

Esta referência lista os atalhos adicionais definidos pela configuração local. Os mapeamentos padrão do LazyVim continuam disponíveis; aqui estão apenas os atalhos acrescentados ou ajustados neste repositório.

## Visão Geral
- Todos os atalhos usam `leader = <Space>` (herdado do LazyVim).
- Mapeamentos com escopo de buffer são carregados apenas em arquivos específicos (por exemplo, buffers Java).
- Integrações com o `which-key` exibem grupos de ajuda como `AI`, `Java` ou `Maven` ao pressionar `<leader>`.

## AI
- `<leader>ac` (normal) — Abre a janela do ChatGPT (`ChatGPT.nvim`). Disponível após carregar o plugin; exibido no `which-key` no grupo **Code With AI** (`<leader>a`).

## Ferramentas de Edição
- `<leader>fp` (normal) — `Telescope` para localizar arquivos dentro da árvore de plugins gerenciada pelo Lazy (`lua/plugins/editor/telescope.lua`). Útil para inspeção rápida das specs instaladas.
- `<leader>rm` (normal) — Abre o seletor Telescope de conexões SSHFS e monta o destino (`remote-sshfs.nvim`).
- `<leader>ru` (normal) — Desmonta a conexão ativa via `RemoteSSHFSDisconnect` ou fallback para `remote-sshfs.connections.unmount_host`.
- Os atalhos de SSHFS aparecem no grupo `<leader>r` → **Remote** do `which-key`.

## Linguagens
### Java (`java` filetype)
Esses mapeamentos são registrados durante o `on_attach` do `jdtls` e aparecem no `which-key` sob o grupo `<leader>j`.
- `<leader>jo` — Organiza imports.
- `<leader>jv` — Extrai variável (abre diálogo interativo).
- `<leader>jc` / `<leader>jC` — Executa/Testa classe atual (respectivamente sem e com debug).
- `<leader>jn` / `<leader>jN` — Executa/Testa método mais próximo.
- `<leader>jm` (visual) — Extrai método a partir da seleção.
- `<leader>jR` — Renomeia arquivo usando o suporte do `jdtls`.

### Maven (qualquer buffer com projeto Maven detectado)
As teclas ficam agrupadas em `<leader>m` pelo `which-key` assim que o evento `LazyVimVeryLazy` ocorre.
- `<leader>mc` — `mvn clean`.
- `<leader>mb` — `mvn package`.
- `<leader>mt` — `mvn test`.
- `<leader>mi` — `mvn install`.
- `<leader>md` — `mvn deploy`.
- `<leader>ml` — Abre seleção interativa do ciclo de vida Maven.
- `<leader>mP` — Solicita perfis e executa com `-P`.
- `<leader>mS` — Executa `spring-boot:run`.
- `<leader>mE` — Permite inserir argumentos customizados para o Maven.
- Cada execução reporta o estado via `vim.notify`; em caso de erro o quickfix (`:copen`) é preenchido automaticamente com o log.

### Python
- `<leader>ci` (normal, buffer Python com Pyright ativo) — Code action para adicionar imports ausentes automaticamente.

## Ferramentas
- `<leader>Lg` (normal) — Abre o LazyGit em terminal flutuante (`kdheepak/lazygit.nvim`). O atalho padrão `<leader>gg` é desativado.
- `<leader>Ld` (normal) — Alterna o LazyDocker (via `toggleterm`). Ao abrir, `<Esc>` no terminal retorna ao modo normal.
- Ambos vivem no grupo `<leader>L` → **Lazy Tools** do `which-key`, evitando conflito com o atalho padrão `<leader>l` → `:Lazy`.

## Observações Adicionais
- Mapeamentos no modo terminal (`<Esc> -> <C-\><C-n>`) aplicam-se apenas ao buffer flutuante do LazyDocker.
- Para descobrir atalhos padrão do LazyVim, use `<leader>?` ou consulte a documentação oficial. Combine este guia com `docs/plugins_contexto.md` para entender os fluxos completos de cada integração.
