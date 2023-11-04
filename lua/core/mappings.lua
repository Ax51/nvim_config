local nmap, remap = unpack(require("utils.keymappings"))

-- NeoTree
nmap("<leader>e", ":Neotree toggle position=float reveal<CR>")
nmap("<leader>E", ":Neotree right reveal<CR>")
nmap("<leader>b", ":Neotree toggle left buffers<CR>")

-- LSP
nmap("<leader>lD", vim.diagnostic.open_float)
nmap("[d", vim.diagnostic.goto_prev)
nmap("]d", vim.diagnostic.goto_next)
nmap("<leader>ld", vim.diagnostic.setloclist)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf, silent = true }
		nmap("gD", vim.lsp.buf.declaration, opts)
		nmap("gd", vim.lsp.buf.definition, opts)
		nmap("K", vim.lsp.buf.hover, opts)
		nmap("gi", vim.lsp.buf.implementation, opts)
		nmap("<space>D", vim.lsp.buf.type_definition, opts)
		nmap("<space>rn", vim.lsp.buf.rename, opts)
		remap("<space>ca", vim.lsp.buf.code_action, { "n", "v" }, opts)
		nmap("gr", vim.lsp.buf.references, opts)
	end,
})

-- Telescope
nmap("<leader>ff", ":Telescope find_files<CR>")
nmap("<leader>fF", ":Telescope dir find_files<CR>")
nmap("<leader>fw", ":Telescope live_grep<CR>")
nmap("<leader>fW", ":Telescope dir live_grep<CR>")
-- NOTE: this ext. require lua code to start. Doesn't want to work with `:Telescope live_grep_args<CR>`
nmap("<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
nmap("<leader>fb", ":Telescope buffers<CR>")
nmap("<leader>fh", ":Telescope help_tags<CR>")
nmap("<leader>fm", ":Telescope marks<CR>")
nmap("<leader>fp", ":Telescope persisted<CR>")
nmap("<leader>fr", ":Telescope resume<CR>")
nmap("<leader>fc", ":TodoTelescope<CR>")
nmap("<leader>gb", ":Telescope git_branches<CR>")
nmap("<leader>gc", ":Telescope git_commits<CR>")
nmap("<leader>gs", ":Telescope git_status<CR>")
nmap("<leader>fs", ":Telescope lsp_document_symbols<CR>")
nmap("gr", ":Telescope lsp_references<CR>")
nmap("gd", ":Telescope lsp_definitions<CR>")

-- LazyGit
nmap("<leader>gg", ":LazyGit<CR>")

-- Navigation
nmap("<c-k>", ":wincmd k<CR>")
nmap("<c-j>", ":wincmd j<CR>")
nmap("<c-h>", ":wincmd h<CR>")
nmap("<c-l>", ":wincmd l<CR>")
nmap("<C-I>", "<C-I>") -- NOTE: we need to separate <C-I> from <tab> by explicitly remap each key

-- Splits
nmap("|", ":vsplit<CR>")
nmap("\\", ":split<CR>")

-- Other
nmap("<leader>w", ":w<CR>")
nmap("<leader>q", ":bp|bd #<CR>")
nmap("<leader>Q", ":bd<CR>")
nmap("<leader>Q!", ":qall<CR>")
nmap("<leader>QA", function()
	local closeOther = require("utils.close_all_bufs_ex_curr")
	local bufflineUi = require("bufferline.ui")

	closeOther()
	bufflineUi.refresh()
end)
nmap("<leader>X", ":BufferLinePickClose<CR>")
nmap("<leader>x", "<c-w>c")
nmap("<leader>s", ":BufferLineSortByTabs<CR>")
nmap("<leader>h", ":nohlsearch<CR>")
nmap("<leader>rs", ":!bun %<CR>")
nmap("<leader>/", "gcc")
remap("jj", "<Esc>", "i")
remap("<leader>c", ":'<,'>t'><CR>", "v") -- NOTE: copy selected lines and paste them below
remap("<leader>C", require("utils.copy_and_comment"), "v")

-- Tabs
nmap("<Tab>", ":BufferLineCycleNext<CR>")
nmap("<s-Tab>", ":BufferLineCyclePrev<CR>")

-- Navbuddy
nmap("<leader>fv", ":Navbuddy<CR>")

-- Tests
nmap("<leader>tt", ":Neotest run<CR>")
nmap("<leader>tS", ":Neotest stop<CR>")
nmap("<leader>ts", ":Neotest summary<CR>")
nmap("<leader>ta", ":Neotest run file<CR>")
nmap("<leader>tl", ":Neotest run last<CR>")
nmap("<leader>to", ":Neotest output<CR>")
nmap("<leader>t[", ":Neotest jump prev<CR>")
nmap("<leader>t]", ":Neotest jump next<CR>")

-- Hop
nmap("<leader>M", ":HopChar1<CR>")
nmap("<leader>m", ":HopWord<CR>")

-- GitBlame
nmap("<leader>gl", function()
	if Git_blame_enabled then
		vim.cmd("GitBlameDisable")
		Git_blame_enabled = false
	else
		vim.cmd("GitBlameEnable")
		Git_blame_enabled = true
	end
end)

-- Zen Mode
nmap("<leader>zz", function()
	if Git_blame_enabled then
		vim.cmd("GitBlameDisable")
		Git_blame_enabled = false
		Git_blame_disabled_by_zenmode = true
	end
	vim.cmd("ZenMode")
end)

-- Twilight
nmap("<leader>zt", ":Twilight<CR>")

-- REST
nmap("<leader>rq", ':lua require("rest-nvim").run()<CR>')
nmap("<leader>rl", ':lua require("rest-nvim").last()<CR>')

-- Boole
nmap("<leader>a", ":Boole increment<CR>")
nmap("<leader>x", ":Boole decrement<CR>")
