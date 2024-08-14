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

return git_diff_fzf_lua
