return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPost", "BufNewFile" },

	config = function()
		require("ibl").setup({
			scope = {
				char = "▏",
				show_start = false,
				show_end = false,
			},
		})
	end,
}
