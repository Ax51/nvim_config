local M = {}

M.is_plugin_loaded = function(plugin_name)
  local loaded_plugin = require("lazy.core.config").plugins[plugin_name]
  if not loaded_plugin then
    return false
  end

  return loaded_plugin._.loaded ~= nil
end

return M
