return {
  { "pwntester/octo.nvim", cmd = "Octo", opts = {} },

  -- markdown preview
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Peek (Markdown Preview)",
      },
    },
    opts = { theme = "dark" }, -- 'dark' or 'light'
    init = function()
      require("which-key").register({
        ["<leader>o"] = { name = "+open" },
      })
    end,
  },

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
    "andweeb/presence.nvim",
    event = "BufRead",
    config = function()
      require("presence"):setup({
        auto_update = true,
        main_image = "file",
        log_level = nil,
        debounce_timeout = 10,
        blacklist = {
          "toggleterm",
          "zsh",
          "zsh*",
          "ToggleTerm",
          "zsh;#toggleterm#1",
          "zsh;#toggleterm#2",
          "zsh;#toggleterm#3",
          "zsh;#toggleterm#4",
          "zsh;#toggleterm#5",
        },
        enable_line_number = true,
        buttons = true,
        show_time = true,

        -- Rich Presence text options
        editing_text = "Editing %s",
        file_explorer_text = "Browsing %s",
        git_commit_text = "Committing changes",
        plugin_manager_text = "Managing plugins",
        reading_text = function(buf_name) --- @param buf_name string
          -- Extract the process name running in toggleterm from the given buffer name
          -- we want to match `zsh;#toggleterm#1`, grab the "zsh" part (aka the beginning before the semicolon) and store it into toggleterm_process
          local toggleterm_process = buf_name:match("([^;]+);#toggleterm#%d+")

          -- Terminal check
          if toggleterm_process == "lazygit" then
            return "Messing with git"
          elseif toggleterm_process == "zsh" then
            return "In the terminal"
          end

          -- Lazygit check `59683:lazygit` grab the "lazygit" part (aka the end after the colon) and store it into lazygit_process
          local lazygit_process = buf_name:match("%d+:(.+)")
          if lazygit_process == "lazygit" then
            return "In Lazygit"
          end

          return string.format("Reading %s", buf_name)
        end,
        workspace_text = "Working on %s",
        line_number_text = "Line %s out of %s",
      })
    end,
  },
}
