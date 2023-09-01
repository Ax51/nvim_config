local neotest = require("neotest")
local jest = require("neotest-jest")

neotest.setup({
	adapters = {
		jest({
			jestCommand = "npx jest --silent",
			env = { CI = true },
			cwd = function(path)
				return vim.fn.getcwd()
			end,
		}),
	},
})
