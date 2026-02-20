return {
  {
    "nvim-treesitter/nvim-treesitter",
    --- @type TSConfig
    opts = function(_, opts)
      opts.auto_install = require("nixCatsUtils").lazyAdd(true, false)

      opts.query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      }
    end,
  },

}
