return function()
  require("nightfox").setup({
    palettes = {
      nightfox = {
        bg0 = "#22262E",
        bg1 = "#212222",
        bg3 = "#363636",
      },
    },
    groups = {
      all = {
        Visual = {
          bg = "#51476D",
        },
        NormalNC = {
          -- Non-current windows
          bg = "#363636",
        },
      },
    },
  })

  vim.cmd([[colorscheme nightfox]])

  vim.api.nvim_create_user_command("ToggleTransparent", function()
    local config = require("nightfox.config").options
    local transparent_value = config.transparent

    require("nightfox").setup({
      options = {
        transparent = not transparent_value,
      },
    })

    vim.cmd([[colorscheme nightfox]])
  end, { desc = "Toggle background transparent" })

  vim.keymap.set("n", "<F6>", "<Cmd>ToggleTransparent<CR>", { desc = "Toggle background transparent" })
end
