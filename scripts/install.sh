#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/petrolal/nvim.dotfiles.git"
MIN_NEOVIM_VERSION="0.11.2"
NEOVIM_VERSION="${NEOVIM_VERSION:-$MIN_NEOVIM_VERSION}"
NEOVIM_URL="https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz"
INSTALL_PREFIX="/usr/local"

log() {
  printf "\033[1;32m[INFO]\033[0m %s\n" "$*"
}

die() {
  printf "\033[1;31m[ERRO]\033[0m %s\n" "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Programa obrigatório não encontrado: $1"
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
    die "Nenhum gerenciador de pacotes suportado encontrado (apt, pacman, dnf)."
  fi
}

install_packages() {
  local mgr="$1"
  case "$mgr" in
    apt)
      sudo apt-get update
      sudo apt-get install -y \
        git curl wget tar unzip ripgrep fd-find python3 python3-pip nodejs npm cargo \
        build-essential openssh-client sshpass lazygit lazydocker
      # fd-find instala como fdfind; cria link simbólico para fd se necessário
      if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
        sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
      fi
      ;;
    pacman)
      sudo pacman -Sy --needed --noconfirm \
        git curl wget ripgrep fd python python-pip nodejs npm rustup base-devel \
        openssh sshpass lazygit lazydocker
      if ! command -v cargo >/dev/null 2>&1; then
        log "Habilitando cargo via rustup"
        rustup default stable
      fi
      ;;
    dnf)
      sudo dnf install -y \
        git curl wget tar unzip ripgrep fd-find python3 python3-pip nodejs npm cargo \
        @"Development Tools" openssh-clients sshpass lazygit
      # lazydocker pode não estar disponível; tenta instalar via go se presente
      if ! command -v lazydocker >/dev/null 2>&1; then
        if command -v go >/dev/null 2>&1; then
          log "Instalando lazydocker via go"
          go install github.com/jesseduffield/lazydocker@latest
          sudo ln -sf "$HOME/go/bin/lazydocker" /usr/local/bin/lazydocker
        else
          log "lazydocker não disponível em dnf; instale manualmente depois (brew/go)."
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
    local current="$(nvim --version | head -n1 | awk '{print $2}')"
    if [[ "$current" == "v${NEOVIM_VERSION}" ]]; then
      log "Neovim v${NEOVIM_VERSION} já instalado."
      return
    fi
  fi

  local tmpdir
  tmpdir="$(mktemp -d)"
  trap 'tmp="${tmpdir:-}"; [[ -n "$tmp" ]] && rm -rf "$tmp"' EXIT
  log "Baixando Neovim ${NEOVIM_VERSION}"
  if ! curl -fSL --retry 3 --retry-delay 1 "$NEOVIM_URL" -o "$tmpdir/nvim.tar.gz"; then
    die "Falha ao baixar Neovim em ${NEOVIM_URL}. Verifique a versão informada."
  fi
  if ! tar -xzf "$tmpdir/nvim.tar.gz" -C "$tmpdir"; then
    die "Falha ao extrair o pacote Neovim baixado."
  fi

  sudo rm -rf "${INSTALL_PREFIX}/nvim-linux64"
  sudo mv "$tmpdir/nvim-linux64" "${INSTALL_PREFIX}/nvim-linux64"
  sudo ln -sf "${INSTALL_PREFIX}/nvim-linux64/bin/nvim" "${INSTALL_PREFIX}/bin/nvim"
  log "Neovim instalado em ${INSTALL_PREFIX}/nvim-linux64"

  local cleanup_dir="$tmpdir"
  trap - EXIT
  rm -rf "$cleanup_dir"
}

ensure_cargo() {
  if ! command -v cargo >/dev/null 2>&1; then
    die "cargo não encontrado. Reabra o shell ou instale manualmente."
  fi
  if [[ -f "$HOME/.cargo/env" ]]; then
    # shellcheck disable=SC1090
    source "$HOME/.cargo/env"
  fi
}

install_stylua() {
  if ! command -v stylua >/dev/null 2>&1; then
    log "Instalando stylua via cargo"
    cargo install stylua --locked
  fi
}

clone_config() {
  local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  if [[ -d "$config_dir" && ! -d "$config_dir/.git" ]]; then
    local backup="${config_dir}-backup-$(date +%Y%m%d%H%M%S)"
    log "Movendo configuração existente para ${backup}"
    mv "$config_dir" "$backup"
  fi
  if [[ -d "$config_dir/.git" ]]; then
    log "Config TurasVim já clonada; atualizando"
    git -C "$config_dir" pull --ff-only
  else
    log "Clonando TurasVim para ${config_dir}"
    git clone --depth 1 "$REPO_URL" "$config_dir"
  fi
}

bootstrap_lazyvim() {
  log "Sincronizando plugins com LazyVim"
  local state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"
  mkdir -p "$state_dir"
  XDG_STATE_HOME="$state_dir" \
    nvim --headless "+Lazy sync | Lazy check" +qa
}

main() {
  require_cmd curl
  require_cmd sudo
  if ! version_ge "$NEOVIM_VERSION" "$MIN_NEOVIM_VERSION"; then
    die "NEOVIM_VERSION deve ser >= ${MIN_NEOVIM_VERSION} (atual: ${NEOVIM_VERSION})."
  fi

  local mgr
  mgr="$(detect_pkg_mgr)"
  log "Usando gerenciador de pacotes: ${mgr}"
  install_packages "$mgr"

  ensure_cargo
  install_stylua
  install_neovim
  clone_config
  bootstrap_lazyvim

  log "Instalação concluída! Abra o Neovim normalmente para começar."
}

main "$@"
