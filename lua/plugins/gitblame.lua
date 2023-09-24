return {
	"f-person/git-blame.nvim",
	cmd = { "GitBlameToggle", "GitBlameEnable", "GitBlameDisable" },

	config = function()
		require("gitblame").setup({
			enabled = false,
		})
	end,
}
