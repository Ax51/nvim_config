local M = {}

M.config = {
  base_folder_path = ".idea/notes",
  folder_structure_base_file_name = "index.md",
  marksman_config_file_name = ".marksman.toml",
  marksman_config = {
    "[core]",
    "title_from_heading = false",
  },
}

local function systemlist(args)
  local result = vim.fn.systemlist(args)

  if vim.v.shell_error ~= 0 then
    return nil
  end

  return result
end

local function get_main_repo_path(start_path)
  local worktree_result = systemlist({ "git", "-C", start_path, "worktree", "list", "--porcelain" })

  if worktree_result then
    for _, line in ipairs(worktree_result) do
      local worktree_path = line:match("^worktree%s+(.+)$")

      if worktree_path then
        return worktree_path
      end
    end
  end

  local root_result = systemlist({ "git", "-C", start_path, "rev-parse", "--show-toplevel" })

  return root_result and root_result[1]
end

local function get_git_context()
  local current_file_dir = vim.fn.expand("%:p:h")
  local start_path = current_file_dir ~= "" and current_file_dir or vim.fn.getcwd()

  local branch_result = systemlist({ "git", "-C", start_path, "rev-parse", "--abbrev-ref", "HEAD" })
  local root_path = get_main_repo_path(start_path)
  local branch_name = branch_result and branch_result[1]

  if not branch_name or branch_name == "" then
    branch_result = systemlist({ "git", "-C", start_path, "branch", "--show-current" })
    branch_name = branch_result and branch_result[1]
  end

  if not root_path or root_path == "" then
    print("Failed to retrieve the main repo path.")
    return nil
  end

  if not branch_name or branch_name == "" then
    print("Failed to retrieve the branch name.")
    return nil
  end

  return {
    root_path = root_path,
    branch_name = branch_name,
    notes_dir = root_path .. "/" .. M.config.base_folder_path,
    note_name = branch_name:gsub("/", "_"),
  }
end

local function ensure_file(file_path, lines)
  if vim.fn.filereadable(file_path) == 1 then
    return
  end

  local parent_dir = vim.fn.fnamemodify(file_path, ":h")

  vim.fn.mkdir(parent_dir, "p")
  vim.fn.writefile(lines or {}, file_path)
end

local function ensure_marksman_config(notes_dir)
  local marksman_config_path = notes_dir .. "/" .. M.config.marksman_config_file_name

  ensure_file(marksman_config_path, M.config.marksman_config)
end

local function get_note_paths(context)
  local desired_path = context.notes_dir .. "/" .. context.note_name

  return {
    single_file_path = desired_path .. ".md",
    folder_path = desired_path,
    index_path = desired_path .. "/" .. M.config.folder_structure_base_file_name,
  }
end

local function open_file(file_path)
  vim.cmd(string.format("edit %s", vim.fn.fnameescape(file_path)))
end

M.open_branch_notes = function()
  local context = get_git_context()

  if not context then
    return
  end

  ensure_marksman_config(context.notes_dir)

  local paths = get_note_paths(context)
  local file_path = vim.fn.isdirectory(paths.folder_path) == 1 and paths.index_path or paths.single_file_path

  ensure_file(file_path)

  print("Opening notes for [ " .. context.branch_name .. " ] branch.")

  open_file(file_path)
end

M.open_branch_notes_folder = function()
  local context = get_git_context()

  if not context then
    return
  end

  ensure_marksman_config(context.notes_dir)

  local paths = get_note_paths(context)

  if vim.fn.isdirectory(paths.folder_path) ~= 1 then
    vim.fn.mkdir(paths.folder_path, "p")

    if vim.fn.filereadable(paths.single_file_path) == 1 then
      local moved_note_path = paths.folder_path .. "/" .. context.note_name .. ".md"
      local rename_result = vim.fn.rename(paths.single_file_path, moved_note_path)

      if rename_result ~= 0 then
        print("Failed to move existing note into the folder.")
        return
      end

      ensure_file(paths.index_path, {
        string.format("[%s](%s)", context.note_name, vim.fn.fnamemodify(moved_note_path, ":t")),
      })
    else
      ensure_file(paths.index_path)
    end
  else
    ensure_file(paths.index_path)
  end

  print("Opening notes folder for [ " .. context.branch_name .. " ] branch.")

  open_file(paths.index_path)
end

return M
