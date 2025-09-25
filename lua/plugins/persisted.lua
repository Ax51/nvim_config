local allowed_dirs = {
  "~/Documents/Programming",
  "~/.config/nvim",
}

return {
  "olimorris/persisted.nvim",

  lazy = false,

  cond = function()
    return require("utils.should_start_persisted")(allowed_dirs)
  end,

  config = function()
    require("persisted").setup({
      save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
      silent = false, -- silent nvim message when sourcing session file
      use_git_branch = false, -- create session files based on the branch of the git enabled repository
      autosave = true, -- automatically save session files when exiting Neovim
      should_autosave = nil, -- function to determine if a session should be autosaved
      autoload = true, -- automatically load the session for the cwd on Neovim startup
      on_autoload_no_session = nil, -- function to run when `autoload = true` but there is no session to load
      follow_cwd = true, -- change session file name to match current working directory if it changes
      -- NOTE: we use custom fzf-lua picker fn for this util. Check for `utils.fzf_lua_persisted`
      -- telescope = {                                                  -- options for the telescope extension
      --   reset_prompt_after_deletion = true,                          -- whether to reset prompt after session deleted
      -- },
    })
  end,
}
