return {

	-- extend auto completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"kdheepak/cmp-latex-symbols",
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
				{ name = "latex_symbols", priority = 700 },
			}))
		end,
	},

	-- add Latex to treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "latex" })
			end
		end,
	},

	-- correctly setup mason lsp / dap extensions
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "texlab" })
			end
		end,
	},

	-- correctly setup lspconfig for Latex
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- make sure mason installs the server
			servers = {
				texlab = {},
			},
		},
	},

	-- TODO: someone who knows latex and reads this comment/file an issue to
	-- set this up without interfering with with treesitter
	-- {
	-- 	"lervag/vimtex",
	-- 	event = "BufRead",
	-- 	config = function()
	-- 		local vimtex = require("vimtex")
	-- 		vimtex.setup({
	-- 			compiler = {
	-- 				latexmk = {
	-- 					options = {
	-- 						"--shell-escape",
	-- 						"--synctex=1",
	-- 						"-interaction=nonstopmode",
	-- 						"-file-line-error",
	-- 						"-pdf",
	-- 					},
	-- 				},
	-- 			},
	-- 			latex = {
	-- 				build = {
	-- 					args = {
	-- 						"-pdf",
	-- 						"-interaction=nonstopmode",
	-- 						"-synctex=1",
	-- 						"-file-line-error",
	-- 						"-shell-escape",
	-- 					},
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
}
