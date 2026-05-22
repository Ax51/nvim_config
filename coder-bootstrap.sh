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

detect_home_dir() {
  if [ -n "${HOME:-}" ]; then
    printf '%s\n' "$HOME"
    return
  fi

  current_uid="$(id -u 2>/dev/null || true)"
  current_user="$(id -un 2>/dev/null || true)"

  if [ -n "$current_user" ] && command -v getent >/dev/null 2>&1; then
    detected_home="$(getent passwd "$current_user" | awk -F: '{ print $6; exit }' || true)"
    if [ -n "$detected_home" ]; then
      printf '%s\n' "$detected_home"
      return
    fi
  fi

  case "$current_user" in
    ""|*[!A-Za-z0-9._-]*)
      ;;
    *)
      detected_home="$(eval "printf '%s' ~$current_user" 2>/dev/null || true)"
      if [ -n "$detected_home" ] && [ "$detected_home" != "~$current_user" ]; then
        printf '%s\n' "$detected_home"
        return
      fi
      ;;
  esac

  if [ -n "$current_uid" ] && [ -r /etc/passwd ]; then
    detected_home="$(awk -F: -v uid="$current_uid" '$3 == uid { print $6; exit }' /etc/passwd || true)"
    if [ -n "$detected_home" ]; then
      printf '%s\n' "$detected_home"
      return
    fi
  fi

  if [ -n "${PWD:-}" ]; then
    printf '%s\n' "$PWD"
    return
  fi

  printf '%s\n' "ERROR: HOME is unset and no fallback home directory could be detected" >&2
  exit 1
}

HOME="$(detect_home_dir)"
export HOME

NVIM_CONFIG_REPO="${NVIM_CONFIG_REPO:-https://github.com/Ax51/nvim_config.git}"
NVIM_CONFIG_BRANCH="${NVIM_CONFIG_BRANCH:-main}"
NVIM_CONFIG_DIR="${NVIM_CONFIG_DIR:-$HOME/.config/nvim}"
LOCAL_BIN="${LOCAL_BIN:-$HOME/.local/bin}"
LOCAL_NVIM_DIR="${LOCAL_NVIM_DIR:-$HOME/.local/nvim}"
NVIM_BIN="$LOCAL_BIN/nvim"

MASON_PACKAGES="${MASON_PACKAGES:-lua-language-server pyright typescript-language-server deno biome mdx-analyzer css-lsp taplo bash-language-server marksman json-lsp rust-analyzer eslint_d prettierd stylua buf shfmt shellcheck}"
TS_PARSERS="${TS_PARSERS:-bash css ghactions go html javascript jsdoc json lua markdown markdown_inline proto python regex rust toml tsx typescript yaml}"
TREE_SITTER_CLI_NPM_VERSION="${TREE_SITTER_CLI_NPM_VERSION:-0.25.9}"

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
      tree-sitter-cli \
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
      tree-sitter-cli \
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
      tree-sitter-cli \
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
      tree-sitter-cli \
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
    warn "No supported package manager found. Install curl, git, gcc/make, zsh, node/npm, python3, ripgrep, fd, fzf, luajit, shellcheck, shfmt, tree-sitter-cli, and clipboard tools manually."
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
  path_line='export PATH="$HOME/.local/bin:$HOME/.local/share/nvim/mason/bin:$HOME/.bun/bin:$HOME/.deno/bin:$HOME/go/bin:$PATH"'

  for profile_file in "$HOME/.profile" "$HOME/.zshrc"; do
    if [ ! -f "$profile_file" ] || ! grep -F "$path_line" "$profile_file" >/dev/null 2>&1; then
      {
        printf '\n%s\n' '# Added by nvim coder bootstrap'
        printf '%s\n' "$path_line"
      } >> "$profile_file"
    fi
  done

  export PATH="$HOME/.local/bin:$HOME/.local/share/nvim/mason/bin:$HOME/.bun/bin:$HOME/.deno/bin:$HOME/go/bin:$PATH"
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

