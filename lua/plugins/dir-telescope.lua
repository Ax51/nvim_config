return {
  "princejoogie/dir-telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  cmd = "Telescope dir",

  config = function()
    local telescope = require("telescope")
    require("dir-telescope").setup({
      hidden = false,
      no_ignore = false,
      show_preview = true,
    })

    telescope.load_extension("dir")
  end,
}
