---Session persistence allowed only for provided paths
---@param allowed_dirs string[]
---@return boolean
local function should_start_persisted(allowed_dirs)
  local should_start = false
  local cwdDir = vim.fn.getcwd()

  for _, dir in ipairs(allowed_dirs) do
    local fullAllowedDir = vim.fn.expand(dir)
    local trimmedCwd = cwdDir:sub(1, string.len(fullAllowedDir))

    if trimmedCwd == fullAllowedDir then
      should_start = true
      break
    end
  end

  return should_start
end

return should_start_persisted
