return function()
  --[[
  -- Keymaps
  --]]
  vim.keymap.set({ "n", "v" }, "<leader>f", "<Cmd>Format<CR>", { desc = "Format current buffer" })

  --[[
  -- Commands
  --]]
  -- Set "Format" command
  vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ["end"] = { args.line2, end_line:len() },
      }
    end
    require("conform").format({ async = true, lsp_fallback = true, range = range })
  end, { range = true })

  -- Set "FormatOnSaveDisable" command
  vim.api.nvim_create_user_command("FormatOnSaveDisable", function(args)
    if args.bang then
      -- FormatDisable! will disable formatting just for this buffer
      vim.b.disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
  end, {
    desc = "Disable autoformat-on-save",
    bang = true,
  })

  -- Set "FormatOnSaveEnable" command
  vim.api.nvim_create_user_command("FormatOnSaveEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
  end, {
    desc = "Re-enable autoformat-on-save",
  })

  --[[
  -- Formatter configurations
  --]]
  require("conform").setup({
    formatters_by_ft = {
      bash = { "shfmt", "shellcheck", "shellharden" },
      sh = { "shfmt", "shellcheck", "shellharden" },
      javascript = { { "biome", "prettier" } },
      javascriptreact = { { "biome", "prettier" } },
      json = { { "biome", "prettier" } },
      lua = { "stylua", "luacheck" },
      nix = { "alejandra" },
      markdown = { "prettier", "injected" },
      yaml = { "prettier" },
      typescript = { { "biome", "prettier" } },
      typescriptreact = { { "biome", "prettier" } },
      php = { "php_cs_fixer" },
      twig = { "djlint" },
      html = { "prettier" },
      css = { "prettier", "stylelint" },
      scss = { "prettier", "stylelint" },
      ["*"] = { "codespell" },
      ["_"] = { "trim_whitespace" },
    },
    formatters = {
      biome = {
        command = "biome", -- not necessarily from node_modules/.bin
      },
      stylua = {
        require_cwd = true, -- only when it finds the root marker
      },
    },
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 5000, lsp_fallback = true }
    end,
  })

  vim.o.formatexpr = [[v:lua.require("conform").formatexpr()]]
end
