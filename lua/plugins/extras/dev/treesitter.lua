return {

  -- This is meant for tree-sitter development.
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      local util = require("util")

      local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

      ---@type table<string, ParserInfo>
      local local_configs = {
        bass = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-bass",
            files = { "src/parser.c" },
          },
        },
        bicep = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-bicep",
            files = { "src/parser.c" },
          },
        },
        capnp = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-capnp",
            files = { "src/parser.c" },
          },
        },
        firrtl = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-firrtl",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        func = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-func",
            files = { "src/parser.c" },
          },
        },
        git_config = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-git-config",
            files = { "src/parser.c" },
          },
          filetype = "gitconfig",
        },
        hare = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-hare",
            files = { "src/parser.c" },
          },
        },
        kdl = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-kdl",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        luap = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-luap",
            files = { "src/parser.c" },
          },
        },
        matlab = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-matlab",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        passwd = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-passwd",
            files = { "src/parser.c" },
          },
        },
        smali = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-smali",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        squirrel = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-squirrel",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        tablegen = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-tablegen",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        -- thrift = {
        --   install_info = {
        --     url = "~/projects/treesitter/tree-sitter-thrift",
        --     files = { "src/parser.c" },
        --   },
        -- },
        uxntal = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-uxntal",
            files = { "src/parser.c", "src/scanner.c" },
          },
          filetype = "tal",
        },
        yuck = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-yuck",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        pony = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-pony",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        luadoc = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-luadoc",
            files = { "src/parser.c" },
          },
        },
        puppet = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-puppet",
            files = { "src/parser.c" },
          },
        },
        luau = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-luau",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        snakemake = {
          install_info = {
            url = "https://github.com/osthomas/tree-sitter-snakemake",
            branch = "main",
            location = "tree-sitter-snakemake",
            files = { "src/parser.c", "src/scanner.cc" },
          },
          experimental = true,
        },
        odin = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-odin",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        objc = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-objc",
            files = { "src/parser.c" },
          },
        },
        d = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-d",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        cairo = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-cairo",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "lua",
        callback = function(_ev)
          local cwd = vim.fn.getcwd()
          if vim.fn.finddir("tree-sitter-luau", cwd) ~= "" then
            vim.bo.filetype = "luau"
          end
        end,
      })

      local dbg = false

      for lang, install_info in pairs(local_configs) do
        local expanded_url = string.gsub(install_info.install_info.url, "^~", os.getenv("HOME") or "~")
        if util.exists(expanded_url) or expanded_url:find("https?://") then
          parser_configs[lang] = install_info
        elseif dbg then
          dd("Skipping " .. lang .. " because " .. install_info.install_info.url .. " does not exist locally")
        end
      end

      require("nvim-treesitter.install").ensure_installed(vim.tbl_keys(local_configs))
    end,
  },
}
