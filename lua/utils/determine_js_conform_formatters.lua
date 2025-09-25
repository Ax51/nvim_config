local M = {}

function M.determine_formatter(bufnr)
  local fallback_formatters = { "prettierd", "prettier" }

  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == "" then
    return fallback_formatters
  end

  local dirname = vim.fs.dirname(bufname)
  if not dirname then
    return fallback_formatters
  end

  local eslint_pattern = "%.?eslint.?r?c?%.?[%a]*"
  local eslint_root = vim.fs.find(function(name)
    return name:match(eslint_pattern) ~= nil
  end, {
    path = dirname,
    upward = true,
  }) or {}

  if #eslint_root > 0 then
    return { "eslint_d" }
  end

  local biome_root = vim.fs.find("biome.json", {
    path = dirname,
    upward = true,
  }) or {}

  if #biome_root > 0 then
    return { "biome" }
  end

  return fallback_formatters
end

return M
