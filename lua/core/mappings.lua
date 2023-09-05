vim.g.mapleader = " "

-- NeoTree
vim.keymap.set("n", "<leader>e", ":Neotree toggle position=float<CR>")
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
local telescope = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", telescope.find_files, {})
vim.keymap.set("n", "<leader>fw", telescope.live_grep, {})
vim.keymap.set("n", "<leader>fb", telescope.buffers, {})
vim.keymap.set("n", "<leader>fh", telescope.help_tags, {})
vim.keymap.set("n", "<leader>fp", ":Telescope persisted<CR>", {})
vim.keymap.set("n", "<leader>fc", ":TodoTelescope", {})
vim.keymap.set("n", "<leader>gb", telescope.git_branches, {})
vim.keymap.set("n", "<leader>gc", telescope.git_commits, {})
vim.keymap.set("n", "<leader>gs", telescope.git_status, {})
vim.keymap.set("n", "<leader>gl", ":GitBlameToggle<CR>", {})
vim.keymap.set("n", "<leader>fs", telescope.lsp_document_symbols, {})
vim.keymap.set("n", "gr", telescope.lsp_references, { noremap = true, silent = true })
vim.keymap.set("n", "gd", telescope.lsp_definitions, { noremap = true, silent = true })

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
vim.keymap.set("n", "<leader>Q", ":qall<CR>")
vim.keymap.set("n", "<leader>X", ":BufferLinePickClose<CR>")
vim.keymap.set("n", "<leader>x", "<c-w>c")
vim.keymap.set("n", "<leader>s", ":BufferLineSortByTabs<CR>")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.keymap.set("n", "<leader>rs", ":!bun %<CR>")

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
