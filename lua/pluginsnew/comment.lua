return {
	"numToStr/Comment.nvim",
	event = "BufReadPre",

	config = function()
		require("Comment").setup({
			-- TODO: change comments highlight colors
			-- TODO: check why some togglers here, and some - in mappings file
			toggler = {
				line = "<leader>/",
				block = "<leader>?",
			},
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end,
}
