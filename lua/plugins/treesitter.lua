return {
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

  {
    "haringsrob/nvim_context_vt",
    opts = {
      disable_ft = { "json", "yaml", "xml" },
      disable_virtual_lines = true,
      ---@param node TSNode
      ---@param ft string
      ---@param _ table
      custom_parser = function(node, ft, _)
        local utils = require("nvim_context_vt.utils")

        -- useless if the node is less than 10 lines
        if node:end_() - node:start() < 10 then
          return nil
        end

        if ft == "lua" and node:type() == "if_statement" then
          return nil
        end

        -- only match if alphabetical characters are present
        if not utils.get_node_text(node)[1]:match("%w") then
          return nil
        end

        return "▶ " .. utils.get_node_text(node)[1]:gsub("{", "")
      end,
    },
    event = "VeryLazy",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = require("nixCatsUtils").lazyAdd(":TSUpdate"),
    opts_extend = require("nixCatsUtils").lazyAdd(nil, false),
    opts = {
      ensure_installed = require("nixCatsUtils").lazyAdd(
        { "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "vim", "vimdoc" },
        false
      ),
      auto_install = require("nixCatsUtils").lazyAdd(true, false),
      sync_install = require("nixCatsUtils").lazyAdd(nil, false),
    },
  },


  { "windwp/nvim-ts-autotag", opts = {}, event = "InsertEnter" },
}
