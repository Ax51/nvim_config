local M = {}

M.config = {
  base_folder_path = "./.idea/notes"
}

M.open_branch_notes = function()
  local branch_name = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]

  if not branch_name or branch_name == "" then
    print("Failed to retrieve the branch name.")
    return
  end

  local file_path = string.format(M.config.base_folder_path .. "/%s.md", branch_name)

  if vim.fn.filereadable(file_path) ~= 1 then
    vim.fn.mkdir(M.config.base_folder_path, "p")
    vim.fn.writefile({}, file_path)
  end

  print("Opening notes for [ " .. branch_name .. " ] branch.")

  vim.cmd(string.format("edit %s", file_path))
end

return M
