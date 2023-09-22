-- NeoTree
vim.keymap.set("n", "<leader>e", ":Neotree toggle position=float reveal<CR>")
vim.keymap.set("n", "<leader>E", ":Neotree right reveal<CR>")
vim.keymap.set("n", "<leader>b", ":Neotree toggle left buffers<CR>")

-- LSP
vim.keymap.set("n", "<leader>lD", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>ld", vim.diagnostic.setloclist)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	end,
})

-- Telescope
local telescope = require("telescope")
local tel_builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", tel_builtin.find_files, {})
vim.keymap.set("n", "<leader>fF", telescope.extensions.dir.find_files, {})
vim.keymap.set("n", "<leader>fw", tel_builtin.live_grep, {})
vim.keymap.set("n", "<leader>fW", telescope.extensions.dir.live_grep, {})
vim.keymap.set("n", "<leader>fb", tel_builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", tel_builtin.help_tags, {})
vim.keymap.set("n", "<leader>fm", tel_builtin.marks, {})
vim.keymap.set("n", "<leader>fp", ":Telescope persisted<CR>", {})
vim.keymap.set("n", "<leader>fc", ":TodoTelescope<CR>", {})
vim.keymap.set("n", "<leader>gb", tel_builtin.git_branches, {})
vim.keymap.set("n", "<leader>gc", tel_builtin.git_commits, {})
vim.keymap.set("n", "<leader>gs", tel_builtin.git_status, {})
vim.keymap.set("n", "<leader>gl", ":GitBlameToggle<CR>", {})
vim.keymap.set("n", "<leader>fs", tel_builtin.lsp_document_symbols, {})
vim.keymap.set("n", "gr", tel_builtin.lsp_references, { noremap = true, silent = true })
vim.keymap.set("n", "gd", tel_builtin.lsp_definitions, { noremap = true, silent = true })

-- LazyGit
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", {})

-- Navigation
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
vim.keymap.set("n", "<leader>/", "gcc")

-- Splits
vim.keymap.set("n", "|", ":vsplit<CR>")
vim.keymap.set("n", "\\", ":split<CR>")

-- Other
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":bp|bd #<CR>")
vim.keymap.set("n", "<leader>Q", ":bd<CR>")
vim.keymap.set("n", "<leader>Q!", ":qall<CR>")
vim.keymap.set("n", "<leader>QA", function() -- delete all buffers, expect active one
	local rawBufArr = vim.api.nvim_list_bufs()
	local currBufNum = vim.api.nvim_get_current_buf()

	for _, value in ipairs(rawBufArr) do
		if value ~= currBufNum and vim.fn.buflisted(value) then
			vim.api.nvim_buf_delete(value, {})
		end
	end
end)
vim.keymap.set("n", "<leader>X", ":BufferLinePickClose<CR>")
vim.keymap.set("n", "<leader>x", "<c-w>c")
vim.keymap.set("n", "<leader>s", ":BufferLineSortByTabs<CR>")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.keymap.set("n", "<leader>rs", ":!bun %<CR>")
vim.keymap.set("v", "<leader>c", ":'<,'>t'><CR>") -- NOTE: copy selected lines and paste them below
vim.keymap.set("v", "<leader>C", function()
	-- NOTE: copy selected lines, paste them below and comment repeated lines
	local comApi = require("Comment.api")
	local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
	vim.api.nvim_feedkeys(esc, "nx", false)

	local initialCursorPos = vim.api.nvim_win_get_cursor(0)
	local startLine = vim.fn.getpos("'<")[2]
	local endLine = vim.fn.getpos("'>")[2]
	local diffLines = math.abs(startLine - endLine)

	vim.cmd("'<,'>t'>")
	vim.api.nvim_win_set_cursor(0, { endLine + 1, 0 })
	comApi.comment.linewise.count(diffLines + 1)
	vim.api.nvim_win_set_cursor(0, initialCursorPos)
end)

-- Tabs
vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>")
vim.keymap.set("n", "<s-Tab>", ":BufferLineCyclePrev<CR>")

-- Navbuddy
vim.keymap.set("n", "<leader>fv", ":Navbuddy<CR>")

-- Tests
vim.keymap.set("n", "<leader>tt", ":Neotest run<CR>", {})
vim.keymap.set("n", "<leader>tS", ":Neotest stop<CR>", {})
vim.keymap.set("n", "<leader>ts", ":Neotest summary<CR>", {})
vim.keymap.set("n", "<leader>ta", ":Neotest run file<CR>", {})
vim.keymap.set("n", "<leader>tl", ":Neotest run last<CR>", {})
vim.keymap.set("n", "<leader>to", ":Neotest output<CR>", {})
vim.keymap.set("n", "<leader>t[", ":Neotest jump prev<CR>", {})
vim.keymap.set("n", "<leader>t]", ":Neotest jump next<CR>", {})

-- Hop
-- local hop = require("hop")

vim.keymap.set("n", "<leader>ma", ":HopAnywhere<CR>", {})
vim.keymap.set("n", "<leader>mc", ":HopChar1<CR>", {})
vim.keymap.set("n", "<leader>mC", ":HopChar2<CR>", {})
vim.keymap.set("n", "<leader>mV", ":HopLineStart<CR>", {})
vim.keymap.set("n", "<leader>ml", ":HopLine<CR>", {})
vim.keymap.set("n", "<leader>mv", ":HopVertical<CR>", {})
vim.keymap.set("n", "<leader>mp", ":HopPattern<CR>", {})
vim.keymap.set("n", "<leader>mw", ":HopWord<CR>", {})
--
vim.keymap.set({ "v", "i" }, "<c-m>a", ":HopAnywhere<CR>", {})
vim.keymap.set({ "v", "i" }, "<c-m>C", ":HopChar1<CR>", {})
vim.keymap.set({ "v", "i" }, "<c-m>c", ":HopChar2<CR>", {})
vim.keymap.set({ "v", "i" }, "<c-m>V", ":HopLineStart<CR>", {})
vim.keymap.set({ "v", "i" }, "<c-m>l", ":HopLine<CR>", {})
vim.keymap.set({ "v", "i" }, "<c-m>v", ":HopVertical<CR>", {})
vim.keymap.set({ "v", "i" }, "<c-m>p", ":HopPattern<CR>", {})
vim.keymap.set({ "v", "i" }, "<c-m>w", ":HopWord<CR>", {})

-- Zen Mode
vim.keymap.set("n", "<leader>zz", function()
	-- vim.cmd("GitBlameDisable")
	vim.cmd("ZenMode")
end, { noremap = true })

-- Twilight
vim.keymap.set("n", "<leader>zt", ":Twilight<CR>", { noremap = true })
