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
		local rust = require("rustaceanvim.neotest")

		neotest.setup({
			adapters = {
				jest({
					jestCommand = "bunx jest --silent",
					env = { CI = true },
					cwd = function()
						local file = vim.fn.expand("%:p")
						if string.find(file, "/app/") then
							return string.match(file, "(.-/[^/]+/)src")
						end
						return vim.fn.getcwd()
					end,
					jestConfigFile = function()
						local file = vim.fn.expand("%:p")
						if string.find(file, "/app/") then
							return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
						end

						return vim.fn.getcwd() .. "/jest.config.ts"
					end,
				}),
				playwright.adapter({
					options = {},
				}),
				rust,
			},
		})
	end,
}
