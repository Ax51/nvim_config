return {
	"numToStr/Comment.nvim",
	keys = {
		{ mode = { "n", "v" }, "gc" },
		{ mode = { "n", "v" }, "gb" },
	},

	config = function()
		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end,
}
