return function()
  local pick = require("mini.pick")
  local extra = require("mini.extra")

  --[[
  -- Keymaps
  --]]
  local keymap = vim.keymap

  keymap.set("n", "<C-p>", function()
    pick.builtin.files()
  end, { desc = "find files" })

  keymap.set("n", "<M-h>", function()
    pick.builtin.help()
  end, { desc = "find help tags" })

  keymap.set("n", "<M-F>", function()
    pick.builtin.grep_live()
  end, { desc = "find pattern match for ripgrep" })

  keymap.set("n", "<M-p>", function()
    extra.pickers.oldfiles()
  end, { desc = "find old files" })

  keymap.set({ "n", "i" }, "<M-r>", function()
    extra.pickers.registers()
  end, { desc = "find registers" })

  keymap.set("n", "<M-j>", function()
    extra.pickers.list({ scope = "jump" })
  end, { desc = "find jumplist" })

  keymap.set("n", "<M-m>", function()
    extra.pickers.marks()
  end, { desc = "find marks" })

  keymap.set("n", "<M-k>", function()
    extra.pickers.keymaps()
  end, { desc = "find keymaps" })

  keymap.set("n", "<M-d>", function()
    extra.pickers.diagnostic()
  end, { desc = "find diagnostic" })

  keymap.set("n", "<M-g>", function()
    extra.pickers.git_hunks()
  end, { desc = "find unstage git hunks" })

  keymap.set("n", "<M-c>", function()
    extra.pickers.git_commits()
  end, { desc = "find git commits" })

  keymap.set("n", "<M-o>", function()
    extra.pickers.lsp({ scope = "document_symbol" })
  end, { desc = "find lsp symbol for current file" })

  keymap.set("n", "<M-z>", function()
    extra.pickers.spellsuggest()
  end, { desc = "find spell suggestion" })

  keymap.set("n", "<M-,>", function()
    extra.pickers.options()
  end, { desc = "find neovim options" })

  keymap.set("n", "<M-f>", function()
    extra.pickers.buf_lines({ scope = "current" })
  end, { desc = "find word for current buffer", nowait = true })

  keymap.set("n", "<M-e>", function()
    extra.pickers.treesitter()
  end, { desc = "find in treesitter" })

  keymap.set("n", "<M-E>", function()
    extra.pickers.explorer()
  end, { desc = "open explorer" })

  keymap.set("n", "<M-b>", function()
    local wipeout_cur = function()
      vim.api.nvim_buf_delete(pick.get_picker_matches().current.bufnr, {})
    end
    local buffer_mappings = { wipeout = { char = "<C-d>", func = wipeout_cur } }
    pick.builtin.buffers({}, { mappings = buffer_mappings })
  end, { desc = "find buffers" })

  keymap.set("n", "<M-:>", function()
    local copy_cmd = function()
      vim.fn.setreg("+", pick.get_picker_matches().current:gsub("^:", ""))
      pick.stop()
    end
    local buffer_mappings = { copy = { char = "+", func = copy_cmd } }
    extra.pickers.history({ scope = ":" }, { mappings = buffer_mappings })
  end, { desc = "find command history" })

  keymap.set("n", "<M-/>", function()
    local copy_cmd = function()
      vim.fn.setreg("+", pick.get_picker_matches().current:gsub("^/", ""))
      pick.stop()
    end
    local buffer_mappings = { copy = { char = "+", func = copy_cmd } }
    extra.pickers.history({ scope = "/" }, { mappings = buffer_mappings })
  end, { desc = "find search history" })

  keymap.set("n", "_", function()
    local items = {
      { value = "SaveNewSession", text = "Save New Session" },
      { value = "DeleteSession", text = "Delete Session" },
      { value = "VisitsAddLabel", text = "Add label to a file" },
      { value = "VisitsAddBranchLabel", text = "Add label a file with the branch name" },
      { value = "ToggleDiffOverlay", text = "Toggle diff overlay" },
    }
    -- item.valueを使用して、グローバルなコマンドを取得
    local commands = {}
    for _, item in ipairs(items) do
      commands[item.value] = vim.api.nvim_get_commands({})[item.value] or {}
    end

    local choose = function(item)
      local value = item.value

      local data = commands[value] or {}
      -- `data.nargs == '0'`は、コマンドが引数を取らない場合にチェックする
      -- 引数が不要な場合は \r（Enterキー）を追加、
      -- 引数が必要な場合はスペースを追加して、ユーザーが引数を入力できるようにする
      local keys = string.format(":%s%s", value, data.nargs == "0" and "\r" or " ")

      vim.schedule(function()
        vim.fn.feedkeys(keys)
      end)
    end

    pick.start({ source = { items = items, name = "Run commands", choose = choose } })
  end, { desc = "Run command" })

  keymap.set("n", "<m-_>", function()
    extra.pickers.commands()
  end, { desc = "find commands" })

  --[[
  -- Configurations
  --]]
  pick.setup({
    mappings = {
      toggle_info = "?",
    },
  })

  vim.ui.select = pick.ui_select
end
