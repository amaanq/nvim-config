local util = require("util")

return {
  -- Add Docker to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        util.list_insert_unique(opts.ensure_installed, "dockerfile")
      end
    end,
  },

  -- Correctly setup lspconfig for Docker
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        dockerls = {},
        docker_compose_language_service = {},
      },
      settings = {
        dockerls = {},
        docker_compose_language_service = {},
      },
    },
  },
}
