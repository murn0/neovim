# このファイルでは、基幹的なプラグインを上から順に設定しているので上部にあるプラグイン設定の方が重要度が高くなる
{pkgs, ...}: let
  inherit (pkgs) vimPlugins;
in rec {
  ###
  # TOC: LSP
  ###
  lspconfig = {
    package = vimPlugins.nvim-lspconfig;
    event = ["VeryLazy" "BufReadPre" "BufReadPost"];
    config = ./lsp.lua;
    runtimeDeps = with pkgs; [
      lua-language-server
      nil
      nodePackages.intelephense
      vscode-langservers-extracted # For HTML/CSS/JSON
      emmet-language-server
      biome
      nodePackages.typescript-language-server # For JavaScript/TypeScript
      typescript # For JavaScript/TypeScript
      yaml-language-server
    ];
    dependencies = {
      inherit cmp-nvim-lsp;
      schemastore = {
        package = vimPlugins.SchemaStore-nvim;
      };
      neoconf = {
        package = vimPlugins.neoconf-nvim;
        config = true;
      };
    };
  };

  ###
  # TOC: cmp
  ###
  cmp = {
    package = vimPlugins.nvim-cmp;
    event = ["InsertEnter"];
    config = ./cmp.lua;
    dependencies = {
      inherit cmp-nvim-lsp;
      cmp-path = {package = vimPlugins.cmp-path;};
      cmp-buffer = {package = vimPlugins.cmp-buffer;};
      nvim-snippy = {
        package = vimPlugins.nvim-snippy;
        dependencies = {
          cmp-snippy = {package = vimPlugins.cmp-snippy;};
          vim-snippets = {package = vimPlugins.vim-snippets;};
        };
      };
    };
  };

  cmp-nvim-lsp = {
    package = vimPlugins.cmp-nvim-lsp;
    dependencies = {
      lspkind = {package = vimPlugins.lspkind-nvim;};
    };
  };

  ###
  # TOC: Treesitter
  ###
  nvim-treesitter = {
    package = pkgs.symlinkJoin {
      name = "nvim-treesitter";
      paths = [vimPlugins.nvim-treesitter] ++ vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
    };
    event = ["BufReadPost"];
    main = "nvim-treesitter.configs";
    dependencies = {
      nvim-ts-context-commentstring = {
        package = vimPlugins.nvim-ts-context-commentstring;
        init = pkgs.writeTextFile {
          name = "ts-context-commentstring.lua";
          text = ''
            return function()
              -- 後方互換性ルーチンをスキップして読み込みを高速化
              vim.g.skip_ts_context_commentstring_module = true
            end
          '';
        };
      };
    };
    config = {
      ensure_installed = {}; # parserはプラグインでインストールしない
      highlight = {
        enable = true;
      };
      indent = {
        enable = true;
      };
      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = "<M-Up>"; # 選択範囲の拡大
          node_incremental = "<M-Up>"; # 選択範囲の拡大
          scope_incremental = false;
          node_decremental = "<M-Down>"; # 選択範囲の縮小
        };
      };
    };
  };

  nvim-treesitter-textobjects = {
    package = vimPlugins.nvim-treesitter-textobjects;
    event = ["BufReadPost"];
    dependencies = {
      mini-ai = {
        package = vimPlugins.mini-nvim;
        config = ./mini-ai.lua;
      };
      mini-surround = {
        package = vimPlugins.mini-nvim;
        config = ./mini-surround.lua;
      };
    };
  };

  nvim-ts-autotag = {
    package = vimPlugins.nvim-ts-autotag;
    event = ["BufReadPre" "BufNewFile"];
    config = true;
  };

  ###
  # TOC: Formatter
  ###
  conform = {
    package = vimPlugins.conform-nvim;
    event = ["VeryLazy"];
    config = ./conform.lua;
    runtimeDeps = with pkgs; [
      alejandra
      biome
      codespell
      luajitPackages.luacheck
      nodePackages.prettier # For Markdown/CSS/HTML
      shellcheck
      shellharden
      shfmt
      stylua
      php83Packages.php-cs-fixer
      djlint # For Twig
    ];
  };

  ###
  # TOC: Linter
  ###
  nvim-lint = {
    package = vimPlugins.nvim-lint;
    event = ["VeryLazy"];
    config = ./nvim-lint.lua;
    runtimeDeps = with pkgs; [
      luajitPackages.luacheck
      nodePackages.jsonlint
      shellcheck
      statix # For nix
      stylelint
      actionlint
    ];
  };

  ###
  # TOC: UI
  ###
  dressing = {
    package = vimPlugins.dressing-nvim;
    main = "dressing";
    event = ["UIEnter"];
    dependencies = {
      inherit nui;
    };
    config = {
      select = {
        enable = false; # vim.ui.select uses `mini.pick`
      };
    };
  };

  mini-pick = {
    package = vimPlugins.mini-nvim;
    event = ["VeryLazy"];
    dependencies = {
      inherit devicons;
    };
    config = ./mini-pick.lua;
  };

  mini-files = {
    package = vimPlugins.mini-nvim;
    event = ["VeryLazy"];
    dependencies = {
      inherit devicons;
    };
    config = ./mini-files.lua;
  };

  mini-statusline = {
    package = vimPlugins.mini-nvim;
    event = ["VeryLazy"];
    dependencies = {
      inherit devicons mini-diff mini-git;
    };
    main = "mini.statusline";
    config = true;
  };

  mini-tabline = {
    package = vimPlugins.mini-nvim;
    event = ["VeryLazy"];
    dependencies = {
      inherit devicons;
    };
    config = ./mini-tabline.lua;
  };

  ###
  # TOC: Git
  ###
  mini-git = {
    package = vimPlugins.mini-nvim;
    event = ["VeryLazy"];
    main = "mini.git";
    config = true;
  };

  mini-diff = {
    package = vimPlugins.mini-nvim;
    event = ["BufReadPre" "BufNewFile"];
    config = ./mini-diff.lua;
  };

  ###
  # TOC: Editor
  ###
  mini-editor = {
    package = vimPlugins.mini-nvim;
    event = ["VeryLazy"];
    config = ./mini-editor.lua;
  };

  dial = {
    package = vimPlugins.dial-nvim;
    event = ["VeryLazy"];
    config = ./dial.lua;
  };

  flash = {
    package = vimPlugins.flash-nvim;
    event = ["VeryLazy"];
    config = ./flash.lua;
  };

  ###
  # TOC: Indent
  ###

  indent-blankline = {
    package = vimPlugins.indent-blankline-nvim;
    event = ["BufReadPost" "BufNewFile"];
    config = ./indent-blankline.lua;
  };

  mini-indentscope = {
    package = vimPlugins.mini-nvim;
    event = ["BufReadPost" "BufNewFile"];
    config = ./mini-indentscope.lua;
  };

  ###
  # TOC: Utility
  ###
  devicons = {
    package = vimPlugins.nvim-web-devicons;
  };

  nui = {
    package = vimPlugins.nui-nvim;
  };

  plenary = {
    package = vimPlugins.plenary-nvim;
  };

  ###
  # TOC: Misc
  ###
  zen-mode = {
    package = vimPlugins.zen-mode-nvim;
    event = ["VeryLazy"];
    config = ./zen-mode.lua;
  };

  mini-misc = {
    package = vimPlugins.mini-nvim;
    event = ["VeryLazy"];
    config = ./mini-misc.lua;
  };

  mini-visits = {
    package = vimPlugins.mini-nvim;
    event = ["VeryLazy"];
    config = ./mini-visits.lua;
  };

  mini-sessions = {
    package = vimPlugins.mini-nvim;
    event = ["VeryLazy"];
    dependencies = {
      inherit nui;
    };
    config = ./mini-sessions.lua;
  };

  toggleterm = {
    package = vimPlugins.toggleterm-nvim;
    event = ["VeryLazy"];
    runtimeDeps = with pkgs; [lazygit];
    config = ./toggleterm.lua;
  };

  ###
  # TOC: Copilot
  ###
  copilot = {
    package = vimPlugins.copilot-lua;
    event = ["InsertEnter" "LspAttach"];
    main = "copilot";
    runtimeDeps = with pkgs; [
      nodejs_22
    ];
    config = {
      panel = {enabled = false;};
      suggestion = {
        enabled = true;
        auto_trigger = false;
        keymap = {
          accept = "<C-CR>";
          accept_word = "<C-w>";
          accept_line = "<C-l>";
          prev = "<C-j>";
          next = "<C-k>";
          dismiss = "<C-q>";
        };
      };
      filetypes = {
        help = true;
        markdown = true;
      };
      copilot_node_command = "${pkgs.nodejs_22}/bin/node";
    };
  };

  ###
  # TOC: Colorscheme
  ###
  nightfox-nvim = {
    package = vimPlugins.nightfox-nvim;
    lazy = false;
    priority = 1000;
    config = ./nightfox.lua;
  };
}
