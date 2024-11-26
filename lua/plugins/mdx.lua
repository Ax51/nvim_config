return {
  "davidmh/mdx.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },

  -- NOTE: don't use `ft` since without this plugin executed mdx filetypes are not recognized
  event = "BufRead *.mdx",

  config = true,
}
