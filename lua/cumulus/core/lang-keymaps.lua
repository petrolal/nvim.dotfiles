-- Cumulus Language-Scoped Keymaps (Story 34.1)
--
-- Problem: every LSP/build-tool keymap used to live flat under the global
-- <leader>c "code/build/lsp" which-key group (Maven, Gradle, Terraform,
-- Ansible, Docker...). That meant opening <leader>c while editing a Python
-- file still showed Maven/Gradle build commands that only make sense for
-- Java/Kotlin -- the groups all merged together regardless of what you were
-- actually editing.
--
-- Fix: each language stack registers its keymaps here as BUFFER-LOCAL
-- mappings (vim.keymap.set(..., { buffer = <bufnr> })), applied only via a
-- FileType autocmd for the filetypes that stack owns. which-key mirrors
-- real keymaps, so a buffer-local mapping only ever shows up in the
-- <leader>c popup while you're editing a matching buffer -- switch to an
-- unrelated filetype and the group disappears on its own, no manual
-- show/hide bookkeeping required.
local M = {}

-- Each entry: { filetypes = {...}, group = "<leader>cX", label = "...", icon = "...",
--               keys = { { lhs, rhs, desc }, ... } }
local stacks = {}

function M.register(stack)
  table.insert(stacks, stack)
end

local augroup = vim.api.nvim_create_augroup("cumulus_lang_keymaps", { clear = true })

function M.setup()
  for _, stack in ipairs(stacks) do
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      pattern = stack.filetypes,
      callback = function(args)
        for _, k in ipairs(stack.keys) do
          vim.keymap.set("n", k[1], k[2], { buffer = args.buf, desc = k[3] })
        end
      end,
    })
  end
end

-- Which-key group specs for all registered stacks, so the popup shows a
-- proper label/icon for e.g. <leader>cj instead of an unnamed prefix. These
-- are buffer = true entries: which-key only displays them while the current
-- buffer actually owns matching buffer-local keymaps under that prefix.
function M.whichkey_spec()
  local spec = {}
  for _, stack in ipairs(stacks) do
    table.insert(spec, {
      stack.group,
      group = stack.label,
      icon = stack.icon,
      buffer = true,
    })
  end
  return spec
end

return M
