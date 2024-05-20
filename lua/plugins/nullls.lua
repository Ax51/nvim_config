return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvimtools/none-ls-extras.nvim" },
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local check_for_biome, check_for_eslint = unpack(require("utils.null_ls_checks"))

		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				require("none-ls.code_actions.eslint_d").with({ condition = check_for_eslint }),

				require("none-ls.diagnostics.eslint_d").with({ condition = check_for_eslint }),

				require("none-ls.formatting.eslint_d").with({ condition = check_for_eslint }),

				null_ls.builtins.formatting.buf,

				null_ls.builtins.formatting.biome.with({ condition = check_for_biome }),

				null_ls.builtins.formatting.stylua,

				null_ls.builtins.formatting.shfmt,

				-- null_ls.builtins.formatting.prettierd.with({
				-- 	filetypes = {
				-- 		"css",
				-- 		"scss",
				-- 		"less",
				-- 		"html",
				-- 		"json",
				-- 		"jsonc",
				-- 		"yaml",
				-- 		"markdown",
				-- 		"markdown.mdx",
				-- 		"handlebars",
				-- 	},
				-- }),
			},

			on_attach = function(client, bufnr)
				-- NOTE: format on save
				if client.supports_method("textDocument/formatting") then
					local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

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
						end,
					})
				end
			end,
		})
	end,
}
