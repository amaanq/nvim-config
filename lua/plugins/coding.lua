return {
  {
    "zbirenbaum/copilot.lua",
    optional = true,
    opts = {
      filetypes = { ["*"] = true },
    },
  },

  {
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 200 },
  },

  -- {
  --   "andythigpen/nvim-coverage",
  --   event = "VeryLazy",
  --   config = true,
  -- },

  -- {
  --   "pwntester/codeql.nvim",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "telescope.nvim",
  --     {
  --       "s1n7ax/nvim-window-picker",
  --       version = "v1.*",
  --       opts = {
  --         autoselect_one = true,
  --         include_current = false,
  --         filter_rules = {
  --           bo = {
  --             filetype = {
  --               "codeql_panel",
  --               "codeql_explorer",
  --               "qf",
  --               "TelescopePrompt",
  --               "TelescopeResults",
  --               "notify",
  --               "NvimTree",
  --               "neo-tree",
  --             },
  --             buftype = { "terminal" },
  --           },
  --         },
  --         current_win_hl_color = "#e35e4f",
  --         other_win_hl_color = "#44cc41",
  --       },
  --     },
  --   },
  --   opts = {
  --     additional_packs = {
  --       "/opt/codeql",
  --     },
  --   },
  --   cmd = { "QL" },
  -- },

  { "wakatime/vim-wakatime", event = "VeryLazy" },

  {
    "andymass/vim-matchup",
    enabled = false,
    event = "BufReadPost",
    init = function()
      vim.o.mps = vim.o.mps .. ',<:>,":"'
    end,
    config = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },

  {
    "echasnovski/mini.pairs",
    enabled = false,
    opts = {
      modes = { command = false },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = {
        "TelescopePrompt",
        "spectre_panel",
        "snacks_picker_input",
      },
    },
    config = true,
  },

  {
    "bennypowers/nvim-regexplainer",
    event = "BufRead",
    dependencies = { "nvim-treesitter/nvim-treesitter", "MunifTanjim/nui.nvim" },
    config = true,
    opts = {
      mappings = {
        toggle = "ge",
      },
    },
  },

  {
    "~p00f/godbolt.nvim",
    url = "https://git.sr.ht/~p00f/godbolt.nvim",
    cmd = { "Godbolt", "GodboltCompiler" },
  },
}
