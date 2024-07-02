return function()
  local keymap = vim.keymap

  keymap.set("n", "<leader>l", "<Cmd>LazyGit<CR>", { desc = "Open LazyGit" })
end
