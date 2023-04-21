local util = require("util")

return {
  -- Add PHP to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        util.list_insert_unique(opts.ensure_installed, "php")
      end
    end,
  },

  -- Correctly setup lspconfig for Docker
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        intelephense = {},
      },
      settings = {
        intelephense = {},
      },
      setup = {
        intelephense = {
          a = function()
            require("lspconfig").intelephense.setup({
              root_dir = require("lspconfig").util.root_pattern("composer.json", ".git", "*.php"),
            })
          end,
        },
      },
    },
  },
}
