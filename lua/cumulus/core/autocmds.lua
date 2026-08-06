-- Cumulus Core Autocmds (Story 1.1)

local function augroup(name)
  return vim.api.nvim_create_augroup("cumulus_" .. name, { clear = true })
end

-- Discard any stray keystrokes typed into the terminal while Neovim was
-- still starting up (e.g. an extra "n" or "g" pressed right after
-- `nvim<CR>`). Without this, that buffered input gets replayed as
-- normal-mode commands the instant the dashboard buffer's single-key
-- mappings become active, unexpectedly opening a scratch buffer or the
-- grep picker instead of showing the dashboard.
-- NOTE: this must be deferred with vim.schedule rather than run inline in
-- the VimEnter callback -- some terminals (e.g. kitty) negotiate extended
-- keyboard protocol support over the same input stream right around
-- startup, and draining raw getchar() input synchronously at VimEnter can
-- race with and corrupt that in-flight handshake, which then shows up as
-- every keystroke getting duplicated for the rest of the session.
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("flush_typeahead"),
  callback = function()
    vim.schedule(function()
      while vim.fn.getchar(1) ~= 0 do
        vim.fn.getchar()
      end
    end)
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "grug-far",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output-panel",
    "checkhealth",
    "neotest-summary",
    "neotest-output",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer",
    })
  end,
})
