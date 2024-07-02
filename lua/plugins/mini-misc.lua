return function()
  local misc = require("mini.misc")

  misc.setup({ make_global = { "put", "put_text", "stat_summary", "bench_time" } })
  misc.setup_auto_root({ ".git", "Makefile", "lua", "flake.nix" })
  misc.setup_restore_cursor()
end
