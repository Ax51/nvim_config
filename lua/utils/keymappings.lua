local M = {}

---full controll over remappings
---@param shortcut string new keys combination to add
---@param command string|function command to execute. can be a Lua function.
---@param mode string|string[] Mode short-name, see |nvim_set_keymap()|.
---@param opts? vim.keymap.set.Opts
M.remap = function(shortcut, command, mode, opts)
  local defmode = "n"
  local defopts = { silent = true }

  vim.keymap.set(mode or defmode, shortcut, command, opts or defopts)
end

---fast and easy remappings for normal mode only
---@param shortcut string new keys combination to add
---@param command string|function command to execute. can be a Lua function.
---@param opts? vim.keymap.set.Opts
M.nmap = function(shortcut, command, opts)
  M.remap(shortcut, command, "n", opts)
end

return M
