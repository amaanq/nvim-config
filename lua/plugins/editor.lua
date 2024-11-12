return {

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
    opts = {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      group_empty_dirs = true, -- When true, empty folders will be grouped together
      hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
      default_component_configs = {
        container = {
          enable_character_fade = false,
        },
        symlink_target = {
          enabled = true,
        },
      },
    },
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

  -- {
  --   "LunarVim/bigfile.nvim",
  --   config = true,
  --   event = "VeryLazy",
  -- },
  {
    "willothy/flatten.nvim",
    lazy = false,
    priority = 1001,
    opts = function()
      local saved_terminal ---@type Terminal?

      return {
        window = {
          open = "smart",
        },
        pipe_path = function()
          -- If running in a terminal inside Neovim:
          local nvim = vim.env.NVIM
          if nvim then
            return nvim
          end
        end,
        nest_if_no_args = true,
        callbacks = {
          should_block = function(argv)
            return vim.tbl_contains(argv, "-b")
          end,
          pre_open = function()
            local term = require("toggleterm.terminal")
            local id = term.get_focused_id()
            saved_terminal = term.get(id)
          end,
          post_open = function(bufnr, winnr, ft, is_blocking, is_diff)
            if is_blocking and saved_terminal then
              -- Hide the terminal while it's blocking
              saved_terminal:close()
            elseif not is_diff then
              -- If it's a normal file, just switch to its window
              vim.api.nvim_set_current_win(winnr)
            end

            -- If the file is a git commit, create one-shot autocmd to delete its buffer on write
            -- If you just want the toggleable terminal integration, ignore this bit
            if ft == "gitcommit" or ft == "gitrebase" then
              vim.api.nvim_create_autocmd("BufWritePost", {
                buffer = bufnr,
                once = true,
                callback = vim.schedule_wrap(function()
                  require("bufdelete").bufdelete(bufnr, true)
                end),
              })
            end
          end,
          -- After blocking ends (for a git commit, etc), reopen the terminal
          block_end = vim.schedule_wrap(function()
            if saved_terminal then
              saved_terminal:open()
              saved_terminal = nil
            end
          end),
        },
      }
    end,
  },
}
