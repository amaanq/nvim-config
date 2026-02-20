return {

  {
    "vuki656/package-info.nvim",
    event = "BufRead package.json",
    opts = {},
  },

  {
    "Saghen/blink.cmp",
    optional = true,
    opts = {
      completion = {
        menu = {
          border = "rounded",
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
      },
    },
  },

  -- Add JavaScript & friends to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "css", "html", "javascript", "jsdoc", "scss" })
      end
    end,
  },

}
