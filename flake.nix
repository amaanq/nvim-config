{
  description = "Amaan's Neovim Flake";

  outputs =
    { self, ... }@args:
    let
      tackInputs = (import ./.tack) { overrides = args.tackOverrides or { }; };
      inputs = tackInputs // {
        inherit self;
      };
      inherit (inputs)
        kotlin-lsp
        neovim-nightly-overlay
        nixCats
        nixpkgs
        nufmt-src
        taplo-src
        tree-sitter-aidl-src
        tree-sitter-blueprint-src
        ;
      inherit (nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config = { };
      pluginFixesOverlay = _: prev: {
        vimPlugins = prev.vimPlugins // {
          lualine-nvim = prev.vimUtils.buildVimPlugin {
            pname = "lualine.nvim";
            version = prev.vimPlugins.lualine-nvim.version;
            src = prev.vimPlugins.lualine-nvim.src;
            meta = prev.vimPlugins.lualine-nvim.meta;
          };

          rustaceanvim = prev.vimUtils.buildVimPlugin {
            pname = "rustaceanvim";
            version = prev.vimPlugins.rustaceanvim.version;
            src = prev.vimPlugins.rustaceanvim.src;
            nvimSkipModules = [
              "rustaceanvim.neotest.init"
            ];
            meta = prev.vimPlugins.rustaceanvim.meta;
          };
        };
      };
      dependencyOverlays = [
        neovim-nightly-overlay.overlays.default
        (utils.standardPluginOverlay inputs)
        pluginFixesOverlay
      ];

      categoryDefinitions =
        { pkgs, ... }:
        let
          treesitterGrammars = map pkgs.neovimUtils.grammarToPlugin [
            (pkgs.tree-sitter.buildGrammar {
              language = "aidl";
              version = "0.1.0";
              src = tree-sitter-aidl-src;
            })
            (pkgs.tree-sitter.buildGrammar {
              language = "blueprint";
              version = "0.1.0";
              src = tree-sitter-blueprint-src;
            })
          ];
        in
        {
          lspsAndRuntimeDeps = {
            general = [
              pkgs.curl
              pkgs.fd
              pkgs.ripgrep
              pkgs.tree-sitter
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
              kotlin-lsp.packages.${pkgs.stdenv.hostPlatform.system}.kotlin-lsp
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
            ];

            nix = [
              pkgs.nixd
              pkgs.nixfmt
            ];

            nushell = [
              (pkgs.nufmt.overrideAttrs {
                src = nufmt-src;
                version = "0-unstable-2026-03-16";
                postPatch = "";
                doCheck = false;
                cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
                  src = nufmt-src;
                  hash = "sha256-heHFiW1/2qV6BJH7Y0ObSV1sPfVaU0m2KLbASdzca8s=";
                };
              })
            ];

            python = [
              pkgs.ruff
              pkgs.ty
            ];

            qml = [
              pkgs.kdePackages.qtdeclarative
            ];

            rust = [
              (pkgs.taplo.overrideAttrs {
                src = taplo-src;
                version = "0.10.0";
                patches = [ ];
                cargoPatches = [ ];
                cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
                  src = taplo-src;
                  hash = "sha256-9BF+S3QrPtbuWKEbEtqNq1dBAy7l1LDK/aMWL54TcmY=";
                };
              })
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
            ]
            ++ treesitterGrammars;
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
              pkgs.vimPlugins.gitsigns-nvim
              pkgs.vimPlugins.grug-far-nvim
              pkgs.vimPlugins.inc-rename-nvim
              pkgs.vimPlugins.lazydev-nvim
              pkgs.vimPlugins.lualine-nvim
              pkgs.vimPlugins.mini-ai
              pkgs.vimPlugins.mini-hipatterns
              pkgs.vimPlugins.mini-icons
              pkgs.vimPlugins.mini-pairs
              pkgs.vimPlugins.noice-nvim
              pkgs.vimPlugins.nui-nvim
              pkgs.vimPlugins.numb-nvim
              pkgs.vimPlugins.nvim-lint
              pkgs.vimPlugins.nvim-lspconfig
              pkgs.vimPlugins.nvim-treesitter-context
              pkgs.vimPlugins.nvim-treesitter-textobjects
              pkgs.vimPlugins.nvim-ts-autotag
              pkgs.vimPlugins.persistence-nvim
              pkgs.vimPlugins.SchemaStore-nvim
              # pkgs.vimPlugins.snacks-nvim
              pkgs.vimPlugins.tokyonight-nvim
              pkgs.vimPlugins.treesj
              pkgs.vimPlugins.ts-comments-nvim
              pkgs.vimPlugins.trouble-nvim
              pkgs.vimPlugins.which-key-nvim
              pkgs.vimPlugins.yanky-nvim
              pkgs.vimPlugins.octo-nvim
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

      patchedNeovim =
        pkgs:
        pkgs.neovim-unwrapped.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [
            # Save/restore b_did_filetype for nested FileType events so that
            # doautoall FileType (e.g. from vim.lsp.enable() during lazy plugin
            # loading) does not leak the flag and break subsequent setf calls.
            ./patches/force-bufread-autocmds.patch
            ./patches/terminal-cell-snapshot.patch
          ];
        });

      packageDefinitions =

        let
          defaultCategories = {
            general = true;
            c = true;
            dot = true;
            extra = true;
            go = false;
            java = true;
            kotlin = true;
            lua = true;
            markdown = true;
            nix = true;
            nushell = true;
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
                neovim-unwrapped = patchedNeovim pkgs;
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
                neovim-unwrapped = patchedNeovim pkgs;
              };
              categories = {
                general = true;
              };
            };

          testnvim =
            { pkgs, ... }:
            {
              settings = {
                suffix-path = true;
                suffix-LD = true;
                wrapRc = false;
                neovim-unwrapped = patchedNeovim pkgs;
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
        mkOverlay =
          name: final: _:
          let
            overlayPkgs = final.appendOverlays dependencyOverlays;
          in
          {
            ${name} = utils.baseBuilder luaPath {
              pkgs = overlayPkgs;
            } categoryDefinitions packageDefinitions name;
          };

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
        overlays = (builtins.mapAttrs (name: _: mkOverlay name) packageDefinitions) // {
          default = mkOverlay defaultPackageName;
        };

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );
}
