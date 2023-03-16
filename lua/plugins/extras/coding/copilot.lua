return {

	-- copilot
	{
		"zbirenbaum/copilot.lua",
		lazy = false,
		cmd = "Copilot",
		build = ":Copilot auth",
		opts = {
			panel = { enabled = false },
			suggestion = { auto_trigger = true },
		},
	},

	{
		"zbirenbaum/copilot-cmp",
		event = "VimEnter",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = true,
	},
}
