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
}
