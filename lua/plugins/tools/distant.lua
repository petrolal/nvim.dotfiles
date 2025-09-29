return {
  {
    "chipsenkbeil/distant.nvim",
    branch = "v0.3",
    cmd = {
      "Distant",
      "DistantConnect",
      "DistantInstall",
      "DistantLaunch",
      "DistantServe",
      "DistantTerminate",
    },
    keys = function()
      local function open_launcher()
        local ok, distant = pcall(require, "distant")
        if not ok then
          vim.notify("distant.nvim nao pode ser carregado.", vim.log.levels.ERROR)
          return
        end

        local cli = distant:cli()
        if not cli:is_executable() then
          vim.notify(
            "distant.nvim nao encontrou o binario do CLI. Execute :DistantInstall antes de abrir o launcher.",
            vim.log.levels.WARN
          )
          return
        end

        vim.cmd("Distant")
      end

      return {
        {
          "<leader>rp",
          open_launcher,
          desc = "Abrir launcher remoto",
        },
      }
    end,
    config = function()
      local ok, distant = pcall(require, "distant")
      if not ok then
        return
      end

      local fn = vim.fn
      local notify = vim.notify

      local function ensure_dir(dir)
        if fn.isdirectory(dir) == 0 then
          local ok_dir, err = pcall(fn.mkdir, dir, "p")
          if not ok_dir then
            notify(
              string.format("distant.nvim nao conseguiu criar %s: %s", dir, err),
              vim.log.levels.WARN
            )
            return false
          end
        end
        return true
      end

      local log_dir = fn.stdpath("state") .. "/distant"
      if not ensure_dir(log_dir) then
        log_dir = fn.stdpath("cache") .. "/distant"
        if not ensure_dir(log_dir) then
          log_dir = nil
        end
      end

      local manager_settings = { user = true }
      local client_settings = {}
      local network_settings = { private = true }

      if log_dir then
        manager_settings.log_file = log_dir .. "/manager.log"
        manager_settings.log_level = "warn"
        client_settings.log_file = log_dir .. "/client.log"
        network_settings.unix_socket = log_dir .. "/manager.sock"
      end

      distant:setup({
        settings = {
          manager = manager_settings,
          client = client_settings,
          network = network_settings,
        },
      })

      if not distant:cli():is_executable() then
        vim.schedule(function()
          if vim.g.distant_cli_warned then
            return
          end
          vim.g.distant_cli_warned = true
          vim.notify(
            "distant.nvim: binario do CLI ausente. Execute :DistantInstall para baixar ou configure `client.bin`.",
            vim.log.levels.WARN
          )
        end)
      end
    end,
  },
}
