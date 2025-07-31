require("nixCatsUtils").setup({
  non_nix_value = true,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

local M = {}

-- Helper function to get lockfile path for nixCats compatibility
local function getlockfilepath()
  local has_nixcats, nixCatsUtils = pcall(require, "nixCatsUtils")
  if has_nixcats and nixCatsUtils.isNixCats and type(nixCats.settings.unwrappedCfgPath) == "string" then
    return nixCats.settings.unwrappedCfgPath .. "/lazy-lock.json"
  else
    return vim.fn.stdpath("config") .. "/lazy-lock.json"
  end
end

---@param opts LazyConfig
function M.load(opts)
  local base_config = {
    lockfile = getlockfilepath(),
    spec = {
      {
        "LazyVim/LazyVim",
        version = false,
        import = "lazyvim.plugins",
        news = {
          colorscheme = "rose-pine",
          lazyvim = true,
          neovim = true,
        },
      },
      -- Add nixCats-specific plugin configurations
      {
        "folke/lazydev.nvim",
        opts = function(_, opts)
          local has_nixcats = pcall(require, "nixCatsUtils")
          if has_nixcats and nixCats and nixCats.nixCatsPath then
            opts.library = opts.library or {}
            table.insert(opts.library, { path = nixCats.nixCatsPath .. "/lua", words = { "nixCats" } })
          end
          return opts
        end,
      },
      { import = "plugins" },
    },
    defaults = {
      lazy = true,
      version = false, -- always use the latest git commit
    },
    dev = {
      patterns = jit.os:find("Windows") and {} or { "amaanq" },
      fallback = jit.os:find("Windows"),
    },
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
    ui = {
      custom_keys = {
        ["<localleader>d"] = function(plugin)
          dd(plugin)
        end,
      },
    },
    debug = false,
  }

  opts = vim.tbl_deep_extend("force", base_config, opts or {})

  -- Use nixCats lazy wrapper if available, otherwise use regular lazy
  local has_nixcats, nixCatsUtils = pcall(require, "nixCatsUtils")
  if has_nixcats and nixCatsUtils.lazyCat then
    -- Get the lazy.nvim path from nixCats if available
    local lazy_path = nil
    if nixCats and nixCats.pawsible then
      lazy_path = nixCats.pawsible({ "allPlugins", "start", "lazy.nvim" })
    end
    nixCatsUtils.lazyCat.setup(lazy_path, opts.spec, { lockfile = opts.lockfile })
  else
    require("lazy").setup(opts)
  end
end

return M
