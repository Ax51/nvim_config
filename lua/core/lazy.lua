local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local installed, lazy = pcall(require, "lazy")
if not installed then
  return
end

local lazyOpts = {
  checker = {
    check_pinned = true,
  },
  ui = {
    border = "single",
    size = {
      width = 0.8,
      height = 0.9,
    },
  },
}

lazy.setup({
  -- NOTE: important to call theme first
  { import = "themes/tokyonight" },
  { import = "plugins" },
}, lazyOpts)
