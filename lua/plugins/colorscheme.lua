return {
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   lazy = false,
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "mocha", -- mocha, macchiato, frappe, latte
  --     })
  --   end,
  -- },
  -- { "ellisonleao/gruvbox.nvim", lazy = false },
  -- {
  --   "marko-cerovac/material.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   init = function()
  --     vim.g.material_style = "deep ocean"
  --   end,
  --   opts = {
  --     plugins = {
  --       "dap",
  --       "dashboard",
  --       "gitsigns",
  --       "hop",
  --       "indent-blankline",
  --       "lspsaga",
  --       "mini",
  --       "neogit",
  --       "neorg",
  --       "nvim-cmp",
  --       "nvim-navic",
  --       "nvim-tree",
  --       "nvim-web-devicons",
  --       "sneak",
  --       "telescope",
  --       "trouble",
  --       "which-key",
  --     },
  --   },
  -- },
  -- { "numToStr/Sakura.nvim", lazy = false },
  -- {
  --   "olimorris/onedarkpro.nvim",
  --   lazy = false,
  --   enabled = false,
  --   config = function()
  --     require("onedarkpro").setup({
  --       highlights = {
  --         Cursor = {
  --           fg = "${blue}",
  --           bg = "${blue}",
  --           style = "bold",
  --         },
  --         CursorLineNr = {
  --           fg = "${blue}",
  --           bg = "${cursorline}",
  --           style = "bold",
  --         },
  --         TermCursor = {
  --           fg = "${blue}",
  --           bg = "${white}",
  --           style = "bold",
  --         },
  --         TabLineSel = {
  --           fg = "${fg}",
  --           bg = "${bg}",
  --           style = "bold",
  --         },
  --
  --         -- NeoTree
  --         NeoTreeDirectoryIcon = { fg = "${yellow}" },
  --         NeoTreeFileIcon = { fg = "${blue}" },
  --         NeoTreeFileNameOpened = {
  --           fg = "${blue}",
  --           style = "italic",
  --         },
  --         NeoTreeFloatTitle = { fg = "${bg}", bg = "${blue}" },
  --         NeoTreeRootName = { fg = "${cyan}", style = "bold" },
  --         NeoTreeTabActive = { bg = "${bg}" },
  --         NeoTreeTabInactive = { bg = "${black}" },
  --         NeoTreeTitleBar = { fg = "${bg}", bg = "${blue}" },
  --
  --         -- Indent Blankline
  --         IndentBlanklineContextChar = { fg = "${gray}" },
  --
  --         -- Telescope
  --         TelescopeSelection = {
  --           bg = "${cursorline}",
  --           fg = "${blue}",
  --         },
  --         TelescopeSelectionCaret = { fg = "${blue}" },
  --         TelescopePromptPrefix = { fg = "${blue}" },
  --
  --         DiagnosticUnderlineError = { sp = "${red}", style = "undercurl" },
  --         DiagnosticUnderlineWarn = { sp = "${yellow}", style = "undercurl" },
  --         DiagnosticUnderlineInfo = { sp = "${blue}", style = "undercurl" },
  --         DiagnosticUnderlineHint = { sp = "${cyan}", style = "undercurl" },
  --       },
  --       options = {
  --         bold = true,
  --         -- italic = true,
  --         underline = true,
  --         cursorline = true,
  --         terminal_colors = true,
  --         undercurl = true,
  --       },
  --     })
  --   end,
  -- },
  -- { "projekt0n/github-nvim-theme", lazy = false },
  -- { "rebelot/kanagawa.nvim", lazy = false, config = true },
  -- { "Shatur/neovim-ayu", lazy = false },
  -- { "shaunsingh/oxocarbon.nvim", lazy = false },
  -- { "LunarVim/horizon.nvim", lazy = false },
  -- { "rose-pine/neovim", name = "rose-pine", lazy = false },
  {
    "tokyonight.nvim",
    opts = function(_, _opts)
      return {
        style = "moon",
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          sidebars = "transparent",
          floats = "transparent",
        },
        transparent = true,
        sidebars = {
          "qf",
          "vista_kind",
          "spectre_panel",
          "NeogitStatus",
          "startuptime",
          "Outline",
        },
        ---@param hl Highlights
        ---@param c ColorScheme
        on_highlights = function(hl, c)
          local prompt = "#2d3149"
          hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg }
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

          hl.LspInlayHint = { link = "Comment" }

          hl["@string.documentation"] = { fg = c.yellow }
          -- hl["@comment.documentation"] = { fg = "#636da6", italic = false, style = { italic = false } }

          -- Smali
          hl["@parameter.builtin"] = { fg = "#efc890" }

          -- C#
          hl["@lsp.type.fieldName.cs"] = { link = "@field" }

          hl["@character.printf"] = { link = "@type" }

          -- Rust
          hl["@lsp.type.selfTypeKeyword.rust"] = { link = "@variable.builtin" }
          hl["@lsp.type.constantName"] = { link = "@constant" }
          hl["@lsp.type.decorator.rust"] = { link = "@attribute" }
          hl["@lsp.type.deriveHelper.rust"] = { link = "@attribute" }
          hl["@lsp.type.extensionMethodName"] = { link = "@lsp.type.interface" }
          hl["@lsp.type.generic.rust"] = { link = "@variable" }
          hl["@lsp.type.formatSpecifier.rust"] = { link = "@punctuation.special" }
          hl["@lsp.type.variable.rust"] = { link = "@variable" }
          hl["@lsp.type.escapeSequence"] = { link = "@string.escape" }
          hl["@lsp.type.stringEscapeCharacter"] = { link = "@string.escape" }
          hl["@lsp.type.selfKeyword"] = { link = "@variable.builtin" }
          hl["@lsp.typemod.enumMember.defaultLibrary"] = { link = "@constant.builtin" }
          hl["@lsp.typemod.enum.defaultLibrary"] = { link = "@type.builtin" }
          hl["@lsp.typemod.event.static"] = { link = "@lsp.type.interface" }
          hl["@lsp.typemod.function.defaultLibrary.rust"] = { link = "@function.builtin" }
          hl["@lsp.typemod.keyword.async"] = { link = "@keyword.coroutine" }
          hl["@lsp.typemod.method.defaultLibrary.rust"] = { link = "@function.builtin" }
          hl["@lsp.typemod.method.trait"] = { link = "@lsp.type.interface" }
          hl["@lsp.typemod.parameter.callable"] = { link = "@function" }
          hl["@lsp.typemod.variable.constant.rust"] = { link = "@constant" }

          -- why are these so bad?
          hl["@lsp.type.keyword.cs"] = {}
          hl["@lsp.type.keyword.go"] = {}
          hl["@lsp.type.keyword.rust"] = {}
          hl["@lsp.type.generic.rust"] = {}
          hl["@lsp.type.keyword.zig"] = {}
          hl["@lsp.type.type.zig"] = {}
          hl["@lsp.typemod.keyword.injected"] = { link = "@keyword" }

          -- These doesn't really need strings highlighted by LSP
          hl["@lsp.type.string.go"] = {}
          hl["@lsp.type.string.rust"] = {}
          hl["@lsp.type.string.zig"] = {}

          hl["@lsp.type.operator"] = { link = "@operator" }
          hl["@lsp.type.const"] = { link = "@constant" }
        end,
      }
    end,
  },

  -- {
  --   "folke/ida-dark.nvim",
  --   dev = true,
  --   priority = 1000,
  --   lazy = false,
  -- },

  -- {
  --   "craftzdog/solarized-osaka.nvim",
  --   lazy = true,
  --   priority = 1000,
  --   opts = {
  --     transparent = true,
  --     styles = {
  --       keywords = { italic = false },
  --       sidebars = "transparent",
  --       floats = "transparent",
  --     },
  --   },
  -- },

  -- {
  --   "LazyVim/LazyVim",
  -- opts = {
  --   colorscheme = function()
  --     opts = {
  --       styles = {
  --         keywords = { italic = false },
  --       },
  --     }
  --     require("chic-noir").load(opts)
  --   end,
  -- },
  -- },
}
