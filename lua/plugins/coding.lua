return {
  {
    "nvim-mini/mini.pairs",
    opts = {
      mappings = {
        ["`"] = { neigh_pattern = "^[^%w_\\\\]" },
      },
    },
  },

  {
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 200 },
  },
}
