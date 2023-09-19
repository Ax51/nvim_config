vim.g.mapleader = " "

-- NeoTree
vim.keymap.set("n", "<leader>e", ":Neotree toggle position=float reveal<CR>")
vim.keymap.set("n", "<leader>E", ":Neotree right reveal<CR>")
vim.keymap.set("n", "<leader>o", ":Neotree float git_status<CR>")

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
vim.keymap.set("n", "<leader>fc", ":TodoTelescope", {})
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
vim.keymap.set("n", "<leader>QA", ":%bd|e#|bd#<CR>")
vim.keymap.set("n", "<leader>X", ":BufferLinePickClose<CR>")
vim.keymap.set("n", "<leader>x", "<c-w>c")
vim.keymap.set("n", "<leader>s", ":BufferLineSortByTabs<CR>")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.keymap.set("n", "<leader>rs", ":!bun %<CR>")
vim.keymap.set("v", "<leader>c", ":'<,'>t'><CR>") -- copy selected lines right below

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
local hop = require("hop")

vim.keymap.set("n", "<leader>ma", hop.hint_anywhere, {})
vim.keymap.set("n", "<leader>mc", hop.hint_char1, {})
vim.keymap.set("n", "<leader>mC", hop.hint_char2, {})
vim.keymap.set("n", "<leader>mV", hop.hint_lines, {})
vim.keymap.set("n", "<leader>ml", hop.hint_lines_skip_whitespace, {})
vim.keymap.set("n", "<leader>mv", hop.hint_vertical, {})
vim.keymap.set("n", "<leader>mp", hop.hint_patterns, {})
vim.keymap.set("n", "<leader>mw", hop.hint_words, {})
--
vim.keymap.set({ "v", "i" }, "<c-m>a", hop.hint_anywhere, {})
vim.keymap.set({ "v", "i" }, "<c-m>C", hop.hint_char1, {})
vim.keymap.set({ "v", "i" }, "<c-m>c", hop.hint_char2, {})
vim.keymap.set({ "v", "i" }, "<c-m>V", hop.hint_lines, {})
vim.keymap.set({ "v", "i" }, "<c-m>l", hop.hint_lines_skip_whitespace, {})
vim.keymap.set({ "v", "i" }, "<c-m>v", hop.hint_vertical, {})
vim.keymap.set({ "v", "i" }, "<c-m>p", hop.hint_patterns, {})
vim.keymap.set({ "v", "i" }, "<c-m>w", hop.hint_words, {})

-- Zen Mode
local zenmode = require("zen-mode")
vim.keymap.set("n", "<leader>zz", function()
	vim.cmd("GitBlameDisable")
	zenmode.toggle()
end, { noremap = true })

-- Twilight
vim.keymap.set("n", "<leader>zt", ":Twilight<CR>", { noremap = true })
