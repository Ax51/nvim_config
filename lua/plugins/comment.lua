require("Comment").setup({
	toggler = {
		line = "<leader>/",
		block = "<leader>?",
	},
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})