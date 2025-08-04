return {

  -- Add Swift to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "objc", "swift" })
      end
    end,
  },

  -- Correctly setup lspconfig for Swift 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {},
      },
      settings = {
        sourcekit = {
          filetypes = { "swift", "objective-c", "objective-cpp" },
        },
      },
    },
  },
}
