return function()
  local flash = require("flash")

  local keymap = vim.keymap
  keymap.set({ "n", "o", "x" }, "<leader><Space>", function()
    flash.jump()
  end, { desc = "Code jump" })
  keymap.set({ "n", "o", "x" }, "<M-Space>", function()
    flash.treesitter()
  end, { desc = "Code jump for treesitter" })

  flash.setup({
    search = {
      exclude = {
        "starter",
      },
    },
    modes = {
      char = {
        -- leave the f-motion to mini.jump.
        enabled = false,
      },
    },
  })
end
