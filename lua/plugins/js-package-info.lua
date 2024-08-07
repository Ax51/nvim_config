return {
  "vuki656/package-info.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim"
  },

  -- NOTE: with lazy-loading somewhy badges colors are missing
  event = "BufEnter package.json",

  opts = {
    colors = {
      up_to_date = "#3C4048",
      outdated = "#d19a66",
    },
  },

  config = function(_, opts)
    require("package-info").setup(opts)

    -- NOTE: temporary fix to set colors with lazy loading this plugin due to this bug:
    -- https://github.com/vuki656/package-info.nvim/issues/155
    vim.cmd([[highlight PackageInfoUpToDateVersion guifg=]] .. opts.colors.up_to_date)
    vim.cmd([[highlight PackageInfoOutdatedVersion guifg=]] .. opts.colors.outdated)
  end
}
