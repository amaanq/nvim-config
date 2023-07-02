return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-go",
      "mrcjkb/neotest-haskell",
      "haydenmeade/neotest-jest",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
      "marilari88/neotest-vitest",
    },
    opts = function(_, opts)
      opts.adapters["neotest-jest"] = {}
      opts.adapters["neotest-plenary"] = {
        min_init = "./tests/init.lua",
      }
      opts.adapters["neotest-python"] = { justMyCode = false }
      opts.adapters["neotest-vitest"] = {}
    end,
  },
}
