local M = {};

local function get_visual_selection_coordinates()
  local coordinates = {}

  coordinates.start_pos = vim.fn.getpos("v")
  coordinates.end_pos = vim.fn.getpos(".")

  return coordinates;
end

function M.get_visual_selection()
  local selection_coordinates = get_visual_selection_coordinates()
  local s_start = selection_coordinates.start_pos
  local s_end = selection_coordinates.end_pos

  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)

  lines[1] = string.sub(lines[1], s_start[3], -1)

  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end

  return lines
end

---@param start_coord number[]
---@param end_coord number[]
---@return string[]
function M.get_text_from_provided_coords(start_coord, end_coord)
  local n_lines = math.abs(end_coord[2] - start_coord[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, start_coord[2] - 1, end_coord[2], false)

  lines[1] = string.sub(lines[1], start_coord[3], -1)

  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, end_coord[3] - start_coord[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, end_coord[3])
  end

  return lines
end

function M.get_paragraph_under_cursor()
  -- Save the current cursor position
  local current_pos = vim.api.nvim_win_get_cursor(0)

  -- Execute the 'vip' command to select the paragraph
  vim.cmd('normal! vip')

  -- Return to normal mode (and save visual selection coordinates)
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)

  -- Restore the original cursor position
  vim.api.nvim_win_set_cursor(0, current_pos)

  -- Get previously selected lines as a table of strings
  local lines = M.get_text_from_provided_coords(vim.fn.getpos("'<"), vim.fn.getpos("'>"))

  -- Return table of lines
  return lines
end

return M;
