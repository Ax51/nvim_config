local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.load_extension("persisted")
telescope.load_extension("fzf")

telescope.setup({
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<tab>"] = actions.toggle_selection + actions.move_selection_next,
				["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
				["<c-a>"] = actions.send_to_qflist + actions.open_qflist,
				["<c-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<c-x>"] = actions.delete_buffer,
			},
			n = {
				["<esc>"] = actions.close,
				["q"] = actions.close,
				["<tab>"] = actions.toggle_selection + actions.move_selection_next,
				["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
				["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
				["<c-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["x"] = actions.delete_buffer,
			},
		},
	},

	-- Show line numbers in preview
	vim.api.nvim_create_autocmd("User", {
		pattern = "TelescopePreviewerLoaded",
		callback = function(args)
			vim.cmd("setlocal number")
		end,
	}),
})
