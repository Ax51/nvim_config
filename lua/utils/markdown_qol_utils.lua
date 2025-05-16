local M = {};

local function get_list_prefix(line)
  -- Matches "- [ ]", "* [ ]", "- [x]", etc.
  local prefix = line:match("^%s*([-%*]%s%[[ xX-]?%])")
  if prefix then
    local filled_todo_pattern = "%[[x%-]%]";

    if prefix:match(filled_todo_pattern) then
      -- NOTE: empty prefix for the new line
      prefix = prefix:gsub(filled_todo_pattern, "[ ]")
    end

    return prefix .. " "
  end
  -- Matches plain unordered list like "- item"
  prefix = line:match("^%s*([-%*])%s+")
  if prefix then
    return prefix .. " "
  end
  return nil
end

local function new_list_line(below)
  local line = vim.api.nvim_get_current_line()
  local indent = line:match("^(%s*)") or ""
  local prefix = get_list_prefix(line)

  if below then
    vim.cmd("normal! o")
  else
    vim.cmd("normal! O")
  end

  if prefix then
    local new_line = indent .. prefix

    vim.api.nvim_set_current_line(new_line)
  end

  vim.cmd("startinsert!")
end

function M.new_list_line_below()
  new_list_line(true)
end

function M.new_list_line_above()
  new_list_line(false)
end

return M;
