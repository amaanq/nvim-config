--  ╭─────────────────────────────────────────────────────────────────────────────╮
--  │          Options are automatically loaded before lazy.nvim startup          │
--  │                     Default options that are always set:                    │
--  │ https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua │
--  ╰─────────────────────────────────────────────────────────────────────────────╯

vim.g.mapleader = " "

vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldcolumn = "1"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.opt.expandtab = false -- Use tabs instead of spaces
vim.opt.grepprg = "rg --vimgrep --smart-case --"
vim.opt.hidden = true -- Enable modified buffers in background
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.shortmess:append({ W = true, I = true, c = true })
vim.opt.showmode = false -- dont show mode since we have a statusline
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.listchars = "trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂"
vim.opt.pumblend = 10

vim.g.os = vim.uv.os_uname().sysname
vim.g.open_command = vim.g.os == "Darwin" and "open" or "xdg-open"
vim.g.dotfiles = vim.env.DOTFILES or vim.fn.expand("~/.dotfiles")
vim.g.vim_dir = vim.g.dotfiles .. "/.config/nvim"

--  ╭─────────────────╮
--  │ Default plugins │
--  ╰─────────────────╯
-- Stop loading built in plugins
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.logipat = 1

-- Disable some extension providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Ensure all autocommands are cleared
vim.api.nvim_create_augroup("vimrc", {})

if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.backup = true
  vim.opt.cmdheight = 0
  vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"
end

if vim.g.neovide then
  vim.opt.guifont = { "Menlo", "h10" }
  vim.g.neovide_scale_factor = 0.3
end

require("util.status")

-- make all keymaps silent by default
local keymap_set = vim.keymap.set
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  return keymap_set(mode, lhs, rhs, opts)
end
