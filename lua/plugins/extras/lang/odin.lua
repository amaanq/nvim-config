return {
  -- Add Odin to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "odin" })
      end
    end,
  },

  -- Correctly setup lspconfig for Odin
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ols = {},
      },
    },
  },
}
