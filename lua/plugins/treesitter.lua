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
    --- @type TSConfig
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
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
        "org",
        "php",
        "proto",
        "scss",
        "sql",
        "svelte",
        "vala",
        "vue",
        "wgsl",
      })
      -- opts.autopairs = { enable = true }
      opts.autotag = { enable = true }
      opts.matchup = {
        enable = true,
        disable = { "c", "cpp" },
        enable_quotes = true,
      }
      opts.playground = {
        enable = true,
        persist_queries = true, -- Whether the query persists across vim sessions
      }
      opts.query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      }
      -- rainbow = {
      --   enable = true,
      --   disable = { "lua" },
      -- },
      -- refactor = {
      --   smart_rename = {
      --     enable = true,
      --     client = {
      --       smart_rename = "<leader>cr",
      --     },
      --   },
      --   navigation = {
      --     enable = true,
      --     keymaps = {
      --       -- goto_definition = "gd",
      --       -- list_definitions = "gnD",
      --       -- list_definitions_toc = "gO",
      --       -- goto_next_usage = "<a-*>",
      --       -- goto_previous_usage = "<a-#>",
      --     },
      --   },
      -- },
      -- textobjects = {
      --   select = {
      --     enable = true,
      --     lookahead = true,
      --     keymaps = {
      --       -- You can use the capture groups defined in textobjects.scm
      --       ["af"] = "@function.outer",
      --       ["if"] = "@function.inner",
      --       ["ac"] = "@class.outer",
      --       ["ic"] = "@class.inner",
      --       ["al"] = "@loop.outer",
      --       ["il"] = "@loop.inner",
      --       ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      --     },
      --   },
      --   move = {
      --     enable = true,
      --     set_jumps = true, -- whether to set jumps in the jumplist
      --     goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
      --     goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
      --     goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
      --     goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
      --   },
      --   lsp_interop = {
      --     enable = true,
      --     peek_definition_code = {
      --       ["gD"] = "@function.outer",
      --     },
      --   },
      --   swap = {
      --     enable = true,
      --     swap_next = {
      --       ["<leader>a"] = "@parameter.inner",
      --     },
      --     swap_previous = {
      --       ["<leader>A"] = "@parameter.inner",
      --     },
      --   },
      -- },
      -- textsubjects = {
      --   enable = true,
      --   keymaps = {
      --     ["."] = "textsubjects-smart",
      --     [";"] = "textsubjects-container-outer",
      --   },
      -- },
      -- context_commentstring = {
      --   enable = true,
      --   enable_autocmd = false,
      -- },
    end,
  },

  { "windwp/nvim-ts-autotag", opts = {}, event = "InsertEnter" },
}
