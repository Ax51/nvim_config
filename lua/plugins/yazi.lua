---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  cmd = "Yazi",
  opts = {
    integrations = {
      grep_in_directory = "fzf-lua",
      grep_in_selected_files = "fzf-lua",
    },
  }
}
