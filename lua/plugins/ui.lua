local Util = require("lazyvim.util")

return {
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
      opts.highlights = function(config) ---@param config bufferline.Config
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
      opts.options.diagnostics = false
    end,
  },

  {
    "folke/which-key.nvim",
    enabled = true,
    opts = {
      preset = "helix",
      debug = vim.uv.cwd():find("which%-key"),
      win = {},
      spec = {},
    },
  },

  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          ["not"] = {
            event = "lsp",
            kind = "progress",
          },
          event = "msg_show",
          find = "%d+L, %d+B",
          cond = function()
            return not focused and false
          end,
        },
        view = "mini",
        opts = { stop = false, replace = true },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      opts.views = {
        mini = {
          win_options = {
            winblend = 0,
            winhighlight = { Normal = "Pmenu", FloatBorder = "Pmenu" },
          },
        },
        cmdline_popup = {
          position = {
            row = 5,
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
        },
        popupmenu = {
          relative = "editor",
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
      }

      opts.presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        cmdline_output_to_split = false,
        lsp_doc_border = true,
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })
    end,
  },

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
        {
          -- limit chars
          function()
            local blame_text = require("gitblame").get_current_blame_text()
            local blame_chars = vim.g.os == "Darwin" and 100 or 250
            if blame_text:len() > blame_chars then
              blame_text = blame_text:sub(1, blame_chars) .. "..."
            end
            return blame_text
          end,
          cond = require("gitblame").is_blame_text_available,
        },
      }

      ---@type table<string, {updated:number, total:number, enabled: boolean, status:string[]}>
      local mutagen = {}

      local function mutagen_status()
        local cwd = vim.uv.cwd() or "."
        mutagen[cwd] = mutagen[cwd]
          or {
            updated = 0,
            total = 0,
            enabled = vim.fs.find("mutagen.yml", { path = cwd, upward = true })[1] ~= nil,
            status = {},
          }
        local now = vim.uv.now() -- timestamp in milliseconds
        local refresh = mutagen[cwd].updated + 10000 < now
        if #mutagen[cwd].status > 0 then
          refresh = mutagen[cwd].updated + 1000 < now
        end
        if mutagen[cwd].enabled and refresh then
          ---@type {name:string, status:string, idle:boolean}[]
          local sessions = {}
          local lines = vim.fn.systemlist("mutagen project list")
          local status = {}
          local name = nil
          for _, line in ipairs(lines) do
            local n = line:match("^Name: (.*)")
            if n then
              name = n
            end
            local s = line:match("^Status: (.*)")
            if s then
              table.insert(sessions, {
                name = name,
                status = s,
                idle = s == "Watching for changes",
              })
            end
          end
          for _, session in ipairs(sessions) do
            if not session.idle then
              table.insert(status, session.name .. ": " .. session.status)
            end
          end
          mutagen[cwd].updated = now
          mutagen[cwd].total = #sessions
          mutagen[cwd].status = status
          if #sessions == 0 then
            vim.notify("Mutagen is not running", vim.log.levels.ERROR, { title = "Mutagen" })
          end
        end
        return mutagen[cwd]
      end

      local error_color = { fg = Snacks.util.color("DiagnosticError") }
      local ok_color = { fg = Snacks.util.color("DiagnosticInfo") }
      table.insert(opts.sections.lualine_x, {
        cond = function()
          return mutagen_status().enabled
        end,
        color = function()
          return (mutagen_status().total == 0 or mutagen_status().status[1]) and error_color or ok_color
        end,
        function()
          local s = mutagen_status()
          local msg = s.total
          if #s.status > 0 then
            msg = msg .. " | " .. table.concat(s.status, " | ")
          end
          return (s.total == 0 and "󰋘 " or "󰋙 ") .. msg
        end,
      })
      table.insert(opts.sections.lualine_x, {
        function()
          local statusline = {
            halloween = "🧛👻👺🧟🎃",
            summer = "🌴🌊",
            winter = "🏂❄️ ⛷️",
            xmas = "🎅🎄🌟🎁",
          }
          return statusline["summer"]
        end,
      })
      table.insert(opts.sections.lualine_x, Snacks.profiler.status())
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
    "LudoPinelli/comment-box.nvim",
    event = "BufReadPre",
  },

  {
    "edgy.nvim",
    opts = {
      animate = {
        fps = vim.g.fps,
      },
    },
  },

  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    config = function()
      require("numb").setup()
    end,
  },

  {
    "Bekaboo/dropbar.nvim",
    event = "LazyFile",
    opts = function()
      local menu_utils = require("dropbar.utils.menu")

      -- Closes all the windows in the current dropbar.
      local function close()
        local menu = menu_utils.get_current()
        while menu and menu.prev_menu do
          menu = menu.prev_menu
        end
        if menu then
          menu:close()
        end
      end

      return {
        menu = {
          preview = false,
          keymaps = {
            -- Navigate back to the parent menu.
            ["h"] = "<C-w>q",
            -- Expands the entry if possible.
            ["l"] = function()
              local menu = menu_utils.get_current()
              if not menu then
                return
              end
              local row = vim.api.nvim_win_get_cursor(menu.win)[1]
              local component = menu.entries[row]:first_clickable()
              if component then
                menu:click_on(component, nil, 1, "l")
              end
            end,
            ["q"] = close,
            ["<esc>"] = close,
          },
        },
      }
    end,
  },

  {
    "mistricky/codesnap.nvim",
    build = "make build_generator",
    event = "VeryLazy",
    keys = {
      { "<leader>cs", "<Esc><cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
      { "<leader>cS", "<Esc><cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures/" },
    },
    lazy = true,
    opts = {
      mac_window_bar = false,
      save_path = "~/Pictures/",
      has_breadcrumbs = true,
      show_workspace = true,
      bg_theme = "sea",
      watermark = "",
      code_font_family = "Berkeley Mono",
      has_line_number = true,
    },
  },
}
