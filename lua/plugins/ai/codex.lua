return {
  {
    "jackMort/ChatGPT.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/which-key.nvim",
    },
    config = function()
      local default_model = vim.env.CODEX_MODEL or "o1-mini"
      local codex_bin = vim.env.CODEX_BIN or "codex"
      local extra_args = { "--full-auto" }
      if vim.env.CODEX_ARGS and vim.env.CODEX_ARGS ~= "" then
        extra_args = vim.tbl_extend("force", extra_args, vim.split(vim.env.CODEX_ARGS, "%s+", { trimempty = true }))
      end

      require("chatgpt").setup({
        api_key_cmd = nil,
        openai_params = {
          model = default_model,
          max_tokens = tonumber(vim.env.CODEX_MAX_TOKENS or "800") or 800,
          stream = false,
        },
        codex = {
          bin = codex_bin,
          extra_args = extra_args,
        },
      })

      local Config = require("chatgpt.config")
      local Api = require("chatgpt.api")

      local function collect_messages(params)
        if params.messages and #params.messages > 0 then
          local chunks = {}
          for _, message in ipairs(params.messages) do
            local role = (message.role or "user"):upper()
            local content = message.content
            if type(content) == "table" then
              local parts = {}
              for _, part in ipairs(content) do
                if type(part) == "table" and type(part.text) == "string" then
                  table.insert(parts, part.text)
                end
              end
              content = table.concat(parts, "\n")
            end
            if type(content) == "string" and content ~= "" then
              table.insert(chunks, string.format("%s:\n%s", role, content))
            end
          end
          table.insert(chunks, "ASSISTANT:")
          return table.concat(chunks, "\n\n")
        end
        if type(params.prompt) == "string" and params.prompt ~= "" then
          return params.prompt
        end
        return ""
      end

      local function run_codex(custom_params, cb)
        local params = vim.tbl_extend("keep", custom_params or {}, Config.options.openai_params or {})
        local prompt = collect_messages(params)
        if prompt == "" then
          vim.schedule(function()
            cb("Prompt vazio.", "ERROR")
          end)
          return
        end

        local bin = (Config.options.codex and Config.options.codex.bin) or codex_bin
        if vim.fn.executable(bin) ~= 1 then
          vim.schedule(function()
            cb(
              table.concat({
                "Codex não encontrado: " .. bin,
                "Instale o CLI (https://github.com/sourcegraph/sg-cli#codex) e certifique-se de que esteja no PATH.",
              }, "\n"),
              "ERROR"
            )
          end)
          return
        end

        local model = params.model or default_model
        local temp_output = vim.fn.tempname()
        local cmd = { bin, "exec", "--model", model, "--output-last-message", temp_output }
        local extra = (Config.options.codex and Config.options.codex.extra_args) or extra_args
        if type(extra) == "table" then
          for _, arg in ipairs(extra) do
            table.insert(cmd, arg)
          end
        end
        table.insert(cmd, "--")
        table.insert(cmd, prompt)

        vim.system(cmd, { text = true }, function(res)
          local exit_code = res.code or res.exit_code or 0
          local stdout = res.stdout or ""
          local stderr = res.stderr or ""

          vim.schedule(function()
            if exit_code ~= 0 then
              if temp_output then
                os.remove(temp_output)
              end
              local err = vim.trim(stderr) ~= "" and vim.trim(stderr) or vim.trim(stdout)
              local msg = err ~= "" and err or string.format("código %d", exit_code)
              if msg:match("Error loading configuration") or msg:match("No such file or directory") then
                msg = table.concat({
                  msg,
                  "Execute `codex login` para gerar ~/.codex/config.toml e concluir a autenticação.",
                }, "\n")
              elseif msg:match("No such device or address") then
                msg = table.concat({
                  msg,
                  "O Codex precisa de um login ativo. Abra um terminal interativo, rode `codex login` e confirme que `~/.codex` existe.",
                }, "\n")
              end
              cb("Codex erro: " .. msg, "ERROR")
              return
            end
            local output = ""
            if temp_output then
              local f = io.open(temp_output, "r")
              if f then
                output = f:read("*a") or ""
                f:close()
              end
              os.remove(temp_output)
            end
            output = vim.trim(output)
            if output == "" then
              output = vim.trim(stdout)
            end
            if output == "" then
              output = "(sem saída)"
            end
            cb(output, { provider = "codex" })
          end)
        end)
      end

      Api.chat_completions = function(custom_params, cb)
        run_codex(custom_params, cb)
      end

      Api.completions = function(custom_params, cb)
        run_codex(custom_params, cb)
      end

      Api.edits = function(custom_params, cb)
        run_codex(custom_params, cb)
      end

      Api.make_call = function(_, params, cb)
        run_codex(params, cb)
      end

      local wk = require("which-key")
      wk.add({
        { "<leader>a", group = "Codex" },
        { "<leader>ac", "<cmd>ChatGPT<CR>", desc = "Abrir Codex", mode = "n", silent = true },
      })
    end,
  },
}
