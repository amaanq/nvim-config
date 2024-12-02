return {
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
}
