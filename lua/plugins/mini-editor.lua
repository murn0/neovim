return function()
  local modules = {
    "mini.align",
    "mini.bracketed",
    "mini.bufremove",
    "mini.cursorword",
    "mini.jump",
    "mini.notify",
    "mini.pairs",
    "mini.splitjoin",
  }

  -- Setup
  for _, module_name in ipairs(modules) do
    require(module_name).setup({})
  end

  -- mini.bufremove keymaps
  vim.keymap.set("n", "<leader>bd", function()
    require("mini.bufremove").delete(0, false)
  end, { desc = "Delete buffer" })

  -- mini.hipatterns setting
  local hipatterns = require("mini.hipatterns")

  hipatterns.setup({
    highlighters = {
      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
      table_of_contents = { pattern = "TOC:", group = "MiniStatuslineModeCommand" },
    },
  })

  -- mini.move setting
  require("mini.move").setup({
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = "<C-M-Left>",
      right = "<C-M-Right>",
      down = "<C-M-Down>",
      up = "<C-M-Up>",

      -- Move current line in Normal mode
      line_left = "<C-M-Left>",
      line_right = "<C-M-Right>",
      line_down = "<C-M-Down>",
      line_up = "<C-M-Up>",
    },
  })
end
