return {
	"karb94/neoscroll.nvim",
	event = "WinScrolled",

	config = function()
		require("neoscroll").setup({
			easing_function = "circular",
		})
	end,
}
