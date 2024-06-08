local function check_for_biome(utils)
  return utils.root_has_file("biome.json")
end

local function check_for_eslint(utils)
  return not check_for_biome(utils)
end

return {
  check_for_biome,
  check_for_eslint,
}
