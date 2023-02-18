return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- mocha, macchiato, frappe, latte
			})
		end,
	},
	{ "ellisonleao/gruvbox.nvim", lazy = false },
	{
		"marko-cerovac/material.nvim",
		lazy = false,
		init = function()
			vim.g.material_style = "deep ocean"
		end,
		config = true,
	},
	{ "numToStr/Sakura.nvim", lazy = false },
	{
		"olimorris/onedarkpro.nvim",
		lazy = false,
		config = function()
			require("onedarkpro").setup({
				highlights = {
					Cursor = {
						fg = "${blue}",
						bg = "${blue}",
						style = "bold",
					},
					CursorLineNr = {
						fg = "${blue}",
						bg = "${cursorline}",
						style = "bold",
					},
					TermCursor = {
						fg = "${blue}",
						bg = "${white}",
						style = "bold",
					},
					TabLineSel = {
						fg = "${fg}",
						bg = "${bg}",
						style = "bold",
					},

					-- NeoTree
					NeoTreeDirectoryIcon = { fg = "${yellow}" },
					NeoTreeFileIcon = { fg = "${blue}" },
					NeoTreeFileNameOpened = {
						fg = "${blue}",
						style = "italic",
					},
					NeoTreeFloatTitle = { fg = "${bg}", bg = "${blue}" },
					NeoTreeRootName = { fg = "${cyan}", style = "bold" },
					NeoTreeTabActive = { bg = "${bg}" },
					NeoTreeTabInactive = { bg = "${black}" },
					NeoTreeTitleBar = { fg = "${bg}", bg = "${blue}" },

					-- Indent Blankline
					IndentBlanklineContextChar = { fg = "${gray}" },

					-- Telescope
					TelescopeSelection = {
						bg = "${cursorline}",
						fg = "${blue}",
					},
					TelescopeSelectionCaret = { fg = "${blue}" },
					TelescopePromptPrefix = { fg = "${blue}" },

					DiagnosticUnderlineError = { sp = "${red}", style = "undercurl" },
					DiagnosticUnderlineWarn = { sp = "${yellow}", style = "undercurl" },
					DiagnosticUnderlineInfo = { sp = "${blue}", style = "undercurl" },
					DiagnosticUnderlineHint = { sp = "${cyan}", style = "undercurl" },
				},
				options = {
					bold = true,
					-- italic = true,
					underline = true,
					cursorline = true,
					terminal_colors = true,
					undercurl = true,
				},
			})
		end,
	},
	{ "projekt0n/github-nvim-theme", lazy = false },
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		config = function()
			local kanagawa = require("kanagawa")
			kanagawa.setup()
		end,
	},
	{ "Shatur/neovim-ayu", lazy = false },
	{ "shaunsingh/oxocarbon.nvim", lazy = false },
	{ "LunarVim/horizon.nvim", lazy = false },
	{ "rose-pine/neovim", name = "rose-pine", lazy = false, opts = { dark_variant = "moon" } },
	{
		"tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = function()
			return {
				style = "moon",
				-- transparent = true,
				-- styles = {
				--   sidebars = "transparent",
				--   floats = "transparent",
				-- },
				sidebars = {
					"qf",
					"vista_kind",
					"terminal",
					"spectre_panel",
					"NeogitStatus",
					"startuptime",
					"Outline",
				},
				on_highlights = function(hl, c)
					hl.CursorLineNr = { fg = c.orange, bold = true }
					hl.LineNr = { fg = c.orange, bold = true }
					hl.LineNrAbove = { fg = c.fg_gutter }
					hl.LineNrBelow = { fg = c.fg_gutter }
					local prompt = "#2d3149"
					hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
					hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
					hl.TelescopePromptNormal = { bg = prompt }
					hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
					hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
					hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
					hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }

					hl.TSRainbowRed = { fg = c.red }
					hl.TSRainbowYellow = { fg = c.yellow }
					hl.TSRainbowBlue = { fg = c.blue }
					hl.TSRainbowOrange = { fg = c.orange }
					hl.TSRainbowGreen = { fg = c.green2 }
					hl.TSRainbowViolet = { fg = c.purple }
					hl.TSRainbowCyan = { fg = c.cyan }
				end,
			}
		end,
	},
}
