{
  description = "Amaan's Neovim Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    kotlin-lsp = {
      url = "github:amaanq/kotlin-lsp-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nixCats, ... }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config = { };
      dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
      ];

      categoryDefinitions =
        { pkgs, ... }:
        {
          lspsAndRuntimeDeps = {
            general = [
              pkgs.curl
              pkgs.fd
              pkgs.ripgrep
              pkgs.copilot-language-server
            ];

            c = [
              pkgs.cmake-format
              pkgs.neocmakelsp
            ];

            dot = [
              pkgs.bash-language-server
              pkgs.shellcheck
              pkgs.shfmt
            ];

            extra = [
              pkgs.vscode-langservers-extracted
            ];

            go = [
              pkgs.gofumpt
              pkgs.gopls
              pkgs.gotools
            ];

            java = [
              pkgs.jdt-language-server
            ];

            kotlin = [
              inputs.kotlin-lsp.packages.${pkgs.stdenv.hostPlatform.system}.kotlin-lsp
              pkgs.ktlint
            ];

            lua = [
              pkgs.lua-language-server
              pkgs.luajitPackages.luacheck
              pkgs.stylua
            ];

            markdown = [
              pkgs.github-markdown-toc-go
              pkgs.markdownlint-cli2
              pkgs.marksman
            ];

            nix = [
              pkgs.nixd
              pkgs.nixfmt
            ];

            python = [
              pkgs.basedpyright
              pkgs.ruff
              # pkgs.ty
            ];

            qml = [
              pkgs.kdePackages.qtdeclarative
            ];

            rust = [
              pkgs.taplo
            ];

            svelte = [
              pkgs.svelte-language-server
            ];

            typescript = [
              pkgs.eslint_d
              pkgs.prettier
              pkgs.tailwindcss-language-server
              pkgs.vtsls
            ];

            yaml = [
              pkgs.yaml-language-server
            ];

            zig = [
              pkgs.zls
            ];
          };

          startupPlugins = {
            general = [
              pkgs.vimPlugins.lazy-nvim
            ];
          };

          optionalPlugins = {
            general = [
              pkgs.vimPlugins.blink-cmp
              pkgs.vimPlugins.bufferline-nvim
              pkgs.vimPlugins.conform-nvim
              pkgs.vimPlugins.dial-nvim
              pkgs.vimPlugins.dropbar-nvim
              pkgs.vimPlugins.friendly-snippets
              pkgs.vimPlugins.git-blame-nvim
              pkgs.vimPlugins.git-conflict-nvim
              pkgs.vimPlugins.gitsigns-nvim
              pkgs.vimPlugins.grug-far-nvim
              pkgs.vimPlugins.inc-rename-nvim
              pkgs.vimPlugins.lazydev-nvim
              # pkgs.vimPlugins.LazyVim
              pkgs.vimPlugins.lualine-nvim
              pkgs.vimPlugins.mini-ai
              pkgs.vimPlugins.mini-hipatterns
              pkgs.vimPlugins.mini-icons
              pkgs.vimPlugins.mini-pairs
              pkgs.vimPlugins.noice-nvim
              pkgs.vimPlugins.nui-nvim
              pkgs.vimPlugins.numb-nvim
              # pkgs.vimPlugins.nvim-autopairs
              pkgs.vimPlugins.nvim-lint
              pkgs.vimPlugins.nvim-lspconfig
              # pkgs.vimPlugins.nvim-treesitter-context
              # pkgs.vimPlugins.nvim-treesitter-textobjects
              # (pkgs.vimPlugins.nvim-treesitter.withPlugins (
              #   p: pkgs.vimPlugins.nvim-treesitter.allGrammars ++ [ testGrammar ]
              # ))
              pkgs.vimPlugins.nvim-ts-autotag
              pkgs.vimPlugins.persistence-nvim
              pkgs.vimPlugins.SchemaStore-nvim
              # pkgs.vimPlugins.snacks-nvim
              pkgs.vimPlugins.toggleterm-nvim
              # pkgs.vimPlugins.tokyonight-nvim
              pkgs.vimPlugins.treesj
              pkgs.vimPlugins.ts-comments-nvim
              pkgs.vimPlugins.trouble-nvim
              pkgs.vimPlugins.which-key-nvim
              pkgs.vimPlugins.yanky-nvim
            ];

            c = [
              pkgs.vimPlugins.clangd_extensions-nvim
            ];

            rust = [
              pkgs.vimPlugins.crates-nvim
              pkgs.vimPlugins.rustaceanvim
            ];

            typescript = [
              pkgs.vimPlugins.package-info-nvim
            ];
          };
        };

      packageDefinitions =

        let
          defaultCategories = {
            general = true;
            c = true;
            dot = true;
            extra = true;
            go = true;
            java = true;
            kotlin = true;
            lua = true;
            markdown = true;
            nix = true;
            python = true;
            # qml = true;
            rust = true;
            svelte = true;
            typescript = true;
            yaml = true;
            zig = true;
          };
        in
        {
          nvim =
            { pkgs, ... }:
            {
              settings = {
                suffix-path = true;
                suffix-LD = true;
                wrapRc = true;
                autoPluginDeps = false;
                aliases = [
                  "nv"
                  "vi"
                ];
                neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
              };
              categories = defaultCategories;
            };

          server =
            { pkgs, ... }:
            {
              settings = {
                suffix-path = true;
                suffix-LD = true;
                wrapRc = true;
                autoPluginDeps = false;
                aliases = [
                  "nv"
                  "vi"
                ];
                neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
              };
              categories = {
                general = true;
                nix = true;
              };
            };

          testnvim =
            { pkgs, ... }:
            {
              settings = {
                suffix-path = true;
                suffix-LD = true;
                wrapRc = false;
                neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
                unwrappedCfgPath = utils.mkLuaInline "os.getenv('HOME') .. '/.config/nvim'";
              };
              categories = defaultCategories;
            };
        };
      defaultPackageName = "nvim";
    in

    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            ;
          extra_pkg_config = {
            allowUnfreePredicate =
              pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "copilot-language-server"
              ];
          };
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;

        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = "";
          };
        };

      }
    )
    // (
      let
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };

        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in
      {
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );
}
