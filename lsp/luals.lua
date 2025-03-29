return {
  name = "lua-language-server",
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".git", '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
}
