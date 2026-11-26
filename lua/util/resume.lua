-- Reports nvim to the terminal over Program Resume (OSC 7577), so beer can
-- start it again with its persistence session after a server restart. nvim
-- also hosts the protocol for its own :terminal buffers, so a claude running
-- in a snacks terminal comes back in the same slot.
local M = {}

-- persistence only saves on VimLeavePre, which a hangup skips, so keep the
-- session fresh while editing.
local SAVE_DELAY_MS = 2000
-- The protocol's replay window for a report's timestamp.
local MAX_SKEW_S = 60

local token ---@type string?
local host_token ---@type string?
local instance ---@type string?
local restored ---@type string?
local reports = {} ---@type table<integer, {argv: string[], cwd?: string}>

local function random_hex()
  local file = assert(io.open("/dev/urandom", "rb"))
  local bytes = file:read(16)
  file:close()
  return (bytes:gsub(".", function(byte)
    return ("%02x"):format(byte:byte())
  end))
end

local function state_file(id)
  return vim.fs.joinpath(vim.fn.stdpath("state"), "program-resume", id .. ".json")
end

local function send(pairs)
  local body = ("pid=%d:time=%d:%s"):format(vim.fn.getpid(), os.time(), pairs)
  local mac = vim.fn.sha256(body .. ":" .. token)
  vim.api.nvim_ui_send(("\27]7577;%s:mac=%s\27\\"):format(body, mac))
end

local function report()
  local argv = { "nvim", ('+lua require("util.resume").restore("%s")'):format(instance) }
  send(
    ("argv=%s:cwd=%s"):format(
      table.concat(vim.tbl_map(vim.base64.encode, argv), ","),
      vim.base64.encode(vim.fn.getcwd())
    )
  )
end

local function write_terminals()
  local herdr = require("util.herdr")
  local saved = {}
  for buf, entry in pairs(reports) do
    if vim.api.nvim_buf_is_valid(buf) then
      saved[#saved + 1] = { argv = entry.argv, cwd = entry.cwd, slot = herdr.slot_for(buf) }
    end
  end
  local path = state_file(instance)
  if #saved == 0 then
    os.remove(path)
    return
  end
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  vim.fn.writefile({ vim.json.encode(saved) }, path)
end

local function on_request(buf, sequence)
  local body = sequence:match("^\27%]7577;(.*)$")
  if not body then
    return
  end
  local signed, mac = body:match("^(.*):mac=(%x+)$")
  if not signed or vim.fn.sha256(signed .. ":" .. host_token) ~= mac then
    return
  end
  local fields = {}
  for key, value in signed:gmatch("([^:=]+)=([^:]*)") do
    fields[key] = value
  end
  if math.abs(os.time() - (tonumber(fields.time) or 0)) > MAX_SKEW_S then
    return
  end
  if fields.clear == "1" then
    reports[buf] = nil
  elseif fields.argv then
    local ok, argv = pcall(vim.tbl_map, vim.base64.decode, vim.split(fields.argv, ",", { plain = true }))
    if not ok or #argv == 0 then
      return
    end
    local cwd = fields.cwd and vim.base64.decode(fields.cwd)
    reports[buf] = { argv = argv, cwd = cwd }
  else
    return
  end
  write_terminals()
end

local function resurrect_terminals(id)
  local path = state_file(id)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok or #lines == 0 then
    return
  end
  local decoded, saved = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not decoded or type(saved) ~= "table" then
    return
  end
  os.remove(path)
  for _, entry in ipairs(saved) do
    local session = { agent = vim.fs.basename(entry.argv[1]), argv = entry.argv, cwd = entry.cwd, slot = entry.slot }
    local resumed, err = pcall(require("util.herdr").resurrect, session)
    if not resumed then
      vim.notify(
        ("resume: %s failed (%s), run %s"):format(session.agent, err, table.concat(entry.argv, " ")),
        vim.log.levels.ERROR
      )
    end
  end
end

--- Entry point of the command beer runs to bring this nvim back.
---@param id string
function M.restore(id)
  restored = id
  require("persistence").load()
end

function M.setup()
  token = vim.env.OSC7577_TOKEN
  if not token or token == "" then
    return
  end
  -- Children report to nvim under its own token, never as this nvim to beer.
  host_token = random_hex()
  vim.env.OSC7577_TOKEN = host_token
  instance = restored or random_hex()

  local group = vim.api.nvim_create_augroup("program_resume", { clear = true })
  local timer = assert(vim.uv.new_timer())
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "DirChanged" }, {
    group = group,
    callback = function()
      timer:stop()
      timer:start(
        SAVE_DELAY_MS,
        0,
        vim.schedule_wrap(function()
          require("persistence").save()
        end)
      )
    end,
  })
  vim.api.nvim_create_autocmd("DirChanged", { group = group, callback = report })
  vim.api.nvim_create_autocmd("TermRequest", {
    group = group,
    callback = function(args)
      on_request(args.buf, args.data.sequence)
    end,
  })
  -- A shell the user exits cleanly takes its program's record with it. A
  -- hangup from beer exits nonzero, so those records survive the restart.
  vim.api.nvim_create_autocmd("TermClose", {
    group = group,
    callback = function(args)
      if reports[args.buf] and vim.v.event.status == 0 then
        reports[args.buf] = nil
        write_terminals()
      end
    end,
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      os.remove(state_file(instance))
      send("clear=1")
    end,
  })
  report()
  if restored then
    vim.defer_fn(function()
      resurrect_terminals(restored)
    end, 150)
  end
end

return M
