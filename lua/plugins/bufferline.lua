require("bufferline").setup({
	options = {
		buffer_close_icon = "",
		show_close_icon = false,
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
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local icon = level:match("error") and "🔻 " or "🔸 "
			-- local icon = level:match("error") and " " or " " -- default icon
			return " " .. icon .. count
		end,
		indicator = {
			icon = "  ", -- this should be omitted if indicator style is not 'icon'
			style = "icon",
		},
		-- separator_style = "slope"
	},
})
