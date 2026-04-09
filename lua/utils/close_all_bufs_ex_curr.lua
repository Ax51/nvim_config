--- Delete all listed buffers except the active one.
local close_all_bufs_except_current = function()
  local api = vim.api
  local raw_bufs = api.nvim_list_bufs()
  local current_buf = api.nvim_get_current_buf()
  local skipped_modified = 0
  local failed = 0

  for _, bufnr in ipairs(raw_bufs) do
    if bufnr ~= current_buf and api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
      if vim.bo[bufnr].modified then
        skipped_modified = skipped_modified + 1
      else
        -- Use bdelete-like behavior instead of wiping buffer metadata.
        local was_listed = vim.bo[bufnr].buflisted
        vim.bo[bufnr].buflisted = false

        local ok = pcall(api.nvim_buf_delete, bufnr, { unload = true })
        if not ok and api.nvim_buf_is_valid(bufnr) then
          vim.bo[bufnr].buflisted = was_listed
          failed = failed + 1
        end
      end
    end
  end

  if skipped_modified > 0 or failed > 0 then
    local parts = {}

    if skipped_modified > 0 then
      table.insert(parts, string.format("skipped %d modified buffer(s)", skipped_modified))
    end

    if failed > 0 then
      table.insert(parts, string.format("failed to close %d buffer(s)", failed))
    end

    vim.notify(table.concat(parts, ", "), vim.log.levels.WARN)
  end
end

return close_all_bufs_except_current
