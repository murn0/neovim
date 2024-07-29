return function()
  local toggleterm = require("toggleterm")

  vim.keymap.set("n", "<leader>t", function()
    toggleterm.toggle_command("direction=float", vim.v.count)
  end, { desc = "Toggle terminal" })

  toggleterm.setup({})
  -- Lazygitの設定
  local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true, -- hidden=trueだとToggleTermToggleAllなどで開かない
    direction = "float",
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })

      -- LazyGitの起動中はキャンセルに<Esc>を使用するのでキーマップを変更
      -- キーマップが存在するかチェックし、存在する場合は削除する関数
      local function safe_del_keymap(mode, lhs, opts)
        opts = opts or {}

        -- キーマップの存在をチェック
        if vim.fn.mapcheck(lhs, mode) ~= "" then
          -- キーマップが存在する場合、削除を実行
          vim.keymap.del(mode, lhs, opts)
        end
      end

      safe_del_keymap("t", "<esc>", { buffer = term.bufnr })
      keymap.set("t", "<C-q>", [[<C-\><C-n>]], { buffer = term.bufnr })
    end,
    on_close = function()
      vim.cmd("startinsert!")
    end,
  })

  keymap.set("n", "<Leader>l", function()
    lazygit:toggle()
  end, { desc = "Open LazyGit" })
end
