# Neovim Config

Personal Neovim configuration managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

Core configuration lives in `lua/core`, plugin specs live in `lua/plugins`, LSP server configs live in `lsp`, and theme settings live in `lua/themes`.

## Fresh Machine Bootstrap

On a fresh Coder or remote development machine, run:

```sh
curl -fsSL \
  -H "Cache-Control: no-cache" \
  "https://raw.githubusercontent.com/Ax51/nvim_config/main/coder-bootstrap.sh?$(date +%s)" | sh
```

The bootstrap script installs Neovim, backs up any existing `~/.config/nvim` directory to `~/.config/nvim.bak.<timestamp>`, clones this config, installs required CLI tools, syncs Lazy plugins, installs Mason packages, and installs tree-sitter parsers.

The script can be customized with environment variables:

```sh
NVIM_CONFIG_BRANCH=main \
NVIM_CONFIG_DIR="$HOME/.config/nvim" \
curl -fsSL \
  -H "Cache-Control: no-cache" \
  "https://raw.githubusercontent.com/Ax51/nvim_config/main/coder-bootstrap.sh?$(date +%s)" | sh
```

The timestamp query avoids stale responses from CDN or corporate proxy caches while still serving the same `main` branch file.

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
