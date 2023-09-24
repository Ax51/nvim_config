return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },

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
				enable_autocmd = false,
			},
		})
	end,
}