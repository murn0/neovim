return function()
  local sessions = require("mini.sessions")

  -- [[
  -- User command
  -- ]]
  vim.api.nvim_create_user_command("SaveNewSession", function()
    local Input = require("nui.input")
    local event = require("nui.utils.autocmd").event
    local input = Input({
      position = "50%",
      size = {
        width = 30,
      },
      border = {
        style = "single",
        text = {
          top = "[New session name]",
          top_align = "left",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:Normal",
      },
    }, {
      prompt = "> ",
      default_value = "",
      on_close = function()
        print("Cancel create new session")
      end,
      on_submit = function(value)
        sessions.write(value)
      end,
    })
    -- mount/open the component
    input:mount()

    -- unmount component when cursor leaves buffer
    input:on(event.BufLeave, function()
      input:unmount()
    end)

    -- unmount input by pressing `<Esc>` in normal mode
    input:map("n", "<Esc>", function()
      input:unmount()
    end, { noremap = true })
  end, { desc = "Save New Session" })

  vim.api.nvim_create_user_command("DeleteSession", function()
    sessions.select("delete")
  end, { desc = "Delete select session" })

  --[[
  -- Keymaps
  --]]
  local keymap = vim.keymap

  keymap.set("n", "<M-s>", function()
    sessions.select()
  end, { desc = "find session" })
end
