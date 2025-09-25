return function()
  local function handle_definition(_, result)
    if not result or vim.tbl_isempty(result) then
      print("No definitions found")
      return
    end

    if #result == 1 then
      -- NOTE: Single definition found
      vim.lsp.buf.definition()
    else
      -- NOTE: Multiple definitions found
      require("fzf-lua").lsp_definitions()
    end
  end

  local params = vim.lsp.util.make_position_params(0, "utf-8")
  vim.lsp.buf_request(0, "textDocument/definition", params, handle_definition)
end
