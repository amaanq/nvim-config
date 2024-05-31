vim.env.RUFF_EXPERIMENTAL_FORMATTER = "1"

if vim.env.VSCODE then
  vim.g.vscode = true
end

if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  require("util.debug").dump(...)
end
_G.bt = function(...)
  require("util.debug").bt(...)
end
vim.print = _G.dd

-- require("util.profiler").startup()

-- vim.loader._profile({ loaders = true })

-- vim.g.profile_loaders = true
require("config.lazy")({
  debug = false,
  profiling = {
    loader = false,
    require = true,
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("util").version()
  end,
})
