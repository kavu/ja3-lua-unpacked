local last_call = false
local call_counts = {}
local last_call_ex = false
local call_counts_ex = {}
local call_stacks = {}
local Reset = function()
  last_call = false
  call_counts = {}
  last_call_ex = false
  call_counts_ex = {}
  call_stacks = {}
end
OnMsg.PostDoneMap = Reset
OnMsg.PreNewMap = Reset
OnMsg.LoadGame = Reset
if not Platform.developer then
  function DetectInfiniteLoop()
  end
  function DetectInfiniteLoopEx(src, id, limit, log)
    local time_now = GameTime()
    if time_now ~= last_call_ex then
      last_call_ex = time_now
      call_counts_ex = {}
    end
    local call_counts = call_counts_ex[id]
    if not call_counts then
      call_counts = {}
      call_counts_ex[id] = call_counts
    end
    call_counts[src] = (call_counts[src] or 0) + 1
    if call_counts[src] > limit + 3 then
      Sleep(2000)
    end
    return true
  end
else
  local trace = {}
  function TraceThread(thread)
    if trace[thread] then
      return
    end
    local getinfo = debug.getinfo
    local DebugHook = function(event, line)
      if event == "line" then
        local info = getinfo(thread, 2, "S")
        local tbl = trace[thread]
        if not string.find(info.source, "lib.lua", -10, true) then
          tbl[#tbl + 1] = tostring(info.source) .. "(" .. tostring(line) .. "): " .. GameTime()
          if 1000 < #tbl then
            table.remove(tbl, 1)
          end
        end
      end
    end
    trace[thread] = {}
    local old_debug_hook, old_debug_mask, old_debug_count = debug.gethook(thread)
    if string.match(old_debug_mask, "[lL]") then
      debug.sethook(thread, DebugHook, old_debug_mask)
    else
      debug.sethook(thread, DebugHook, old_debug_mask .. "l")
    end
  end
  function DumpTrace(thread)
    print("-------- trace -------")
    local tbl = trace[thread]
    for i = 1, #tbl do
      print(tbl[i])
    end
  end
  function DetectInfiniteLoop(src, ...)
    local time_now = GameTime()
    if time_now ~= last_call then
      last_call = time_now
      call_counts = {}
    end
    call_counts[src] = (call_counts[src] or 0) + 1
    if 2 < call_counts[src] then
      print(...)
      error("Infinite loop game time " .. tostring(GameTime()), 1)
      Sleep(200)
    end
    return true
  end
  function DetectInfiniteLoopEx(src, id, limit, log)
    local time_now = GameTime()
    if time_now ~= last_call_ex then
      last_call_ex = time_now
      call_counts_ex = {}
      call_stacks = {}
    end
    local call_counts = call_counts_ex[id]
    local stacks = call_stacks[id]
    if not call_counts then
      call_counts = {}
      stacks = {}
      call_stacks[id] = stacks
      call_counts_ex[id] = call_counts
    end
    local logs = stacks[src]
    if not logs then
      logs = {}
      stacks[src] = logs
    end
    logs[#logs + 1] = log or GetStack(2)
    local call_count = (call_counts[src] or 0) + 1
    call_counts[src] = call_count
    if limit < call_count then
      local thread = CurrentThread()
      error("Infinite loop game time " .. tostring(GameTime()), 1)
      if IsValid(src) then
        local text = "class = \"" .. src.class .. "\""
        if src:IsKindOf("CommandObject") then
          text = text .. ", command = \"" .. tostring(src.command) .. "\""
        end
        print(text)
      end
      if log then
        local i = 1
        while call_count >= i do
          local entry = logs[i]
          local j = i
          repeat
            i = i + 1
          until call_count < i or logs[i] ~= entry
          if i - j == 1 then
            printf("call #%d: %s", j, entry)
          else
            printf("call #%d-%d: %s", j, i - 1, entry)
          end
        end
      else
        for i = 1, call_count do
          printf("call #%d", i)
          string.gsub(logs[i], "(.-)\n", function(s)
            print(s)
          end)
        end
      end
    end
    if call_count > 5 + limit then
      Sleep(200)
    end
    return true
  end
end
