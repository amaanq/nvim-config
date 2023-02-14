return {
	-- copilot
	{
		"zbirenbaum/copilot.lua",
		lazy = false,
		config = true,
		opts = {
			panel = { enabled = false },
			suggestion = { auto_trigger = true },
			plugin_manager_path = vim.fn.stdpath("data") .. "/lazy",
		},
	},

	{
		"zbirenbaum/copilot-cmp",
		event = "VimEnter",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = true,
	},
}
