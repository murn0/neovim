return function()
  local toggleterm = require("toggleterm")
  local Terminal = require("toggleterm.terminal").Terminal
  local pick = require("mini.pick")

  --[[
  -- Keymaps
  --]]
  local keymap = vim.keymap

  -- ターミナルモード用のkeymapを設定
  function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
    keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
  end

  -- ToggleTerm以外の端末モードでもこのkeymapを使用したい場合は`term://*`に設定する
  vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

  -- <M-¥>にToggleTermのコマンドを表示するkeymapを設定
  keymap.set("n", "\\", function()
    local items = {
      { value = "vertical", text = "Show vertical" },
      { value = "horizontal", text = "Show horizontal" },
      { value = "float", text = "Show float" },
      { value = "tab", text = "Show tab" },
      { value = "all", text = "Show all terminals" },
      { value = "select", text = "Select terminal" },
      { value = "name", text = "Set terminal name" },
    }

    local choose = function(item)
      local value = item.value
      local keys = ""
      if value == "all" then
        keys = ":ToggleTermToggleAll\n"
      elseif value == "select" then
        keys = ":TermSelect\n"
      elseif value == "name" then
        keys = ":ToggleTermSetName\n"
      else
        keys = ":ToggleTerm direction=" .. value .. "\n"
      end

      vim.schedule(function()
        vim.fn.feedkeys(keys)
      end)
    end

    pick.start({ source = { items = items, name = "Select ToggleTerm commands", choose = choose } })
  end, { desc = "Select ToggleTerm commands" })

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

  --[[
  -- Configurations
  --]]
  toggleterm.setup({
    size = function(args)
      if args.direction == "horizontal" then
        return 17
      elseif args.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = { [[<c-\>]], [[<c-¥>]] },
  })
end
