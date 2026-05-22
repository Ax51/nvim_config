#!/bin/sh

set -eu

# Bootstrap this Neovim config on a fresh Linux/Coder machine.
#
# Intended usage:
#   curl -fsSL https://raw.githubusercontent.com/Ax51/nvim_config/main/coder-bootstrap.sh | sh
#
# Useful overrides:
#   NVIM_CONFIG_REPO=https://github.com/Ax51/nvim_config.git
#   NVIM_CONFIG_BRANCH=main
#   NVIM_CONFIG_DIR="$HOME/.config/nvim"

NVIM_CONFIG_REPO="${NVIM_CONFIG_REPO:-https://github.com/Ax51/nvim_config.git}"
NVIM_CONFIG_BRANCH="${NVIM_CONFIG_BRANCH:-main}"
NVIM_CONFIG_DIR="${NVIM_CONFIG_DIR:-$HOME/.config/nvim}"
LOCAL_BIN="${LOCAL_BIN:-$HOME/.local/bin}"
LOCAL_NVIM_DIR="${LOCAL_NVIM_DIR:-$HOME/.local/nvim}"
NVIM_BIN="$LOCAL_BIN/nvim"

MASON_PACKAGES="${MASON_PACKAGES:-lua-language-server pyright typescript-language-server deno biome mdx-analyzer css-lsp taplo bash-language-server marksman json-lsp rust-analyzer eslint_d prettierd stylua buf shfmt shellcheck}"
TS_PARSERS="${TS_PARSERS:-bash css ghactions go html javascript jsdoc json lua markdown markdown_inline proto python regex rust toml tsx typescript yaml}"

log() {
  printf '%s\n' "==> $*"
}

warn() {
  printf '%s\n' "WARN: $*" >&2
}

die() {
  printf '%s\n' "ERROR: $*" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  elif command_exists sudo; then
    sudo "$@"
  else
    die "Need root privileges for: $*"
  fi
}

install_each() {
  installer="$1"
  shift

  for package_name in "$@"; do
    if ! $installer "$package_name"; then
      warn "Could not install OS package: $package_name"
    fi
  done
}

apt_install() {
  as_root apt-get install -y "$1"
}

dnf_install() {
  as_root dnf install -y "$1"
}

yum_install() {
  as_root yum install -y "$1"
}

apk_install() {
  as_root apk add --no-cache "$1"
}

brew_install() {
  brew install "$1"
}

install_os_packages() {
  log "Installing OS packages"

  if command_exists apt-get; then
    as_root apt-get update
    install_each apt_install \
      bash \
      build-essential \
      ca-certificates \
      curl \
      fd-find \
      fzf \
      git \
      golang-go \
      gzip \
      luajit \
      luarocks \
      nodejs \
      npm \
      pkg-config \
      protobuf-compiler \
      python3 \
      python3-pip \
      python3-venv \
      ripgrep \
      shellcheck \
      shfmt \
      tar \
      unzip \
      wl-clipboard \
      xclip \
      xz-utils \
      zsh
  elif command_exists dnf; then
    install_each dnf_install \
      bash \
      ca-certificates \
      curl \
      fd-find \
      fzf \
      gcc \
      gcc-c++ \
      git \
      golang \
      gzip \
      luajit \
      luarocks \
      make \
      nodejs \
      npm \
      pkg-config \
      protobuf-compiler \
      python3 \
      python3-pip \
      ripgrep \
      ShellCheck \
      shfmt \
      tar \
      unzip \
      wl-clipboard \
      xclip \
      xz \
      zsh
  elif command_exists yum; then
    install_each yum_install \
      bash \
      ca-certificates \
      curl \
      fzf \
      gcc \
      gcc-c++ \
      git \
      golang \
      gzip \
      make \
      nodejs \
      npm \
      pkgconfig \
      python3 \
      python3-pip \
      ripgrep \
      tar \
      unzip \
      xclip \
      xz \
      zsh
  elif command_exists apk; then
    install_each apk_install \
      bash \
      build-base \
      ca-certificates \
      curl \
      fd \
      fzf \
      git \
      go \
      gzip \
      luajit \
      luarocks \
      nodejs \
      npm \
      pkgconf \
      protobuf \
      python3 \
      py3-pip \
      ripgrep \
      shellcheck \
      shfmt \
      tar \
      unzip \
      wl-clipboard \
      xclip \
      xz \
      zsh
  elif command_exists brew; then
    install_each brew_install \
      bash \
      bufbuild/buf/buf \
      curl \
      fd \
      fzf \
      git \
      go \
      luajit \
      luarocks \
      node \
      pkg-config \
      protobuf \
      python \
      ripgrep \
      shellcheck \
      shfmt \
      tree-sitter \
      unzip \
      xz \
      zsh
  else
    warn "No supported package manager found. Install curl, git, gcc/make, zsh, node/npm, python3, ripgrep, fd, fzf, luajit, shellcheck, shfmt, and clipboard tools manually."
  fi

  mkdir -p "$LOCAL_BIN"

  if ! command_exists fd && command_exists fdfind; then
    ln -sf "$(command -v fdfind)" "$LOCAL_BIN/fd"
  fi
}

