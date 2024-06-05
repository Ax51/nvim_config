local closeAllBufsExceptCurrent = function() -- delete all buffers, expect active one
  local rawBufArr = vim.api.nvim_list_bufs()
  local currBufNum = vim.api.nvim_get_current_buf()

  for _, bufnr in ipairs(rawBufArr) do
    if bufnr ~= currBufNum and vim.fn.buflisted(bufnr) and not vim.api.nvim_buf_get_option(bufnr, "modified") then
      vim.api.nvim_buf_delete(bufnr, {})
    end
  end
end

return closeAllBufsExceptCurrent
