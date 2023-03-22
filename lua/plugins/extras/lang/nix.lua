local util = require("util")

return {

	-- Add Nix to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				util.list_insert_unique(opts.ensure_installed, "nix")
			end
		end,
	},

	-- Correctly setup lspconfig for Nix 🚀
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- Ensure mason installs the server
				rnix = {},
			},
			settings = {
				rnix = {},
			},
		},
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function(_, opts)
			local nls = require("null-ls")
			if type(opts.sources) == "table" then
				vim.list_extend(opts.sources, {
					nls.builtins.code_actions.statix,
					nls.builtins.formatting.alejandra,
					nls.builtins.diagnostics.deadnix,
				})
			end
		end,
	},
}
