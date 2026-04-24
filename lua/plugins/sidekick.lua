return {
  "folke/sidekick.nvim",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    local prompt_ui = require("sidekick.cli.ui.prompt")
    local default_prompt_select = prompt_ui.select
    local sidekick = require("sidekick")
    local sidekick_config = require("sidekick.config")
    local sidekick_prompt_picker = require("utils.sidekick_prompt_picker")

    local default_ai_tools = {
      claude = {},
      codex = {},
      cursor = {},
      copilot = {},
    }

    local prompts = {
      pr_comments_review = [[Fetch all review comments from the pull request linked below.
Deduplicate overlapping comments, then summarize them in a table with:
1. requirement
2. your opinion
3. expected code updates

PR link:]],
      fix_merge_conflicts = "Please help me fix the merge conflicts",

      -- simple context prompts
      file = "{file}",
      line = "{line}",
      buffers = "{buffers}",
      position = "{position}",
      quickfix = "{quickfix}",
      selection = "{selection}",
      diagnostics = "{diagnostics}",
    }

    sidekick.setup({
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
        tools = default_ai_tools,
        prompts = prompts,
      },
      picker = "fzf-lua",
    })

    -- NOTE: Sidekick deep-merges custom CLI tables with its defaults,
    -- so replace them to show only your prompts and tools.
    sidekick_config.cli.tools = default_ai_tools
    sidekick_config.cli.prompts = prompts

    -- NOTE: intentional override to replace Sidekick's default prompt
    -- picker with our fzf-lua implementation that keeps prompt previews.
    ---@diagnostic disable-next-line: duplicate-set-field
    prompt_ui.select = function(prompt_opts)
      return sidekick_prompt_picker.select_with_fzf(default_prompt_select, prompt_opts)
    end
  end,
}
