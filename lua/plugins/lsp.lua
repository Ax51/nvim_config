return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"SmiteshP/nvim-navic",
	},
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		-- NOTE: apply border for hover screens globally to every server
		local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or "rounded"
			return orig_util_open_floating_preview(contents, syntax, opts, ...)
		end

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		-- Setup language servers.
		local lspconfig = require("lspconfig")
		lspconfig.mdx_analyzer.setup({})
		lspconfig.taplo.setup({})
		lspconfig.lua_ls.setup({
			on_init = function(client)
				local path = client.workspace_folders[1].name
				if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
					client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
									-- "${3rd}/luv/library"
									-- "${3rd}/busted/library",
								},
								-- NOTE: or pull in all of 'runtimepath'. But this is a lot slower
								-- library = vim.api.nvim_get_runtime_file("", true),
							},
						},
					})

					client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
				end
				return true
			end,
			capabilities = capabilities,
		})
		lspconfig.tsserver.setup({
			on_attach = function(client, bufnr)
				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, bufnr)
				end
			end,
			capabilities = capabilities,
		})
		lspconfig.prismals.setup({})
		lspconfig.cssls.setup({
			capabilities = capabilities,
		})
		lspconfig.golangci_lint_ls.setup({})
	end,
}
