return {
  { "yanky.nvim", keys = { { "<leader>p", false, mode = { "n", "x" } } } },
  {
    "snacks.nvim",
    opts = {
      profiler = {
        runtime = "~/projects/neovim/runtime/",
        presets = {
          on_stop = function()
            Snacks.profiler.scratch()
          end,
        },
      },
      input = {},
      indent = {
        scope = {
          treesitter = {
            enabled = true,
          },
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
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
        Snacks.toggle.zen():map("<leader>z")
      end)
    end,
  },
}
