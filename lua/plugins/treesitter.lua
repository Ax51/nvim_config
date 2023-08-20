require'nvim-treesitter.configs'.setup {
	ensure_installed = { "typescript", "lua", "rust", "tsx", "javascript" },
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true
	}
}

