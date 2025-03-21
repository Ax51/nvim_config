return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    "zbirenbaum/copilot.lua",
    "nvim-lua/plenary.nvim",
  },
  cmd = { "CopilotChat", "Copilot" },
  build = "make tiktoken", -- Only on MacOS or Linux
  opts = true,
  -- See Commands section for default commands if you want to lazy load on them
}
