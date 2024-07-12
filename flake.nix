{
  description = "Neovim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    neovim-flake.url = "github:murn0/neovim-flake";
    neovim.url = "github:nix-community/neovim-nightly-overlay";
    pre-commit-nix.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.pre-commit-nix.flakeModule
        inputs.neovim-flake.flakeModule
      ];

      systems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];
      perSystem = {
        config,
        inputs',
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        neovim = {
          ## Neovim nightlyを使用する場合はコメントアウトを外す
          # package = inputs'.neovim.packages.default;
          configPath = ./.;
          initLua.src = ./init.lua;
          dependencies = with pkgs; [
            tree-sitter
            zig
            git
          ];
          lazy = {
            package = pkgs.fetchFromGitHub {
              owner = "folke";
              repo = "lazy.nvim";
              rev = "refs/tags/v10.24.2";
              sha256 = "sha256-gw/X5QffH2IoWLsWbpHMT1sup3LrCa5bT1t+cGDf4RQ=";
            };
            plugins = import ./lua/plugins/spec.nix {
              inherit pkgs;
            };
          };
        };

        packages = {
          default = config.neovim.result;
        };

        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          name = "neovim.nix";
          nativeBuildInputs = with pkgs; [
            just
          ];
          packages = [
            config.neovim.result
          ];
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };

        pre-commit = {
          settings = {
            hooks.alejandra.enable = true;
            hooks.stylua.enable = true;
          };
        };
      };
    };
}
