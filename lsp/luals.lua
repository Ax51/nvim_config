local lazypath = vim.fn.stdpath("data") .. "/lazy"

local library_paths = vim.api.nvim_get_runtime_file("", true)
table.insert(library_paths, vim.fn.stdpath("config"))
table.insert(library_paths, lazypath)

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
        library = library_paths,
      },
    },
  },
}
