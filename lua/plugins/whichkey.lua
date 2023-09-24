return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,

	config = function()
		local wk = require("which-key")

		wk.register({
			f = {
				name = "Find",
				f = { "Find File" },
				F = { "Find File in selected directories" },
				b = { "Find Buffer" },
				h = { "Find Help" },
				w = { "Find by word" },
				W = { "Find by word in selected directories" },
				p = { "Show persisted sessions" },
				s = { "Show file Symbols" },
				m = { "Show marks" },
			},
			e = { "Float file Manager" },
			E = { "Right side file Manager" },
			o = { "Git status" },
			x = { "Close active splitted screen" },
			X = { "Select tabs to close" },
			q = { "Close Buffer" },
			Q = {
				name = "Close Buffer & it's tab",
				["!"] = "Quit NVIM",
				A = "Close all buffers except current",
			},
			w = { "Save" },
			h = { "No highlight" },
			g = {
				name = "Git",
				b = "Branches",
				c = "Commits",
				s = "Status",
				g = "Open Lazygit",
				l = "Toggle GitBlame",
			},
			l = {
				name = "LSP",
				d = "Diagnostic",
				D = "Hover diagnostic",
				f = "Format",
				r = "Rename",
				a = "Action",
				s = "Symbol",
			},
			r = {
				name = "Run",
				s = "Execute JS script with Bun",
			},
			t = {
				name = "Tests",
				t = "Run nearest test",
				S = "Stop running tests",
				s = "Show summary",
				a = "Run all nested tests",
				l = "Run last test",
				o = "Show error output",
				["["] = "Navigate to the prev test",
				["]"] = "Navigate to the next test",
			},
			m = {
				name = "Hop",
				a = "anywhere",
				c = "by 1 char",
				C = "by 1 or 2 chars",
				V = "to line at start",
				l = "to line at zero",
				v = "vertical",
				p = "by pattern",
				w = "to the word",
			},
			z = {
				name = "Zen mode",
				a = "Ataraxis mode",
				m = "Minimalist mode",
				n = "Narrow mode",
				f = "Focus mode",
				t = "Toggle Twilight mode",
			},
		}, { prefix = "<leader>" })
	end,
}
