local util = require("util")

return {

  -- Add C# to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        util.list_insert_unique(opts.ensure_installed, "c_sharp")
      end
    end,
  },

  -- Correctly setup lspconfig for C# 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        omnisharp = {},
      },
      -- configure omnisharp to fix the semantic tokens bug (really annoying)
      setup = {
        omnisharp = function(_, _)
          ---@param input string
          ---@return string
          local function toCamelCase(input)
            local words = {} ---@type string[]
            local sanitized_input = input:gsub("[^%w%s]", " ")
            for word in sanitized_input:gmatch("%S+") do
              table.insert(words, word:lower())
            end

            for i = 2, #words do
              words[i] = words[i]:gsub("^%l", string.upper)
            end

            return table.concat(words)
          end

          require("lazyvim.util").on_attach(function(client, _) ---@param client lspconfig.options.omnisharp
            if client.name == "omnisharp" then
              local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers ---@type string[]
              for i, v in ipairs(tokenModifiers) do
                if v:match(" name$") then
                  tokenModifiers[i] = v:gsub(" name$", "")
                end
                tokenModifiers[i] = toCamelCase(tokenModifiers[i])
              end

              local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes ---@type string[]
              for i, v in ipairs(tokenTypes) do
                if v:match(" name$") then
                  tokenTypes[i] = v:gsub(" name$", "")
                end
                tokenTypes[i] = toCamelCase(tokenTypes[i])
              end
            end
          end)
          return false
        end,
      },
    },
  },
}
