local wk = require("which-key")

wk.register({
	f = {
		name = "Find",
		f = { "Find File" },
		b = { "Find Buffer" },
		h = { "Find Help" },
		w = { "Find by word" },
	},
	e = { "Float file Manager" },
	E = { "Right side file Manager" },
	o = { "Git status" },
	x = { "Close Buffer" },
	X = { "Close all tabs to the Right" },
	q = { "Close Buffer" },
	Q = { "Close NVIM" },
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
}, { prefix = "<leader>" })
