#!/bin/sh

set -eu

repo_dir="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd -P)"
config_root="${XDG_CONFIG_HOME:-$HOME/.config}"
yazi_config_dir="${YAZI_CONFIG_HOME:-$config_root/yazi}"
zellij_config_dir="${ZELLIJ_CONFIG_DIR:-$config_root/zellij}"
lazygit_config_dir="${LAZYGIT_CONFIG_DIR:-}"

if [ -z "$lazygit_config_dir" ]; then
  if command -v lazygit >/dev/null 2>&1; then
    lazygit_config_dir="$(lazygit --print-config-dir)"
  else
    lazygit_config_dir="$config_root/lazygit"
  fi
fi

link_config() {
  source_path="$1"
  target_path="$2"

  if [ "$source_path" = "$target_path" ]; then
    return
  fi

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    return
  fi

  mkdir -p "$(dirname -- "$target_path")"
  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    backup_dir="$(mktemp -d "$target_path.bak.XXXXXX")"
    mv "$target_path" "$backup_dir/original"
    printf 'Backed up %s to %s/original\n' "$target_path" "$backup_dir"
  fi
  ln -s "$source_path" "$target_path"
  printf 'Linked %s -> %s\n' "$target_path" "$source_path"
}

link_config "$repo_dir/config/yazi" "$yazi_config_dir"
link_config "$repo_dir/config/lazygit/config.yml" "$lazygit_config_dir/config.yml"
link_config "$repo_dir/config/zellij/config.kdl" "$zellij_config_dir/config.kdl"

if command -v ya >/dev/null 2>&1; then
  YAZI_CONFIG_HOME="$yazi_config_dir" ya pkg install
else
  printf '%s\n' 'ERROR: ya is unavailable; install Yazi and rerun this script to install its packages.' >&2
  exit 1
fi
