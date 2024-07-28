return function()
  local toggleterm = require("toggleterm")

  vim.keymap.set("n", "<leader>t", function()
    toggleterm.toggle_command("direction=float", vim.v.count)
  end, { desc = "Toggle terminal" })

  toggleterm.setup({})
end
