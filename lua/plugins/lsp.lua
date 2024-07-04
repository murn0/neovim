return function()
  --[[
  -- Keymaps
  --]]
  local keymap = vim.keymap

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_user_bindings", {}),
    callback = function(event)
      -- commands
      vim.api.nvim_buf_create_user_command(event.buf, "FormatLSP", function(_)
        vim.lsp.buf.format()
      end, { desc = "Format current buffer with LSP" })
      vim.api.nvim_buf_create_user_command(event.buf, "RestartLSP", function(_)
        vim.lsp.stop_client(vim.lsp.get_clients())
        vim.cmd("edit")
      end, { desc = "Restart all active LSP clients" })

      -- mappings
      keymap.set("n", "<c-w>-", function()
        vim.cmd("split")
        vim.lsp.buf.definition()
      end, { buffer = event.buf, desc = "lsp: show definition in new split" })
      keymap.set("n", "<c-w>|", function()
        vim.cmd("vsplit")
        vim.lsp.buf.definition()
      end, { buffer = event.buf, desc = "lsp: show definition in new split" })
      keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "lsp: show definition" })
      keymap.set("n", "gD", vim.lsp.buf.type_definition, { buffer = event.buf, desc = "lsp: show type definition" })
      keymap.set("n", "gr", function()
        vim.lsp.buf.references({ includeDeclaration = false })
      end, { buffer = event.buf, desc = "lsp: show refs" })
      keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = event.buf, desc = "lsp: show implementations" })
      keymap.set("n", "go", vim.lsp.buf.document_symbol, { buffer = event.buf, desc = "lsp: outline symbols" })
      keymap.set("n", "gC", vim.lsp.buf.incoming_calls, { buffer = event.buf, desc = "lsp: list incoming calls" })
      keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf, desc = "lsp: show help" })
      keymap.set("n", "<F5>", vim.lsp.buf.rename, { buffer = event.buf, desc = "lsp: rename symbol" })
      keymap.set("n", "<F12>", vim.lsp.buf.code_action, { buffer = event.buf, desc = "lsp: run code action" })
      keymap.set("n", "<cr>", vim.diagnostic.open_float, { buffer = event.buf, desc = "lsp: open diagnostic" })
    end,
  })

  --[[
  -- LSP configurations
  -- nvim-lspconfigが提供するLSP設定は以下を参照
  -- - https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  -- - `:h lspconfig-all`
  --]]
  local lspconfig = require("lspconfig")
  local updated_capabilities = require("cmp_nvim_lsp").default_capabilities()

  updated_capabilities.textDocument.completion.completionItem.snippetSupport = true

  -- Lua
  lspconfig.lua_ls.setup({
    capabilities = updated_capabilities,
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
        runtime = {
          version = "LuaJIT",
          path = { "?.lua", "?/init.lua" },
        },
        diagnostics = {
          globals = { "vim" },
        },
        telemetry = { enable = false },
      },
    },
  })

  -- JSON
  lspconfig.jsonls.setup({
    filetypes = { "json", "jsonc", "json5" },
    capabilities = updated_capabilities,
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
        format = { enable = true },
      },
    },
  })

  -- Nix
  lspconfig.nil_ls.setup({
    capabilities = updated_capabilities,
  })

  -- PHP
  local get_intelephense_license = function()
    local f = assert(io.open(os.getenv("XDG_CONFIG_HOME") .. "/intelephense/licence.txt", "rb"))
    local content = f:read("*a")
    f:close()
    return string.gsub(content, "%s+", "")
  end

  lspconfig.intelephense.setup({
    capabilities = updated_capabilities,
    init_options = {
      licenceKey = get_intelephense_license(),
      globalStoragePath = os.getenv("XDG_CONFIG_HOME") .. "/intelephense",
    },
  })

  -- HTML
  lspconfig.html.setup({
    capabilities = updated_capabilities,
  })

  -- CSS
  lspconfig.cssls.setup({
    capabilities = updated_capabilities,
  })

  -- Biome
  lspconfig.biome.setup({
    capabilities = updated_capabilities,
  })

  -- Emmet
  lspconfig.emmet_language_server.setup({
    filetypes = {
      "css",
      "eruby",
      "html",
      "htmldjango",
      "javascriptreact",
      "less",
      "pug",
      "sass",
      "scss",
      "typescriptreact",
      "php",
      "twig",
    },
    capabilities = updated_capabilities,
  })
end
