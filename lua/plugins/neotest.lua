return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"haydenmeade/neotest-jest",
		"thenbe/neotest-playwright",
	},
	cmd = "Neotest",

	config = function()
		local neotest = require("neotest")
		local jest = require("neotest-jest")
		local playwright = require("neotest-playwright")

		neotest.setup({
			adapters = {
				jest({
					jestCommand = "npx jest --silent",
					env = { CI = true },
					cwd = function()
						return vim.fn.getcwd()
					end,
				}),
				playwright.adapter({
					options = {},
				}),
			},
		})
	end,
}
