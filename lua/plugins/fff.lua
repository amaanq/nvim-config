return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    init = function()
      -- download doesn't set +x on the .so; fix it before the native module loads
      local ok, download = pcall(require, "fff.download")
      if ok then
        local path = download.get_binary_path()
        if path then
          pcall(vim.uv.fs_chmod, path, tonumber("755", 8))
        end
      end
    end,
    lazy = false,
    opts = {
      layout = {
        height = 0.8,
        width = 0.8,
        prompt_position = "bottom",
        preview_position = "right",
        preview_size = 0.5,
      },
      preview = {
        enabled = true,
      },
      keymaps = {
        close = "<Esc>",
        select = "<CR>",
        select_split = "<C-s>",
        select_vsplit = "<C-v>",
        select_tab = "<C-t>",
        move_up = { "<Up>", "<C-p>" },
        move_down = { "<Down>", "<C-n>" },
        preview_scroll_up = "<C-u>",
        preview_scroll_down = "<C-d>",
      },
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("fff").find_files()
        end,
        desc = "Find Files (fff)",
      },
      {
        "<leader>fF",
        function()
          require("fff").find_in_git_root()
        end,
        desc = "Find Files (git root)",
      },
      {
        "<leader>fg",
        function()
          require("fff").live_grep()
        end,
        desc = "Live Grep (fff)",
      },
    },
  },
  -- Disable snacks picker keymaps that conflict with fff
  {
    "snacks.nvim",
    keys = {
      { "<leader>ff", false },
      { "<leader>fF", false },
    },
  },
}
