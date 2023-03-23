local util = require("util")

return {

  -- Add Scala to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        util.list_insert_unique(opts.ensure_installed, "scala")
      end
    end,
  },

  -- Correctly setup lspconfig for Scala 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        metals = {},
      },
      setup = {
        metals = {},
      },
    },
  },
}
