return {
  {
    "telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-dap.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      { "nvim-telescope/telescope-project.nvim" },
      { "debugloop/telescope-undo.nvim" },
    },
    keys = {
      {
        "<leader>fp",
        "<cmd>Telescope project display_type=full<cr>",
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
      extensions = {
        project = {
          base_dirs = {
            "~/projects",
          },
        },
        undo = {
          use_delta = true,
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.4,
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("dap")
      telescope.load_extension("project")
      telescope.load_extension("undo")
    end,
  },
}
