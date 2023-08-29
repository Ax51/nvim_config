local actions = require("telescope.actions")

require("telescope").setup({
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
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-Q>"] = actions.send_to_qflist + actions.open_qflist,
			},
			n = {
				["<esc>"] = actions.close,
				["q"] = actions.close,
				["<tab>"] = actions.toggle_selection + actions.move_selection_next,
				["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-Q>"] = actions.send_to_qflist + actions.open_qflist,
			},
		},
	},
})

require("telescope").load_extension("fzf")
