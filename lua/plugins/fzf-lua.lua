return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  cmd = "FzfLua",

  opts = {
    grep = {
      rg_opts = "--column --line-number --no-heading --color=always --smart-case --multiline --max-columns=4096 -e",
      rg_glob = true,
    }
  }
}
