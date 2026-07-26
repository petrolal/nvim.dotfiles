#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/petrolal/nvim.dotfiles.git"
MIN_NEOVIM_VERSION="0.11.4"
NEOVIM_VERSION="${NEOVIM_VERSION:-$MIN_NEOVIM_VERSION}"
NEOVIM_URL="https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux-x86_64.tar.gz"
INSTALL_PREFIX="/usr/local"

log() {
  printf "\033[1;32m[INFO]\033[0m %s\n" "$*"
}

die() {
  printf "\033[1;31m[ERRO]\033[0m %s\n" "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required program not found: $1"
}

version_ge() {
  local a="$1"
  local b="$2"
  [[ "$(printf '%s\n%s\n' "$a" "$b" | sort -V | head -n1)" == "$b" ]]
}

detect_pkg_mgr() {
  if command -v apt-get >/dev/null 2>&1; then
    echo "apt"
  elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  else
    die "No supported package manager found (apt, pacman, dnf)."
  fi
}

install_packages() {
  local mgr="$1"
  case "$mgr" in
    apt)
      log "Updating apt repositories and installing core dependencies..."
      sudo apt-get update
      sudo apt-get install -y \
        git curl wget tar unzip ripgrep fd-find python3 python3-pip python3-venv python3-full nodejs npm cargo \
        build-essential openssh-client sshpass lazygit lazydocker openjdk-21-jdk
      if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
        sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
      fi
      ;;
    pacman)
      log "Updating pacman packages..."
      sudo pacman -Sy --needed --noconfirm \
        git curl wget ripgrep fd python python-pip nodejs npm rustup base-devel \
        openssh sshpass lazygit lazydocker jdk21-openjdk
      if ! command -v cargo >/dev/null 2>&1; then
        log "Enabling cargo via rustup"
        rustup default stable
      fi
      ;;
    dnf)
      log "Installing dnf dependencies..."
      sudo dnf install -y \
        git curl wget tar unzip ripgrep fd-find python3 python3-pip python3-devel nodejs npm cargo \
        @"Development Tools" openssh-clients sshpass lazygit java-21-openjdk java-21-openjdk-devel
      if ! command -v lazydocker >/dev/null 2>&1; then
        if command -v go >/dev/null 2>&1; then
          log "Installing lazydocker via go..."
          go install github.com/jesseduffield/lazydocker@latest
          sudo ln -sf "$HOME/go/bin/lazydocker" /usr/local/bin/lazydocker
        fi
      fi
      if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
        sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
      fi
      ;;
  esac
}

install_neovim() {
  if command -v nvim >/dev/null 2>&1; then
    local current
    current="$(nvim --version | head -n1 | awk '{print $2}')"
    if [[ "$current" == "v${NEOVIM_VERSION}" ]]; then
      log "Neovim v${NEOVIM_VERSION} is already installed."
      return
    fi
  fi

  local tmpdir
  tmpdir="$(mktemp -d)"
  trap 'tmp="${tmpdir:-}"; [[ -n "$tmp" ]] && rm -rf "$tmp"' EXIT
  log "Downloading Neovim v${NEOVIM_VERSION}..."
  if ! curl -fSL --retry 3 --retry-delay 1 "$NEOVIM_URL" -o "$tmpdir/nvim.tar.gz"; then
    die "Failed to download Neovim from ${NEOVIM_URL}."
  fi
  if ! tar -xzf "$tmpdir/nvim.tar.gz" -C "$tmpdir"; then
    die "Failed to extract downloaded Neovim package."
  fi

  sudo rm -rf "${INSTALL_PREFIX}/nvim-linux-x86_64"
  sudo mv "$tmpdir/nvim-linux-x86_64" "${INSTALL_PREFIX}/nvim-linux-x86_64"
  sudo ln -sf "${INSTALL_PREFIX}/nvim-linux-x86_64/bin/nvim" "${INSTALL_PREFIX}/bin/nvim"
  log "Neovim installed successfully at ${INSTALL_PREFIX}/nvim-linux-x86_64"

  local cleanup_dir="$tmpdir"
  trap - EXIT
  rm -rf "$cleanup_dir"
}

ensure_cargo() {
  if ! command -v cargo >/dev/null 2>&1; then
    die "cargo not found. Please install Rust/cargo."
  fi
  if [[ -f "$HOME/.cargo/env" ]]; then
    # shellcheck disable=SC1090
    source "$HOME/.cargo/env"
  fi
}

install_global_tools() {
  log "Installing global formatting and Python/Node utilities..."

  -- Install stylua via cargo if missing
  if ! command -v stylua >/dev/null 2>&1; then
    log "Installing stylua via cargo..."
    cargo install stylua --locked || true
  fi

  -- Install ruff via pip if missing
  if ! command -v ruff >/dev/null 2>&1; then
    log "Installing ruff via pip..."
    pip install --user --break-system-packages ruff || pip install --user ruff || true
  fi

  -- Ensure pynvim for Python Neovim provider
  python3 -m pip install --user --break-system-packages pynvim || python3 -m pip install --user pynvim || true

  -- Ensure neovim npm package for Node provider
  if command -v npm >/dev/null 2>&1; then
    sudo npm install -g neovim || npm install -g neovim || true
  fi
}

clone_config() {
  local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  if [[ -d "$config_dir" && ! -d "$config_dir/.git" ]]; then
    local backup="${config_dir}-backup-$(date +%Y%m%d%H%M%S)"
    log "Backing up existing config to ${backup}..."
    mv "$config_dir" "$backup"
  fi
  if [[ -d "$config_dir/.git" ]]; then
    log "Config directory already cloned; updating repository..."
    git -C "$config_dir" pull --ff-only || true
  else
    log "Cloning nvim dotfiles to ${config_dir}..."
    git clone --depth 1 "$REPO_URL" "$config_dir"
  fi
}

bootstrap_lazy_and_mason() {
  log "Syncing plugins and auto-installing Mason LSPs/formatters..."
  local state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"
  mkdir -p "$state_dir"

  -- Sync plugins
  XDG_STATE_HOME="$state_dir" \
    nvim --headless "+Lazy! sync" +qa

  -- Pre-install all configured Mason tools
  XDG_STATE_HOME="$state_dir" \
    nvim --headless "+MasonInstall jdtls java-debug-adapter java-test kotlin-language-server kotlin-debug-adapter ktlint google-java-format ruff pyright shellcheck flake8" +qa || true
}

main() {
  require_cmd curl
  require_cmd sudo
  if ! version_ge "$NEOVIM_VERSION" "$MIN_NEOVIM_VERSION"; then
    die "NEOVIM_VERSION must be >= ${MIN_NEOVIM_VERSION} (current: ${NEOVIM_VERSION})."
  fi

  local mgr
  mgr="$(detect_pkg_mgr)"
  log "Detected package manager: ${mgr}"
  install_packages "$mgr"

  ensure_cargo
  install_global_tools
  install_neovim
  clone_config
  bootstrap_lazy_and_mason

  log "Installation complete! Launch Neovim using 'nvim'."
}

main "$@"
