local closeAllBufsExceptCurrent = function() -- delete all buffers, expect active one
	local rawBufArr = vim.api.nvim_list_bufs()
	local currBufNum = vim.api.nvim_get_current_buf()

	for _, value in ipairs(rawBufArr) do
		if value ~= currBufNum and vim.fn.buflisted(value) then
			vim.api.nvim_buf_delete(value, {})
		end
	end
end

return closeAllBufsExceptCurrent
