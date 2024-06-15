---delete all buffers, expect active one
local close_all_bufs_except_current = function()
  local rawBufArr = vim.api.nvim_list_bufs()
  local currBufNum = vim.api.nvim_get_current_buf()

  for _, bufnr in ipairs(rawBufArr) do
    if bufnr ~= currBufNum and vim.fn.buflisted(bufnr) and not vim.api.nvim_get_option_value("modified", {}) then
      vim.api.nvim_buf_delete(bufnr, {})
    end
  end
end

return close_all_bufs_except_current
