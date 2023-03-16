local util = require("util")

return {

	-- Add CMake to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				util.list_insert_unique(opts.ensure_installed, "cmake")
			end
		end,
	},

	-- Correctly setup lspconfig for CMake 🚀
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				neocmake = {},
			},
			settings = {
				neocmake = {},
			},
		},
	},
}
