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

local function open_file_if_readable(full_path)
  if vim.fn.filereadable(full_path) == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(full_path))
    return true
  end
  return false
end

local not_a_path_err_code = "Not a path"

local function file_open(path)
  local first_char = path:sub(1, 1)
  local md_root_markers = { ".git", ".marksman.toml" }

  if first_char == "." then
    local buf_path = vim.api.nvim_buf_get_name(0)
    local buf_dir = vim.fn.fnamemodify(buf_path, ":p:h")
    local full_path = vim.fn.resolve(buf_dir .. "/" .. path)
    if not open_file_if_readable(full_path) then
      error("Relative file not found: " .. path, 0)
    end
  elseif first_char == "/" then
    local buf_path = vim.api.nvim_buf_get_name(0)
    local root = vim.fs.root(buf_path, md_root_markers)
    if root then
      local full_path = vim.fn.resolve(root .. path)
      if not open_file_if_readable(full_path) then
        error("Absolute file not found: " .. path, 0)
      end
    else
      error("No root found for absolute path: " .. path, 0)
    end
  else
    error(not_a_path_err_code, 0)
  end
end

local function allow_to_open_local_files()
  local default_ui_open = vim.ui.open

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.open = function(path, opts)
    local success, result = pcall(file_open, path)

    if not success then
      if result ~= not_a_path_err_code then
        -- NOTE: If the error is not about the path, notify the user
        vim.notify(result, vim.log.levels.ERROR, { title = "Error opening file" })
      end

      default_ui_open(path, opts)
    end
  end
end

function M.new_list_line_below()
  new_list_line(true)
end

function M.new_list_line_above()
  new_list_line(false)
end

M.allow_to_open_local_files = allow_to_open_local_files;

return M;
