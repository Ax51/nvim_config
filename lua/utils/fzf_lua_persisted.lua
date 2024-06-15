local function show_saved_sessions_in_fzf_lua()
  local persisted = require('persisted')
  local fzf_lua = require('fzf-lua')

  local sessions = persisted.list()

  local session_dirs = {}
  for _, session in ipairs(sessions) do
    table.insert(session_dirs, session.dir_path)
  end

  local function find_path_from_dir(selected_dir)
    for _, session in ipairs(sessions) do
      if (session.dir_path == selected_dir) then
        return session.file_path
      end
    end
    return nil
  end

  fzf_lua.fzf_exec(session_dirs, {
    prompt = 'Saved sessions> ',
    actions = {
      ['default'] = function(selected)
        local found_save_file_path = find_path_from_dir(selected[1])

        if found_save_file_path then
          persisted.load({ session = found_save_file_path })
        else
          vim.print("Can't find save file path for selected item!")
        end
      end,
    },
  })
end

return show_saved_sessions_in_fzf_lua
