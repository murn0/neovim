return function()
  --[[
  -- Keymaps
  --]]
  vim.keymap.set("n", "_", function()
    require("mini.files").open(vim.api.nvim_buf_get_name(0))
  end, { desc = "browse files" })

  --[[
  -- Configuration
  --]]
  require("mini.files").setup({
    mappings = {
      -- go_in = "<Right>",
      -- go_in_plus = "<S-Right>",
      -- go_out = "<Left>",
      -- go_out_plus = "<S-Left>",
      close = "<ESC>",
      show_help = "?",
    },
  })
end
