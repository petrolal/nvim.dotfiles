#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo " Cumulus Neovim Automated Verification"
echo "=========================================="

echo "[1/3] Running Neovim headless Lazy plugin check..."
if nvim --headless "+Lazy check" +qa; then
  echo "✔ Headless Lazy check PASSED."
else
  echo "✖ Headless Lazy check FAILED."
  exit 1
fi

echo "[2/3] Verifying Cumulus core options and keymaps..."
if nvim --headless "+lua assert(vim.opt.timeoutlen:get() == 200); assert(vim.opt.relativenumber:get() == true); assert(vim.g.mapleader == ' '); print('✔ Options verified')" +qa; then
  echo "✔ Core options PASSED."
else
  echo "✖ Core options FAILED."
  exit 1
fi

echo "[3/3] Verifying AWS Theme engine highlights..."
if nvim --headless "+lua require('cumulus.theme.aws').load(); assert(vim.g.colors_name == 'aws-theme'); local float_hl = vim.api.nvim_get_hl(0, { name = 'FloatBorder' }); assert(string.format('#%06X', float_hl.fg):upper() == '#FF9900'); print('✔ AWS Theme verified')" +qa; then
  echo "✔ AWS Theme engine PASSED."
else
  echo "✖ AWS Theme engine FAILED."
  exit 1
fi

echo "=========================================="
echo " ALL VALIDATIONS PASSED SUCCESSFULLY!"
echo "=========================================="
