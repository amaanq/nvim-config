return {

  -- This is meant for tree-sitter development.
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      local util = require("util")

      local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

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
        cue = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-cue",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        dhall = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-dhall",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        firrtl = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-firrtl",
            files = { "src/parser.c", "src/scanner.cc" },
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
            files = { "src/parser.c" },
          },
        },
        passwd = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-passwd",
            files = { "src/parser.c" },
          },
        },
        po = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-po",
            files = { "src/parser.c" },
          },
        },
        qmldir = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-qmldir",
            files = { "src/parser.c" },
          },
        },
        smali = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-smali",
            files = { "src/parser.c" },
          },
        },
        smithy = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-smithy",
            files = { "src/parser.c" },
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
        ungrammar = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-ungrammar",
            files = { "src/parser.c" },
          },
        },
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
      }

      local dbg = false

      for lang, install_info in pairs(local_configs) do
        local expanded_url = string.gsub(install_info.install_info.url, "^~", os.getenv("HOME") or "~")
        if util.exists(expanded_url) then
          parser_configs[lang] = install_info
        elseif dbg then
          dd("Skipping " .. lang .. " because " .. install_info.install_info.url .. " does not exist locally")
        end
      end

      require("nvim-treesitter.install").ensure_installed(vim.tbl_keys(local_configs))
    end,
  },
}
