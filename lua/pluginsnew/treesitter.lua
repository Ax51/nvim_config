return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	build = ":TSUpdate",

	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "typescript", "lua", "rust", "tsx", "javascript" },
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
			},
			context_commentstring = {
				enable = true,
			},
		})
	end,
}
