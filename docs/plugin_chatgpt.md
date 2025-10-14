# ChatGPT.nvim (Integração TurasVim)

Este módulo adiciona suporte ao `jackMort/ChatGPT.nvim` com ajustes mínimos necessários para funcionar no ambiente TurasVim.

## Especificação
- Local: `lua/plugins/ai/chatgpt.lua`.
- Dependências resolvidas automaticamente pelo Lazy:
  - `nvim-lua/plenary.nvim` (utilidades Lua).
  - `MunifTanjim/nui.nvim` (UI para prompts/flutuantes).
  - `folke/which-key.nvim` (ajuda de atalhos).

## Configuração
```lua
require("chatgpt").setup({
  api_key_cmd = "echo $OPENAI_API_KEY",
  openai_params = {
    model = "gpt-4o-mini",
    max_tokens = 800,
  },
})
```
- A chave é lida do ambiente via `OPENAI_API_KEY`. Garanta que a variável esteja exportada antes de abrir o Neovim.
- O modelo padrão (`gpt-4o-mini`) oferece latência reduzida, com limite de 800 tokens por resposta. Ajuste conforme necessário editando o spec.

## Keymaps
O módulo registra um grupo `Code With AI` no `which-key`:
- `<leader>a` — Prefixo que revela o grupo.
- `<leader>ac` — Abre a interface principal do ChatGPT em modo normal.

## Uso
1. Defina `OPENAI_API_KEY` no shell (`export OPENAI_API_KEY=...`).
2. Abra o Neovim e pressione `<leader>ac` para iniciar uma sessão.
3. Opcionalmente personalize prompts e parâmetros editando `lua/plugins/ai/chatgpt.lua`.

## Observações
- Respeite os limites de uso da API; o módulo não implementa throttling.
- Verifique mensagens em `:messages` caso a chave não esteja definida ou o serviço retorne erro HTTP.
- Use `:lua require("chatgpt.api").cancel()` para encerrar requisições pendentes, se necessário.
