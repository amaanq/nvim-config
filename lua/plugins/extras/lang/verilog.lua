return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
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
        svls = {
          mason = false,
        },
        verible = {
          cmd = { "verible-verilog-ls", "--rules=line-length=length:120" },
        },
      },
    },
  },
}
