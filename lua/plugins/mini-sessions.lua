return function()
  local pick = require("mini.pick")
  local extra = require("mini.extra")

  vim.api.nvim_create_user_command("SaveNewSession", function(opts)
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
        print("Cancel add new session")
      end,
      on_submit = function(value)
        require("mini.sessions").write(value)
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
    -- require("mini.sessions").write(vim.ui.input("Session name: ", ""))
  end, { desc = "Save New Session" })

  --[[
  -- Keymaps
  --]]
  local keymap = vim.keymap

  require("mini.sessions").setup({})
end
