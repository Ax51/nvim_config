local M = {}

M.check_for_biome = function(utils)
  return utils.root_has_file("biome.json")
end

M.check_for_eslint = function(utils)
  return not M.check_for_biome(utils)
end

return M
