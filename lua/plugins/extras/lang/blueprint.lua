return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if require("nixCatsUtils").isNixCats then
        return
      end

      require("nvim-treesitter.parsers").blueprint = {
        install_info = {
          url = "https://github.com/amaanq/tree-sitter-blueprint",
        },
        tier = 3,
      }

      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "blueprint" })
      end
    end,
  },
}
