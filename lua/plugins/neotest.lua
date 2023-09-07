local neotest = require("neotest")
local jest = require("neotest-jest")
local playwright = require("neotest-playwright")

neotest.setup({
	adapters = {
		jest({
			jestCommand = "npx jest --silent",
			env = { CI = true },
			cwd = function(path)
				return vim.fn.getcwd()
			end,
		}),
		playwright.adapter({
			options = {},
		}),
	},
})
