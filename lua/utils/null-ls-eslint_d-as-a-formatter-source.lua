local null_ls_helpers = require("null-ls.helpers")
local null_ls_utils = require("null-ls.utils")
local FORMATTING = require("null-ls.methods").internal.FORMATTING

return null_ls_helpers.make_builtin({
  name = "eslint_d",
  meta = {
    url = "https://github.com/mantoni/eslint_d.js/",
    description = "Like ESLint, but faster.",
    notes = {
      "Once spawned, the server will continue to run in the background. This is normal and not related to null-ls. You can stop it by running `eslint_d stop` from the command line.",
    },
  },
  method = FORMATTING,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
    "astro",
  },
  generator_opts = {
    command = "eslint_d",
    args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
    to_stdin = true,
    cwd = null_ls_helpers.cache.by_bufnr(function(params)
      return null_ls_utils.cosmiconfig("eslint", "eslintConfig")(params.bufname)
    end),
    on_output = function(params, done)
      done({ { text = params.output } })
    end
  },
  factory = null_ls_helpers.formatter_factory,
})
