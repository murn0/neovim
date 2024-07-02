return function()
  --[[
  -- Keymaps
  --]]
  vim.keymap.set("n", "<C-Up>", function()
    require("dial.map").manipulate("increment", "normal")
  end)
  vim.keymap.set("n", "<C-Down>", function()
    require("dial.map").manipulate("decrement", "normal")
  end)
  vim.keymap.set("n", "g<C-Up>", function()
    require("dial.map").manipulate("increment", "gnormal")
  end)
  vim.keymap.set("n", "g<C-Down>", function()
    require("dial.map").manipulate("decrement", "gnormal")
  end)
  vim.keymap.set("v", "<C-Up>", function()
    require("dial.map").manipulate("increment", "visual")
  end)
  vim.keymap.set("v", "<C-Down>", function()
    require("dial.map").manipulate("decrement", "visual")
  end)
  vim.keymap.set("v", "g<C-Up>", function()
    require("dial.map").manipulate("increment", "gvisual")
  end)
  vim.keymap.set("v", "g<C-Down>", function()
    require("dial.map").manipulate("decrement", "gvisual")
  end)

  --[[
  -- Configurations
  --]]
  local augend = require("dial.augend")

  require("dial.config").augends:register_group({
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.date.alias["%Y/%m/%d"],
      augend.constant.alias.bool,
      augend.semver.alias.semver,
      augend.constant.new({ elements = { "let", "const" } }),
    },
  })
end
