local function config_ts_lsps()
  local tss_root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' };
  local deno_root_markers = { 'deno.json', 'deno.jsonc' };

  vim.lsp.config("deno", {
    root_dir = function(fname, cb)
      local deno_root = vim.fs.root(fname, deno_root_markers)

      -- NOTE: run only in case project has `deno` related files
      if deno_root ~= nil then
        cb(deno_root)
      end
    end
  })

  vim.lsp.config("tsls", {
    root_dir = function(fname, cb)
      local deno_root_project = vim.fs.root(fname, deno_root_markers)

      -- NOTE: don't run in case this is a deno project
      if deno_root_project ~= nil then
        return
      end

      local ts_root_path = vim.fs.root(fname, tss_root_markers);

      if ts_root_path ~= nil then
        cb(ts_root_path)
      end
    end,
  })
end

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

config_ts_lsps();

vim.lsp.enable({
  "luals",
  "pyright",
  "tsls",
  "deno",
  "biome",
  "mdx_analyzer",
  "cssls",
  "taplo",
  "bashls",
  "marksman",
  "jsonls",
})
vim.diagnostic.config({ virtual_text = true })
