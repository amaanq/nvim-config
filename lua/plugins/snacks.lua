return {
  { "yanky.nvim", keys = { { "<leader>p", false, mode = { "n", "x" } } } },
  {
    "snacks.nvim",
    ---@type snacks.Config
    opts = {
      profiler = {
        runtime = "~/projects/neovim/runtime/",
        presets = {
          on_stop = function()
            Snacks.profiler.scratch()
          end,
        },
      },
      image = { enabled = true },
      input = {},
      indent = {
        scope = {
          treesitter = {
            enabled = true,
          },
        },
      },
      picker = {
        config = function(opts)
          opts.sources.explorer.hidden = true
        end,
        debug = { scores = false, leaks = false, explorer = true, files = true },
        -- Threading + AOSP exclusions for GrapheneOS
        sources = {
          files = {
            cmd = "fd",
            args = {
              "--type",
              "f",
              "--threads",
              "32",
              "--hidden",
              "--follow",
              "--exclude",
              "out",
              "--exclude",
              "prebuilts",
              "--exclude",
              ".repo",
              "--exclude",
              ".git",
              "--exclude",
              "*.o",
              "--exclude",
              "*.a",
              "--exclude",
              "*.so",
              "--exclude",
              "external/chromium*",
              "--exclude",
              "external/llvm*",
            },
          },
          grep = {
            cmd = "rg",
            args = {
              "--threads",
              "32",
              "--glob",
              "!out",
              "--glob",
              "!prebuilts",
              "--glob",
              "!.repo",
              "--glob",
              "!.git",
              "--glob",
              "!*.o",
              "--glob",
              "!*.a",
              "--glob",
              "!*.so",
              "--glob",
              "!external/chromium*",
              "--glob",
              "!external/llvm*",
            },
          },
          files_with_symbols = {
            multi = { "files", "lsp_symbols" },
            filter = {
              ---@param p snacks.Picker
              ---@param filter snacks.picker.Filter
              transform = function(p, filter)
                local symbol_pattern = filter.pattern:match("^.-@(.*)$")
                -- store the current file buffer
                if filter.source_id ~= 2 then
                  local item = p:current()
                  if item and item.file then
                    filter.meta.buf = vim.fn.bufadd(item.file)
                  end
                end
                if symbol_pattern and filter.meta.buf then
                  filter.pattern = symbol_pattern
                  filter.current_buf = filter.meta.buf
                  filter.source_id = 2
                else
                  filter.source_id = 1
                end
              end,
            },
          },
        },
        win = {
          input = {
            keys = {
              ["<c-l>"] = { "toggle_lua", mode = { "n", "i" } },
              -- ["<c-t>"] = { "edit_tab", mode = { "n", "i" } },
              -- ["<Esc>"] = { "close", mode = { "n", "i" } },
            },
          },
          list = {
            keys = {},
          },
        },
        actions = {
          toggle_lua = function(p)
            local opts = p.opts --[[@as snacks.picker.grep.Config]]
            opts.ft = not opts.ft and "lua" or nil
            p:find()
          end,
        },
      },
      scroll = {
        animate = {
          duration = { total = 100 },
          easing = "inOutExpo",
          fps = vim.g.fps,
        },
      },
      dashboard = { example = "github" },
      gitbrowse = {
        config = function(opts, defaults)
          dd(opts, defaults)
        end,
      },
    },
    keys = {
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Open",
      },
      {
        "<leader>nt",
        function()
          Snacks.scratch({ icon = " ", name = "Todo", ft = "markdown", file = "~/dotfiles/TODO.md" })
        end,
        desc = "Todo List",
      },
      { "<leader>p", "", desc = "+profile" },
      {
        "<leader>ps",
        function()
          Snacks.profiler.scratch()
        end,
      },
      {
        "<leader>pd",
        desc = "Toggle profiler debug",
        function()
          if not Snacks.profiler.running() then
            Snacks.notify("Profiler debug started")
            Snacks.profiler.start()
          else
            Snacks.profiler.debug()
            Snacks.notify("Profiler debug stopped")
          end
        end,
      },
    },
  },
  {
    "snacks.nvim",
    opts = function()
      LazyVim.on_load("which-key.nvim", function()
        Snacks.toggle.profiler():map("<leader>pp")
        Snacks.toggle.profiler_highlights():map("<leader>ph")
        Snacks.toggle.zen():map("<leader>z")
      end)
    end,
  },
}
