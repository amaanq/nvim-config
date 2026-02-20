local M = {}

local function getlockfilepath()
  if require("nixCatsUtils").isNixCats and type(nixCats.settings.unwrappedCfgPath) == "string" then
    return nixCats.settings.unwrappedCfgPath .. "/lazy-lock.json"
  else
    return vim.fn.stdpath("config") .. "/lazy-lock.json"
  end
end

---@param opts LazyConfig
function M.load(opts)
  require("nixCatsUtils").setup({
    non_nix_value = true,
  })

  opts = vim.tbl_deep_extend("force", {
    defaults = {
      lazy = true,
      version = false, -- always use the latest git commit
    },
    spec = {
      {
        "amaanq/LazyVim",
        version = false,
        import = "lazyvim.plugins",
        news = {
          colorscheme = "rose-pine",
          lazyvim = true,
          neovim = true,
        },
      },
      { import = "plugins" },
    },
    lockfile = getlockfilepath(),
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = {
      enabled = true,
      notify = false,
    },
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
        },
      },
    },
    readme = {
      enabled = false,
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
  require("nixCatsUtils.lazyCat").setup(nixCats.pawsible({ "allPlugins", "start", "lazy.nvim" }), opts)
end

return M
