return {
	"nat-418/boole.nvim",
	cmd = "Boole",

	config = function()
		require("boole").setup({
			mappings = {},

			-- User defined loops
			additions = {
				{ "Foo", "Bar" },
				{ "tic", "tac", "toe" },
				{ "private", "protected", "public" },
				{ "let", "const" },
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
