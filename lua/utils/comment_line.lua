local M = {}

---@param ref_position [integer, integer]
---@return string
local function get_commentstring(ref_position)
  local buf_cs = vim.bo.commentstring

  local ok, ts_parser = pcall(vim.treesitter.get_parser, 0, "")
  if not ok or not ts_parser then
    return buf_cs
  end

  local row, col = ref_position[1] - 1, ref_position[2]
  local caps = vim.treesitter.get_captures_at_pos(0, row, col)

  for i = #caps, 1, -1 do
    local id = caps[i].id
    local metadata = caps[i].metadata
    local capture_metadata = metadata[id]
    local ts_cs = metadata["bo.commentstring"] or capture_metadata and capture_metadata["bo.commentstring"]

    if ts_cs then
      return ts_cs
    end
  end

  local ref_range = { row, col, row, col + 1 }
  local ts_cs
  local deepest_level = 0

  ---@param lang_tree vim.treesitter.LanguageTree
  ---@param level integer
  local function traverse(lang_tree, level)
    if not lang_tree:contains(ref_range) then
      return
    end

    local filetypes = vim.treesitter.language.get_filetypes(lang_tree:lang())
    for _, filetype in ipairs(filetypes) do
      local current_cs = vim.filetype.get_option(filetype, "commentstring")
      if current_cs ~= "" and level > deepest_level then
        ts_cs = current_cs
        deepest_level = level
      end
    end

    for _, child_lang_tree in pairs(lang_tree:children()) do
      traverse(child_lang_tree, level + 1)
    end
  end

  traverse(ts_parser, 1)

  return ts_cs or buf_cs
end

---@param ref_position [integer, integer]
---@return string, string
local function get_comment_parts(ref_position)
  local commentstring = get_commentstring(ref_position)

  if commentstring == nil or commentstring == "" then
    vim.notify("Option 'commentstring' is empty.", vim.log.levels.WARN)
    return "", ""
  end

  local left, right = commentstring:match("^(.-)%%s(.-)$")
  if not left or not right then
    error(vim.inspect(commentstring) .. " is not a valid 'commentstring'.")
  end

  return left, right
end

---@param insert_above boolean
local function add_commented_line(insert_above)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local indent = line:match("^%s*") or ""
  local left, right = get_comment_parts(cursor)

  if left == "" and right == "" then
    return
  end

  local content_padding = left:match("%s$") and "" or " "
  local new_line = indent .. left .. content_padding .. right
  local target_line = insert_above and cursor[1] - 1 or cursor[1]
  local insert_col = #indent + #left + #content_padding

  vim.api.nvim_buf_set_lines(0, target_line, target_line, false, { new_line })
  if right == "" then
    vim.api.nvim_win_set_cursor(0, { target_line + 1, math.max(insert_col - 1, 0) })
    vim.cmd("startinsert!")
    return
  end

  vim.api.nvim_win_set_cursor(0, { target_line + 1, insert_col })
  vim.cmd("startinsert")
end

function M.below()
  add_commented_line(false)
end

function M.above()
  add_commented_line(true)
end

return M
