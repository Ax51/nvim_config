vim.opt_local.wrap = true

local md_utils = require("utils.markdown_qol_utils")

vim.keymap.set("n", "o", md_utils.new_list_line_below, { buffer = true })
vim.keymap.set("n", "O", md_utils.new_list_line_above, { buffer = true })

md_utils.allow_to_open_local_files()
