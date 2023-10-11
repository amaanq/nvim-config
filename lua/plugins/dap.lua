return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    { "rcarriga/nvim-dap-ui", config = true },
    { "theHamsta/nvim-dap-virtual-text", config = true },
    { "mfussenegger/nvim-dap-python" },
    { "Pocco81/dap-buddy.nvim" },
    { "jbyuki/one-small-step-for-vimkind" },
  },
  config = function()
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })

    require("dap").defaults.fallback.terminal_win_cmd = "enew | set filetype=dap-terminal"

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dap-repl",
      callback = function()
        require("dap.ext.autocompl").attach()
      end,
    })

    require("which-key").register({
      ["<leader>d"] = { name = "+debug" },
      ["<leader>db"] = { name = "+breakpoints" },
      ["<leader>ds"] = { name = "+steps" },
      ["<leader>dv"] = { name = "+views" },
    })

    local dap = require("dap")
    dap.configurations.lua = {
      {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
      },
    }

    ---@type Dap.AdapterFactory
    dap.adapters.nlua = function(callback, config)
      callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
    end

    local dapui = require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end,
  keys = {
    {
      "<leader>dbc",
      '<cmd>lua require("dap").set_breakpoint(vim.ui.input("Breakpoint condition: "))<cr>',
      desc = "Conditional Breakpoint",
    },
    {
      "<leader>dbl",
      '<cmd>lua require("dap").set_breakpoint(nil, nil, vim.ui.input("Log point message: "))<cr>',
      desc = "Logpoint",
    },
    { "<leader>dbr", '<cmd>lua require("dap.breakpoints").clear()<cr>', desc = "Remove All Breakpoints" },
    { "<leader>dbs", "<cmd>Telescope dap list_breakpoints<cr>", desc = "Show All Breakpoints" },
    { "<leader>dbt", '<cmd>lua require("dap").toggle_breakpoint()<cr>', desc = "Toggle Breakpoint" },
    { "<leader>dc", '<cmd>lua require("dap").continue()<cr>', desc = "Continue" },
    {
      "<leader>dw",
      '<cmd>lua require("dap.ui.widgets").hover(nil, { border = "none" })<cr>',
      desc = "Evaluate Expression",
      mode = { "n", "v" },
    },
    { "<leader>dp", '<cmd>lua require("dap").pause()<cr>', desc = "Pause" },
    { "<leader>dr", "<cmd>Telescope dap configurations<cr>", desc = "Run" },
    { "<leader>dsb", '<cmd>lua require("dap").step_back()<cr>', desc = "Step Back" },
    { "<leader>dsc", '<cmd>lua require("dap").run_to_cursor()<cr>', desc = "Run to Cursor" },
    { "<leader>dsi", '<cmd>lua require("dap").step_into()<cr>', desc = "step Into" },
    { "<leader>dso", '<cmd>lua require("dap").step_over()<cr>', desc = "Step Over" },
    { "<leader>dsx", '<cmd>lua require("dap").step_out()<cr>', desc = "Step Out" },
    { "<leader>dx", '<cmd>lua require("dap").terminate()<cr>', desc = "Terminate" },
    {
      "<leader>dvf",
      function()
        require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames, { border = "none" })
      end,
      desc = "Show Frames",
    },
    {
      "<leader>dvr",
      function()
        require("dap").repl.open(nil, "20split")
      end,
      desc = "Show Repl",
    },
    {
      "<leader>dvs",
      function()
        require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes, { border = "none" })
      end,
      desc = "Show Scopes",
    },
    {
      "<leader>dvt",
      function()
        require("dap.ui.widgets").centered_float(require("dap.ui.widgets").threads, { border = "none" })
      end,
      desc = "Show Threads",
    },
    { "<leader>dr", '<cmd>lua require("dap").repl.open()<cr>', desc = "Repl" },
    { "<leader>du", '<cmd>lua require("dapui").toggle()<cr>', desc = "Dap UI" },
    { "<leader>dd", '<cmd>lua require("osv").run_this()<cr>', desc = "Launch Lua Debugger" },
    { "<leader>dl", '<cmd>lua require("osv").launch({ port = 8086 })<cr>', desc = "Launch Lua Debugger Server" },
  },
}
