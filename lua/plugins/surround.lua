return {
  "kylechui/nvim-surround",
  keys = {
    { mode = "n", "ys" },
    { mode = "n", "yS" },
    { mode = "n", "cs" },
    { mode = "n", "ds" },

    { mode = "v", "S" },
    { mode = "v", "gS" },

    { mode = "i", "<C-g>s", desc = "surround" },
    { mode = "i", "<C-g>S", desc = "surround line" },
  },

  config = true,
  -- NOTE: default keymaps =
  -- 	insert = "<C-g>s",
  -- 	insert_line = "<C-g>S",
  -- 	normal = "ys",
  -- 	normal_cur = "yss",
  -- 	normal_line = "yS",
  -- 	normal_cur_line = "ySS",
  -- 	visual = "S",
  -- 	visual_line = "gS",
  -- 	delete = "ds",
  -- 	change = "cs",
}
