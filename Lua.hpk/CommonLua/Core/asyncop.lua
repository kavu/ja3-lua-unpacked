if FirstLoad then
  AsyncOps = {}
end
function AsyncOpDone(opid, ...)
  Wakeup(AsyncOps[opid], ...)
  AsyncOps[opid] = nil
end
local __wakeup = function(id, ok, ...)
  if not ok then
    AsyncOps[id] = nil
    AsyncOpStop(id)
    return "timeout"
  end
  if AsyncOps[id] then
    AsyncOps[id] = nil
    return "cancelled"
  end
  return ...
end
AsyncCanYield = CanYield
local AsyncOpWrap = function(func)
  return function(...)
    if not IsRealTimeThread() or not AsyncCanYield() then
      return func(nil, ...)
    end
    local id, res2, res3, res4 = func(true, ...)
    if type(id) ~= "number" then
      return id, res2, res3, res4
    end
    AsyncOps[id] = CurrentThread()
    return __wakeup(id, WaitWakeup())
  end
end
for op, func in pairs(async) do
  _G[op] = AsyncOpWrap(func)
end
function AsyncOpWait(timeout, id_ref, funcname, ...)
  local id, res2, res3, res4 = async[funcname](true, ...)
  if type(id) ~= "number" then
    return id, res2, res3, res4
  end
  if id_ref then
    rawset(id_ref, "asyncop_id", id)
  end
  AsyncOps[id] = CurrentThread()
  return __wakeup(id, WaitWakeup(timeout))
end
function AsyncOpCancel(id_ref)
  local id, thread
  if type(id_ref) == "thread" then
    for _id, _thread in pairs(AsyncOps) do
      if _thread == id_ref then
        id = _id
        thread = _thread
      end
    end
  elseif type(id_ref) == "table" then
    id = rawget(id_ref, "asyncop_id")
    rawset(id_ref, "asyncop_id", nil)
    thread = id and AsyncOps[id]
  end
  if thread then
    AsyncOps[id] = "cancelled"
    AsyncOpStop(id)
    return Wakeup(thread)
  end
end
