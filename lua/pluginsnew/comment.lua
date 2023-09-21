return {
	"numToStr/Comment.nvim",
	-- TODO: doublecheck if lazy should be set to false?
	lazy = false,
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},

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
