local root_markers = {
  "package.json",
  "tsconfig.json",
  ".git",
  "biome.json",
  "biome.jsonc",
};

-- NOTE: Disable `biome` for projects that contains `eslint` config files
return {
  cmd = { 'biome', 'lsp-proxy' },
  filetypes = {
    'astro',
    'css',
    'graphql',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'svelte',
    'typescript',
    'typescript.tsx',
    'typescriptreact',
    'vue',
  },
  root_markers = root_markers,
  root_dir = function(fname, cb)
    local eslint_root_path = vim.fs.root(fname,
      function(name)
        -- NOTE: all possible eslint config files
        return name:match('%.?eslint.?r?c?%.?[%a]*') ~= nil
      end
    )

    if eslint_root_path ~= nil then
      return
    end

    local biome_root_path = vim.fs.root(fname, root_markers)

    if biome_root_path ~= nil then
      cb(biome_root_path)
    end
  end,
  single_file_support = true,
}
