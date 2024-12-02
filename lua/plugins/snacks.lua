return {
  { "yanky.nvim", keys = { { "<leader>p", false, mode = { "n", "x" } } } },
  {
    "snacks.nvim",
    opts = {
      profiler = { runtime = "~/projects/neovim/runtime/" },
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
        "<leader>pp",
        desc = "Group traces and open a picker",
        function()
          if not Snacks.profiler.toggle() then
            Snacks.profiler.pick({ min_time = 0.2 })
          end
        end,
      },
      {
        "<leader>ph",
        desc = "Toggle profiler highlights",
        function()
          Snacks.profiler.highlight()
        end,
      },
      {
        "<leader>pd",
        desc = "Toggle profiler debug",
        function()
          if not Snacks.profiler.enabled then
            Snacks.notify("Profiler debug started")
            Snacks.profiler.start()
          else
            Snacks.profiler.debug()
            Snacks.notify("Profiler debug stopped")
          end
          if not Snacks.profiler.enabled then
            Snacks.profiler.pick({})
          end
        end,
      },
    },
  },
}
