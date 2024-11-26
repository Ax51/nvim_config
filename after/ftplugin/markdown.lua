vim.opt_local.wrap = true

-- NOTE: Reassign mdx files to enable mdx_analyzer
if vim.fn.expand("%:e") == "mdx" then
  vim.bo.filetype = "markdown.mdx"
end
