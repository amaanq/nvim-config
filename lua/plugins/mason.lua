return {
  {
    "mason-org/mason.nvim",
    enabled = require("nixCatsUtils").lazyAdd(true, false),
    version = "1.11.0",
  },
  {
    "mason-org/mason-lspconfig.nvim",
    enabled = require("nixCatsUtils").lazyAdd(true, false),
    version = "1.32.0",
  },
}
