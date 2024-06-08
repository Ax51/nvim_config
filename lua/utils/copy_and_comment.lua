-- NOTE: copy selected lines, paste them below and comment repeated lines
local function copyNCommentSelectedLines()
  local comApi = require("Comment.api")
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)

  local initialCursorPos = vim.api.nvim_win_get_cursor(0)
  local startLine = vim.fn.getpos("'<")[2]
  local endLine = vim.fn.getpos("'>")[2]
  local diffLines = math.abs(startLine - endLine)

  vim.cmd("'<,'>t'>")
  vim.api.nvim_win_set_cursor(0, { endLine + 1, 0 })
  comApi.comment.linewise.count(diffLines + 1)
  vim.api.nvim_win_set_cursor(0, initialCursorPos)
end

return copyNCommentSelectedLines
