return {
  { "pwntester/octo.nvim", cmd = "Octo", opts = {} },

  -- better diffing
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    opts = {},
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
  },

  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    config = function()
      require("numb").setup()
    end,
  },

  {
    "psliwka/vim-dirtytalk",
    build = ":DirtytalkUpdate",
    config = function()
      vim.opt.spelllang:append("programming")
    end,
  },

  "wellle/targets.vim",

  { "rafcamlet/nvim-luapad", cmd = "Luapad" },

  {
    "bennypowers/nvim-regexplainer",
    event = "BufRead",
    dependencies = { "nvim-treesitter/nvim-treesitter", "MunifTanjim/nui.nvim" },
    config = true,
  },

  {
    "~p00f/godbolt.nvim",
    url = "https://git.sr.ht/~p00f/godbolt.nvim",
    cmd = { "Godbolt", "GodboltCompiler" },
  },

  -- {
  --   "jackMort/ChatGPT.nvim",
  --   cmd = { "ChatGPTActAs", "ChatGPT" },
  --   opts = {},
  -- },

  {
    "t-troebst/perfanno.nvim",
    opts = {},
    keys = {
      { "<leader>alf", "<cmd>PerfLoadFlat<cr>", desc = "Load flat profile" },
      { "<leader>alg", "<cmd>PerfLoadCallGraph<cr>", desc = "Load call graph" },
      { "<leader>alo", "<cmd>PerfLoadFlameGraph<cr>", desc = "Load flame graph" },
      { "<leader>ae", "<cmd>PerfPickEvent<cr>", desc = "Pick event" },
      { "<leader>aa", "<cmd>PerfAnnotate<cr>", desc = "Annotate" },
      { "<leader>af", "<cmd>PerfAnnotateFunction<cr>", desc = "Annotate function" },
      { "<leader>at", "<cmd>PerfToggleAnnotations<cr>", desc = "Toggle annotations" },
      { "<leader>ah", "<cmd>PerfHottestLines<cr>", desc = "Hottest lines" },
      { "<leader>as", "<cmd>PerfHottestSymbols<cr>", desc = "Hottest symbols" },
      { "<leader>ac", "<cmd>PerfHottestCallersFunction<cr>", desc = "Hottest callers function" },
      { "<leader>all", "<cmd>PerfLuaProfileStart<cr>", desc = "Start Lua Profiler" },
      { "<leader>als", "<cmd>PerfLuaProfileStop<cr>", desc = "Stop Lua Profiler" },
    },
    cmd = {
      "PerfLuaProfileStart",
      "PerfLuaProfileStop",
      "PerfLoadFlat",
      "PerfLoadCallGraph",
      "PerfLoadFlameGraph",
      "PerfCacheLoad",
      "PerfCacheSave",
      "PerfCacheDelete",
      "PerfCycleFormat",
    },
  },

  {
    "andweeb/presence.nvim",
    event = "BufRead",
    opts = {
      main_image = "file",
      enable_line_number = true,
      blacklist = {
        ".*zsh.*",
        ".*ToggleTerm.*",
        ".*toggleterm.*",
      },
      buttons = function(_, repo_url)
        if repo_url then
          if repo_url:match("amaanq") then
            return nil
          end
          -- Check if repo url uses short ssh syntax
          local domain, project = repo_url:match("^git@(.+):(.+)$")
          if domain and project then
            repo_url = string.format("https://%s/%s", domain, project)
          end

          -- Check if repo url uses a valid protocol
          local protocols = {
            "ftp",
            "git",
            "http",
            "https",
            "ssh",
          }
          local protocol, relative = repo_url:match("^(.+)://(.+)$")
          if not vim.tbl_contains(protocols, protocol) or not relative then
            return nil
          end

          -- Check if repo url has the user specified
          local user, path = relative:match("^(.+)@(.+)$")
          if user and path then
            repo_url = string.format("https://%s", path)
          else
            repo_url = string.format("https://%s", relative)
          end

          return {
            { label = "View Repository", url = repo_url },
          }
        end

        return nil
      end,
      ---@param filename string
      editing_text = function(filename)
        -- if in .config/nvim, return "Editing dotfiles"
        -- if in ~/projects/treesitter/*/grammar.js, return "Editing a tree-sitter grammar"
        -- else return "Editing %s"
        if filename:match(".config/nvim") then
          return "Editing my dotfiles"
        elseif filename:match("projects/treesitter/.+/grammar.js") then
          -- try and get the name from the * part, if it's tree-sitter-{name}, else just return "Editing a tree-sitter grammar"
          local name = filename:match("projects/treesitter/.+/grammar.js"):match("tree%-sitter%-(.+)")
          if name then
            return string.format("Editing %s's tree-sitter grammar", name)
          end
          return "Editing a tree-sitter grammar"
        else
          return string.format("Editing %s", filename)
        end
      end,
      reading_text = function(buf_name) --- @param buf_name string
        local toggleterm_process = buf_name:match("([^;]+);#toggleterm#%d+")

        -- Terminal check
        if toggleterm_process == "lazygit" then
          return "Messing with git"
        elseif toggleterm_process == "zsh" then
          return "In the terminal"
        end

        local lazygit_process = buf_name:match("%d+:(.+)")
        if lazygit_process == "lazygit" then
          return "In Lazygit"
        end

        return string.format("Reading %s", buf_name)
      end,
    },
  },

  {
    "3rd/image.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
        neorg = {
          enabled = false,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      kitty_method = "normal",
    },
  },

  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Neorg", "NeorgOpen", "NeorgNew", "NeorgDoc" },
    event = "LazyFile",
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            neorg_leader = "<leader>o",
          },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.concealer"] = {
          config = {
            icon_preset = "diamond",
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
              school = "~/School/notes",
            },
            default_workspace = "notes",
          },
        },
        ["core.summary"] = {},
      },
    },
  },
}
