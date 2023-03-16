return {

	-- projects
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				detection_methods = { "pattern", "lsp" },
				ignore_lsp = { "null-ls" },
				patterns = { ".git" },
			})
		end,
	},

	-- {
	-- 	"nvim-orgmode/orgmode",
	-- 	dependencies = "nvim-treesitter/nvim-treesitter",
	-- 	event = "VeryLazy",
	-- 	opts = {},
	-- 	config = function()
	-- 		require("orgmode").setup_ts_grammar()
	-- 	end,
	-- },

	-- neorg
	{
		"nvim-neorg/neorg",
		ft = "norg",
		opts = {
			load = {
				["core.defaults"] = {},
				["core.norg.concealer"] = {},
				["core.norg.completion"] = {
					config = { engine = "nvim-cmp" },
				},
				["core.integrations.nvim-cmp"] = {},
			},
		},
	},

	-- markdown preview
	{
		"toppair/peek.nvim",
		build = "deno task --quiet build:fast",
		keys = {
			{
				"<leader>op",
				function()
					local peek = require("peek")
					if peek.is_open() then
						peek.close()
					else
						peek.open()
					end
				end,
				desc = "Peek (Markdown Preview)",
			},
		},
		opts = { theme = "dark" }, -- 'dark' or 'light'
		init = function()
			require("which-key").register({
				["<leader>o"] = { name = "+open" },
			})
		end,
	},

	-- better diffing
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		config = true,
		keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
	},

	-- colorizer
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			filetypes = { "*", "!lazy" },
			buftype = { "*", "!prompt", "!nofile" },
			user_default_options = {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = false, -- "Name" codes like Blue
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				AARRGGBB = false, -- 0xAARRGGBB hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				-- Available modes: foreground, background
				-- Available modes for `mode`: foreground, background,  virtualtext
				mode = "background", -- Set the display mode.
				virtualtext = "■",
			},
		},
	},

	{
		"nacro90/numb.nvim",
		event = "CmdlineEnter",
		config = function()
			require("numb").setup()
		end,
	},

	{
		"psliwka/vim-dirtytalk",
		build = ":DirtytalkUpdate",
		config = function()
			vim.opt.spelllang:append("programming")
		end,
	},

	"wellle/targets.vim",

	{ "rafcamlet/nvim-luapad", cmd = "Luapad" },

	{
		"bennypowers/nvim-regexplainer",
		event = "BufRead",
		config = true,
		dependencies = { "nvim-treesitter/nvim-treesitter", "MunifTanjim/nui.nvim" },
	},

	-- {
	-- "~poof/godbolt.nvim",
	-- 	url = "https://sr.ht/~p00f/godbolt.nvim/",
	-- 		config = true,
	-- 	},
}
