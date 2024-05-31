return {

  -- This is meant for tree-sitter development.
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      local util = require("util")

      local parsers = require("nvim-treesitter.parsers")
      local ok, configs = pcall(parsers.get_parser_configs)
      if not ok then
        configs = parsers.configs
      end

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
            files = { "src/parser.c", "src/scanner.c" },
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
        -- snakemake = {
        --   install_info = {
        --     url = "https://github.com/osthomas/tree-sitter-snakemake",
        --     branch = "main",
        --     location = "tree-sitter-snakemake",
        --     files = { "src/parser.c", "src/scanner.c" },
        --   },
        --   experimental = true,
        -- },
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
        make = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-make",
            files = { "src/parser.c" },
          },
        },
        bitbake = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-bitbake",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        re2c = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-re2c",
            files = { "src/parser.c" },
          },
        },
        forth = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-forth",
            files = { "src/parser.c" },
          },
        },
        doxygen = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-doxygen",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        -- bash = {
        --   install_info = {
        --     url = "~/projects/treesitter/tree-sitter-bash",
        --     files = { "src/parser.c", "src/scanner.c" },
        --   },
        -- },
        kconfig = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-kconfig",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        nasm = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-nasm",
            files = { "src/parser.c" },
          },
        },
        gn = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-gn",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        testvector = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-testvector",
            files = { "src/parser.c" },
          },
        },
        just = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-just",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        linkerscript = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-linkerscript",
            files = { "src/parser.c" },
          },
          filetype = "ld",
        },
        objdump = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-objdump",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        svelte = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-svelte",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        php = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-php",
            location = "php",
            files = { "src/parser.c", "src/scanner.c" },
          },
        },
        php_only = {
          install_info = {
            url = "~/projects/treesitter/tree-sitter-php",
            location = "php_only",
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
          configs[lang] = install_info
        elseif dbg then
          dd("Skipping " .. lang .. " because " .. install_info.install_info.url .. " does not exist locally")
        end
      end

      require("nvim-treesitter.install").ensure_installed(vim.tbl_keys(local_configs))
    end,
  },

  {
    "tree-sitter-grammars/tree-sitter-test",
    build = "make parser/test.so",
    ft = "test",
    init = function()
      -- toggle dynamic language injection
      vim.g.tstest_dynamic_injection = true
      -- toggle full-width rules for test separators
      vim.g.tstest_fullwidth_rules = false
      -- set the highlight group of the rules
      vim.g.tstest_rule_hlgroup = "FoldColumn"
    end,
  },
}
