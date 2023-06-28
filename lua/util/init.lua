-- selene: allow(global_usage)

-- selene: allow(global_usage)
_G.profile = function(cmd, times, flush)
  times = times or 100
  local start = vim.loop.hrtime()
  for _ = 1, times, 1 do
    if flush then
      jit.flush(cmd, true)
    end
    cmd()
  end
  print(((vim.loop.hrtime() - start) / 1e6 / times) .. "ms")
end

local M = {}

---@param cmd string command to execute
---@param warn? string|boolean if vim.fn.executable <= 0 then warn with warn
function M.executable(cmd, warn)
  if vim.fn.executable(cmd) > 0 then
    return true
  end
  if warn then
    local message = type(warn) == "string" and warn or ("Command `%s` was not executable"):format(cmd)
    vim.notify(message, vim.log.levels.WARN, { title = "Executable not found" })
  end
  return false
end

---@class CommandArgs
---@field args string
---@field fargs table
---@field bang boolean

---Create an nvim command
---@param name any
---@param rhs string|fun(args: CommandArgs)
---@param opts table?
function M.command(name, rhs, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, rhs, opts)
end

---@param fname string
---@return string|boolean
function M.exists(fname)
  local stat = vim.loop.fs_stat(fname)
  return (stat and stat.type) or false
end

---@param fname string
---@return string
function M.fqn(fname)
  fname = vim.fn.fnamemodify(fname, ":p")
  return vim.loop.fs_realpath(fname) or fname
end

function M.clipman()
  local file = M.fqn("~/.local/share/clipman.json")
  if M.exists(file) then
    local f = io.open(file)
    if not f then
      return
    end
    local data = f:read("*a")
    f:close()

    -- allow empty files
    data = vim.trim(data)
    if data ~= "" then
      local ok, json = pcall(vim.fn.json_decode, data)
      if ok and json then
        local items = {} ---@type table[]
        for i = #json, 1, -1 do
          items[#items + 1] = json[i]
        end
        vim.ui.select(items, {
          prompt = "Clipman",
        }, function(choice)
          if choice then
            vim.api.nvim_paste(choice, true, 1)
          end
        end)
      else
        vim.notify(("failed to load clipman from %s"):format(file), vim.log.levels.ERROR)
      end
    end
  end
end

---@param is_file? boolean
function M.test(is_file)
  local file = is_file and vim.fn.expand("%:p") or "./tests"
  local init = vim.fn.glob("tests/*init*")
  require("plenary.test_harness").test_directory(file, { minimal_init = init, sequential = true })
end

function M.version()
  local v = vim.version() ---@type table
  if v and not v.prerelease then
    vim.notify(
      ("Neovim v%d.%d.%d"):format(v.major, v.minor, v.patch),
      vim.log.levels.WARN,
      { title = "Neovim: not running nightly!" }
    )
  end
end

function M.runlua()
  local ns = vim.api.nvim_create_namespace("runlua")
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    vim.diagnostic.reset(ns, buf)
  end

  local global = _G
  ---@type {lnum:number, col:number, message:string}[]
  local diagnostics = {}

  local function get_source()
    local info = debug.getinfo(3, "Sl")
    ---@diagnostic disable-next-line: param-type-mismatch
    local buf = vim.fn.bufload(info.source:sub(2))
    local row = info.currentline - 1
    return buf, row
  end

  local G = setmetatable({
    error = function(msg, level)
      local buf, row = get_source()
      diagnostics[#diagnostics + 1] = { lnum = row, col = 0, message = msg or "error" }
      vim.diagnostic.set(ns, buf, diagnostics)
      global.error(msg, level)
    end,
    print = function(...)
      local buf, row = get_source()
      local str = table.concat(
        vim.tbl_map(function(o) ---@param o any
          if type(o) == "table" then
            return vim.inspect(o)
          end
          return tostring(o)
        end, { ... }),
        " "
      )
      local indent = #vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]:match("^%s+")
      local lines = vim.split(str, "\n")
      ---@param line string
      local virt_lines = vim.tbl_map(function(line)
        return { { string.rep(" ", indent * 2) .. " ", "DiagnosticInfo" }, { line, "MsgArea" } }
      end, lines)
      vim.api.nvim_buf_set_extmark(buf, ns, row, 0, { virt_lines = virt_lines })
    end,
  }, { __index = _G })
  require("lazy.core.util").try(loadfile(vim.api.nvim_buf_get_name(0), "bt", G))
end

function M.cowboy()
  ---@type table?
  local id
  local ok = true
  for _, key in ipairs({ "h", "j", "k", "l", "+", "-" }) do
    local count = 0
    local timer = assert(vim.loop.new_timer())
    local map = key
    vim.keymap.set("n", key, function()
      if vim.v.count > 0 then
        count = 0
      end
      if count >= 10 then
        ok, id = pcall(vim.notify, "Hold it Cowboy!", vim.log.levels.WARN, {
          icon = "🤠",
          replace = id,
          keep = function()
            return count >= 10
          end,
        })
        if not ok then
          id = nil
          return map
        end
      else
        count = count + 1
        timer:start(2000, 0, function()
          count = 0
        end)
        return map
      end
    end, { expr = true, silent = true })
  end
end

-- Insert values into a list if they don't already exist
---@param tbl string[]
---@param vals string|string[]
function M.list_insert_unique(tbl, vals)
  if type(vals) ~= "table" then
    vals = { vals }
  end
  for _, val in ipairs(vals) do
    if not vim.tbl_contains(tbl, val) then
      table.insert(tbl, val)
    end
  end
end

return M