download_file() {
  url="$1"
  output="$2"

  if command_exists curl; then
    curl -fL "$url" -o "$output"
  elif command_exists wget; then
    wget -O "$output" "$url"
  else
    die "Need curl or wget to download $url"
  fi
}

install_neovim() {
  log "Installing Neovim"

  mkdir -p "$LOCAL_BIN"

  os_name="$(uname -s)"
  arch_name="$(uname -m)"

  if [ "$os_name" != "Linux" ]; then
    if command_exists nvim; then
      NVIM_BIN="$(command -v nvim)"
      export NVIM_BIN
      warn "Non-Linux OS detected; using existing nvim at $NVIM_BIN"
      return
    fi
    die "This bootstrap installs Neovim release archives only on Linux."
  fi

  case "$arch_name" in
    x86_64|amd64)
      nvim_asset_arch="x86_64"
      nvim_legacy_asset="nvim-linux64.tar.gz"
      ;;
    aarch64|arm64)
      nvim_asset_arch="arm64"
      nvim_legacy_asset="nvim-linux-arm64.tar.gz"
      ;;
    *)
      die "Unsupported CPU architecture for Neovim archive: $arch_name"
      ;;
  esac

  tmp_dir="$(mktemp -d)"
  nvim_archive="$tmp_dir/nvim.tar.gz"
  nvim_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-$nvim_asset_arch.tar.gz"

  if ! download_file "$nvim_url" "$nvim_archive"; then
    legacy_url="https://github.com/neovim/neovim/releases/latest/download/$nvim_legacy_asset"
    warn "Could not download $nvim_url; trying $legacy_url"
    download_file "$legacy_url" "$nvim_archive"
  fi

  rm -rf "$tmp_dir/extract"
  mkdir -p "$tmp_dir/extract"
  tar -xzf "$nvim_archive" -C "$tmp_dir/extract"
  extracted_dir="$(find "$tmp_dir/extract" -mindepth 1 -maxdepth 1 -type d | head -n 1)"

  [ -n "$extracted_dir" ] || die "Neovim archive did not contain an extracted directory"

  rm -rf "$LOCAL_NVIM_DIR"
  mv "$extracted_dir" "$LOCAL_NVIM_DIR"
  ln -sf "$LOCAL_NVIM_DIR/bin/nvim" "$LOCAL_BIN/nvim"
  rm -rf "$tmp_dir"
}

