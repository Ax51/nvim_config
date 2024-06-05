return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"SmiteshP/nvim-navic",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup()

		-- NOTE: apply border for hover screens globally to every server
		local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or "rounded"
			return orig_util_open_floating_preview(contents, syntax, opts, ...)
		end

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		-- NOTE: Setup language servers
		local lspconfig = require("lspconfig")
		lspconfig.mdx_analyzer.setup({
			capabilities = capabilities,
		})

		lspconfig.taplo.setup({
			capabilities = capabilities,
		})

		lspconfig.bashls.setup({
			on_attach = function(client, bufnr)
				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, bufnr)
					require("nvim-navbuddy").attach(client, bufnr)
				end
			end,

			capabilities = capabilities,
		})

		lspconfig.biome.setup({
			capabilities = capabilities,
		})

		lspconfig.lua_ls.setup({
			on_init = function(client)
				local path = client.workspace_folders[1].name
				if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
					return
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						-- library = {
						-- 	vim.env.VIMRUNTIME,
						-- Depending on the usage, you might want to add additional paths here.
						-- "${3rd}/luv/library"
						-- "${3rd}/busted/library",
						-- },
						-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
						library = vim.api.nvim_get_runtime_file("", true),
					},
				})
			end,

			settings = {
				Lua = {},
			},

			on_attach = function(client, bufnr)
				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, bufnr)
					require("nvim-navbuddy").attach(client, bufnr)
				end
			end,

			capabilities = capabilities,
		})

		lspconfig.tsserver.setup({
			on_attach = function(client, bufnr)
				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, bufnr)
					require("nvim-navbuddy").attach(client, bufnr)
				end

				-- NOTE: disabled tsserver formatting since I use eslint
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
			capabilities = capabilities,
		})

		lspconfig.cssls.setup({
			on_attach = function(client, bufnr)
				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, bufnr)
					require("nvim-navbuddy").attach(client, bufnr)
				end
			end,

			capabilities = capabilities,
		})
	end,
}
