return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    init = function()
      require("lint").linters.verilator.args = {
        "-sv",
        "-Wall",
        "--bbox-sys",
        "--bbox-unsup",
        "--lint-only",
        "--timing=22",
      }
    end,
    opts = {
      linters_by_ft = {
        verilog = { "verilator" },
        systemverilog = { "verilator" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        svls = {},
        verible = {
          cmd = { "verible-verilog-ls", "--rules=line-length=length:120" },
        },
      },
    },
  },
}
