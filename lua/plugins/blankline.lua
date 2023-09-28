-- NOTE: v3 has some breaking changes and works different, need more info
-- return {
-- 	"lukas-reineke/indent-blankline.nvim",
-- 	main = "ibl",
-- 	event = { "BufReadPost", "BufNewFile" },
--
-- 	config = true,
-- }
return {
	"lukas-reineke/indent-blankline.nvim",
	version = "2.20.8",
	event = { "BufReadPost", "BufNewFile" },

	config = function()
		require("indent_blankline").setup({
			show_current_context = true,
		})
	end,
}
