return function()
  local files = require("mini.files")

  --[[
  -- Keymaps
  --]]
  vim.keymap.set("n", "<leader>e", function()
    if not files.close() then
      files.open(vim.api.nvim_buf_get_name(0))
    end
  end, { desc = "browse files" })

  --[[
  -- Configuration
  --]]
  files.setup({
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
