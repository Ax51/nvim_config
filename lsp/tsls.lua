return {
  init_options = { hostInfo = "neovim" },
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  -- NOTE: `root_dir` declaration is moved to a lsp config
  -- since `tsls` could possibly conflicts with `denols`
  on_init = function(client)
    -- NOTE: Disable formatting capability
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  single_file_support = true,
}
