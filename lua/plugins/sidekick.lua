return {
  "folke/sidekick.nvim",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  opts = {
    cli = {
      mux = {
        backend = "zellij",
        enabled = true,
      },
      win = {
        split = {
          width = 120,
        },
      },
    },
  },
}
