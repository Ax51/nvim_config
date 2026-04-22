local M = {}

local function normalize_prompt(prompt)
  prompt = type(prompt) == "string" and { msg = prompt } or prompt
  prompt = type(prompt) == "function" and { msg = "[function]" } or prompt
  prompt.msg = prompt.msg or ""
  return prompt
end

function M.select_with_fzf(default_prompt_select, prompt_opts)
  local Config = require("sidekick.config")
  local Context = require("sidekick.cli.context")

  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    return default_prompt_select(prompt_opts)
  end

  local context = Context.get()
  local items = {}
  local entries = {}
  local prompt_names = vim.tbl_keys(Config.cli.prompts)
  table.sort(prompt_names)

  for _, name in ipairs(prompt_names) do
    local prompt = normalize_prompt(Config.cli.prompts[name] or {})
    local text, rendered = context:render({ prompt = name })
    if rendered and #rendered > 0 then
      items[#items + 1] = {
        text = text or "",
        rendered = rendered,
        summary = prompt.msg:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""),
      }
      entries[#entries + 1] = ("%d. [%s] %s"):format(#items, name, items[#items].summary)
    end
  end

  if #items == 0 then
    return prompt_opts.cb()
  end

  fzf.fzf_exec(entries, {
    prompt = "Sidekick prompts> ",
    fzf_opts = {
      ["--no-multi"] = true,
    },
    winopts = {
      height = 0.70,
      width = 0.75,
      preview = {
        hidden = false,
        layout = "vertical",
        vertical = "down:55%",
      },
    },
    preview = function(args)
      local index = tonumber((args[1] or ""):match("^%s*(%d+)%."))
      local item = index and items[index] or nil
      if not item then
        return ""
      end
      return item.text
    end,
    actions = {
      ["default"] = function(selected)
        local index = tonumber(((selected or {})[1] or ""):match("^%s*(%d+)%."))
        local item = index and items[index] or nil
        if item then
          return prompt_opts.cb(item.text, item.rendered)
        end
        return prompt_opts.cb()
      end,
    },
  })
end

return M
