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

if vim.env.PROF then
  vim.opt.rtp:append("/home/amaanq/projects/neovim/snacks.nvim/")
  require("snacks.profiler").startup({
    startup = {
      event = "UIEnter",
    },
    runtime = "~/projects/neovim/neovim/runtime",
  })
end

require("config.lazy").load({
  debug = false,
  profiling = {
    loader = false,
    require = false,
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("util").version()
  end,
})
