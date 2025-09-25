return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    linters_by_ft = {
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    },
  },

enabled = require("constants").null_ls_migration_finished == true,

  config = function(_, opts)
    local lint = require("lint")
    lint.linters_by_ft = opts.linters_by_ft or lint.linters_by_ft

    -- lint.linters.eslint_d.args = {
    --   "json",
    --   "--stdin",
    --   "--stdin-filename",
    --   function()
    --     return vim.api.nvim_buf_get_name(0)
    --   end,
    -- }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
