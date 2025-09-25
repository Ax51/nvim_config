# Repository Guidelines

## Project Structure & Module Organization
- Core Neovim configuration lives under `init.lua` with modular pieces in `lua/core`. Key entry points: `lua/core/init.lua` wires mappings, plugin setup, and LSP configuration, while `lua/core/lsp.lua` enables language servers via `vim.lsp.enable`.
- Plugins are managed as individual specs in `lua/plugins`, each file represents single plugin configuration and returns a table consumed by Lazy.nvim. `lazy-lock.json` pins exact plugin commits. `lazy-lock.json` file is managed by `Lazy.nvim` plugin and shouldn't been touched manually.
- Single `lua/themes/tokyonight.lua` file represents nvim theme configuration.
- `lua/missing_vim_uv_types/uv.lua` file contains type definitions that are missing by default for vim. This file was taken as-is and shouldn't been touched or modified.
- Shared helpers reside in `lua/utils` (e.g., `utils/keymappings.lua` for declarative keymap helpers). Markdown notes being ignored by git sit in `notes/`.

## Build, Test, and Development Commands
- `:Lazy sync` inside Neovim installs or updates plugins based on `lua/plugins`. Run after editing plugin specs.
- `:checkhealth` verifies core dependencies (treesitter, LSP, tooling) and surfaces actionable diagnostics.
- `:Mason` opens the Mason UI for external tool management when new language servers or formatters are required.

## Coding Style & Naming Conventions
- Follow `.editorconfig`: UTF‑8, LF endings, 2‑space indentation. Lua files prefer `snake_case` locals and module tables (e.g., `config_ts_lsps`).
- Configuration modules export explicit tables: `return { ... }` for plugin specs or `return M` for utility modules.
- Keep inline comments minimal and purposeful; prefer top-of-block notes for complex behaviour.

## Testing Guidelines
- Use `:checkhealth` and relevant plugin commands (`:Neotest run`, `:Neotest summary`) to validate integrations. Demo mappings in scratch buffers before committing.
- When adding LSP or formatting tweaks, open a sample project and confirm no spurious diagnostics. Capture failures with `:messages`.

## Commit & Pull Request Guidelines
- Commit messages always prefixes with one of the following keyword representing what was changed in that certain commit:
  - fix:
  - feat:
  - docs:
  - style:
  - refactor:
  - test:
  - chore:
  - ci:
  - perf:
  - improvement:
  - breaking:
  - revert
- Commit messages mirror terse imperative style seen in history: `Add conform formatter autocmd`, `Tweak blink completion`. Group related edits per commit.
- Pull requests should outline affected modules (`lua/core/lsp.lua`, `lua/plugins/*`), list manual test steps, and reference issue numbers if tracking work externally. Screenshot UI changes (statusline, telescope prompts) when relevant.

## Agent-Specific Notes
- Reload configuration quickly via `:source %` when editing Lua modules within Neovim. For large refactors, restart Neovim to ensure plugin state resets.
- Prefer `rg` and `lua vim.print(...)` for inspection; avoid adding temporary debug logging to tracked files.
