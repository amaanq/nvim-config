return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = { ["*"] = true },
      suggestion = { enabled = true, auto_trigger = true },
    },
  },

  -- Supertab
  -- {
  --   "L3MON4D3/LuaSnip",
  --   opts = {
  --     history = true,
  --     region_check_events = "InsertEnter",
  --     delete_check_events = "TextChanged",
  --   },
  --   keys = function()
  --     return {}
  --   end,
  -- },

  {
    "nvim-cmp",
    dependencies = {
      -- "f3fora/cmp-spell",
      -- "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      -- "jc-doyle/cmp-pandoc-references",
      "petertriho/cmp-git",
      "rcarriga/cmp-dap",
      "hrsh7th/cmp-cmdline",
      { "windwp/nvim-autopairs", opts = {} },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- local has_words_before = function()
      --   unpack = unpack or table.unpack
      --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      -- end

      -- local luasnip = require("luasnip")
      local cmp = require("cmp")

      table.insert(opts.sources, { name = "git" })
      -- table.insert(opts.sources, { name = "pandoc_references" })
      table.insert(opts.sources, { name = "emoji" })
      -- table.insert(opts.sources, { name = "calc" })
      -- table.insert(opts.sources, { name = "spell" })

      -- opts.mapping = vim.tbl_extend("force", opts.mapping, {
      --   ["<Tab>"] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --       -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
      --       cmp.confirm({ select = true })
      --     -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
      --     -- this way you will only jump inside the snippet region
      --     elseif luasnip.expand_or_locally_jumpable() then
      --       luasnip.expand_or_jump()
      --     elseif has_words_before() then
      --       cmp.complete()
      --     else
      --       fallback()
      --     end
      --   end, { "i", "s" }),
      --   ["<S-Tab>"] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --       cmp.select_prev_item()
      --     elseif luasnip.jumpable(-1) then
      --       luasnip.jump(-1)
      --     else
      --       fallback()
      --     end
      --   end, { "i", "s" }),
      -- })

      opts.window = {
        completion = vim.tbl_deep_extend("force", cmp.config.window.bordered(), {
          winhighlight = "Normal:Pmenu",
        }),
        documentation = vim.tbl_deep_extend("force", cmp.config.window.bordered(), {
          winhighlight = "Normal:Pmenu",
        }),
      }

      cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
        sources = { { name = "dap" } },
      })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- cmp.setup.cmdline(":", {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources({
      --     { name = "path" },
      --   }, {
      --     {
      --       name = "cmdline",
      --       option = {
      --         ignore_cmds = { "Man", "!" },
      --       },
      --     },
      --   }),
      -- })

      -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  {
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 200 },
  },

  {
    "andythigpen/nvim-coverage",
    event = "VeryLazy",
    config = true,
  },

  {
    "rest-nvim/rest.nvim",
    ft = "http",
    config = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = true,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Encode URL before making request
        encode_url = true,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          show_http_info = true,
          show_headers = true,
          -- executables or functions for formatting response body [optional]
          -- set them to false if you want to disable them
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end,
          },
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
      })
    end,
    keys = {
      {
        "<leader>cq",
        function()
          require("rest-nvim").run(true)
        end,
        desc = "Preview Request",
        ft = "http",
      },
      {
        "<leader>ct",
        function()
          require("rest-nvim").run()
        end,
        desc = "Test Request",
        ft = "http",
      },
    },
  },

  {
    "pwntester/codeql.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "telescope.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "s1n7ax/nvim-window-picker",
        version = "v1.*",
        opts = {
          autoselect_one = true,
          include_current = false,
          filter_rules = {
            bo = {
              filetype = {
                "codeql_panel",
                "codeql_explorer",
                "qf",
                "TelescopePrompt",
                "TelescopeResults",
                "notify",
                "NvimTree",
                "neo-tree",
              },
              buftype = { "terminal" },
            },
          },
          current_win_hl_color = "#e35e4f",
          other_win_hl_color = "#44cc41",
        },
      },
    },
    opts = {
      additional_packs = {
        "/opt/codeql",
      },
    },
    cmd = { "QL" },
  },

  { "wakatime/vim-wakatime", event = "VeryLazy" },

  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      vim.o.mps = vim.o.mps .. ',<:>,":"'
    end,
    config = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },
}
