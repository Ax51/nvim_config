local M = {}

local is_sidekick_plugin_loaded = false

M.check_is_sidekick_plugin_loaded = function()
  if is_sidekick_plugin_loaded == true then
    return true
  end

  local is_plugin_loaded = require("utils.check_lazy_plugin_loaded").is_plugin_loaded("sidekick.nvim")

  if is_plugin_loaded == true then
    is_sidekick_plugin_loaded = true
  end

  return is_sidekick_plugin_loaded
end

M.copilot_status_line = {
  function()
    return " "
  end,
  color = function()
    local is_plugin_loaded = M.check_is_sidekick_plugin_loaded()
    if not is_plugin_loaded then
      return "Comment"
    end

    local status = require("sidekick.status").get()
    if status then
      return status == nil and "DiagnosticError"
        or status.kind == "Error" and "DiagnosticError"
        or status.kind == "Warning" and "DiagnosticWarn"
        or status.busy and "DiagnosticWarn"
        or "Special"
    end
  end,
}

M.sidekick_status_line = {
  function()
    local is_plugin_loaded = M.check_is_sidekick_plugin_loaded()
    if not is_plugin_loaded then
      return " "
    end

    local status = require("sidekick.status").cli()
    return " " .. (#status > 1 and #status or "")
  end,
  color = function()
    local is_plugin_loaded = M.check_is_sidekick_plugin_loaded()
    if not is_plugin_loaded then
      return "Comment"
    end

    local cli_status = #require("sidekick.status").cli() > 0
    return cli_status and "Special" or "DiagnosticError"
  end,
}

return M
