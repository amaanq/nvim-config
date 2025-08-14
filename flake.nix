{
  description = "Amaan's Neovim Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
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
              pkgs.curlHTTP3
              pkgs.fd
              pkgs.ripgrep
            ];

            c = [
              pkgs.cmake-format
              pkgs.neocmakelsp
            ];

            csharp = [
              pkgs.csharpier
              pkgs.omnisharp-roslyn
            ];

            dot = [
              pkgs.bash-language-server
              pkgs.shellcheck
              pkgs.shfmt
            ];

            elixir = [
              pkgs.beam28Packages.elixir-ls
            ];

            extra = [
              pkgs.ghostscript
              pkgs.libxml2 # xmllint
              pkgs.mermaid-cli
              pkgs.tectonic
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
              pkgs.nixfmt-rfc-style
            ];

            python = [
              pkgs.ruff
              pkgs.ty
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
              pkgs.vimPlugins.avante-nvim
              pkgs.vimPlugins.blink-cmp
              pkgs.vimPlugins.blink-cmp-npm-nvim
              pkgs.vimPlugins.bufferline-nvim
              pkgs.vimPlugins.codesnap-nvim
              pkgs.vimPlugins.comment-box-nvim
              pkgs.vimPlugins.conform-nvim
              pkgs.vimPlugins.copilot-lua
              pkgs.vimPlugins.dial-nvim
              pkgs.vimPlugins.dropbar-nvim
              pkgs.vimPlugins.edgy-nvim
              pkgs.vimPlugins.flash-nvim
              pkgs.vimPlugins.flatten-nvim
              pkgs.vimPlugins.friendly-snippets
              pkgs.vimPlugins.git-blame-nvim
              pkgs.vimPlugins.git-conflict-nvim
              pkgs.vimPlugins.gitlinker-nvim
              pkgs.vimPlugins.gitsigns-nvim
              pkgs.vimPlugins.godbolt-nvim
              pkgs.vimPlugins.grug-far-nvim
              pkgs.vimPlugins.inc-rename-nvim
              pkgs.vimPlugins.lazydev-nvim
              pkgs.vimPlugins.LazyVim
              pkgs.vimPlugins.lualine-nvim
              pkgs.vimPlugins.markdown-preview-nvim
              pkgs.vimPlugins.mini-ai
              pkgs.vimPlugins.mini-files
              pkgs.vimPlugins.mini-hipatterns
              pkgs.vimPlugins.mini-icons
              pkgs.vimPlugins.mini-pairs
              pkgs.vimPlugins.mini-surround
              pkgs.vimPlugins.neo-tree-nvim
              pkgs.vimPlugins.noice-nvim
              pkgs.vimPlugins.nui-nvim
              pkgs.vimPlugins.numb-nvim
              pkgs.vimPlugins.nvim-autopairs
              pkgs.vimPlugins.nvim-lint
              pkgs.vimPlugins.nvim-lspconfig
              pkgs.vimPlugins.nvim-treesitter-context
              pkgs.vimPlugins.nvim-treesitter-textobjects
              pkgs.vimPlugins.nvim-treesitter.withAllGrammars
              pkgs.vimPlugins.nvim-ts-autotag
              pkgs.vimPlugins.nvim-web-devicons
              pkgs.vimPlugins.nvim_context_vt
              pkgs.vimPlugins.octo-nvim
              pkgs.vimPlugins.persistence-nvim
              pkgs.vimPlugins.plenary-nvim
              pkgs.vimPlugins.playground
              pkgs.vimPlugins.render-markdown-nvim
              pkgs.vimPlugins.SchemaStore-nvim
              pkgs.vimPlugins.snacks-nvim
              pkgs.vimPlugins.todo-comments-nvim
              pkgs.vimPlugins.toggleterm-nvim
              pkgs.vimPlugins.tokyonight-nvim
              pkgs.vimPlugins.treesj
              pkgs.vimPlugins.ts-comments-nvim
              pkgs.vimPlugins.trouble-nvim
              pkgs.vimPlugins.vim-illuminate
              pkgs.vimPlugins.vim-startuptime
              pkgs.vimPlugins.vim-wakatime
              pkgs.vimPlugins.which-key-nvim
              pkgs.vimPlugins.yanky-nvim
              {
                plugin = pkgs.vimPlugins.catppuccin-nvim;
                name = "catppuccin";
              }
            ];

            c = [
              pkgs.vimPlugins.cmake-tools-nvim
              pkgs.vimPlugins.clangd_extensions-nvim
            ];

            csharp = [
              pkgs.vimPlugins.neotest-dotnet
              pkgs.vimPlugins.omnisharp-extended-lsp-nvim
            ];

            elixir = [
              pkgs.vimPlugins.neotest-elixir
            ];

            go = [
              pkgs.vimPlugins.neotest-golang
            ];

            java = [
              pkgs.vimPlugins.nvim-jdtls
            ];

            neotest = [
              pkgs.vimPlugins.nvim-nio
              pkgs.vimPlugins.neotest
            ];

            python = [
              pkgs.vimPlugins.neotest-python
            ];

            rust = [
              pkgs.vimPlugins.crates-nvim
              pkgs.vimPlugins.rustaceanvim
            ];

            typescript = [
              pkgs.vimPlugins.package-info-nvim
            ];

            zig = [
              pkgs.vimPlugins.neotest-zig
            ];
          };
        };

      packageDefinitions = {
        nvim =
          { pkgs, ... }:
          {
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              aliases = [
                "nv"
                "vi"
              ];
              neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
            };
            categories = {
              general = true;
              c = true;
              csharp = true;
              dot = true;
              elixir = true;
              extra = true;
              go = true;
              java = true;
              lua = true;
              markdown = true;
              neotest = true;
              nix = true;
              python = true;
              rust = true;
              svelte = true;
              typescript = true;
              yaml = true;
              zig = true;
            };
          };

        server =
          { pkgs, ... }:
          {
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              aliases = [
                "nv"
                "vi"
              ];
              neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
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
              neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
              unwrappedCfgPath = utils.mkLuaInline "os.getenv('HOME') .. '/.config/nvim'";
            };
            categories = {
              general = true;
              c = true;
              csharp = true;
              dot = true;
              elixir = true;
              extra = true;
              go = true;
              java = true;
              lua = true;
              markdown = true;
              neotest = true;
              nix = true;
              python = true;
              rust = true;
              svelte = true;
              typescript = true;
              yaml = true;
              zig = true;
            };
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
            extra_pkg_config
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
            shellHook = '''';
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
