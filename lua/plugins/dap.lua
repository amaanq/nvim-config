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

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "dap-repl",
			callback = function()
				require("dap.ext.autocompl").attach()
			end,
		})

		local dap = require("dap")
		dap.configurations.lua = {
			{
				type = "nlua",
				request = "attach",
				name = "Attach to running Neovim instance",
			},
		}

		dap.adapters.nlua = function(callback, config)
			callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
		end

		local dapui = require("dapui")
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open({})
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close({})
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close({})
		end
	end,
	keys = {
		{
			"<leader>dbc",
			'<CMD>lua require("dap").set_breakpoint(vim.ui.input("Breakpoint condition: "))<CR>',
			desc = "Conditional Breakpoint",
		},
		{
			"<leader>dbl",
			'<CMD>lua require("dap").set_breakpoint(nil, nil, vim.ui.input("Log point message: "))<CR>',
			desc = "Logpoint",
		},
		{ "<leader>dbr", '<CMD>lua require("dap.breakpoints").clear()<CR>', desc = "Remove All Breakpoints" },
		{ "<leader>dbs", "<CMD>Telescope dap list_breakpoints<CR>", desc = "Show All Breakpoints" },
		{ "<leader>dbt", '<CMD>lua require("dap").toggle_breakpoint()<CR>', desc = "Toggle Breakpoint" },
		{ "<leader>dc", '<CMD>lua require("dap").continue()<CR>', desc = "Continue" },
		{
			"<leader>dw",
			'<CMD>lua require("dap.ui.widgets").hover(nil, { border = "none" })<CR>',
			desc = "Widgets",
			mode = { "n", "v" },
		},
		{ "<leader>dp", '<CMD>lua require("dap").pause()<CR>', desc = "Pause" },
		{ "<leader>dr", "<CMD>Telescope dap configurations<CR>", desc = "Run" },
		{ "<leader>dsb", '<CMD>lua require("dap").step_back()<CR>', desc = "Step Back" },
		{ "<leader>dsc", '<CMD>lua require("dap").run_to_cursor()<CR>', desc = "Step to Cursor" },
		{ "<leader>dsi", '<CMD>lua require("dap").step_into()<CR>', desc = "step Into" },
		{ "<leader>dso", '<CMD>lua require("dap").step_over()<CR>', desc = "Step Over" },
		{ "<leader>dsx", '<CMD>lua require("dap").step_out()<CR>', desc = "Step Out" },
		{ "<leader>dx", '<CMD>lua require("dap").terminate()<CR>', desc = "Terminate" },
		{
			"<leader>dvf",
			'<CMD>lua require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames, { border = "none" })<CR>',
			desc = "Show Frames",
		},
		{
			"<leader>dvs",
			'<CMD>lua require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes, { border = "none" })<CR>',
			desc = "Show Scopes",
		},
		{
			"<leader>dvt",
			'<CMD>lua require("dap.ui.widgets").centered_float(require("dap.ui.widgets").threads, { border = "none" })<CR>',
			desc = "Show Threads",
		},

		{ "<leader>dr", '<CMD>lua require("dap").repl.open()<CR>', desc = "Repl" },
		{ "<leader>du", '<CMD>lua require("dapui").toggle()<CR>', desc = "Dap UI" },
		{ "<leader>dd", '<CMD>lua require("osv").run_this()<CR>', desc = "Launch Lua Debugger" },
		{ "<leader>dl", '<CMD>lua require("osv").launch({ port = 8086 })<CR>', desc = "Launch Lua Debugger Server" },
	},
}

-- - `DapBreakpoint` for breakpoints (default: `B`)
-- - `DapBreakpointCondition` for conditional breakpoints (default: `C`)
-- - `DapLogPoint` for log points (default: `L`)
-- - `DapStopped` to indicate where the debugee is stopped (default: `→`)
-- - `DapBreakpointRejected` to indicate breakpoints rejected by the debug
--   adapter (default: `R`)
--
-- You can customize the signs by setting them with the |sign_define()| function.
-- For example:
--
-- >
--     lua << EOF
--     vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
--     EOF
-- <
