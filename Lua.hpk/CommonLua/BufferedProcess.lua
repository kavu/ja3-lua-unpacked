local SuspendProcessReasons, SuspendedProcessing
local CheckExecutionTimestamp = empty_func
local CheckRemainingReason = empty_func
local table_unpack = table.unpack
local table_iequal = table.iequal
if FirstLoad then
  __process_params_meta = {
    __eq = function(t1, t2)
      if type(t1) ~= type(t2) or not rawequal(getmetatable(t1), getmetatable(t2)) then
        return false
      end
      local count = t1[1]
      if count ~= t2[1] then
        return false
      end
      for i = 2, count do
        if t1[i] ~= t2[i] then
          return false
        end
      end
      return true
    end
  }
end
local PackProcessParams = function(obj, ...)
  local count = select("#", ...)
  if count == 0 then
    return obj or false
  end
  return setmetatable({
    count + 2,
    obj,
    ...
  }, __process_params_meta)
end
local UnpackProcessParams = function(params)
  if type(params) ~= "table" or getmetatable(params) ~= __process_params_meta then
    return params
  end
  return table_unpack(params, 2, params[1])
end
function OnMsg.DoneMap()
  CheckRemainingReason()
  SuspendProcessReasons = false
  SuspendedProcessing = false
end
local ExecuteSuspended = function(process)
  local delayed = SuspendedProcessing
  local funcs_to_params = delayed and delayed[process]
  if not funcs_to_params then
    return
  end
  delayed[process] = nil
  local procall = procall
  for _, funcname in ipairs(funcs_to_params) do
    local func = _G[funcname]
    for _, params in ipairs(funcs_to_params[funcname]) do
      procall(func, UnpackProcessParams(params))
    end
  end
end
function CancelProcessing(process)
  if not SuspendProcessReasons or not SuspendProcessReasons[process] then
    return
  end
  if SuspendedProcessing then
    SuspendedProcessing[process] = nil
  end
  SuspendProcessReasons[process] = nil
  Msg("ProcessingResumed", process, "cancel")
end
function IsProcessingSuspended(process)
  local process_to_reasons = SuspendProcessReasons
  return process_to_reasons and next(process_to_reasons[process])
end
function SuspendProcessing(process, reason, ignore_errors)
  reason = reason or ""
  local reasons = SuspendProcessReasons and SuspendProcessReasons[process]
  if reasons and reasons[reason] then
    return
  end
  local now = GameTime()
  if reasons then
    reasons[reason] = now
    return
  end
  SuspendProcessReasons = table.set(SuspendProcessReasons, process, reason, now)
  Msg("ProcessingSuspended", process)
end
function ResumeProcessing(process, reason, ignore_errors)
  reason = reason or ""
  local reasons = SuspendProcessReasons and SuspendProcessReasons[process]
  local suspended = reasons and reasons[reason]
  if not suspended then
    return
  end
  local now = GameTime()
  reasons[reason] = nil
  if next(reasons) ~= nil then
    return
  end
  SuspendProcessReasons[process] = nil
  if next(SuspendProcessReasons) == nil then
    SuspendProcessReasons = false
  end
  ExecuteSuspended(process)
  Msg("ProcessingResumed", process)
end
function ExecuteProcess(process, funcname, obj, ...)
  if not IsProcessingSuspended(process) then
    return procall(_G[funcname], obj, ...)
  end
  local params = PackProcessParams(obj, ...)
  local suspended = SuspendedProcessing
  if not suspended then
    suspended = {}
    SuspendedProcessing = suspended
  end
  local funcs_to_params = suspended[process]
  if not funcs_to_params then
    suspended[process] = {
      funcname,
      [funcname] = {params}
    }
    return
  end
  local objs = funcs_to_params[funcname]
  if not objs then
    funcs_to_params[#funcs_to_params + 1] = funcname
    funcs_to_params[funcname] = {params}
    return
  end
  table.insert_unique(objs, params)
end
if Platform.asserts then
  local ExecutionTimestamps
  function OnMsg.DoneMap()
    ExecutionTimestamps = false
  end
  function CheckExecutionTimestamp(process, funcname, obj, delayed)
    if not config.DebugSuspendProcess then
      return
    end
    if not ExecutionTimestamps then
      ExecutionTimestamps = {}
      CreateRealTimeThread(function()
        Sleep(1)
        ExecutionTimestamps = false
      end)
    end
    local func_to_objs = ExecutionTimestamps[process]
    if not func_to_objs then
      func_to_objs = {}
      ExecutionTimestamps[process] = func_to_objs
    end
    local objs_to_timestamp = func_to_objs[funcname]
    if not objs_to_timestamp then
      objs_to_timestamp = {}
      func_to_objs[funcname] = objs_to_timestamp
    end
    obj = obj or false
    local rtime, gtime = RealTime(), GameTime()
    local timestamp = xxhash(rtime, gtime)
    if timestamp == objs_to_timestamp[obj] then
      print("Duplicated processing:", process, funcname, "time:", gtime, "obj:", obj and obj.class, obj and obj.handle)
    else
      objs_to_timestamp[obj] = timestamp
    end
  end
  function CheckRemainingReason()
    local process = next(SuspendProcessReasons)
    local reason = process and next(SuspendProcessReasons[process])
    if reason then
    end
  end
end