tree_sitter_cli_works() {
  command_exists tree-sitter \
    && tree-sitter --version >/dev/null 2>&1 \
    && tree-sitter build --help >/dev/null 2>&1
}

install_rust() {
  if command_exists cargo; then
    return 0
  fi

  log "Installing Rust toolchain for tree-sitter-cli fallback"
  if ! curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal; then
    warn "Could not install Rust toolchain"
    return 1
  fi

  export PATH="$HOME/.cargo/bin:$PATH"
}

install_tree_sitter_cli() {
  if tree_sitter_cli_works; then
    return
  fi

  if command_exists npm; then
    log "Installing tree-sitter CLI with npm"
    npm install -g --prefix "$HOME/.local" "tree-sitter-cli@$TREE_SITTER_CLI_NPM_VERSION" \
      || warn "Could not install tree-sitter CLI with npm"

    if tree_sitter_cli_works; then
      return
    fi
  fi

  if install_rust; then
    log "Installing tree-sitter CLI from source with cargo"
    cargo install --locked --root "$HOME/.local" "tree-sitter-cli" \
      || warn "Could not install tree-sitter CLI with cargo"

    if tree_sitter_cli_works; then
      return
    fi
  fi

  warn "tree-sitter CLI is still unavailable or incompatible; tree-sitter parser installation may fail"
}

install_yazi() {
  if command_exists yazi && command_exists ya; then
    return
  fi

  os_name="$(uname -s)"
  arch_name="$(uname -m)"

  case "$os_name:$arch_name" in
    Linux:x86_64|Linux:amd64)
      yazi_target="x86_64-unknown-linux-musl"
      ;;
    Linux:aarch64|Linux:arm64)
      yazi_target="aarch64-unknown-linux-musl"
      ;;
    Darwin:x86_64|Darwin:amd64)
      yazi_target="x86_64-apple-darwin"
      ;;
    Darwin:aarch64|Darwin:arm64)
      yazi_target="aarch64-apple-darwin"
      ;;
    *)
      warn "Skipping Yazi prebuilt install for unsupported platform: $os_name $arch_name"
      return
      ;;
  esac

  log "Installing Yazi from prebuilt release"
  tmp_dir="$(mktemp -d)"
  yazi_archive="$tmp_dir/yazi.zip"
  yazi_url="https://github.com/sxyazi/yazi/releases/latest/download/yazi-$yazi_target.zip"

  if ! download_file "$yazi_url" "$yazi_archive"; then
    rm -rf "$tmp_dir"
    warn "Could not download Yazi release archive: $yazi_url"
    return
  fi

  if ! unzip -q "$yazi_archive" -d "$tmp_dir/extract"; then
    rm -rf "$tmp_dir"
    warn "Could not extract Yazi release archive"
    return
  fi

  yazi_bin="$(find "$tmp_dir/extract" -type f -name yazi -perm -u+x | head -n 1)"
  ya_bin="$(find "$tmp_dir/extract" -type f -name ya -perm -u+x | head -n 1)"

  if [ -z "$yazi_bin" ] || [ -z "$ya_bin" ]; then
    yazi_bin="$(find "$tmp_dir/extract" -type f -name yazi | head -n 1)"
    ya_bin="$(find "$tmp_dir/extract" -type f -name ya | head -n 1)"
  fi

  if [ -z "$yazi_bin" ] || [ -z "$ya_bin" ]; then
    rm -rf "$tmp_dir"
    warn "Yazi archive did not contain both yazi and ya binaries"
    return
  fi

  mkdir -p "$LOCAL_BIN"
  cp "$yazi_bin" "$LOCAL_BIN/yazi"
  cp "$ya_bin" "$LOCAL_BIN/ya"
  chmod +x "$LOCAL_BIN/yazi" "$LOCAL_BIN/ya"
  rm -rf "$tmp_dir"
}

