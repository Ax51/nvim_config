-- TODO:
-- - [ ] fn should open file not on the first line but on the found word
-- - [ ] fn should use the list of words to find instead of `"TODO"` only
-- - [ ] fn should use `rg` instead because it's faster
-- - [ ] it should be easier to change branches and words to search. (like move them to constants)
-- - [ ] fzf should contain preview window
-- - after opening the window it will be better if searched words will be already highlited and we could
-- easily iterate over them with `n` key (like execute `/'words'` search right after opening the file)
-- - [ ] we shouldn't include files where we delete searched words instead of adding them
local function git_diff_fzf_lua()
  local base_branch = "staging" -- Replace with your base branch if different
  local handle = io.popen("git diff --name-only " .. base_branch .. "... | xargs grep -l 'TODO'")
  local result = handle:read("*a")
  handle:close()

  if result == "" then
    print("No files with TODO found in the diff.")
    return
  end

  local files = vim.split(result, "\n")
  table.remove(files, #files) -- Remove the last empty entry

  require('fzf-lua').fzf_exec(files, {
    prompt = 'Select file with TODO: ',
    actions = {
      ['default'] = function(selected)
        vim.cmd("edit " .. selected[1])
      end
    }
  })
end

---@param command string
---@return boolean
local function check_for_console_command_existence(command)
  local handle = io.popen("command -v " .. command)
  ---@type string | nil
  local result = handle and handle:read("*a") or nil

  if not result then
    print("Unable to check util [ " .. command .. " ] existence")
    return false;
  end

  -- NOTE: already checked for handle in result
  ---@diagnostic disable-next-line: need-check-nil
  handle:close();

  return result:len() > 0 and true or false
end

local function git_diff_fzf_lua_2()
  if not check_for_console_command_existence("git") then
    print("Please install [ git ] before")
    return;
  end

  if not check_for_console_command_existence("rg") then
    print("Please install [ git ] before")
    return;
  end

  ---@type string
  local base_branch = "main"
  -- local base_branch = "staging"

  ---@type string[]
  local target_keywords_table = { "TODO", "FIXIT", "DELETE" }

  ---@type string
  local command = "git diff " ..
      base_branch ..
      " --unified=0 --output-indicator-new=' ' | rg --no-heading --trim -o -A 1 '^[^-].*(" ..
      table.concat(target_keywords_table, "|") ..
      "):.*'"

  local handle = io.popen(command)

  if not handle then
    print("Failed to execute git command!")

    return
  end

  ---@type string
  local result = handle:read("*a")

  handle:close()

  print("result:\n---\n", result, "\n---")
end

-- TODO: [WIP]
-- git_diff_fzf_lua_2()

return git_diff_fzf_lua
