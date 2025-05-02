local M = {}

M.check_for_biome = function(utils)
  return utils.root_has_file("biome.json")
end

M.check_for_eslint = function(utils)
  return not M.check_for_biome(utils)
end

M.check_for_eslint_flat_config = function()
  local a = vim.fs.root(vim.fn.getcwd(),
    function(name)
      -- NOTE: all possible eslint config files
      return name:match('%.?eslint.config%.?[%a]*') ~= nil
    end
  )

  return a ~= nil;
end;

return M
