# Neovim Config

Personal Neovim configuration managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

Core configuration lives in `lua/core`, plugin specs live in `lua/plugins`, LSP server configs live in `lsp`, and theme settings live in `lua/themes`.

## Fresh Machine Bootstrap

On a fresh GitHub Codespaces, Coder, or remote development machine, run:

```sh
curl -fsSL \
  -H "Cache-Control: no-cache" \
  "https://raw.githubusercontent.com/Ax51/nvim_config/main/ssh-bootstrap.sh?$(date +%s)" | sh
```

The bootstrap script installs Neovim, backs up any existing `~/.config/nvim` directory to `~/.config/nvim.bak.<timestamp>`, clones this config, installs required CLI tools, syncs Lazy plugins, installs Mason packages, and installs tree-sitter parsers.

It also links Yazi, lazygit, and Zellij settings to the tracked files in `config/` and runs `ya pkg install` to restore Yazi's locked packages. Existing settings are preserved in adjacent `.bak.XXXXXX/original` backups.

## Shared CLI Settings

`config/yazi/`, `config/lazygit/config.yml`, and `config/zellij/config.kdl` are the source of truth. To link an existing machine without running the full bootstrap:

```sh
sh scripts/link-cli-config.sh
```

Run this from the cloned repository with Yazi installed. The script is safe to rerun. It respects `XDG_CONFIG_HOME`, `YAZI_CONFIG_HOME`, and `ZELLIJ_CONFIG_DIR`, and asks `lazygit --print-config-dir` for lazygit's active directory (or accepts `LAZYGIT_CONFIG_DIR`).

Yazi's entire config directory is linked so new settings files and package-manager updates also land in the repository. Only lazygit's `config.yml` and Zellij's `config.kdl` are linked; other files remain local. Installed Yazi plugins and flavors are ignored by Git and restored from `package.toml`.

Editing settings through their usual paths edits the repository files directly. Commit and push those changes to make them available to new machines; existing machines receive them with `git pull`. After package changes, run `ya pkg install`. After upgrading Yazi, use `ya pkg upgrade` if plugin compatibility requires it, then commit the updated `package.toml`.

The script can be customized with environment variables:

```sh
NVIM_CONFIG_BRANCH=main \
NVIM_CONFIG_DIR="$HOME/.config/nvim" \
curl -fsSL \
  -H "Cache-Control: no-cache" \
  "https://raw.githubusercontent.com/Ax51/nvim_config/main/ssh-bootstrap.sh?$(date +%s)" | sh
```

The timestamp query avoids stale responses from CDN or corporate proxy caches while still serving the same `main` branch file.

For troubleshooting network failures, enable verbose mode:

```sh
BOOTSTRAP_VERBOSE=1 \
curl -fsSL \
  -H "Cache-Control: no-cache" \
  "https://raw.githubusercontent.com/Ax51/nvim_config/main/ssh-bootstrap.sh?$(date +%s)" | sh
```

By default the script installs `zsh` for Neovim shell usage but does not change the account login shell. To make new SSH sessions start in `zsh`, run:

```sh
SET_ZSH_LOGIN_SHELL=1 \
curl -fsSL \
  -H "Cache-Control: no-cache" \
  "https://raw.githubusercontent.com/Ax51/nvim_config/main/ssh-bootstrap.sh?$(date +%s)" | sh
```

## Manual Setup

If the config is already cloned, open Neovim and run:

```vim
:Lazy sync
:checkhealth
```

Use `:Mason` to inspect or manage external language servers, formatters, linters, and other developer tools.

## Layout

- `init.lua` loads the core config.
- `lua/core` contains editor options, mappings, Lazy setup, and LSP enablement.
- `lua/plugins` contains individual Lazy plugin specs.
- `lsp` contains native Neovim LSP server configs.
- `lua/utils` contains shared helper modules.
- `lua/themes/tokyonight.lua` contains the theme config.
- `queries` contains custom tree-sitter queries.
- `snippets` contains LuaSnip snippets.

## Notes

- `lazy-lock.json` is managed by Lazy.nvim and should not be edited manually.
- `lua/missing_vim_uv_types/uv.lua` is vendored type data and should be left unchanged.
- For large config changes, restart Neovim after editing so plugin state is reset cleanly.
