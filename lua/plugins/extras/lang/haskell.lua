local util = require("util")

return {

  -- Add Haskell & related to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        util.list_insert_unique(opts.ensure_installed, { "haskell" })
      end
    end,
  },

  -- Ensure Haskell LSP & DAP are installed
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        util.list_insert_unique(opts.ensure_installed, { "haskell-language-server", "haskell-debug-adapter" })
      end
    end,
  },

  {
    "mrcjkb/haskell-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = function(_, opts)
      local ht = require("haskell-tools")
      ht.start_or_attach({
        hls = {
          on_attach = function(_, buffer)
            vim.keymap.set("n", "<space>ca", vim.lsp.codelens.run, { buffer = buffer })
            vim.keymap.set("n", "K", ht.hoogle.hoogle_signature, { buffer = buffer })
            vim.keymap.set("n", "<space>cle", ht.lsp.buf_eval_all, { buffer = buffer })
          end,
        },
      })
    end,
  },
}
