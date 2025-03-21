return {
  "zbirenbaum/copilot.lua",

  event = "InsertEnter",
  config = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
    },
    copilot_model = "gpt-4o-copilot",
  },
}
