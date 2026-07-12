-- Reports embedded-terminal tails to herdr, and focuses the matching
-- terminal when a nested agent row is clicked in herdr's panel.
local M = {}

local uv = vim.uv or vim.loop

local INTERVAL_MS = 1000
local TAIL_LINES = 40
local RESUBSCRIBE_MS = 2000

local terminals = {} ---@type table<number, {pid: number, last_text?: string, last_title?: string}>
local timer ---@type uv.uv_timer_t?
local seq = 0
-- uv callbacks run in a fast context where vim.fn/vim.env are off limits
local pane_id ---@type string?
local socket_path ---@type string?
local request_prefix ---@type string?
local subscribing = false
local leaving = false
local pending_tick ---@type uv.uv_timer_t?

local function debug_log(msg)
  if vim.g.herdr_debug then
    vim.schedule(function()
      vim.notify("herdr: " .. msg, vim.log.levels.INFO)
    end)
  end
end

local function enabled()
  return vim.env.HERDR_ENV == "1" and vim.env.HERDR_PANE_ID ~= nil and vim.env.HERDR_SOCKET_PATH ~= nil
end

-- herdr's API socket serves one request per connection
local function send(line)
  local pipe = uv.new_pipe(false)
  if not pipe then
    return
  end
  pipe:connect(socket_path, function(err)
    if err then
      pipe:close()
      return
    end
    pipe:write(line .. "\n", function()
      pipe:read_start(function()
        if not pipe:is_closing() then
          pipe:close()
        end
      end)
    end)
  end)
end

local function report(params)
  seq = seq + 1
  local ok, line = pcall(vim.json.encode, {
    id = ("%s:%d"):format(request_prefix, seq),
    method = "pane.report_nested_terminal",
    params = params,
  })
  if ok then
    send(line)
  end
end

local function report_closed(pid)
  report({ pane_id = pane_id, pid = pid, closed = true })
end

local function buf_visible(buf)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return true
    end
  end
  return false
end

local function tick()
  for buf, entry in pairs(terminals) do
    if not vim.api.nvim_buf_is_valid(buf) then
      terminals[buf] = nil
      report_closed(entry.pid)
    else
      local lines = vim.api.nvim_buf_get_lines(buf, -(TAIL_LINES + 1), -1, false)
      local text = table.concat(lines, "\n")
      local title = vim.b[buf].term_title or ""
      local params = { pane_id = pane_id, pid = entry.pid, visible = buf_visible(buf) }
      if text == entry.last_text and title == entry.last_title then
        -- heartbeat
        params.changed = false
      else
        entry.last_text = text
        entry.last_title = title
        params.text = text
        params.title = title
      end
      report(params)
    end
  end
  if next(terminals) == nil and timer then
    timer:stop()
  end
end

local function track(buf)
  local pid = vim.b[buf].terminal_job_pid
  if type(pid) ~= "number" or pid <= 0 then
    return
  end
  terminals[buf] = { pid = pid }
  if not timer then
    timer = uv.new_timer()
  end
  if timer and not timer:is_active() then
    timer:start(INTERVAL_MS, INTERVAL_MS, vim.schedule_wrap(tick))
  end
end

local function snacks_term_for(buf)
  local ok, terms = pcall(function()
    return Snacks.terminal.list()
  end)
  if not ok or type(terms) ~= "table" then
    return nil
  end
  for _, term in ipairs(terms) do
    if term.buf == buf then
      return term
    end
  end
end

local function focus_buf(buf)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == buf then
      vim.api.nvim_set_current_win(win)
      debug_log("focused existing window for buf " .. buf)
      return
    end
  end
  -- snacks terminals must switch through snacks: its fixbuf autocmd swaps
  -- foreign buffers back out of its windows, so a raw win_set_buf reverts.
  -- assumes float terminals: hiding a non-float that is the last window of
  -- a tab would :tabclose before the target shows
  local target = snacks_term_for(buf)
  if target then
    local ok = pcall(function()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local shown = vim.api.nvim_win_get_buf(win)
        if shown ~= buf and terminals[shown] and vim.b[shown].snacks_terminal then
          local other = snacks_term_for(shown)
          if other then
            other:hide()
          end
        end
      end
      target:show()
      target:focus()
    end)
    if ok then
      debug_log("switched snacks terminal to buf " .. buf)
      return
    end
    debug_log("snacks switch failed for buf " .. buf)
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local shown = vim.api.nvim_win_get_buf(win)
    if shown ~= buf and terminals[shown] and not vim.b[shown].snacks_terminal then
      local ok = pcall(function()
        if vim.wo[win].winfixbuf then
          vim.wo[win].winfixbuf = false
        end
        vim.api.nvim_win_set_buf(win, buf)
      end)
      if ok then
        vim.api.nvim_set_current_win(win)
        debug_log("swapped buf " .. buf .. " into terminal window")
        return
      end
    end
  end
  vim.cmd("botright sbuffer " .. buf)
  vim.api.nvim_win_set_height(0, math.max(12, math.floor(vim.o.lines * 0.3)))
  debug_log("opened split for buf " .. buf)
