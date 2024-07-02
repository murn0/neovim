return function()
  local cmp = require("cmp")
  local snippy = require("snippy")

  local cmp_buffer_locality_comparator = function(...)
    return require("cmp_buffer"):compare_locality(...)
  end

  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  vim.opt.completeopt = { "menu", "menuone", "noinsert" }

  cmp.setup({
    snippet = {
      expand = function(args)
        snippy.expand_snippet(args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "snippy" },
      { name = "path" },
      { name = "buffer" },
    }),
    sorting = {
      priority_weight = 2,
      comparators = {
        cmp_buffer_locality_comparator,
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.score,
        cmp.recently_used,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    mapping = {
      ["<C-u>"] = cmp.mapping.scroll_docs(-5),
      ["<C-d>"] = cmp.mapping.scroll_docs(5),
      ["<C-c>"] = cmp.mapping.abort(),

      -- see https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          if #cmp.get_entries() == 1 then
            cmp.confirm({ select = true })
          else
            cmp.select_next_item()
          end
        elseif snippy.can_expand_or_advance() then
          snippy.expand_or_advance()
        elseif has_words_before() then
          cmp.complete()
          if #cmp.get_entries() == 1 then
            cmp.confirm({ select = true })
          end
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif snippy.can_jump(-1) then
          snippy.previous()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<CR>"] = cmp.mapping({
        i = function(fallback)
          if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
          else
            fallback()
          end
        end,
        s = cmp.mapping.confirm({ select = true }),
        c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
      }),
    },
    formatting = {
      format = require("lspkind").cmp_format({
        mode = "symbol",
        maxwidth = 50,
        menu = {
          buffer = "[ buf]",
          nvim_lsp = "[ lsp]",
          path = "[path]",
          snippy = "[snip]",
        },
      }),
    },
  })
end
