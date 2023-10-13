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
        news = {
          lazyvim = true,
          neovim = true,
        },
      },
      { import = "plugins" },
      { import = "plugins.extras.coding.copilot" },
      { import = "plugins.extras.dev.treesitter" },
      { import = "plugins.extras.lang.bash" },
      { import = "plugins.extras.lang.haskell" },
      { import = "plugins.extras.lang.nix" },
      { import = "plugins.extras.lang.nodejs" },
      { import = "plugins.extras.lang.zig" },
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
          -- "rplugin",
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
