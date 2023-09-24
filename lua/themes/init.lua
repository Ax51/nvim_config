--[[
 NOTE:
 To add new theme, just apply it's name to the themes list,
 define source and add default theme name, that will be called
 for day - light theme & night - for dark theme. If there is only
 one theme name to call, its better to repeat day and night fields
]]

local themesList = {}

themesList.darkplus = {
	source = "lunarvim/darkplus.nvim",

	day = "darkplus",
	night = "darkplus",
}

themesList.kanagawa = {
	source = "rebelot/kanagawa.nvim",

	day = "kanagawa-wave",
	night = "kanagawa-dragon",
}

themesList.ayu = {
	source = "Shatur/neovim-ayu",

	day = "ayu-mirage",
	night = "ayu-dark",
}

themesList.melange = {
	source = "savq/melange-nvim",

	day = "melange",
	night = "melange",
}

themesList.gruvbox = {
	source = "luisiacc/gruvbox-baby",

	day = "gruvbox-baby",
	night = "gruvbox-baby",
}

themesList.fox = {
	source = "EdenEast/nightfox.nvim",

	day = "duskfox",
	night = "carbonfox",
}

themesList.tokyonight = {
	source = "folke/tokyonight.nvim",
	opts = {
		on_highlights = function(hl, c)
			-- NOTE: change unused variable color
			hl.diagnosticunnecessary = {
				fg = c.comment,
			}
		end,
	},

	day = "tokyonight-storm",
	night = "tokyonight-night",
}

local function setDefaultTheme(theme)
	local defThemeOpts = {
		lazy = false,
		priority = 1000,
	}

	local result = {}

	for themeName, themeTable in pairs(themesList) do
		local configuredTheme = {}

		if themeName == theme then
			-- NOTE: selected theme
			for opt, optValue in pairs(defThemeOpts) do
				-- NOTE: add each def opt to the selected theme
				configuredTheme[opt] = optValue
			end
		else
			configuredTheme.lazy = true
		end

		-- NOTE: spread all theme specific opts
		for opt, optValue in pairs(themeTable) do
			if opt == "source" then
				configuredTheme[1] = optValue
			elseif opt == "day" or opt == "night" then
				-- NOTE: continue
			end
			configuredTheme[opt] = optValue
		end

		table.insert(result, configuredTheme)
	end

	return result
end

return { setDefaultTheme, themesList }
