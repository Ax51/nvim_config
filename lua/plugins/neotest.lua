local neotest = require("neotest")
local jest = require("neotest-jest")

neotest.setup({
	adapters = {
		jest({
			jestCommand = "npx jest --watch",
			jestConfigFile = "custom.jest.config.ts",
			env = { CI = true },
			cwd = function(path)
				return vim.fn.getcwd()
			end,
		}),
	},
})