ensure_profile_path() {
  # shellcheck disable=SC2016
  path_line='export PATH="$HOME/.local/bin:$HOME/.local/share/nvim/mason/bin:$HOME/.cargo/bin:$HOME/.bun/bin:$HOME/.deno/bin:$HOME/go/bin:$PATH"'

  for profile_file in "$HOME/.profile" "$HOME/.zshrc"; do
    if [ ! -f "$profile_file" ] || ! grep -F "$path_line" "$profile_file" >/dev/null 2>&1; then
      {
        printf '\n%s\n' '# Added by nvim coder bootstrap'
        printf '%s\n' "$path_line"
      } >> "$profile_file"
    fi
  done

  export PATH="$HOME/.local/bin:$HOME/.local/share/nvim/mason/bin:$HOME/.cargo/bin:$HOME/.bun/bin:$HOME/.deno/bin:$HOME/go/bin:$PATH"
}

install_rust() {
  if command_exists cargo; then
    return
  fi

  log "Installing Rust toolchain"
  curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal
  export PATH="$HOME/.cargo/bin:$PATH"
}

install_bun() {
  if command_exists bun; then
    return
  fi

  log "Installing Bun"
  curl -fsSL https://bun.sh/install | bash
  export PATH="$HOME/.bun/bin:$PATH"
}

install_deno() {
  if command_exists deno; then
    return
  fi

  log "Installing Deno"
  curl -fsSL https://deno.land/install.sh | sh
  export PATH="$HOME/.deno/bin:$PATH"
}

cargo_install_crate_if_missing() {
  binary_name="$1"
  crate_name="$2"

  if command_exists "$binary_name"; then
    return
  fi

  if ! command_exists cargo; then
    warn "Skipping $binary_name because cargo is unavailable"
    return
  fi

  log "Installing $binary_name with cargo"
  if ! cargo install --locked "$crate_name"; then
    warn "Could not install $binary_name with cargo"
  fi
}

install_lazygit() {
  if command_exists lazygit; then
    return
  fi

  if command_exists go; then
    log "Installing lazygit with go"
    GOBIN="$LOCAL_BIN" go install github.com/jesseduffield/lazygit@latest || warn "Could not install lazygit with go"
  else
    warn "Skipping lazygit because go is unavailable"
  fi
}

install_runtime_clis() {
  install_rust
  install_bun
  install_deno

  cargo_install_crate_if_missing yazi yazi-fm
  cargo_install_crate_if_missing ya yazi-cli
  cargo_install_crate_if_missing zellij zellij
  cargo_install_crate_if_missing viu viu
  install_lazygit
}

backup_existing_config() {
  if [ -e "$NVIM_CONFIG_DIR" ] || [ -L "$NVIM_CONFIG_DIR" ]; then
    backup_path="$NVIM_CONFIG_DIR.bak.$(date +%Y%m%d%H%M%S)"
    log "Moving existing Neovim config to $backup_path"
    mv "$NVIM_CONFIG_DIR" "$backup_path"
  fi
}

clone_config() {
  log "Cloning Neovim config"
  mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"
  git clone --depth 1 --branch "$NVIM_CONFIG_BRANCH" "$NVIM_CONFIG_REPO" "$NVIM_CONFIG_DIR"
}

sync_lazy() {
  log "Installing Lazy.nvim plugins"
  "$NVIM_BIN" --headless "+Lazy! sync" +qa
}

