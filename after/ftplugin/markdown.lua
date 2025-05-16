vim.opt_local.wrap = true

vim.keymap.set("n", "o", require("utils.markdown_qol_utils").new_list_line_below, { buffer = true })
vim.keymap.set("n", "O", require("utils.markdown_qol_utils").new_list_line_above, { buffer = true })
