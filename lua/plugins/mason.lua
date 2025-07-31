return {
  { "mason-org/mason.nvim", enabled = require("nixCatsUtils").lazyAdd(true, false) },
  { "mason-org/mason-lspconfig.nvim", enabled = require("nixCatsUtils").lazyAdd(true, false) },
}
