local util = require("util")

return {

	-- Add Bash to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				util.list_insert_unique(opts.ensure_installed, "bash")
			end
		end,
	},

	-- Ensure Bash linter and formatter are installed
	{
		"jay-babu/mason-null-ls.nvim",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				util.list_insert_unique(opts.ensure_installed, { "shellcheck", "shfmt" })
			end
		end,
	},

	-- Ensure Bash debugger is installed
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				util.list_insert_unique(opts.ensure_installed, "bash")
			end
		end,
	},

	-- Correctly setup lspconfig for Bash 🚀
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Ensure mason installs the server
				bashls = {},
			},
			settings = {
				bashls = {},
			},
		},
	},
}
