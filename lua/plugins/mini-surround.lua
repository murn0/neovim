return function()
  local ts_input = require("mini.surround").gen_spec.input.treesitter

  require("mini.surround").setup({
    -- b(alance) textobject: (),[],{} alias
    -- q(uote) textobject: '',"",`` alias
    search_method = "cover_or_next",
    custom_surroundings = {
      a = {
        input = ts_input({ outer = "@parameter.outer", inner = "@parameter.inner" }),
      },
      f = {
        input = ts_input({ outer = "@function.outer", inner = "@function.inner" }),
      },
      c = {
        input = ts_input({ outer = "@conditional.outer", inner = "@conditional.inner" }),
      },
      l = {
        input = ts_input({ outer = "@loop.outer", inner = "@loop.inner" }),
      },
      t = {
        input = { "<(%w-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- from https://github.com/echasnovski/mini.surround/blob/14f418209ecf52d1a8de9d091eb6bd63c31a4e01/lua/mini/surround.lua#LL1048C13-L1048C72
        output = function()
          local emmet = require("mini.surround").user_input("Emmet")
          if not emmet then
            return nil
          end
          return require("parser.emmet").totag(emmet)
        end,
      },
    },
  })
end
