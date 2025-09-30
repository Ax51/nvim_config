local M = {}

M.check_for_biome = function()
  local a = vim.fs.root(vim.api.nvim_buf_get_name(0), { "biome.json", "biome.jsonc" })
  return a ~= nil
end

M.check_for_eslint = function()
  local has_eslint_config_file = vim.fs.root(vim.api.nvim_buf_get_name(0), function(name)
    -- NOTE: all possible eslint config files
    return name:match("%.?eslint.?r?c?%.?[%a]*") ~= nil
  end)
  local has_biome_config_file = M.check_for_biome()
  return has_biome_config_file == false and has_eslint_config_file ~= nil
end

M.check_for_eslint_flat_config = function()
  local a = vim.fs.root(vim.api.nvim_buf_get_name(0), function(name)
    -- NOTE: all possible eslint flat config files
    return name:match("%.?eslint.config%.?[%a]*") ~= nil
  end)
  return a ~= nil
end

return M
