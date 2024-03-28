local nmap = unpack(require("utils.keymappings"))

vim.g.rustaceanvim = function()
	return {
		server = {
			on_attach = function()
				nmap("<leader>a", ":RustLsp codeAction<CR>")
				nmap("<leader>k", ":RustLsp openDocs<CR>")
			end,
		},
	}
end

return {
	"mrcjkb/rustaceanvim",
	-- version = "^4",
	ft = "rust",
}
