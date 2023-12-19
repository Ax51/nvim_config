return {
	"nat-418/boole.nvim",
	cmd = "Boole",

	config = function()
		require("boole").setup({
			mappings = {},

			-- User defined loops
			additions = {
				{ "private", "protected", "public" },
				{ "let", "const" },
				{ "type", "interface" },
				{ "toBeVisible", "toBeHidden" },
			},
			allow_caps_additions = {
				{ "enable", "disable" },
				-- enable → disable
				-- Enable → Disable
				-- ENABLE → DISABLE
			},
		})
	end,
}
