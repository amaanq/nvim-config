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
    dependencies = {},
    build = require("nixCatsUtils").lazyAdd(":TSUpdate"),
    --- @type TSConfig
    opts = function(_, opts)
      local parsers = {
        "cmake",
        -- "comment",
        "diff",
        "dockerfile",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "git_rebase",
        "glsl",
        "graphql",
        "haskell",
        "http",
        "kconfig",
        "json",
        "json5",
        "kotlin",
        "make",
        "meson",
        "ninja",
        "nix",
        "php",
        "proto",
        "scss",
        "sql",
        "svelte",
        "vala",
        "vue",
        "wgsl",
      }

      -- When using nix, parsers are installed via nix, so disable ensure_installed
      local ensure_installed = require("nixCatsUtils").lazyAdd(parsers, false)
      if ensure_installed then
        vim.list_extend(opts.ensure_installed or {}, ensure_installed)
      end

      -- Disable auto_install when using nix
      opts.auto_install = require("nixCatsUtils").lazyAdd(true, false)

      -- opts.matchup = {
      --   enable = true,
      --   disable = { "c", "cpp" },
      --   enable_quotes = true,
      -- }
      opts.playground = {
        enable = true,
        persist_queries = true, -- Whether the query persists across vim sessions
      }
      opts.query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      }
    end,
  },

  { "windwp/nvim-ts-autotag", opts = {}, event = "InsertEnter" },
}