install_zellij() {
  if command_exists zellij; then
    return
  fi

  os_name="$(uname -s)"
  arch_name="$(uname -m)"

  case "$os_name:$arch_name" in
    Linux:x86_64|Linux:amd64)
      zellij_target="x86_64-unknown-linux-musl"
      ;;
    Linux:aarch64|Linux:arm64)
      zellij_target="aarch64-unknown-linux-musl"
      ;;
    Darwin:x86_64|Darwin:amd64)
      zellij_target="x86_64-apple-darwin"
      ;;
    Darwin:aarch64|Darwin:arm64)
      zellij_target="aarch64-apple-darwin"
      ;;
    *)
      warn "Skipping Zellij prebuilt install for unsupported platform: $os_name $arch_name"
      return
      ;;
  esac

  log "Installing Zellij from prebuilt release"
  tmp_dir="$(mktemp -d)"
  zellij_archive="$tmp_dir/zellij.tar.gz"
  zellij_url="https://github.com/zellij-org/zellij/releases/latest/download/zellij-$zellij_target.tar.gz"

  if ! download_file "$zellij_url" "$zellij_archive"; then
    rm -rf "$tmp_dir"
    warn "Could not download Zellij release archive: $zellij_url"
    return
  fi

  if ! tar -xzf "$zellij_archive" -C "$tmp_dir"; then
    rm -rf "$tmp_dir"
    warn "Could not extract Zellij release archive"
    return
  fi

  zellij_bin="$(find "$tmp_dir" -type f -name zellij -perm -u+x | head -n 1)"

  if [ -z "$zellij_bin" ]; then
    zellij_bin="$(find "$tmp_dir" -type f -name zellij | head -n 1)"
  fi

  if [ -z "$zellij_bin" ]; then
    rm -rf "$tmp_dir"
    warn "Zellij archive did not contain a zellij binary"
    return
  fi

  mkdir -p "$LOCAL_BIN"
  cp "$zellij_bin" "$LOCAL_BIN/zellij"
  chmod +x "$LOCAL_BIN/zellij"
  rm -rf "$tmp_dir"
}

install_viu() {
  if command_exists viu; then
    return
  fi

  os_name="$(uname -s)"
  arch_name="$(uname -m)"

  case "$os_name:$arch_name" in
    Linux:x86_64|Linux:amd64)
      viu_target="x86_64-unknown-linux-musl"
      ;;
    *)
      warn "Skipping Viu prebuilt install for unsupported platform: $os_name $arch_name"
      return
      ;;
  esac

  log "Installing Viu from prebuilt release"
  tmp_dir="$(mktemp -d)"
  viu_bin="$tmp_dir/viu"
  viu_url="https://github.com/atanunq/viu/releases/latest/download/viu-$viu_target"

  if ! download_file "$viu_url" "$viu_bin"; then
    rm -rf "$tmp_dir"
    warn "Could not download Viu release binary: $viu_url"
    return
  fi

  mkdir -p "$LOCAL_BIN"
  cp "$viu_bin" "$LOCAL_BIN/viu"
  chmod +x "$LOCAL_BIN/viu"
  rm -rf "$tmp_dir"
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
  install_bun
  install_deno
  install_tree_sitter_cli

  install_yazi
  install_zellij
  install_viu
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

local ok_ts, ts = pcall(require, "nvim-treesitter")
if not ok_ts then
  vim.api.nvim_err_writeln("nvim-treesitter is not available")
  vim.cmd("cquit")
end

local ok_parsers, parser_config = pcall(require, "nvim-treesitter.parsers")
if not ok_parsers then
  vim.api.nvim_err_writeln("nvim-treesitter parser module is not available")
  vim.cmd("cquit")
end

local function register_ghactions_parser()
  parser_config.ghactions = {
    install_info = {
      url = "https://github.com/rmuir/tree-sitter-ghactions",
      queries = "queries",
    },
  }
end

register_ghactions_parser()
vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    parser_config = require("nvim-treesitter.parsers")
    register_ghactions_parser()
  end,
})

local failed = {}
local install_task = ts.install(parsers, {
  max_jobs = 4,
  summary = true,
})
local ok_install, install_result = install_task:pwait(900000)

if not ok_install then
  table.insert(failed, tostring(install_result))
elseif install_result ~= true then
  table.insert(failed, "one or more parser installs failed")
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
