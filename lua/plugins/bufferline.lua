require("bufferline").setup({
	options = {
		buffer_close_icon = "",
		mode = "buffers",
		offsets = {
			{
				filetype = "neo-tree",
				text = "File Explorer",
				separator = true,
				padding = 1,
			},
		},
		color_icons = true,
		show_duplicate_prefix = true,
		always_show_bufferline = true,
		diagnostics = "nvim_lsp",
		indicator = {
			icon = "  ", -- this should be omitted if indicator style is not 'icon'
			style = "icon",
		},
		-- separator_style = "slope"
	},
})
