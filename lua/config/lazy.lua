local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
  vim.fn.system({ "git", "-C", lazypath, "checkout", "tags/stable" }) -- last stable release
end
vim.opt.rtp:prepend(lazypath)

---@param opts LazyConfig
return function(opts)
  opts = vim.tbl_deep_extend("force", {
    spec = {
      {
        "LazyVim/LazyVim",
        import = "lazyvim.plugins",
        opts = {},
      },
      -- LazyVim extras
      { import = "lazyvim.plugins.extras.coding.yanky" },
      { import = "lazyvim.plugins.extras.dap.core" },
      { import = "lazyvim.plugins.extras.editor.mini-files" },
      { import = "lazyvim.plugins.extras.lang.clangd" },
      { import = "lazyvim.plugins.extras.lang.go" },
      { import = "lazyvim.plugins.extras.lang.rust" },
      { import = "lazyvim.plugins.extras.lang.typescript" },
      { import = "lazyvim.plugins.extras.lang.json" },
      { import = "lazyvim.plugins.extras.test.core" },
      { import = "lazyvim.plugins.extras.ui.edgy" },
      { import = "lazyvim.plugins.extras.ui.mini-animate" },
      { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
      { import = "lazyvim.plugins.extras.util.project" },
      { import = "lazyvim.plugins.extras.vscode" },
      -- My own plugins
      { import = "plugins" },
      { import = "plugins.extras.coding.copilot" },
      { import = "plugins.extras.dev.treesitter" },
      { import = "plugins.extras.lang.bash" },
      { import = "plugins.extras.lang.cmake" },
      { import = "plugins.extras.lang.csharp" },
      { import = "plugins.extras.lang.docker" },
      { import = "plugins.extras.lang.haskell" },
      { import = "plugins.extras.lang.java" },
      { import = "plugins.extras.lang.nix" },
      { import = "plugins.extras.lang.nodejs" },
    },
    defaults = {
      lazy = true,
      version = false, -- always use the latest git commit
    },
    dev = { patterns = jit.os:find("Windows") and {} or { "amaanq" } },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = { enabled = true },
    diff = {
      cmd = "terminal_git",
    },
    performance = {
      cache = {
        enabled = true,
        -- disable_events = {},
      },
      rtp = {
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "rplugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
    ui = {
      custom_keys = {
        ["<localleader>d"] = function(plugin)
          dd(plugin)
        end,
      },
    },
    debug = false,
  }, opts or {})
  require("lazy").setup(opts)
end
