local function js_ts_formatters(bufnr)
  local formatters = require("utils.determine_js_conform_formatters").determine_formatter(bufnr)

  formatters.stop_after_first = true

  return formatters
end

return {
  "stevearc/conform.nvim",

  enabled = require("constants").null_ls_migration_finished == true,

  event = { "BufReadPre", "BufNewFile" },

  opts = {
    formatters_by_ft = {
      javascript = js_ts_formatters,
      typescript = js_ts_formatters,
      javascriptreact = js_ts_formatters,
      typescriptreact = js_ts_formatters,
      lua = { "stylua" },
      shell = { "shfmt" },
      proto = { "buf" },
    },
    format_on_save = {
      -- NOTE: These options will be passed to conform.format()
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
  },
}
