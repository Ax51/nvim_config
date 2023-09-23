local M = {}

M.darkplus = { "lunarvim/darkplus.nvim" }

M.kanagawa = { "rebelot/kanagawa.nvim" }

M.ayu = { "shatur/neovim-ayu" }

M.melange = { "savq/melange-nvim" }

M.gruvbox = { "luisiacc/gruvbox-baby" }

M.fox = { "edeneast/nightfox.nvim" }

M.tokyonight = {
	"folke/tokyonight.nvim",
	opts = {
		on_highlights = function(hl, c)
			-- NOTE: change unused variable color
			hl.diagnosticunnecessary = {
				fg = c.comment,
			}
		end,
	},
}

local function setDefaultTheme(theme)
	local defThemeOpts = {
		lazy = false,
		priority = 1000,
	}

	local result = {}

	for themeName, themeTable in pairs(M) do
		if themeName == theme then
			-- NOTE: selected theme
			for opt, optValue in pairs(defThemeOpts) do
				-- NOTE: add each def opt to the selected theme
				themeTable[opt] = optValue
			end
		else
			themeTable.lazy = true
		end
		table.insert(result, themeTable)
	end

	return result
end

return setDefaultTheme
