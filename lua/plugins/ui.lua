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

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local icons = require("lazyvim.config").icons

      opts.options.disabled_filetypes.winbar = { "dashboard" }
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
            if not package.loaded["gitblame"] then
              return ""
            end
            local blame_text = require("gitblame").get_current_blame_text()
            local blame_chars = vim.g.os == "Darwin" and 100 or 250
            if blame_text:len() > blame_chars then
              blame_text = blame_text:sub(1, blame_chars) .. "..."
            end
            return blame_text
          end,
          cond = function()
            return package.loaded["gitblame"] and require("gitblame").is_blame_text_available()
          end,
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

          local names = {}
          for _, client in ipairs(buf_clients) do
            table.insert(names, client.name)
          end

          local ok, conform = pcall(require, "conform")
          if ok then
            for _, fmt in ipairs(conform.list_formatters(0)) do
              table.insert(names, fmt.name)
            end
          end

          return string.format("[%s]", table.concat(names, ", "))
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
    "snacks.nvim",
    ---@type snacks.Config
    opts = {
      terminal = {
        fixed_id = true,
        exclusive = true,
        win = {
          style = "terminal",
          position = "float",
          border = "rounded",
          wo = { winhighlight = "FloatBorder:Normal" },
          backdrop = 60,
          height = function()
            return math.ceil(math.min(vim.o.lines, math.max(20, vim.o.lines - 10)))
          end,
          width = function()
            return math.ceil(math.min(vim.o.columns, math.max(80, vim.o.columns - 20)))
          end,
          keys = {
            term_normal = false, -- disable double-ESC, we use our own ESC mapping
          },
        },
      },
    },
    keys = (function()
      local keys = {}
      for i = 1, 10 do
        local key = i == 10 and "0" or tostring(i)
        table.insert(keys, {
          "<leader>" .. key,
          function()
            Snacks.terminal.toggle(nil, { count = i })
          end,
          desc = "Terminal " .. i,
        })
      end
      return keys
    end)(),
    init = function()
      vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true, silent = true })
      vim.keymap.set("t", "<C-]>", "\027", { noremap = true, silent = true }) -- send literal ESC
    end,
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
    "amaanq/gitlink.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>gy",
        function()
          require("gitlink").get_buf_range_url("n")
        end,
        desc = "Copy Git Link",
      },
      {
        "<leader>gY",
        function()
          require("gitlink").get_buf_range_url("n", { action = vim.ui.open })
        end,
        desc = "Open Git Link",
      },
    },
    opts = {},
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
}
