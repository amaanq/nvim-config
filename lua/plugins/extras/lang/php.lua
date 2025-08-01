return {
  -- Add PHP to treesitter
  {
    -- "nvim-treesitter/nvim-treesitter",
    -- opts = function(_, opts)
    --   if type(opts.ensure_installed) == "table" then
    --     vim.list_extend(opts.ensure_installed, { "php" })
    --   end
    -- end,
  },

  -- Correctly setup lspconfig for PHP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        intelephense = {
          root_dir = require("lspconfig").util.root_pattern("composer.json", ".git", "*.php"),
        },
      },
    },
  },
}
