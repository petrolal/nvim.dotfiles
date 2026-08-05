#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo " Cumulus Neovim Automated Verification"
echo "=========================================="

echo "[1/5] Running Neovim headless Lazy plugin check..."
if nvim --headless "+Lazy check" +qa; then
  echo "✔ Headless Lazy check PASSED."
else
  echo "✖ Headless Lazy check FAILED."
  exit 1
fi

echo "[2/5] Verifying Cumulus core options & exit confirmation..."
if nvim --headless "+lua assert(vim.opt.timeoutlen:get() == 200); assert(vim.opt.relativenumber:get() == true); assert(vim.opt.confirm:get() == true); assert(vim.g.mapleader == ' '); print('✔ Options verified')" +qa; then
  echo "✔ Core options PASSED."
else
  echo "✖ Core options FAILED."
  exit 1
fi

echo "[3/5] Verifying Multi-Cloud Signature Themes (AWS, Azure, GCP, OCI)..."
if nvim --headless "+colorscheme aws-theme" "+colorscheme azure-theme" "+colorscheme gcp-theme" "+colorscheme oci-theme" "+lua print('✔ All 4 cloud themes loaded')" +qa; then
  echo "✔ Multi-Cloud Theme engines PASSED."
else
  echo "✖ Multi-Cloud Theme engines FAILED."
  exit 1
fi

echo "[4/5] Running Cumulus Healthcheck Suite (:checkhealth cumulus)..."
if nvim --headless "+checkhealth cumulus" +qa; then
  echo "✔ Cumulus healthcheck suite PASSED."
else
  echo "✖ Cumulus healthcheck suite FAILED."
  exit 1
fi

echo "[5/5] Verifying Markdown & File Operation Modules..."
if nvim --headless "+lua assert(pcall(require, 'render-markdown')); assert(pcall(require, 'persistence')); print('✔ Modules verified')" +qa; then
  echo "✔ Markdown & File Operation modules PASSED."
else
  echo "✖ Markdown & File Operation modules FAILED."
  exit 1
fi

echo "=========================================="
echo " ALL 5 VALIDATIONS PASSED SUCCESSFULLY!"
echo "=========================================="
