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
nmap("<leader>fb", ":Telescope buffers<CR>")
nmap("<leader>fh", ":Telescope help_tags<CR>")
nmap("<leader>fm", ":Telescope marks<CR>")
nmap("<leader>fp", ":Telescope persisted<CR>")
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

-- Splits
nmap("|", ":vsplit<CR>")
nmap("\\", ":split<CR>")

-- Other
nmap("<leader>w", ":w<CR>")
nmap("<leader>q", ":bp|bd #<CR>")
nmap("<leader>Q", ":bd<CR>")
nmap("<leader>Q!", ":qall<CR>")
nmap("<leader>QA", require("utils.close_all_bufs_ex_curr"))
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
nmap("<leader>ma", ":HopAnywhere<CR>")
nmap("<leader>mc", ":HopChar1<CR>")
nmap("<leader>mC", ":HopChar2<CR>")
nmap("<leader>mV", ":HopLineStart<CR>")
nmap("<leader>ml", ":HopLine<CR>")
nmap("<leader>mv", ":HopVertical<CR>")
nmap("<leader>mp", ":HopPattern<CR>")
nmap("<leader>mw", ":HopWord<CR>")
--
remap("<c-m>a", ":HopAnywhere<CR>", { "v", "i" })
remap("<c-m>C", ":HopChar1<CR>", { "v", "i" })
remap("<c-m>c", ":HopChar2<CR>", { "v", "i" })
remap("<c-m>V", ":HopLineStart<CR>", { "v", "i" })
remap("<c-m>l", ":HopLine<CR>", { "v", "i" })
remap("<c-m>v", ":HopVertical<CR>", { "v", "i" })
remap("<c-m>p", ":HopPattern<CR>", { "v", "i" })
remap("<c-m>w", ":HopWord<CR>", { "v", "i" })

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
