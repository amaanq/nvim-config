return {

  -- Add Zig to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "zig" })
      end
    end,
  },

  -- Correctly setup lspconfig for zig 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        zls = {
          -- Zig is too new and the latest stable version is way behind dev
          mason = false,
          settings = {
            enable_inlay_hints = false,
          },
        },
      },
    },
  },
}
