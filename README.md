# 💤 Neovim Config

<a href="https://dotfyle.com/amaanq/nvim-config"><img src="https://dotfyle.com/amaanq/nvim-config/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/amaanq/nvim-config"><img src="https://dotfyle.com/amaanq/nvim-config/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/amaanq/nvim-config"><img src="https://dotfyle.com/amaanq/nvim-config/badges/plugin-manager?style=flat" /></a>

This is what I currently daily drive when writing code.

Major credit goes to [@folke](https://github.com/folke) as my config is heavily
inspired by his.

## Trying out my config

## Install Instructions

> Install requires Neovim 0.9+. Always review the code before installing a configuration.

Clone the repository and install the plugins:

```sh
git clone git@github.com:amaanq/nvim-config ~/.config/amaanq/nvim-config
NVIM_APPNAME=amaanq/nvim-config/ nvim --headless +"Lazy! sync" +qa
```

Open Neovim with this config:

```sh
NVIM_APPNAME=amaanq/nvim-config/ nvim
```

![image](https://user-images.githubusercontent.com/29718261/218633577-99753269-7c96-4920-8cf7-83c566de09d8.png)

## Snapshot of my Tree-Sitter dev workflow

![image](https://user-images.githubusercontent.com/29718261/218633047-55980754-49fe-4e11-9c8e-516ac8844ae2.png)

## Lazygit

![image](https://user-images.githubusercontent.com/29718261/218633151-f475327a-d21b-4ad6-9c91-df19e902bfce.png)

## Terminal (ToggleTerm)

![image](https://user-images.githubusercontent.com/29718261/218633347-a11d8213-baa4-4465-92c0-55d0284b206e.png)

## Telescope (Live Grep & more)

![image](https://user-images.githubusercontent.com/29718261/218633394-5c856a14-cce6-4b3f-b98f-5aa266e3fa57.png)

## Spectre (replace)

![image](https://user-images.githubusercontent.com/29718261/218633464-e780dc79-ee71-4850-8a9a-724a50d81401.png)

## Swap Colorschemes (via Telescope)

![image](https://user-images.githubusercontent.com/29718261/218633755-5e14d79a-7928-48d7-bf99-83735a98713d.png)

<!-- plugins:start -->

## Plugins

### bars-and-lines

- [utilyre/barbecue.nvim](https://dotfyle.com/plugins/utilyre/barbecue.nvim)
- [SmiteshP/nvim-navic](https://dotfyle.com/plugins/SmiteshP/nvim-navic)

### color

- [folke/twilight.nvim](https://dotfyle.com/plugins/folke/twilight.nvim)

### colorscheme

- [projekt0n/github-nvim-theme](https://dotfyle.com/plugins/projekt0n/github-nvim-theme)
- [marko-cerovac/material.nvim](https://dotfyle.com/plugins/marko-cerovac/material.nvim)
- [catppuccin/nvim](https://dotfyle.com/plugins/catppuccin/nvim)
- [olimorris/onedarkpro.nvim](https://dotfyle.com/plugins/olimorris/onedarkpro.nvim)
- [rebelot/kanagawa.nvim](https://dotfyle.com/plugins/rebelot/kanagawa.nvim)
- [rose-pine/neovim](https://dotfyle.com/plugins/rose-pine/neovim)

### comment

- [LudoPinelli/comment-box.nvim](https://dotfyle.com/plugins/LudoPinelli/comment-box.nvim)

### completion

- [zbirenbaum/copilot.lua](https://dotfyle.com/plugins/zbirenbaum/copilot.lua)
- [hrsh7th/nvim-cmp](https://dotfyle.com/plugins/hrsh7th/nvim-cmp)

### cursorline

- [RRethy/vim-illuminate](https://dotfyle.com/plugins/RRethy/vim-illuminate)

### debugging

- [rcarriga/nvim-dap-ui](https://dotfyle.com/plugins/rcarriga/nvim-dap-ui)
- [mfussenegger/nvim-dap](https://dotfyle.com/plugins/mfussenegger/nvim-dap)
- [t-troebst/perfanno.nvim](https://dotfyle.com/plugins/t-troebst/perfanno.nvim)

### dependency-management

- [Saecki/crates.nvim](https://dotfyle.com/plugins/Saecki/crates.nvim)
- [vuki656/package-info.nvim](https://dotfyle.com/plugins/vuki656/package-info.nvim)

### editing-support

- [monaqa/dial.nvim](https://dotfyle.com/plugins/monaqa/dial.nvim)
- [debugloop/telescope-undo.nvim](https://dotfyle.com/plugins/debugloop/telescope-undo.nvim)
- [folke/zen-mode.nvim](https://dotfyle.com/plugins/folke/zen-mode.nvim)
- [haringsrob/nvim_context_vt](https://dotfyle.com/plugins/haringsrob/nvim_context_vt)
- [nacro90/numb.nvim](https://dotfyle.com/plugins/nacro90/numb.nvim)
- [windwp/nvim-ts-autotag](https://dotfyle.com/plugins/windwp/nvim-ts-autotag)
- [bennypowers/nvim-regexplainer](https://dotfyle.com/plugins/bennypowers/nvim-regexplainer)
- [Wansmer/treesj](https://dotfyle.com/plugins/Wansmer/treesj)

### file-explorer

- [nvim-neo-tree/neo-tree.nvim](https://dotfyle.com/plugins/nvim-neo-tree/neo-tree.nvim)

### formatting

- [stevearc/conform.nvim](https://dotfyle.com/plugins/stevearc/conform.nvim)

### fuzzy-finder

- [nvim-telescope/telescope.nvim](https://dotfyle.com/plugins/nvim-telescope/telescope.nvim)

### git

- [ruifm/gitlinker.nvim](https://dotfyle.com/plugins/ruifm/gitlinker.nvim)
- [f-person/git-blame.nvim](https://dotfyle.com/plugins/f-person/git-blame.nvim)
- [akinsho/git-conflict.nvim](https://dotfyle.com/plugins/akinsho/git-conflict.nvim)
- [sindrets/diffview.nvim](https://dotfyle.com/plugins/sindrets/diffview.nvim)

### github

- [pwntester/octo.nvim](https://dotfyle.com/plugins/pwntester/octo.nvim)
- [pwntester/codeql.nvim](https://dotfyle.com/plugins/pwntester/codeql.nvim)

### lsp

- [smjonas/inc-rename.nvim](https://dotfyle.com/plugins/smjonas/inc-rename.nvim)
- [neovim/nvim-lspconfig](https://dotfyle.com/plugins/neovim/nvim-lspconfig)
- [mfussenegger/nvim-lint](https://dotfyle.com/plugins/mfussenegger/nvim-lint)
- [scalameta/nvim-metals](https://dotfyle.com/plugins/scalameta/nvim-metals)
- [mrcjkb/haskell-tools.nvim](https://dotfyle.com/plugins/mrcjkb/haskell-tools.nvim)
- [SmiteshP/nvim-navbuddy](https://dotfyle.com/plugins/SmiteshP/nvim-navbuddy)

### lsp-installer

- [williamboman/mason.nvim](https://dotfyle.com/plugins/williamboman/mason.nvim)

### lua-colorscheme

- [ellisonleao/gruvbox.nvim](https://dotfyle.com/plugins/ellisonleao/gruvbox.nvim)

### media

- [andweeb/presence.nvim](https://dotfyle.com/plugins/andweeb/presence.nvim)

### motion

- [echasnovski/mini.bracketed](https://dotfyle.com/plugins/echasnovski/mini.bracketed)

### nvim-dev

- [rafcamlet/nvim-luapad](https://dotfyle.com/plugins/rafcamlet/nvim-luapad)
- [anuvyklack/animation.nvim](https://dotfyle.com/plugins/anuvyklack/animation.nvim)
- [jbyuki/one-small-step-for-vimkind](https://dotfyle.com/plugins/jbyuki/one-small-step-for-vimkind)
- [folke/neodev.nvim](https://dotfyle.com/plugins/folke/neodev.nvim)
- [MunifTanjim/nui.nvim](https://dotfyle.com/plugins/MunifTanjim/nui.nvim)
- [nvim-lua/plenary.nvim](https://dotfyle.com/plugins/nvim-lua/plenary.nvim)

### plugin-manager

- [folke/lazy.nvim](https://dotfyle.com/plugins/folke/lazy.nvim)

### preconfigured

- [LazyVim/LazyVim](https://dotfyle.com/plugins/LazyVim/LazyVim)

### snippet

- [L3MON4D3/LuaSnip](https://dotfyle.com/plugins/L3MON4D3/LuaSnip)

### split-and-window

- [anuvyklack/windows.nvim](https://dotfyle.com/plugins/anuvyklack/windows.nvim)

### statusline

- [nvim-lualine/lualine.nvim](https://dotfyle.com/plugins/nvim-lualine/lualine.nvim)

### syntax

- [nvim-treesitter/nvim-treesitter](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter)

### tabline

- [akinsho/bufferline.nvim](https://dotfyle.com/plugins/akinsho/bufferline.nvim)

### terminal-integration

- [samjwill/nvim-unception](https://dotfyle.com/plugins/samjwill/nvim-unception)

### test

- [nvim-neotest/neotest](https://dotfyle.com/plugins/nvim-neotest/neotest)
- [andythigpen/nvim-coverage](https://dotfyle.com/plugins/andythigpen/nvim-coverage)

### utility

- [zbirenbaum/neodim](https://dotfyle.com/plugins/zbirenbaum/neodim)
- [folke/noice.nvim](https://dotfyle.com/plugins/folke/noice.nvim)
- [rcarriga/nvim-notify](https://dotfyle.com/plugins/rcarriga/nvim-notify)

<!-- plugins:end -->
