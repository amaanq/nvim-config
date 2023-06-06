return {
  { "nvim-neotest/neotest-go" },
  { "mrcjkb/neotest-haskell" },
  { "haydenmeade/neotest-jest" },
  { "nvim-neotest/neotest-plenary" },
  { "nvim-neotest/neotest-python" },
  { "rouge8/neotest-rust" },
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        "neotest-go",
        "neotest-haskell",
        "neotest-jest",
        "neotest-plenary",
        ["neotest-python"] = {
          dap = { justMyCode = false },
        },
        "neotest-rust",
      },
    },
  },
}
