# Codex (Wrapper ChatGPT.nvim)

Este módulo envolve o `jackMort/ChatGPT.nvim`, mas apresenta tudo com a marca Codex dentro do TurasVim.

-## Especificação
- Local: `lua/plugins/ai/codex.lua`.
- Dependências Lazy: `nvim-lua/plenary.nvim`, `MunifTanjim/nui.nvim`, `folke/which-key.nvim`.
- Requer o binário `codex` acessível no `PATH`.

## Configuração
```lua
require("chatgpt").setup({
  openai_params = {
    model = os.getenv("CODEX_MODEL") or "o1-mini",
    max_tokens = tonumber(os.getenv("CODEX_MAX_TOKENS") or "800"),
    stream = false,
  },
  codex = {
    bin = os.getenv("CODEX_BIN") or "codex",
    extra_args = vim.tbl_extend(
      "force",
      { "--full-auto" },
      vim.split(os.getenv("CODEX_ARGS") or "", "%s+", { trimempty = true })
    ),
  },
})
```
- O módulo ignora `api_key_cmd` e redireciona as chamadas OpenAI para o CLI `codex` usando `vim.system`.
- Variáveis `CODEX_MODEL`, `CODEX_MAX_TOKENS`, `CODEX_BIN` e `CODEX_ARGS` sobrescrevem os valores padrão quando definidas.
- O histórico do chat é serializado para texto (roles USER/ASSISTANT) e enviado ao comando `codex exec --model <modelo> --output-last-message <tmp>`; o arquivo temporário retornado alimenta a UI.

## Keymaps
O módulo registra um grupo `Code With AI` no `which-key`:
- `<leader>a` — Prefixo que revela o grupo.
- `<leader>ac` — Abre a interface principal do Codex em modo normal.

## Uso
1. Garanta que o `codex` CLI esteja instalado e autenticado (`codex login`) e, se desejar, configure `CODEX_MODEL`/`CODEX_ARGS`.
2. Abra o Neovim e pressione `<leader>ac` para iniciar uma sessão com o layout tradicional, agora identificado como Codex.
3. A resposta aparece após o término do processo (não há streaming); erros retornados pelo CLI são exibidos no cabeçalho.

## Observações
- O prompt enviado ao Codex inclui todo o histórico da conversa para preservar contexto.
- Caso o binário não esteja acessível ou retorne código diferente de zero, a mensagem de erro é repassada ao usuário.
- Falhas comuns (ex.: config ausente ou "No such device or address") trazem instruções: instalar o CLI, rodar `codex login` em um terminal interativo e garantir `~/.codex` acessível.
- Como `vim.system` retorna a resposta completa, o chat aguarda o término da execução antes de atualizar a janela.
