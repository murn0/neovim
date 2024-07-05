return function()
  local lint = require("lint")

  lint.linters_by_ft = {
    bash = { "shellcheck" },
    nix = { "statix" },
    lua = { "luacheck" },
    -- TODO: BiomeのCSSのLint機能が追加されたら削除できないか確認する
    css = { "stylelint" },
    scss = { "stylelint" },
  }

  -- Lua
  lint.linters.luacheck.args = { "--globals", "vim", "--no-max-line-length" }

  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
      require("lint").try_lint()
    end,
  })
end
