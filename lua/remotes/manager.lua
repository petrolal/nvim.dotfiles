-- ~/.config/nvim/lua/remotes/manager.lua
-- Garante conexão via distant 0.20.0: instala se necessário, usa socket correto e manager ativo.

local M = {}
local launch_distant -- forward declare

-------------------------------------------------------
-- util
-------------------------------------------------------
local function has(exec)
  return vim.fn.executable(exec) == 1
end
local function exepath(bin)
  local p = vim.fn.exepath(bin)
  return p ~= "" and p or nil
end
local function run_job(cmd, opt)
  return vim.fn.jobstart(cmd, opt or {})
end
local function notify(msg, lvl, rep)
  local opts = { title = "remotes" }
  if rep then
    opts.replace = rep
  end
  local id = vim.notify(msg, lvl or vim.log.levels.INFO, opts)
  return (type(id) == "number") and id or rep
end

local STATE = { pass = {} }

-------------------------------------------------------
-- spinner
-------------------------------------------------------
local function spinner_start(text)
  local ok_notify = pcall(require, "notify")
  local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  local i, id = 1, nil
  local t = vim.loop.new_timer()

  if ok_notify then
    t:start(
      0,
      180,
      vim.schedule_wrap(function()
        id = vim.notify(
          frames[i] .. " " .. text,
          vim.log.levels.INFO,
          { title = "remotes", replace = id, timeout = false }
        )
        i = (i % #frames) + 1
      end)
    )
    return {
      stop = function(final_msg, level)
        if t and not t:is_closing() then
          t:stop()
          t:close()
        end
        if final_msg then
          vim.notify(final_msg, level or vim.log.levels.INFO, { title = "remotes", replace = id })
        end
      end,
    }
  else
    t:start(
      0,
      180,
      vim.schedule_wrap(function()
        vim.api.nvim_echo({ { frames[i] .. " " .. text, "ModeMsg" } }, false, {})
        i = (i % #frames) + 1
      end)
    )
    return {
      stop = function(final_msg, level)
        if t and not t:is_closing() then
          t:stop()
          t:close()
        end
        if final_msg then
          local hl = (level == vim.log.levels.ERROR) and "ErrorMsg" or "MoreMsg"
          vim.api.nvim_echo({ { final_msg, hl } }, false, {})
        else
          vim.api.nvim_echo({ { "", "" } }, false, {})
        end
      end,
    }
  end
end

-------------------------------------------------------
-- local distant bin
-------------------------------------------------------
local function local_distant_path()
  local cfg = vim.fn.stdpath("config")
  local uname = vim.loop.os_uname()
  local arch = uname.machine or "x86_64"
  local sys = (uname.sysname or "Linux"):lower()
  local cands = {}
  if sys:find("linux") then
    if arch == "x86_64" or arch == "amd64" then
      cands[#cands + 1] = cfg .. "/remotes/bin/distant-x86_64-unknown-linux-gnu"
    elseif arch == "aarch64" or arch == "arm64" then
      cands[#cands + 1] = cfg .. "/remotes/bin/distant-aarch64-unknown-linux-gnu"
    end
  elseif sys:find("darwin") then
    if arch == "x86_64" then
      cands[#cands + 1] = cfg .. "/remotes/bin/distant-x86_64-apple-darwin"
    elseif arch == "arm64" or arch == "aarch64" then
      cands[#cands + 1] = cfg .. "/remotes/bin/distant-aarch64-apple-darwin"
    end
  end
  for _, f in ipairs(cands) do
    if vim.loop.fs_stat(f) then
      return f
    end
  end
  return exepath("distant")
end

-------------------------------------------------------
-- remote helpers
-------------------------------------------------------
local function remote_uid(remote, pass, cb)
  local cmd
  if pass and has("sshpass") then
    cmd = {
      "env",
      "SSHPASS=" .. pass,
      "sshpass",
      "-e",
      "ssh",
      "-o",
      "StrictHostKeyChecking=accept-new",
      remote,
      "id -u",
    }
  else
    cmd = { "ssh", "-o", "BatchMode=no", "-o", "StrictHostKeyChecking=accept-new", remote, "id -u" }
  end
  run_job(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, d, _)
      cb(d and d[1] or "")
    end,
  })
end

local function check_remote_has(remote, pass, cb)
  local cmd
  if pass and has("sshpass") then
    cmd = {
      "env",
      "SSHPASS=" .. pass,
      "sshpass",
      "-e",
      "ssh",
      "-o",
      "StrictHostKeyChecking=accept-new",
      remote,
      "command -v distant >/dev/null 2>&1 && echo OK || echo NO",
    }
  else
    cmd = {
      "ssh",
      "-o",
      "BatchMode=no",
      "-o",
      "StrictHostKeyChecking=accept-new",
      remote,
      "command -v distant >/dev/null 2>&1 && echo OK || echo NO",
    }
  end
  run_job(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data, _)
      local ok = false
      if data then
        for _, line in ipairs(data) do
          if line and line:match("OK") then
            ok = true
            break
          end
        end
      end
      cb(ok)
    end,
  })
end

local function remote_install_script()
  return [[
set -e
src="$1"
[ -s "$src" ] || { echo "ERR:NOFILE"; exit 1; }
chmod 0755 "$src"
if [ "$(id -u)" = "0" ] && [ -w /usr/local/bin ]; then
  mv -f "$src" /usr/local/bin/distant 2>/dev/null || cp "$src" /usr/local/bin/distant
  chmod 0755 /usr/local/bin/distant
  echo "OK:/usr/local/bin/distant"
else
  mkdir -p "$HOME/.local/bin"
  mv -f "$src" "$HOME/.local/bin/distant" 2>/dev/null || cp "$src" "$HOME/.local/bin/distant"
  chmod 0755 "$HOME/.local/bin/distant"
  echo "OK:$HOME/.local/bin/distant"
fi
]]
end

-------------------------------------------------------
-- ensure_remote_and_then
-------------------------------------------------------
local function ensure_remote_and_then(remote, on_ready)
  check_remote_has(remote, nil, function(has_bin_noauth)
    if has_bin_noauth then
      notify("Remoto já possui 'distant'. Conectando...")
      on_ready()
      return
    end

    local pass = STATE.pass[remote]
    local function proceed_with_pass(p)
      check_remote_has(remote, p, function(has_bin_auth)
        if has_bin_auth then
          notify("Encontrado 'distant' no remoto. Conectando...")
          on_ready()
          return
        end

        if not has("sshpass") then
          notify("sshpass não encontrado. Instale-o.", vim.log.levels.ERROR)
          return
        end

        local local_bin = local_distant_path()
        if not local_bin then
          notify("Binário local 'distant' não encontrado.", vim.log.levels.ERROR)
          return
        end

        remote_uid(remote, p, function(uid)
          local dest_hint = (uid == "0") and "/usr/local/bin/distant" or "$HOME/.local/bin/distant"
          local tmp_remote = "/tmp/distant.upload." .. tostring(math.random(10000, 99999))

          local sp = spinner_start(("Enviando distant para %s"):format(tmp_remote))
          local scp_cmd = {
            "env",
            "SSHPASS=" .. p,
            "sshpass",
            "-e",
            "scp",
            "-o",
            "StrictHostKeyChecking=accept-new",
            local_bin,
            ("%s:%s"):format(remote, tmp_remote),
          }

          run_job(scp_cmd, {
            on_exit = function(_, rc)
              if rc ~= 0 then
                sp.stop(("Upload falhou (rc=%d)"):format(rc), vim.log.levels.ERROR)
                return
              end
              sp.stop(("Upload concluído (rc=%d)"):format(rc))

              local sp2 = spinner_start("Instalando no remoto...")
              local ssh_cmd = {
                "env",
                "SSHPASS=" .. p,
                "sshpass",
                "-e",
                "ssh",
                "-o",
                "StrictHostKeyChecking=accept-new",
                remote,
                "sh",
                "-s",
                "--",
                tmp_remote,
              }
              local killed = false
              local job = run_job(ssh_cmd, {
                stdin = "pipe",
                stdout_buffered = true,
                stderr_buffered = true,
                on_stdout = function(_, data, _)
                  if data then
                    for _, line in ipairs(data) do
                      if line:match("^OK:") then
                        notify("[remoto] " .. line)
                      end
                    end
                  end
                end,
                on_stderr = function(_, data, _)
                  if data and table.concat(data, ""):match("%S") then
                    notify("[ssh] " .. table.concat(data, "\n"), vim.log.levels.WARN)
                  end
                end,
                on_exit = function(_, code)
                  if killed then
                    return
                  end
                  check_remote_has(remote, p, function(ok2)
                    if code == 0 and ok2 then
                      sp2.stop("Instalado no remoto (" .. dest_hint .. ")")
                      on_ready()
                    else
                      sp2.stop("Falha ao instalar no remoto.", vim.log.levels.ERROR)
                    end
                  end)
                end,
              })
              if job <= 0 then
                sp2.stop("Falha ao iniciar instalação.", vim.log.levels.ERROR)
                return
              end
              vim.fn.chansend(job, remote_install_script())
              vim.fn.chanclose(job, "stdin")
              vim.defer_fn(function()
                if vim.fn.jobwait({ job }, 0)[1] == -1 then
                  killed = true
                  pcall(vim.fn.jobstop, job)
                  sp2.stop("Timeout na instalação (60s).", vim.log.levels.ERROR)
                end
              end, 60000)
            end,
          })
        end)
      end)
    end

    if pass then
      proceed_with_pass(pass)
      return
    end
    if not has("sshpass") then
      notify("sshpass não encontrado.", vim.log.levels.ERROR)
      return
    end
    local input = vim.fn.inputsecret(("Senha SSH para %s: "):format(remote))
    if not input or input == "" then
      notify("Senha não informada.", vim.log.levels.ERROR)
      return
    end
    STATE.pass[remote] = input
    proceed_with_pass(input)
  end)
end

-------------------------------------------------------
-- launch distant
-------------------------------------------------------
launch_distant = function(tgt)
  -- detecta socket padrão do manager da 0.20.0
  local rt = vim.env.XDG_RUNTIME_DIR or (vim.fn.expand("~") .. "/.local/run")
  local sock = rt .. "/distant/" .. (vim.env.USER or "user") .. ".distant.sock"
  if vim.loop.fs_stat(sock) then
    vim.env.DISTANT_MANAGER = "unix://" .. sock
  end

  if vim.fn.exists(":DistantLaunch") ~= 2 then
    local ok, lazy = pcall(require, "lazy")
    if ok then
      pcall(lazy.load, { plugins = { "distant.nvim" } })
    end
  end
  if vim.fn.exists(":DistantLaunch") ~= 2 then
    notify("distant.nvim não carregado", vim.log.levels.ERROR)
    return
  end

  if not tgt:match("^ssh://") then
    tgt = "ssh://" .. tgt
  end
  notify("Conectando a " .. tgt .. " ...")

  local ok1 = pcall(vim.cmd, "DistantLaunch " .. vim.fn.fnameescape(tgt))
  if ok1 then
    return
  end
  pcall(function()
    local distant = require("distant")
    local bin = local_distant_path()
    distant:setup({
      manager = {
        log_level = "info",
        launch = {
          enabled = true,
          binary = bin,
        },
      },
      client = bin and { bin = bin } or nil,
    })
  end)
  local ok2 = pcall(vim.cmd, "DistantLaunch " .. vim.fn.fnameescape(tgt))
  if not ok2 then
    notify("Launch falhou (exit 1). Verifique se o manager está ativo e o socket correto.", vim.log.levels.ERROR)
  end
end

-------------------------------------------------------
-- integração com telescope
-------------------------------------------------------
function M.setup()
  vim.api.nvim_create_user_command("DistantSmartConnect", function(o)
    ensure_remote_and_then(o.args:gsub("^ssh://", ""), function()
      launch_distant(o.args)
    end)
  end, { nargs = 1 })

  local Path = require("plenary.path")
  local DB = vim.fn.stdpath("data") .. "/distant_remotes.json"

  local function load_hosts()
    local p = Path:new(DB)
    if not p:exists() then
      return {}
    end
    local ok, data = pcall(function()
      return vim.json.decode(p:read())
    end)
    return ok and type(data) == "table" and data or {}
  end
  local function save_hosts(list)
    Path:new(DB):write(vim.json.encode(list), "w")
  end

  vim.api.nvim_create_user_command("RemoteAdd", function()
    local list = load_hosts()
    vim.ui.input({ prompt = "Label: " }, function(label)
      if not label or label == "" then
        return
      end
      vim.ui.input({ prompt = "Target (user@host ou ssh://...): " }, function(target)
        if not target or target == "" then
          return
        end
        table.insert(list, { label = label, target = target })
        save_hosts(list)
        notify("Remote adicionado: " .. label)
      end)
    end)
  end, {})

  vim.api.nvim_create_user_command("RemoteMenu", function()
    local list = load_hosts()
    local entries = {}
    for _, it in ipairs(list) do
      entries[#entries + 1] = {
        display = it.label .. "  →  " .. it.target,
        ordinal = it.label .. " " .. it.target,
        value = it,
      }
    end

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local state = require("telescope.actions.state")

    pickers
      .new({}, {
        prompt_title = "Remotes",
        finder = finders.new_table({
          results = entries,
          entry_maker = function(e)
            return e
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(buf, map)
          local function connect()
            local e = state.get_selected_entry()
            actions.close(buf)
            ensure_remote_and_then(e.value.target:gsub("^ssh://", ""), function()
              launch_distant(e.value.target)
            end)
          end
          local function add()
            actions.close(buf)
            vim.cmd("RemoteAdd")
          end
          local function del()
            local e = state.get_selected_entry()
            actions.close(buf)
            local l = load_hosts()
            for i, it in ipairs(l) do
              if it.label == e.value.label then
                table.remove(l, i)
                break
              end
            end
            save_hosts(l)
            notify("Removido: " .. e.value.label)
          end
          local function ren()
            local e = state.get_selected_entry()
            actions.close(buf)
            local l = load_hosts()
            vim.ui.input({ prompt = "Novo label: ", default = e.value.label }, function(n)
              if not n or n == "" then
                return
              end
              for _, it in ipairs(l) do
                if it.label == e.value.label then
                  it.label = n
                  break
                end
              end
              save_hosts(l)
              notify("Renomeado: " .. e.value.label .. " -> " .. n)
            end)
          end

          map("i", "<CR>", connect)
          map("n", "<CR>", connect)
          map("i", "<C-a>", add)
          map("n", "a", add)
          map("i", "<C-d>", del)
          map("n", "d", del)
          map("i", "<C-r>", ren)
          map("n", "r", ren)
          return true
        end,
      })
      :find()
  end, {})
end

M.local_distant_path = local_distant_path

return M
