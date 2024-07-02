return function()
  local ai = require("mini.ai")
  local gen_ai_spec = require("mini.extra").gen_ai_spec

  ai.setup({
    mappings = {
      around_last = "",
      inside_last = "",
    },
    n_lines = 200,
    custom_textobjects = {
      -- b(alance) textobject: (),[],{ } alias
      -- q(uote) textobject: '',"",`` alias
      a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      l = ai.gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
      c = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" }),
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
      -- B = gen_ai_spec.buffer(),
      -- i = gen_ai_spec.indent(),
      -- d = gen_ai_spec.diagnostic(),
      L = gen_ai_spec.line(),
    },
  })

  -- TODO: mini.bracketsで代替できそう
  -- for _, op in pairs({ "c" }) do
  --   vim.keymap.set("n", "]" .. op, function ()
  --     ai.move_cursor("left", "a", op, { search_method = "next" })
  --   end, {
  --     desc = "Goto next start of a" .. op .. " textobject",
  --   })
  --
  --   vim.keymap.set("n", "[" .. op, function ()
  --     ai.move_cursor("left", "a", op, { search_method = "prev" })
  --   end, {
  --     desc = "Goto previous start of a" .. op .. " textobject",
  --   })
  -- end

  local keymap = vim.keymap

  for _, op in pairs({ "a", "f", "l" }) do
    -- textobjectの最後に移動できるkeymapを設定
    -- e.g. [Fで前のfunctionの最後に移動
    keymap.set("n", "[" .. string.upper(op), function()
      ai.move_cursor("right", "a", op, { search_method = "prev" })
    end, {
      desc = "Goto previous end of a" .. op .. " textobject",
    })

    keymap.set("n", " ]" .. string.upper(op), function()
      ai.move_cursor("right", "a", op, { search_method = "next" })
    end, {
      desc = "Goto next end of a" .. op .. " textobject",
    })

    -- textobjectの最初に移動できるkeymapを設定
    -- e.g. [fで前のfunctionの最初に移動
    keymap.set("n", "[" .. op, function()
      ai.move_cursor("left", "i", op, { search_method = "prev" })
    end, {
      desc = "Goto previous start of a" .. op .. " textobject",
    })

    keymap.set("n", "]" .. op, function()
      ai.move_cursor("left", "i", op, { search_method = "next" })
    end, {
      desc = "Goto next start of a" .. op .. " textobject",
    })
  end
end
