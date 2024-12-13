--  ╭─────────────────────────────────────────────────────────────────────────────╮
--  │          Options are automatically loaded before lazy.nvim startup          │
--  │                     Default options that are always set:                    │
--  │ https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua │
--  ╰─────────────────────────────────────────────────────────────────────────────╯

-- vim.g.__ts_debug = 1

vim.g.mapleader = " "

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

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
vim.g.fps = vim.g.os == "Darwin" and 120 or 160
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
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Ensure all autocommands are cleared
vim.api.nvim_create_augroup("vimrc", {})

vim.opt.backup = true
vim.opt.cmdheight = 0
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"

if vim.g.neovide then
  vim.opt.guifont = "Menlo,Symbols Nerd Font Mono:h10"
  vim.g.neovide_scale_factor = 0.3
end

vim.o.title = true
vim.o.titlestring = LazyVim.root.cwd():match("([^/]+)$")

-- make all keymaps silent by default
local keymap_set = vim.keymap.set
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  return keymap_set(mode, lhs, rhs, opts)
end

vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.g.deprecation_warnings = true
vim.g.ai_cmp = false
vim.g.lazyvim_blink_main = true

if vim.fn.has("win32") == 1 then
  LazyVim.terminal.setup("pwsh")
end

vim.g.rustaceanvim = {
  tools = {
    float_win_config = {
      border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      },

      --- maximal width of floating windows. Nil means no max.
      ---@type integer | nil
      max_width = nil,

      --- maximal height of floating windows. Nil means no max.
      ---@type integer | nil
      max_height = nil,
      --- whether the window gets automatically focused
      --- default: false
      ---@type boolean
      auto_focus = false,
      --- whether splits opened from floating preview are vertical
      --- default: false
      ---@type 'horizontal' | 'vertical'
      open_split = "horizontal",
    },
  },
}

for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
  local default_diagnostic_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, result, context, config)
    if err ~= nil and err.code == -32802 then
      return
    end
    return default_diagnostic_handler(err, result, context, config)
  end
end
