local util = require("util")

return {

	-- Add C/C++ to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				util.list_insert_unique(opts.ensure_installed, { "c", "cpp" })
			end
		end,
	},

	-- Ensure clang_format is installed
	{
		"jay-babu/mason-null-ls.nvim",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				util.list_insert_unique(opts.ensure_installed, { "clang_format" })
			end
		end,
	},

	-- Correctly setup lspconfig for clangd 🚀
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"p00f/clangd_extensions.nvim",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
			},
		},
		opts = {
			servers = {
				clangd = {},
			},
			setup = {
				clangd = function(_, opts)
					opts.capabilities.offsetEncoding = { "utf-16" }
					opts.cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
					}
					opts.init_options = {
						usePlaceholders = true,
						completeUnimported = true,
						clangdFileStatus = true,
					}
					require("clangd_extensions").setup({
						server = opts,
						extensions = {
							ast = {
								--These require codicons (https://github.com/microsoft/vscode-codicons)
								role_icons = {
									type = "",
									declaration = "",
									expression = "",
									specifier = "",
									statement = "",
									["template argument"] = "",
								},
								kind_icons = {
									Compound = "",
									Recovery = "",
									TranslationUnit = "",
									PackExpansion = "",
									TemplateTypeParm = "",
									TemplateTemplateParm = "",
									TemplateParamObject = "",
								},
							},
						},
					})
					return true
				end,
			},
		},
	},
}
