local darkplus = { "lunarvim/darkplus.nvim" }

local kanagawa = { "rebelot/kanagawa.nvim" }

local ayu = { "Shatur/neovim-ayu" }

local melange = { "savq/melange-nvim" }

local gruvbox = { "luisiacc/gruvbox-baby" }

local fox = { "EdenEast/nightfox.nvim" }

local tokyonight = {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		on_highlights = function(hl)
			-- change unused variable color
			hl.DiagnosticUnnecessary = {
				fg = "#5f7bb9",
			}
		end,
	},
}

-- TODO: add the ability to choose default theme either from there, or from the importing place
return {
	darkplus,
	kanagawa,
	ayu,
	melange,
	gruvbox,
	fox,
	tokyonight,
}
