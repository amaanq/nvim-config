return {

	-- add swift to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "swift" })
			end
		end,
	},

	-- correctly setup lspconfig for Swift
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- make sure mason installs the server
			servers = {
				sourcekit = {
					filetypes = { "swift", "objective-c", "objective-cpp" },
				},
			},
		},
	},
}
