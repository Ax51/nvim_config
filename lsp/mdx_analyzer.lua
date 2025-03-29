local node_modules_path = vim.fs.root(0, { "node_modules" })

return {
  cmd = { 'mdx-language-server', '--stdio' },
  filetypes = { 'mdx' },
  root_markers = { 'package.json' },
  single_file_support = true,
  settings = {},
  init_options = {
    typescript = {
      tsdk = node_modules_path and node_modules_path .. '/node_modules/typescript/lib' or nil,
    },
  },
}
