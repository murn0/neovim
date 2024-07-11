return function()
  local tabline = require("mini.tabline")
  local palette = require("nightfox.palette").load("nightfox")

  vim.api.nvim_set_hl(0, "MiniTablineCurrent", {
    fg = palette.fg1,
    bg = palette.bg1,
    bold = true,
  })

  vim.api.nvim_set_hl(0, "MiniTablineVisible", {
    fg = palette.fg2,
    bg = palette.bg3,
  })

  vim.api.nvim_set_hl(0, "MiniTablineHidden", {
    fg = palette.fg3,
    bg = "#363636",
  })

  vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", {
    fg = palette.yellow.base,
    bg = palette.bg1,
    bold = true,
    italic = true,
  })

  vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", {
    fg = palette.yellow.dim,
    bg = palette.bg3,
    italic = true,
  })

  vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", {
    fg = palette.yellow.dim,
    bg = "#363636",
    italic = true,
  })

  vim.api.nvim_set_hl(0, "MiniTablineFill", {
    bg = palette.bg1,
  })

  tabline.setup()
end
