return {

  -- add folding range to capabilities
  {
    "neovim/nvim-lspconfig",
    opts = {
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
    },
  },

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "mrbjarksen/neo-tree-diagnostics.nvim",
      {
        "s1n7ax/nvim-window-picker",
        opts = {
          use_winbar = "smart",
          autoselect_one = true,
          include_current = false,
          filter_rules = {
            bo = {
              filetype = { "neo-tree-popup", "quickfix" },
              buftype = { "terminal", "quickfix", "nofile" },
            },
          },
        },
      },
    },
    opts = function(_, opts)
      opts.close_if_last_window = true -- Close Neo-tree if it is the last window left in the tab
      opts.group_empty_dirs = true -- When true, empty folders will be grouped together
      opts.hijack_netrw_behavior = "open_default" -- netrw disabled, opening a directory opens neo-tree
    end,
  },

  {
    "RRethy/vim-illuminate",
    opts = {
      large_file_cutoff = 20000,
    },
  },

  -- add nvim-ufo
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      -- {
      -- 	"luukvbaal/statuscol.nvim",
      -- 	config = function()
      -- 		require("statuscol").setup({
      -- 			foldfunc = "builtin",
      -- 			setopt = true,
      -- 		})
      -- 	end,
      -- },
    },
    event = "BufReadPost",
    opts = {},
    init = function()
      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set("n", "zR", function()
        require("ufo").openAllFolds()
      end)
      vim.keymap.set("n", "zM", function()
        require("ufo").closeAllFolds()
      end)
    end,
  },

  {
    "samjwill/nvim-unception",
    event = "BufReadPost",
    init = function()
      vim.g.unception_open_buffer_in_new_tab = true
    end,
  },

  {
    "flash.nvim",
    opts = {
      modes = {
        char = {
          jump_labels = function(motion)
            -- never show jump labels by default
            -- return false
            -- Always show jump labels for ftFT
            return vim.v.count == 0 and motion:find("[ftFT]")
            -- Show jump labels for ftFT in operator-pending mode
            -- return vim.v.count == 0 and motion:find("[ftFT]") and vim.fn.mode(true):find("o")
          end,
        },
      },
    },
  },

  {
    "LunarVim/bigfile.nvim",
    config = true,
    event = "VeryLazy",
  },
}
