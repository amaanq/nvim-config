return {

  -- Ensure Bash debugger is installed
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "bash" })
      end
    end,
  },

  -- Correctly setup lspconfig for Bash 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        bashls = {},
      },
      settings = {
        bashls = {},
      },
    },
  },
}
