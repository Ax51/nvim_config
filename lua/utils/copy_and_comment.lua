-- NOTE: copy selected lines, paste them below and comment repeated lines
local function copyNCommentSelectedLines()
  local native_comment = require("vim._comment")
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)

  local initialCursorPos = vim.api.nvim_win_get_cursor(0)
  local startLine = vim.fn.getpos("'<")[2]
  local endLine = vim.fn.getpos("'>")[2]
  local diffLines = math.abs(startLine - endLine)
  local pasted_start_line = endLine + 1
  local pasted_end_line = pasted_start_line + diffLines

  vim.cmd("'<,'>t'>")
  vim.api.nvim_win_set_cursor(0, { pasted_start_line, 0 })
  native_comment.toggle_lines(pasted_start_line, pasted_end_line, { pasted_start_line, 0 })
  vim.api.nvim_win_set_cursor(0, initialCursorPos)
end

return copyNCommentSelectedLines
