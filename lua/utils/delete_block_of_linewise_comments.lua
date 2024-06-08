return function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor_pos[1]
  local total_lines = vim.api.nvim_buf_line_count(bufnr)

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local U = require("Comment.utils")
  local F = require("Comment.ft")
  local ctx = {
    cmode = U.cmode.comment,
    cmotion = U.cmotion.line,
    ctype = 1, -- NOTE: linewise
    range = { srow = row, scol = col, erow = row, ecol = col },
  }

  -- Get the comment regex from Comment.nvim
  local comment_pattern = F.calculate(ctx)

  if not comment_pattern then
    print("No comment pattern found for this filetype.")
    return
  end

  -- Escape Lua magic characters in the regex
  comment_pattern = vim.pesc(comment_pattern):gsub("%%%%s", "")

  -- Detect start of the comment block
  local start_line = nil
  for i = current_line, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    if not line:match("^%s*" .. comment_pattern) then
      break
    end
    start_line = i
  end

  -- Detect end of the comment block
  local end_line = nil
  for i = current_line, total_lines do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    if not line:match("^%s*" .. comment_pattern) then
      break
    end
    end_line = i
  end

  -- Delete the comment block
  if start_line and end_line then
    if start_line == end_line then
      print("deleted", start_line, "line")
    else
      print("deleted lines from", start_line, "to", end_line)
    end
    vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, false, {})
  end
end
