return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvimtools/none-ls-extras.nvim" },
  event = { "BufReadPre", "BufNewFile" },

  config = function()
    local check_for_eslint = require("utils.null_ls_checks").check_for_eslint

    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        require("none-ls.code_actions.eslint_d").with({ condition = check_for_eslint }),

        require("none-ls.diagnostics.eslint_d").with({ condition = check_for_eslint }),

        require("none-ls.formatting.eslint_d").with({ condition = check_for_eslint }),

        -- NOTE: temporary disabled since auto formatting causes a lot of changes
        -- null_ls.builtins.diagnostics.buf,

        null_ls.builtins.formatting.buf,

        null_ls.builtins.formatting.shfmt,
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
