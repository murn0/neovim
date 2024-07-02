return function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = {
      "help",
      "dashboard",
      "Trouble",
      "lazy",
    },
    callback = function()
      vim.b.miniindentscope_disable = true
    end,
  })

  local indentscope = require("mini.indentscope")

  indentscope.setup({
    draw = {
      animation = indentscope.gen_animation.none(),
    },
    options = {
      try_as_border = true,
    },
  })
end
