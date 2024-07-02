return function()
  vim.keymap.set("n", "<leader>z", "<Cmd>ZenMode<CR>", { desc = "toggle ZenMode" })

  require("zen-mode").setup({
    plugins = {
      gitsigns = true,
      tmux = true,
      kitty = { enabled = false, font = "+4" },
    },
  })
end
