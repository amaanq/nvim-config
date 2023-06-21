return {

  {
    "huggingface/hfcc.nvim",
    opts = {
      api_token = "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",
      model = "bigcode/starcoder",
      query_params = {
        max_new_tokens = 200,
      },
    },
    init = function()
      vim.api.nvim_create_user_command("StarCoder", function()
        require("hfcc.completion").complete()
      end, {})
    end,
  },

  -- better text objects
  {
    "echasnovski/mini.ai",
    keys = { { "[f", desc = "Prev function" }, { "]f", desc = "Next function" } },
    opts = function(plugin)
      -- call config of parent spec
      plugin._.super.config()

      -- add treesitter jumping
      local function jump(capture, start, down)
        local rhs = function()
          local parser = vim.treesitter.get_parser()
          if not parser then
            return vim.notify("No treesitter parser for the current buffer", vim.log.levels.ERROR)
          end

          local query = vim.treesitter.get_query(vim.bo.filetype, "textobjects")
          if not query then
            return vim.notify("No textobjects query for the current buffer", vim.log.levels.ERROR)
          end

          local cursor = vim.api.nvim_win_get_cursor(0)

          ---@type {[1]:number, [2]:number}[]
          local locs = {}
          for _, tree in ipairs(parser:trees()) do
            for capture_id, node, _ in query:iter_captures(tree:root(), 0) do
              if query.captures[capture_id] == capture then
                local range = { node:range() } ---@type number[]
                local row = (start and range[1] or range[3]) + 1
                local col = (start and range[2] or range[4]) + 1
                if down and row > cursor[1] or (not down) and row < cursor[1] then
                  table.insert(locs, { row, col })
                end
              end
            end
          end
          return pcall(vim.api.nvim_win_set_cursor, 0, down and locs[1] or locs[#locs])
        end

        local c = capture:sub(1, 1):lower()
        local lhs = (down and "]" or "[") .. (start and c or c:upper())
        local desc = (down and "Next " or "Prev ") .. (start and "start" or "end") .. " of " .. capture:gsub("%..*", "")
        vim.keymap.set("n", lhs, rhs, { desc = desc })
      end

      for _, capture in ipairs({ "function.outer", "class.outer" }) do
        for _, start in ipairs({ true, false }) do
          for _, down in ipairs({ true, false }) do
            jump(capture, start, down)
          end
        end
      end
    end,
  },

  {
    "danymat/neogen",
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate()
        end,
        desc = "Neogen Comment",
      },
    },
    opts = { snippet_engine = "luasnip" },
  },

  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    opts = {},
  },

  {
    "echasnovski/mini.bracketed",
    event = "BufReadPost",
    config = function()
      local bracketed = require("mini.bracketed")

      -- local function put(cmd, regtype)
      -- 	local body = vim.fn.getreg(vim.v.register)
      -- 	local type = vim.fn.getregtype(vim.v.register)
      -- 	---@diagnostic disable-next-line: param-type-mismatch
      -- 	vim.fn.setreg(vim.v.register, body, regtype or "l")
      -- 	bracketed.register_put_region()
      -- 	vim.cmd(('normal! "%s%s'):format(vim.v.register, cmd:lower()))
      -- 	---@diagnostic disable-next-line: param-type-mismatch
      -- 	vim.fn.setreg(vim.v.register, body, type)
      -- end

      -- for _, cmd in ipairs({ "]p", "[p" }) do
      -- 	put(cmd)
      -- 	vim.keymap.set("n", cmd, function() end)
      -- end
      --
      -- for _, cmd in ipairs({ "]P", "[P" }) do
      -- 	vim.keymap.set("n", cmd, function()
      -- 		put(cmd, "c")
      -- 	end)
      -- end

      -- local put_keys = { "p", "P" }
      -- for _, lhs in ipairs(put_keys) do
      -- 	vim.keymap.set({ "n", "x" }, lhs, function()
      -- 		return bracketed.register_put_region(lhs)
      -- 	end, { expr = true })
      -- end

      bracketed.setup({
        file = { suffix = "" },
        window = { suffix = "" },
        quickfix = { suffix = "" },
        yank = { suffix = "" },
        treesitter = { suffix = "n" },
      })
    end,
  },

  -- better yank/paste
  {
    "gbprod/yanky.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = { { "kkharji/sqlite.lua", enabled = not jit.os:find("Windows") } },
    opts = {
      highlight = { timer = 150 },
      ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
    },
    keys = {
      -- stylua: ignore
      { "<leader>P", function() require("telescope").extensions.yank_history.yank_history({ }) end, desc = "Paste from Yanky" },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },
      { "[y", "<Plug>(YankyCycleForward)" },
      { "]y", "<Plug>(YankyCycleBackward)" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)" },
      { "=p", "<Plug>(YankyPutAfterFilter)" },
      { "=P", "<Plug>(YankyPutBeforeFilter)" },
    },
  },

  -- better increase/descrease
  {
    "monaqa/dial.nvim",
    event = "VeryLazy",
    -- splutylua: ignore
    keys = {
      {
        "<C-a>",
        function()
          return require("dial.map").inc_normal()
        end,
        expr = true,
        desc = "Increment",
      },
      {
        "<C-x>",
        function()
          return require("dial.map").dec_normal()
        end,
        expr = true,
        desc = "Decrement",
      },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.constant.new({ elements = { "let", "const" } }),
          augend.semver.alias.semver,
        },
      })
    end,
  },

  {
    "simrat39/symbols-outline.nvim",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    cmd = "SymbolsOutline",
    opts = {},
  },

  {
    "nvim-cmp",
    dependencies = {
      -- "f3fora/cmp-spell",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      -- "jc-doyle/cmp-pandoc-references",
      "petertriho/cmp-git",
      "rcarriga/cmp-dap",
      "zbirenbaum/copilot-cmp",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.tbl_deep_extend("force", opts.sources, {
        { name = "nvim_lsp", priority = 1000 },
        {
          name = "git",
          priority = 800,
          options = { filetypes = { "gitcommit", "NeogitCommitMessage", "octo" } },
        },
        { name = "luasnip", priority = 750 },
        -- { name = "pandoc_references", priority = 725 },
        { name = "emoji", priority = 700 },
        { name = "calc", priority = 650 },
        { name = "path", priority = 500 },
        -- { name = "spell", priority = 400 },
        { name = "buffer", priority = 250 },
      }))

      cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
        sources = { { name = "dap" } },
      })
    end,
  },

  {
    "gorbit99/codewindow.nvim",
    enabled = false,
    event = "BufReadPre",
    keys = {
			-- stylua: ignore
			{ "<leader>um", function() require("codewindow").toggle_minimap() end, desc = "Toggle Minimap" },
    },
    config = function()
      require("codewindow").setup({
        z_index = 25,
        auto_enable = true,
        exclude_filetypes = {
          "alpha",
          "dap-terminal",
          "DiffviewFiles",
          "git",
          "gitcommit",
          "help",
          "lazy",
          "lspinfo",
          "mason",
          "NeogitCommitMessage",
          "NeogitStatus",
          "neotest-summary",
          "neo-tree",
          "neo-tree-popup",
          "noice",
          "Outline",
          "qf",
          "spectre_panel",
          "toggleterm",
          "Trouble",
        },
      })
    end,
  },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "UndoTree Toggle" } },
    config = function()
      vim.g.undotree_TreeNodeShape = "◦" -- Alternative: '◉'
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
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
        "<leader>cp",
        function()
          require("rest-nvim").run(true)
        end,
        desc = "Preview Request",
      },
      {
        "<leader>ct",
        function()
          require("rest-nvim").run()
        end,
        desc = "Test Request",
      },
    },
  },
}
