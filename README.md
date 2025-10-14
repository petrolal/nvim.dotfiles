# P3TROL4LVim

My Touretted Neovim template based on **💤 LazyVim**.

## Quick Install

Run the bootstrap script (installs Neovim v0.11.4, required packages, and clones this config):

```bash
curl -fsSL https://raw.githubusercontent.com/petrolal/nvim.dotfiles/main/scripts/install.sh | bash
```

Pass `NEOVIM_VERSION` to override the default release:

```bash
curl -fsSL https://raw.githubusercontent.com/petrolal/nvim.dotfiles/main/scripts/install.sh | NEOVIM_VERSION=0.10.2 bash
```

## Requirements & Manual Setup

See `docs/dependencies.md` for distro-specific package commands and manual steps if you prefer to inspect each dependency before installing.

After the first launch, open Neovim and run:

```vim
:checkhealth
:MasonInstall shellcheck shfmt flake8 pyright ruff debugpy
```

## Contribution

- [ ] Lucas H N A Petrola - Main developer.
