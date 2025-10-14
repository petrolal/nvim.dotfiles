return {
  {
    "nosduco/remote-sshfs.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = function()
      local fn = vim.fn
      local base_dir = fn.expand("~") .. "/remotes"
      if fn.isdirectory(base_dir) == 0 then
        fn.mkdir(base_dir, "p")
      end

      local default_opts = {
        mounts = {
          base_dir = base_dir,
          unmount_on_exit = true,
          options = {
            "-o",
            "IdentityFile=" .. fn.expand("~/.ssh/id_ed25519"),
            "-o",
            "allow_other",
            "-o",
            "reconnect",
            "-o",
            "follow_symlinks",
            "-o",
            "cache=yes",
          },
        },
        handlers = {
          on_connect = {
            change_dir = true,
          },
          on_disconnect = {
            clean_mount_folders = true,
          },
        },
        ui = {
          confirm = {
            connect = true,
            change_dir = true,
          },
        },
      }

      if vim.g.remote_sshfs_connections then
        default_opts.connections = vim.g.remote_sshfs_connections
      end

      return vim.tbl_deep_extend("force", default_opts, vim.g.remote_sshfs_opts or {})
    end,
    config = function(_, opts)
      local remote_sshfs = require("remote-sshfs")
      remote_sshfs.setup(opts)

      local ok, telescope = pcall(require, "telescope")
      if ok and telescope.load_extension then
        telescope.load_extension("remote-sshfs")
      end
    end,
    keys = {
      {
        "<leader>rm",
        function()
          local ok, telescope = pcall(require, "telescope")
          if not ok then
            vim.notify("remote-sshfs: telescope não disponível", vim.log.levels.ERROR)
            return
          end

          local ok_ext, extension = pcall(function()
            return telescope.extensions["remote-sshfs"]
          end)

          if ok_ext and extension and type(extension.connect) == "function" then
            extension.connect()
          else
            vim.notify("remote-sshfs: extensão do Telescope indisponível", vim.log.levels.WARN)
          end
        end,
        desc = "Remote SSHFS",
      },
      {
        "<leader>ru",
        function()
          if vim.fn.exists(":RemoteSSHFSDisconnect") == 2 then
            vim.cmd.RemoteSSHFSDisconnect()
            return
          end

          local ok, connections = pcall(require, "remote-sshfs.connections")
          if ok and type(connections.unmount_host) == "function" then
            connections.unmount_host()
          else
            vim.notify("remote-sshfs: comando de disconnect indisponível", vim.log.levels.WARN)
          end
        end,
        desc = "Unmount SSHFS",
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>r", group = "Remote" })
    end,
  },
}
