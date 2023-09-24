return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		-- NOTE: I'm not sure that I need this plugin
		-- { "linrongbin16/lsp-progress.nvim", config = true },
	},
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "⏽", right = "⏽" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					"%f",
				},
				lualine_x = {
					-- require("lsp-progress").progress,
					-- "encoding",
					-- "filetype",
					-- "filesize",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"%f",
						color = { fg = "#ffaa88" },
					},
				},
				lualine_x = {
					{
						"diff",
						color = { fg = "#ffaa88" },
					},
				},
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {
				lualine_b = {
					"filename",
				},
				lualine_c = {
					{
						"navic",
						color_correction = nil,
						navic_opts = nil,
					},
				},
			},
			inactive_winbar = {},
			extensions = {},
		})
	end,
}
