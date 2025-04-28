-- local lsp = vim.lsp
--
-- local function virtual_text_document_handler(uri, res, client)
--   if not res then
--     return nil
--   end
--
--   local lines = vim.split(res.result, '\n')
--   local bufnr = vim.uri_to_bufnr(uri)
--
--   local current_buf = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
--   if #current_buf ~= 0 then
--     return nil
--   end
--
--   vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
--   vim.api.nvim_set_option_value('readonly', true, { buf = bufnr })
--   vim.api.nvim_set_option_value('modified', false, { buf = bufnr })
--   vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
--   lsp.buf_attach_client(bufnr, client.id)
-- end
--
-- local function virtual_text_document(uri, client)
--   local params = {
--     textDocument = {
--       uri = uri,
--     },
--   }
--   local result = client.request_sync('deno/virtualTextDocument', params)
--   virtual_text_document_handler(uri, result, client)
-- end
--
-- local function denols_handler(err, result, ctx, config)
--   vim.print("me called")
--   if not result or vim.tbl_isempty(result) then
--     return nil
--   end
--
--   local client = vim.lsp.get_client_by_id(ctx.client_id)
--   vim.print("client", client)
--   for _, res in pairs(result) do
--     local uri = res.uri or res.targetUri
--     if uri:match '^deno:' then
--       virtual_text_document(uri, client)
--       res['uri'] = uri
--       res['targetUri'] = uri
--     end
--   end
--
--   lsp.handlers[ctx.method](err, result, ctx, config)
-- end

local function virtual_text_document(params)
  local bufnr = params.buf
  local actual_path = params.match:sub(1)

  local clients = vim.lsp.get_clients({ name = "deno" })
  if #clients == 0 then
    return
  end

  local client = clients[1]
  local method = "deno/virtualTextDocument"
  local req_params = { textDocument = { uri = actual_path } }
  local response = client.request_sync(method, req_params, 2000, 0)
  if not response or type(response.result) ~= "string" then
    return
  end

  local lines = vim.split(response.result, "\n")
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_set_option_value("readonly", true, { buf = bufnr })
  vim.api.nvim_set_option_value("modified", false, { buf = bufnr })
  vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
  vim.api.nvim_buf_set_name(bufnr, actual_path)
  vim.lsp.buf_attach_client(bufnr, client.id)

  local filetype = "typescript"
  if actual_path:sub(-3) == ".md" then
    filetype = "markdown"
  end
  vim.api.nvim_set_option_value("filetype", filetype, { buf = bufnr })
end

vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
  pattern = { "deno:/*" },
  callback = virtual_text_document,
})


return {
  cmd = { 'deno', 'lsp' },
  cmd_env = { NO_COLOR = true },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  -- NOTE: `root_dir` declaration is moved to a lsp config
  -- since `denols` could possibly conflicts with `tsls`
  settings = {
    deno = {
      enable = true,
      suggest = {
        imports = {
          hosts = {
            ['https://deno.land'] = true,
          },
        },
      },
    },
  },
  -- handlers = {
  --   ['textDocument/definition'] = denols_handler,
  --   ['textDocument/typeDefinition'] = denols_handler,
  --   ['textDocument/references'] = denols_handler,
  -- },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(0, 'LspDenolsCache', function()
      client:exec_cmd({
        command = 'deno.cache',
        arguments = { {}, vim.uri_from_bufnr(bufnr) },
      }, { bufnr = bufnr }, function(err, _result, ctx)
        if err then
          local uri = ctx.params.arguments[2]
          vim.api.nvim_err_writeln('cache command failed for ' .. vim.uri_to_fname(uri))
        end
      end)
    end, {
      desc = 'Cache a module and all of its dependencies.',
    })
  end,
}
