return {
  { "fei6409/log-highlight.nvim", event = "BufRead *.log", opts = {} },

  {
    "amaanq/nvim-aosp",
    config = function()
      require("aosp").setup()
    end,
  },
}
