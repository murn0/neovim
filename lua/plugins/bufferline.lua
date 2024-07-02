return function()
  --[[
  -- Keymaps
  --]]
  local keymap = vim.keymap
  keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>")
  keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>")
  keymap.set("n", "[m", "<Cmd>BufferLineMovePrev<CR>")
  keymap.set("n", "]m", "<Cmd>BufferLineMoveNext<CR>")

  --[[
  -- Configurations
  --]]
  require("bufferline").setup({
    options = {
      -- close_command = function(n)
      --   require("mini.bufremove").delete(n, false)
      -- end,
      -- right_mouse_command = function(n)
      --   require("mini.bufremove").delete(n, false)
      -- end,
      show_buffer_close_icons = false,
      show_close_icon = false,
      move_wraps_at_ends = true,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diag)
        local icons = require("icons").diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
    },
  })
end
