local Util = require("lazyvim.util")

return {

  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    opts = {
      level = vim.log.levels.INFO,
      fps = 144,
      stages = "fade_in_slide_out",
      background_colour = "#000000",
      time_formats = {
        notification = "%I:%M:%S %p",
      },
    },
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    ---@param opts bufferline.UserConfig
    opts = function(_, opts)
      opts.options.show_close_icon = true
      -- opts.options.separator_style = "slant"
      opts.options.offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
        {
          filetype = "Outline",
          text = "Symbols Outline",
          highlight = "TSType",
          text_align = "left",
        },
      }
      opts.options.hover = {
        enabled = true,
        delay = 200,
        reveal = { "close" },
      }
      opts.highlights = function(config) ---@param bufferline.Config
        local hl = {}

        for name, tbl in pairs(config.highlights) do
          local tbl_copy = {}
          for k, v in pairs(tbl) do
            -- Modify gui to remove italic
            if k == "gui" then
              local parts = vim.split(v, ",")
              for _, part in pairs(parts) do
                if part ~= "italic" then
                  tbl_copy["gui"] = part
                end
              end
            else
              tbl_copy[k] = v
            end
          end
          hl[name] = tbl_copy
        end

        return hl
      end
    end,
  },

  -- auto-resize windows
  {
    "anuvyklack/windows.nvim",
    event = "WinNew",
    dependencies = {
      { "anuvyklack/middleclass" },
      { "anuvyklack/animation.nvim", enabled = false },
    },
    keys = { { "<leader>Z", "<cmd>WindowsMaximize<cr>", desc = "Zoom" } },
    config = function()
      vim.o.winminwidth = 5
      vim.o.winminwidth = 5
      vim.o.equalalways = false
      require("windows").setup({
        animation = { enable = false, duration = 150 },
      })
    end,
  },

  -- scrollbar
  -- { "lewis6991/satellite.nvim", opts = {}, event = "VeryLazy", enabled = false },
  -- {
  --   "echasnovski/mini.map",
  --   main = "mini.map",
  --   event = "VeryLazy",
  --   enabled = false,
  --   config = function()
  --     local map = require("mini.map")
  --     map.setup({
  --       integrations = {
  --         map.gen_integration.builtin_search(),
  --         map.gen_integration.gitsigns(),
  --         map.gen_integration.diagnostic(),
  --       },
  --     })
  --     map.open()
  --   end,
  -- },
  -- {
  --   "petertriho/nvim-scrollbar",
  --   event = "BufReadPost",
  --   enabled = false,
  --   config = function()
  --     local scrollbar = require("scrollbar")
  --     local colors = require("tokyonight.colors").setup()
  --     scrollbar.setup({
  --       handle = { color = colors.bg_highlight },
  --       excluded_filetypes = { "prompt", "TelescopePrompt", "noice", "notify" },
  --       marks = {
  --         Search = { color = colors.orange },
  --         Error = { color = colors.error },
  --         Warn = { color = colors.warning },
  --         Info = { color = colors.info },
  --         Hint = { color = colors.hint },
  --         Misc = { color = colors.purple },
  --       },
  --     })
  --   end,
  -- },

  -- style windows with different colorschemes
  -- {
  --   "folke/styler.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     themes = {
  --       -- markdown = { colorscheme = "rose-pine" },
  --       help = { colorscheme = "rose-pine", background = "dark" },
  --       -- toggleterm = { colorscheme = "rose-pine" },
  --     },
  --   },
  -- },
  --
  -- silly drops
  -- {
  --   "folke/drop.nvim",
  --   enabled = false,
  --   event = "VeryLazy",
  --   config = function()
  --     math.randomseed(os.time())
  --     -- local theme = ({ "stars", "snow" })[math.random(1, 3)]
  --     require("drop").setup({ theme = "spring", max = 60, interval = 100 })
  --   end,
  -- },

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local icons = require("lazyvim.config").icons

      opts.options.disabled_filetypes.winbar = { "alpha", "dashboard", "neo-tree", "neo-tree-popup" }
      opts.sections.lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        {
          -- limit to 180 chars
          function()
            local blame_text = require("gitblame").get_current_blame_text()
            if blame_text:len() > 180 then
              blame_text = blame_text:sub(1, 180) .. "..."
            end
            return blame_text
          end,
          cond = require("gitblame").is_blame_text_available,
        },
      }
      table.insert(opts.sections.lualine_x, {
        function()
          return require("util.dashboard").status()
        end,
      })
      table.insert(opts.sections.lualine_x, {
        function()
          local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
          if #buf_clients == 0 then
            return "LSP Inactive"
          end

          local formatters = require("conform").list_formatters(0)

          local buf_client_names = {}
          local buf_formatters = {}

          for _, client in pairs(buf_clients) do
            if client.name ~= "copilot" then
              table.insert(buf_client_names, client.name)
            end
          end

          for _, client in pairs(formatters) do
            table.insert(buf_formatters, client.name)
          end

          vim.list_extend(buf_client_names, buf_formatters)

          if #buf_client_names == 0 then
            return "LSP Inactive"
          end

          local unique_client_names = table.concat(buf_client_names, ", ")
          local language_servers = string.format("[%s]", unique_client_names)

          return language_servers
        end,
        color = { gui = "bold" },
        -- cond = conditions.hide_in_width,
      })
      opts.sections.lualine_z = {
        function()
          return " " .. os.date("%I:%M %p")
        end,
      }
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    init = function()
      vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true, silent = true })
    end,
    ---@type ToggleTermConfig
    opts = {
      shading_factor = 0.3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
      direction = "float",
      persist_mode = false,
    },
    keys = {
      {
        "<leader>1",
        function()
          require("toggleterm").toggle(1, 0, Util.root.get(), "float")
        end,
        desc = "Terminal 1",
      },
      {
        "<leader>2",
        function()
          require("toggleterm").toggle(2, 0, Util.root.get(), "float")
        end,
        desc = "Terminal 2",
      },
      {
        "<leader>3",
        function()
          require("toggleterm").toggle(3, 0, Util.root.get(), "float")
        end,
        desc = "Terminal 3",
      },
      {
        "<leader>4",
        function()
          require("toggleterm").toggle(4, 0, Util.root.get(), "float")
        end,
        desc = "Terminal 4",
      },
      {
        "<leader>5",
        function()
          require("toggleterm").toggle(5, 0, Util.root.get(), "float")
        end,
        desc = "Terminal 5",
      },
      {
        "<leader>Tn",
        "<cmd>ToggleTermSetName<cr>",
        desc = "Set Terminal Name",
      },
      {
        "<leader>Ts",
        "<cmd>TermSelect<cr>",
        desc = "Select Terminal",
      },
    },
  },

  -- git blame
  {
    "f-person/git-blame.nvim",
    event = "BufReadPre",
    init = function()
      vim.g.gitblame_display_virtual_text = 0
    end,
  },

  -- git conflict
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    config = true,
  },
  {
    "rhysd/git-messenger.vim",
    event = "VeryLazy",
    keys = { { "<leader>gm", "<cmd>GitMessenger<cr>", desc = "Git Messenger" } },
  },
  -- { "rhysd/committia.vim", event = "BufRead" },
  {
    "ruifm/gitlinker.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gy", "<cmd>lua require('gitlinker').get_buf_range_url('n')<cr>", desc = "Copy Git Link" },
      {
        "<leader>gY",
        "<cmd>lua require('gitlinker').get_buf_range_url('n', {action_callback = require('gitlinker.actions').open_in_browser})<cr>",
        desc = "Open Git Link",
      },
    },
    opts = {},
  },

  {
    "lukas-reineke/virt-column.nvim",
    event = "VeryLazy",
    config = function()
      require("virt-column").setup({ char = "▕" })
    end,
  },

  {
    "sontungexpt/url-open",
    event = "VeryLazy",
    cmd = "URLOpenUnderCursor",
    opts = {
      highlight_url = {
        all_urls = {
          enabled = true,
          fg = "#199eff",
        },
      },
    },
  },

  {
    "lukas-reineke/headlines.nvim",
    enabled = false,
    ft = { "markdown", "rmd", "org" },
  },

  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    config = true,
  },

  -- {
  --   "zbirenbaum/neodim",
  --   event = "LspAttach",
  --   opts = {
  --     hide = {
  --       virtual_text = false,
  --       signs = false,
  --       underline = false,
  --     },
  --   },
  -- },

  {
    "LudoPinelli/comment-box.nvim",
    event = "BufReadPre",
  },

  "folke/twilight.nvim",
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },

  {
    "echasnovski/mini.animate",
    opts = {
      open = { enable = false },
      close = { enable = false },
    },
  },
}
