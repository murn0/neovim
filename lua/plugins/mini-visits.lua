return function()
  local visits = require("mini.visits")
  local pick = require("mini.pick")
  local extra = require("mini.extra")

  --[[
  -- Keymaps
  --]]
  local keymap = vim.keymap

  -- pick
  pick.registry.custom_visit_paths = function(local_opts)
    extra.pickers.visit_paths(local_opts, {
      mappings = {
        delete_path = {
          char = "<C-q>",
          func = function()
            local choose_path = pick.get_picker_matches().current
            visits.remove_path(choose_path)
            -- pickのリストを更新するとちらつきが発生するため、picker自体を閉じる
            -- see https://github.com/echasnovski/mini.nvim/issues/525#issuecomment-1767795741
            pick.stop()
            print("Delete visit path: " .. choose_path)
          end,
        },
      },
    })
  end
  keymap.set("n", "<M-v>", function()
    pick.registry.custom_visit_paths()
  end, { desc = "find paths from MiniVisits" })

  pick.registry.custom_visit_labels = function(local_opts)
    extra.pickers.visit_labels(local_opts, {
      mappings = {
        delete_label = {
          char = "<C-q>",
          func = function()
            local choose_label = pick.get_picker_matches().current
            visits.remove_label(choose_label)
            pick.stop()
            print("Delete visit label: " .. choose_label)
          end,
        },
      },
    })
  end
  keymap.set("n", "<M-l>", function()
    pick.registry.custom_visit_labels()
  end, { desc = "find labels from MiniVisits" })

  -- set label
  keymap.set("n", "<leader>vl", function()
    visits.add_label()
  end, { desc = "add label for MiniVisits" })
  keymap.set("n", "<leader>vL", function()
    visits.remove_label()
  end, { desc = "remove label for MiniVisits" })

  keymap.set("n", "<leader>vb", function()
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
    if vim.v.shell_error ~= 0 then
      return nil
    end
    branch = vim.trim(branch)
    visits.add_label(branch)
  end, { desc = "add branch label for MiniVisits" })
  keymap.set("n", "<leader>vB", function()
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
    if vim.v.shell_error ~= 0 then
      return nil
    end
    branch = vim.trim(branch)
    visits.remove_label(branch)
  end, { desc = "remove branch label for MiniVisits" })

  --[[
  -- Configurations
  --]]
  visits.setup()
end
