return {

	-- Better `vim.notify()`
	{
		"rcarriga/nvim-notify",
		opts = function(_, opts)
			opts.level = vim.log.levels.INFO
			opts.fps = 144
			opts.stages = "fade_in_slide_out"
		end,
	},

	-- bufferline
	{
		"akinsho/bufferline.nvim",
		opts = function(_, opts)
			opts.options.show_close_icon = true
			opts.options.separator_style = "slant"
			opts.options.offsets = {
				{
					filetype = "neo-tree",
					text = "Neo-tree",
					highlight = "Directory",
					text_align = "left",
				},
				{
					filetype = "Outline",
					text = "Symbols Outline",
					highlight = "TSType",
					text_align = "left",
				},
			}
			opts.options.hover = {
				enabled = true,
				delay = 200,
				reveal = { "close" },
			}
		end,
	},

	-- dashboard
	{
		"goolord/alpha-nvim",
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			local logo = [[
      ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
      ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
      ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
      ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
      ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
      ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]

			dashboard.section.header.val = vim.split(logo, "\n")
			dashboard.section.buttons.val = {
				dashboard.button("p", " " .. " Open project", "<cmd>Telescope project display_type=full<cr>"),
				dashboard.button("e", " " .. " New file", "<cmd>ene <BAR> startinsert<cr>"),
				dashboard.button("f", " " .. " Find file", "<cmd>cd $HOME/Projects | Telescope find_files<cr>"),
				dashboard.button("r", " " .. " Recent files", "<cmd>Telescope oldfiles <cr>"),
				dashboard.button("s", "勒" .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
				dashboard.button("c", " " .. " Config", ":e $MYVIMRC | :cd %:p:h | Telescope file_browser<cr>"),
				dashboard.button("g", " " .. " Find text", ":Telescope live_grep <cr>"),
				dashboard.button("l", "鈴" .. " Lazy", "<cmd>Lazy<cr>"),
				dashboard.button("m", " " .. " Mason", "<cmd>Mason<cr>"),
				dashboard.button("q", " " .. " Quit", "<cmd>qa<cr>"),
			}
			for _, button in ipairs(dashboard.section.buttons.val) do
				button.opts.hl = "AlphaButtons"
				button.opts.hl_shortcut = "AlphaShortcut"
			end
			dashboard.section.footer.opts.hl = "Type"
			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.opts.hl = "AlphaButtons"
			dashboard.opts.layout[1].val = 8
			return dashboard
		end,
	},

	-- floating winbar
	{
		"b0o/incline.nvim",
		event = "BufReadPre",
		config = function()
			local colors = require("tokyonight.colors").setup()
			require("incline").setup({
				highlight = {
					groups = {
						InclineNormal = { guibg = "#3e68d7", guifg = colors.black },
						InclineNormalNC = { guifg = "#3e68d7", guibg = colors.black },
					},
				},
				window = { margin = { vertical = 0, horizontal = 1 } },
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					local icon, color = require("nvim-web-devicons").get_icon_color(filename)
					return { { icon, guifg = color }, { " " }, { filename } }
				end,
			})
		end,
	},

	-- auto-resize windows
	{
		"anuvyklack/windows.nvim",
		event = "WinNew",
		dependencies = {
			{ "anuvyklack/middleclass" },
			{ "anuvyklack/animation.nvim", enabled = false },
		},
		keys = { { "<leader>Z", "<cmd>WindowsMaximize<cr>", desc = "Zoom" } },
		config = function()
			vim.o.winminwidth = 5
			vim.o.winminwidth = 5
			vim.o.equalalways = false
			require("windows").setup({
				animation = { enable = false, duration = 150 },
			})
		end,
	},

	-- scrollbar
	{
		"petertriho/nvim-scrollbar",
		event = "BufReadPost",
		config = function()
			local scrollbar = require("scrollbar")
			local colors = require("tokyonight.colors").setup()
			scrollbar.setup({
				handle = { color = colors.bg_highlight },
				excluded_filetypes = { "prompt", "TelescopePrompt", "noice", "notify" },
				marks = {
					Search = { color = colors.orange },
					Error = { color = colors.error },
					Warn = { color = colors.warning },
					Info = { color = colors.info },
					Hint = { color = colors.hint },
					Misc = { color = colors.purple },
				},
			})
		end,
	},

	-- style windows with different colorschemes
	{
		"folke/styler.nvim",
		event = "VeryLazy",
		opts = {
			themes = {
				markdown = { colorscheme = "tokyonight-storm" },
				help = { colorscheme = "oxocarbon", background = "dark" },
			},
		},
	},

	-- silly drops
	{
		"folke/drop.nvim",
		event = "VeryLazy",
		config = function()
			math.randomseed(os.time())
			local theme = ({ "stars", "snow" })[math.random(1, 3)]
			require("drop").setup({ theme = theme, max = 60, interval = 50 })
		end,
	},

	-- lualine
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			local icons = require("lazyvim.config").icons

			opts.options.disabled_filetypes.winbar = { "alpha", "dashboard", "neo-tree", "neo-tree-popup" }
			opts.sections.lualine_c = {
				{
					"diagnostics",
					symbols = {
						error = icons.diagnostics.Error,
						warn = icons.diagnostics.Warn,
						info = icons.diagnostics.Info,
						hint = icons.diagnostics.Hint,
					},
				},
				{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
				{ "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
				{
					-- limit to 180 chars
					function()
						local blame_text = require("gitblame").get_current_blame_text()
						if blame_text:len() > 180 then
							blame_text = blame_text:sub(1, 180) .. "..."
						end
						return blame_text
					end,
					cond = require("gitblame").is_blame_text_available,
				},
			}
			table.insert(opts.sections.lualine_x, {
				function()
					return require("util.dashboard").status()
				end,
			})
			opts.sections.lualine_z = {
				function()
					return " " .. os.date("%I:%M %p")
				end,
			}
		end,
	},

	{
		"norcalli/nvim-terminal.lua",
		ft = "terminal",
		config = true,
	},

	{
		"akinsho/nvim-toggleterm.lua",
		keys = "<C-`>",
		event = "VeryLazy",
		init = function()
			-- Hide number column for
			-- vim.cmd [[au TermOpen * setlocal nonumber norelativenumber]]

			-- Esc twice to get to normal mode
			vim.cmd([[tnoremap <ESC> <C-\><C-N>]])
		end,
		opts = {
			size = 20,
			open_mapping = [[<C-`>]],
			shading_factor = 0.3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
			direction = "float",
		},
	},

	-- git blame
	{
		"f-person/git-blame.nvim",
		event = "BufReadPre",
		init = function()
			vim.g.gitblame_display_virtual_text = 0
		end,
	},

	-- git conflict
	{
		"akinsho/git-conflict.nvim",
		event = "VeryLazy",
		config = true,
	},
	{ "rhysd/git-messenger.vim", event = "BufRead" },
	{ "rhysd/committia.vim", event = "BufRead" },
	{
		"ruifm/gitlinker.nvim",
		event = "BufRead",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitlinker").setup()
		end,
	},
	{ "pwntester/octo.nvim", cmd = "Octo", config = true },

	{
		"lukas-reineke/virt-column.nvim",
		event = "VeryLazy",
		config = function()
			require("virt-column").setup({ char = "▕" })
		end,
	},

	{ "itchyny/vim-highlighturl", event = "VeryLazy" },

	{
		"lukas-reineke/headlines.nvim",
		ft = { "org", "norg", "markdown", "yaml" },
		config = function()
			require("headlines").setup({
				markdown = {
					headline_highlights = { "Headline1", "Headline2", "Headline3" },
				},
				org = {
					headline_highlights = false,
				},
				norg = { codeblock_highlight = false },
			})
		end,
	},

	{
		"utilyre/barbecue.nvim",
		event = "VeryLazy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		config = true,
	},

	{
		"zbirenbaum/neodim",
		event = "LspAttach",
		opts = {
			hide = {
				virtual_text = false,
				signs = false,
				underline = false,
			},
		},
	},

	{
		"LudoPinelli/comment-box.nvim",
		event = "BufReadPre",
	},
}
