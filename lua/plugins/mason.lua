return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	lazy = true,

	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup()
	end,
}
