local u = require("utils")

return {

  -- TOC: Copilot
  u.from_nixpkgs({
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter", "LspAttach" },
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
        layout = {
          position = "right",
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        keymap = {
          accept = "<M-CR>",
          accept_word = "<C-w>",
          accept_line = "<C-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-q>",
        },
      },
      filetypes = {
        markdown = true,
      },
    },
  }),
}