end

local request_tick

-- session id == the job's pid: nvim spawns terminal jobs as session leaders
local function focus_session(session)
  for buf, entry in pairs(terminals) do
    if entry.pid == session and vim.api.nvim_buf_is_valid(buf) then
      focus_buf(buf)
      request_tick()
      return
    end
  end
  debug_log("no tracked terminal for session " .. session)
end

local function handle_event_line(line)
  local ok, msg = pcall(vim.json.decode, line)
  if not ok or type(msg) ~= "table" or type(msg.data) ~= "table" then
    return
  end
  -- generic event subscriptions serialize EventKind as snake_case, unlike
  -- the dotted names used in subscription requests
  if msg.event ~= "pane_nested_terminal_focused" then
    return
  end
  local data = msg.data
  if data.pane_id == pane_id and type(data.session) == "number" then
    debug_log("focus event for session " .. data.session)
    vim.schedule(function()
      focus_session(data.session)
    end)
  end
end

local subscribe

local function schedule_resubscribe()
  if leaving or subscribing then
    return
  end
  local retry = uv.new_timer()
  if not retry then
    return
  end
  retry:start(RESUBSCRIBE_MS, 0, function()
    retry:close()
    subscribe()
  end)
end

subscribe = function()
  if leaving or subscribing then
    return
  end
  local pipe = uv.new_pipe(false)
  if not pipe then
    return
  end
  subscribing = true
  pipe:connect(socket_path, function(err)
    if err then
      subscribing = false
      pipe:close()
      schedule_resubscribe()
      return
    end
    debug_log("event subscription connected")
    local ok, request = pcall(vim.json.encode, {
      id = request_prefix .. ":events",
      method = "events.subscribe",
      params = { subscriptions = { { type = "pane.nested_terminal_focused" } } },
    })
    if not ok then
      subscribing = false
      pipe:close()
      return
    end
    pipe:write(request .. "\n")
    local buffer = ""
    pipe:read_start(function(rerr, data)
      if rerr or not data then
        subscribing = false
        if not pipe:is_closing() then
          pipe:close()
        end
        schedule_resubscribe()
        return
      end
      buffer = buffer .. data
      while true do
        local nl = buffer:find("\n", 1, true)
        if not nl then
          break
        end
        handle_event_line(buffer:sub(1, nl - 1))
        buffer = buffer:sub(nl + 1)
      end
    end)
  end)
end

-- coalesce bursts of window events into one immediate report pass so
-- herdr's visible-row highlight updates without waiting for the next tick
request_tick = function()
  if pending_tick or leaving then
    return
  end
  pending_tick = uv.new_timer()
  if not pending_tick then
    return
  end
  pending_tick:start(30, 0, function()
    if pending_tick then
      pending_tick:close()
      pending_tick = nil
    end
    vim.schedule(tick)
  end)
end

function M.setup()
  if not enabled() then
    return
  end
  pane_id = vim.env.HERDR_PANE_ID
  socket_path = vim.env.HERDR_SOCKET_PATH
  request_prefix = ("nvim-herdr:%d"):format(vim.fn.getpid())

  local group = vim.api.nvim_create_augroup("herdr_nested_agents", { clear = true })

  vim.api.nvim_create_autocmd("TermOpen", {
    group = group,
    callback = function(args)
      track(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "WinClosed" }, {
    group = group,
    callback = function()
      if next(terminals) ~= nil then
        request_tick()
      end
    end,
  })

  vim.api.nvim_create_autocmd("TermClose", {
    group = group,
    callback = function(args)
      local entry = terminals[args.buf]
      if entry then
        terminals[args.buf] = nil
        report_closed(entry.pid)
      end
    end,
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      leaving = true
      for _, entry in pairs(terminals) do
        report_closed(entry.pid)
      end
      terminals = {}
    end,
  })

  -- adopt terminals opened before setup ran
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
      track(buf)
    end
  end

  subscribe()
end

return M
