return function()
  local lint = require("lint")

  lint.linters_by_ft = {
    bash = { "shellcheck" },
    nix = { "statix" },
    lua = { "luacheck" },
    json = { "jsonlint" },
    -- TODO: BiomeのCSSのLint機能が追加されたら削除できないか確認する
    css = { "stylelint" },
    scss = { "stylelint" },
  }

  -- Lua
  lint.linters.luacheck.args = { "--globals", "vim", "--no-max-line-length" }

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    callback = function()
      local buf = vim.api.nvim_buf_get_name(0)
      if string.find(buf, "%.github/workflows/.*%.yml") then
        lint.try_lint("actionlint", { cwd = vim.loop.cwd() })
      else
        lint.try_lint()
      end
    end,
  })
end
