return {
	"nvim-telescope/telescope-live-grep-args.nvim",
	-- NOTE: uncomment this for downloading stable version.
	-- This will not install any breaking changes.
	-- version = "^1.0.0",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	lazy = true,

	config = function()
		require("telescope").load_extension("live_grep_args")
	end,
}
