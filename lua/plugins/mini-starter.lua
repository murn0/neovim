return function()
  local starter = require("mini.starter")

  starter.setup({
    evaluate_single = true,
    items = {
      starter.sections.recent_files(5, false),
      starter.sections.sessions(5, true),
      { action = "Pick explorer", name = "Explorer", section = "Pick" },
      { action = "Pick files", name = "Files", section = "Pick" },
      { action = "Pick grep_live", name = "Grep live", section = "Pick" },
      starter.sections.builtin_actions(),
    },
  })
end
