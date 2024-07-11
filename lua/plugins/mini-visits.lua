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
            local default_opts = pick.get_picker_opts()
            local label = string.match(default_opts.source.name, '"([^"]+)"')
            local path = pick.get_picker_matches().current
            -- label名の選択画面ではlabelがnilなのでpickerを終了する
            if label == nil then
              return true
            end

            -- fileの選択画面での処理
            visits.remove_label(label, path)
            pick.stop()
            print("Delete visit path: " .. path .. "(" .. label .. ")")
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
    visits.remove_label()
  end, { desc = "Remove a label from a file" })

  local function removeLabelWithBrachName()
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
    if vim.v.shell_error ~= 0 then
      return nil
    end
    branch = vim.trim(branch)
    visits.remove_label(branch)
  end

  keymap.set("n", "<leader>vb", function()
    removeLabelWithBrachName()
  end, { desc = "Add label a file with the branch name for MiniVisits" })

  local createCommand = vim.api.nvim_create_user_command

  createCommand("VisitsAddLabel", function()
    visits.add_label()
  end, { desc = "Add label to a file" })

  createCommand("VisitsRemoveLabel", function()
    visits.remove_label()
  end, { desc = "Remove a label from a file" })

  createCommand("VisitsAddBranchLabel", function()
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
    if vim.v.shell_error ~= 0 then
      return nil
    end
    branch = vim.trim(branch)
    visits.add_label(branch)
  end, { desc = "Add label a file with the branch name" })

  createCommand("VisitsRemoveBranchLabel", function()
    removeLabelWithBrachName()
  end, { desc = "Remove the branch name label from a file" })

  --[[
  -- Configurations
  --]]
  visits.setup()
end