install_mason_packages() {
  log "Installing Mason packages"

  mason_script="$(mktemp)"
  cat > "$mason_script" <<'LUA'
local packages = {}
for name in string.gmatch(vim.env.MASON_PACKAGES or "", "%S+") do
  table.insert(packages, name)
end

local ok_lazy, lazy = pcall(require, "lazy")
if ok_lazy then
  lazy.load({ plugins = { "mason.nvim" } })
end

local ok_mason, mason = pcall(require, "mason")
if not ok_mason then
  vim.api.nvim_err_writeln("mason.nvim is not available")
  vim.cmd("cquit")
end

mason.setup()

local registry = require("mason-registry")
local failed = {}
local refreshed = false

registry.refresh(function()
  refreshed = true
end)

if not vim.wait(120000, function()
  return refreshed
end, 100) then
  vim.api.nvim_err_writeln("Timed out refreshing Mason registry")
  vim.cmd("cquit")
end

for _, name in ipairs(packages) do
  local ok_pkg, pkg = pcall(registry.get_package, name)
  if not ok_pkg then
    table.insert(failed, name .. " (not found in Mason registry)")
  elseif not pkg:is_installed() then
    local ok_install, err = pcall(function()
      pkg:install()
    end)
    if not ok_install then
      table.insert(failed, name .. " (" .. tostring(err) .. ")")
    end
  end
end

local function installs_finished()
  for _, name in ipairs(packages) do
    local ok_pkg, pkg = pcall(registry.get_package, name)
    if ok_pkg and pkg:is_installing() then
      return false
    end
  end
  return true
end

if not vim.wait(900000, installs_finished, 500) then
  table.insert(failed, "timeout waiting for Mason installs")
end

for _, name in ipairs(packages) do
  local ok_pkg, pkg = pcall(registry.get_package, name)
  if ok_pkg and not pkg:is_installed() then
    table.insert(failed, name .. " (install did not complete)")
  end
end

if #failed > 0 then
  vim.api.nvim_err_writeln("Mason failures:")
  for _, item in ipairs(failed) do
    vim.api.nvim_err_writeln("  - " .. item)
  end
  vim.cmd("cquit")
end

vim.cmd("qa")
LUA

  MASON_PACKAGES="$MASON_PACKAGES" "$NVIM_BIN" --headless "+luafile $mason_script"
  rm -f "$mason_script"
}

install_treesitter_parsers() {
  log "Installing tree-sitter parsers"

  ts_script="$(mktemp)"
  cat > "$ts_script" <<'LUA'
local parsers = {}
for name in string.gmatch(vim.env.TS_PARSERS or "", "%S+") do
  table.insert(parsers, name)
end

local ok_lazy, lazy = pcall(require, "lazy")
if ok_lazy then
  lazy.load({ plugins = { "nvim-treesitter" } })
end

local ok_parsers, parser_config = pcall(require, "nvim-treesitter.parsers")
if not ok_parsers then
  vim.api.nvim_err_writeln("nvim-treesitter parser module is not available")
  vim.cmd("cquit")
end

parser_config.ghactions = {
  install_info = {
    url = "https://github.com/rmuir/tree-sitter-ghactions",
    queries = "queries",
  },
}

local failed = {}
for _, name in ipairs(parsers) do
  local ok_install, err = pcall(vim.cmd, "TSInstallSync " .. name)
  if not ok_install then
    table.insert(failed, name .. " (" .. tostring(err) .. ")")
  end
end

if #failed > 0 then
  vim.api.nvim_err_writeln("Tree-sitter parser failures:")
  for _, item in ipairs(failed) do
    vim.api.nvim_err_writeln("  - " .. item)
  end
  vim.cmd("cquit")
end

vim.cmd("qa")
LUA

  TS_PARSERS="$TS_PARSERS" "$NVIM_BIN" --headless "+luafile $ts_script"
  rm -f "$ts_script"
}

report_missing_optional_tools() {
  missing=""

  for tool_name in claude codex cursor copilot; do
    if ! command_exists "$tool_name"; then
      missing="$missing $tool_name"
    fi
  done

  if [ -n "$missing" ]; then
    warn "Sidekick AI CLI tools are not auto-installed because they require vendor-specific auth/setup. Missing:$missing"
  fi
}

main() {
  ensure_profile_path
  install_os_packages
  install_neovim
  install_runtime_clis
  backup_existing_config
  clone_config
  sync_lazy
  install_mason_packages
  install_treesitter_parsers
  report_missing_optional_tools

  log "Done. Start Neovim with: $NVIM_BIN"
}

main "$@"
