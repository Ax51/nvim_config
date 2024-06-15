local M = {}

M.remap = function(shortcut, command, mode, opts)
  local defmode = "n"
  local defopts = { silent = true }

  vim.keymap.set(mode or defmode, shortcut, command, opts or defopts)
end

M.nmap = function(shortcut, command, opts)
  M.remap(shortcut, command, "n", opts)
end

return M
