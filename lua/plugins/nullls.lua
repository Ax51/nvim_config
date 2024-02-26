return {
	"nvimtools/none-ls.nvim",
	dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls-extras.nvim" },
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local null_ls = require("null-ls")
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			sources = {
				require("none-ls.code_actions.eslint_d"),
				require("none-ls.diagnostics.eslint_d"),
				require("none-ls.formatting.eslint_d"),
				require("none-ls.formatting.rustfmt"),
				-- null_ls.builtins.formatting.lua_format,
				null_ls.builtins.formatting.stylua,
				-- null_ls.builtins.formatting.rome,
				null_ls.builtins.formatting.prettierd.with({
					filetypes = {
						"css",
						"scss",
						"less",
						"html",
						"json",
						"jsonc",
						"yaml",
						"markdown",
						"markdown.mdx",
						"handlebars",
					},
				}),
			},
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								bufnr = bufnr,
								filter = function(c)
									return c.name == "null-ls"
								end,
							})
							-- vim.lsp.buf.formatting_sync()
						end,
					})
				end
			end,
		})
	end,
}
