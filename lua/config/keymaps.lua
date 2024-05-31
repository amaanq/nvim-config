--  ╭─────────────────────────────────────────────────────────────────────────────╮
--  │            Keymaps are automatically loaded on the VeryLazy event           │
--  │                     Default keymaps that are always set:                    │
--  │ https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua │
--  ╰─────────────────────────────────────────────────────────────────────────────╯

local util = require("util")

-- util.cowboy()

-- Move to window using the movement keys
vim.keymap.set("n", "<left>", "<C-w>h")
vim.keymap.set("n", "<down>", "<C-w>j")
vim.keymap.set("n", "<up>", "<C-w>k")
vim.keymap.set("n", "<right>", "<C-w>l")

-- change word with <c-c>
vim.keymap.set("n", "<C-c>", "<cmd>normal! ciw<cr>a")

-- htop
if vim.fn.executable("htop") == 1 then
  vim.keymap.set("n", "<leader>xh", function()
    require("lazyvim.util").float_term({ "htop" })
  end, { desc = "htop" })
end

local function do_open(uri)
  local cmd, err = vim.ui.open(uri)
  local rv = cmd and cmd:wait(1000) or nil
  if cmd and rv and rv.code ~= 0 then
    err = ("vim.ui.open: command %s (%d): %s"):format(
      (rv.code == 124 and "timeout" or "failed"),
      rv.code,
      vim.inspect(cmd.cmd)
    )
  end
  return err
end

--  ╭───────────────────────────────────────────────────────────╮
--  │ Credit: June Gunn <Leader>?/! | Google it / Feeling lucky │
--  ╰───────────────────────────────────────────────────────────╯
---@param pat string
local function google(pat)
  local query = '"' .. vim.fn.substitute(pat, '["\n]', " ", "g") .. '"'
  query = vim.fn.substitute(query, "[[:punct:] ]", [[\=printf("%%%02X", char2nr(submatch(0)))]], "g")
  do_open("https://www.google.com/search?" .. "q=" .. query)
end

vim.keymap.set("n", "<leader>?", function()
  google(vim.fn.expand("<cWORD>"))
end, { desc = "Google" })

vim.keymap.set("x", "<leader>?", function()
  google(vim.fn.getreg("g"))
end, { desc = "Google" })

--  ╭────────────────────────────────────╮
--  │ GX - replicate netrw functionality │
--  ╰────────────────────────────────────╯
local function open_link()
  local url = vim.ui._get_url()
  if url:match("%w://") then
    return do_open(url)
  end

  -- consider anything that looks like string/string a github link
  local plugin_url_regex = "[%a%d%-%.%_]*%/[%a%d%-%.%_]*"
  local link = string.match(url, plugin_url_regex)
  if link then
    return do_open(string.format("https://www.github.com/%s", link))
  end

  vim.notify("No link found under cursor")
end

vim.keymap.set("n", "gx", open_link)
vim.keymap.set("n", "gf", "<cmd>e <cfile><cr>", { desc = "Open File" })

--  ╭──────────╮
--  │ Commands │
--  ╰──────────╯
util.command("ToggleBackground", function()
  vim.o.background = vim.o.background == "dark" and "light" or "dark"
end)

-- Swap clangd compile commands

local function swap_compilecommands()
  local json = require("json")
  -- take rootdir/compile_commands.json and swap the two entries
  local rootdir = vim.fn.getcwd()
  local file = rootdir .. "/compile_commands.json"
  local f = io.open(file, "r")
  if not f then
    vim.notify("No compile_commands.json found")
    return
  end
  local data = f:read("*all")
  f:close()
  local commands = json.decode(data)
  commands[1], commands[2] = commands[2], commands[1]

  f = io.open(file, "w")
  if not f then
    vim.notify("Could not open compile_commands.json for writing!")
    return
  end
  f:write(json.encode(commands))
  f:close()
  vim.notify("Swapped compile_commands.json!")
end

local function swap_compilecommands2()
  local shell_code = [=[
#!/usr/bin/env bash

compile_commands_file="$PWD/compile_commands.json"
echo "$compile_commands_file"
tmp_file=$(mktemp)

jq '[.[1], .[0]]' "$compile_commands_file" >"$tmp_file" && mv "$tmp_file" "$compile_commands_file"
]=]
  local tmp_file = vim.fn.tempname()
  local f = io.open(tmp_file, "w")
  if not f then
    vim.notify("Could not open tmp_file for writing!")
    return
  end
  f:write(shell_code)
  f:close()
  vim.fn.jobstart({ "sh", tmp_file }, { detach = true })
  vim.notify("Swapped compile_commands.json!")
end

-- vim.keymap.set("n", "<leader>clf", swap_compilecommands2, { desc = "Swap Compile Commands" })

local watch_type = require("vim._watch").FileChangeType

local function handler(res, callback)
  if not res.files or res.is_fresh_instance then
    return
  end

  for _, file in ipairs(res.files) do
    local path = res.root .. "/" .. file.name
    local change = watch_type.Changed
    if file.new then
      change = watch_type.Created
    end
    if not file.exists then
      change = watch_type.Deleted
    end
    callback(path, change)
  end
end

function watchman(path, opts, callback)
  vim.system({ "watchman", "watch", path }):wait()

  local buf = {}
  local sub = vim.system({
    "watchman",
    "-j",
    "--server-encoding=json",
    "-p",
  }, {
    stdin = vim.json.encode({
      "subscribe",
      path,
      "nvim:" .. path,
      {
        expression = { "anyof", { "type", "f" }, { "type", "d" } },
        fields = { "name", "exists", "new" },
      },
    }),
    stdout = function(_, data)
      if not data then
        return
      end
      for line in vim.gsplit(data, "\n", { plain = true, trimempty = true }) do
        table.insert(buf, line)
        if line == "}" then
          local res = vim.json.decode(table.concat(buf))
          handler(res, callback)
          buf = {}
        end
      end
    end,
    text = true,
  })

  return function()
    sub:kill("sigint")
  end
end

if vim.fn.executable("watchman") == 1 then
  require("vim.lsp._watchfiles")._watchfunc = watchman
else
  vim.notify("watchman not found, using default filewatcher")
end
