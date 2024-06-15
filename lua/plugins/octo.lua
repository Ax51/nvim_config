return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'ibhagwan/fzf-lua',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = "Octo",

  opts = {
    picker = "fzf-lua",
    suppress_missing_scope = {
      projects_v2 = true,
    }
  }
}
