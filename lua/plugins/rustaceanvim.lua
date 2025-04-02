return {
  "mrcjkb/rustaceanvim",
  -- version = "^4",
  ft = "rust",

  init = function()
    local nmap = require("utils.keymappings").nmap

    vim.g.rustaceanvim = function()
      return {
        server = {
          on_attach = function(client, bufnr)
            if client.server_capabilities.documentSymbolProvider then
              require("nvim-navic").attach(client, bufnr)
            end

            nmap("<leader>la", ":RustLsp codeAction<CR>")
            nmap("<leader>k", ":RustLsp openDocs<CR>")
          end,
        },
      }
    end
  end,
}
