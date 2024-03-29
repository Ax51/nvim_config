return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"windwp/nvim-ts-autotag",
	},

	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "typescript", "lua", "rust", "tsx", "javascript" },
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
			},
			autotag = {
				enable = true,
				enable_close_on_slash = false,
			},
		})
	end,
}
