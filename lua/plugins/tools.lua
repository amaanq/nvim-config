return {
  { "pwntester/octo.nvim", cmd = "Octo", opts = {} },

  -- -- better diffing
  -- {
  --   "sindrets/diffview.nvim",
  --   cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  --   opts = {},
  --   keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
  -- },

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

  -- {
  --   "andweeb/presence.nvim",
  --   event = "BufRead",
  --   opts = {
  --     main_image = "file",
  --     enable_line_number = true,
  --     blacklist = {
  --       ".*zsh.*",
  --       ".*ToggleTerm.*",
  --       ".*toggleterm.*",
  --     },
  --     buttons = false,
  --     ---@param filename string
  --     editing_text = function(filename)
  --       -- if in .config/nvim, return "Editing dotfiles"
  --       -- if in ~/projects/treesitter/*/grammar.js, return "Editing a tree-sitter grammar"
  --       -- else return "Editing %s"
  --       if filename:match(".config/nvim") then
  --         return "Editing my dotfiles"
  --       elseif filename:match("projects/treesitter/.+/grammar.js") then
  --         -- try and get the name from the * part, if it's tree-sitter-{name}, else just return "Editing a tree-sitter grammar"
  --         local name = filename:match("projects/treesitter/.+/grammar.js"):match("tree%-sitter%-(.+)")
  --         if name then
  --           return string.format("Editing %s's tree-sitter grammar", name)
  --         end
  --         return "Editing a tree-sitter grammar"
  --       else
  --         return string.format("Editing %s", filename)
  --       end
  --     end,
  --     reading_text = function(buf_name) --- @param buf_name string
  --       local toggleterm_process = buf_name:match("([^;]+);#toggleterm#%d+")
  --
  --       -- Terminal check
  --       if toggleterm_process == "lazygit" then
  --         return "Messing with git"
  --       elseif toggleterm_process == "zsh" then
  --         return "In the terminal"
  --       end
  --
  --       local lazygit_process = buf_name:match("%d+:(.+)")
  --       if lazygit_process == "lazygit" then
  --         return "In Lazygit"
  --       end
  --
  --       return string.format("Reading %s", buf_name)
  --     end,
  --   },
  -- },

  -- {
  --   "3rd/image.nvim",
  --   event = "VeryLazy",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   opts = {
  --     backend = "kitty",
  --     integrations = {
  --       markdown = {
  --         enabled = true,
  --         clear_in_insert_mode = false,
  --         download_remote_images = true,
  --         only_render_image_at_cursor = false,
  --         filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
  --       },
  --       neorg = {
  --         enabled = false,
  --         clear_in_insert_mode = false,
  --         download_remote_images = true,
  --         only_render_image_at_cursor = false,
  --         filetypes = { "norg" },
  --       },
  --     },
  --     max_width = nil,
  --     max_height = nil,
  --     max_width_window_percentage = nil,
  --     max_height_window_percentage = 50,
  --     kitty_method = "normal",
  --     window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
  --     window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  --     editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
  --     tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
  --     hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
  --   },
  -- },

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

  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim", "nvim-telescope/telescope.nvim" },
    opts = {},
  },

  {
    "stevearc/overseer.nvim",
    commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
      },
    },
  },
}
