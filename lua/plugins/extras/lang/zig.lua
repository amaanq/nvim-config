local util = require("util")

return {

	-- Add Zig to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				util.list_insert_unique(opts.ensure_installed, "zig")
			end
		end,
	},

	-- Correctly setup lspconfig for zig 🚀
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Ensure mason installs the server
				zls = {},
			},
			setup = {
				zls = {},
			},
		},
	},
}
