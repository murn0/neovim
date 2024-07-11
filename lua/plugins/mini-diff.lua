return function()
  local diff = require("mini.diff")

  vim.keymap.set("n", "<leader>gh", function()
    diff.toggle_overlay()
  end, { desc = "Toggle git hunk preview from MiniDiff" })

  vim.api.nvim_create_user_command("ToggleDiffOverlay", function()
    diff.toggle_overlay()
  end, { desc = "Toggle git hunk preview from MiniDiff" })

  diff.setup()
end
