MapVar("DelayedCallObjects", {})
MapVar("DelayedCallThreads", {})
MapVar("NotifyLastTimeCalled", 0)
local DoNotify = function(method)
  return function()
    Sleep(0)
    Sleep(0)
    local objs = DelayedCallObjects[method]
    if objs then
      local i = 1
      if type(method) == "function" then
        while true do
          local obj = objs[i]
          if obj == nil then
            break
          end
          if IsValid(obj) then
            procall(method, obj)
          end
          i = i + 1
        end
      else
        while true do
          local obj = objs[i]
          if obj == nil then
            goto lbl_49
          end
          if IsValid(obj) then
            procall(obj[method], obj)
          end
          i = i + 1
        end
      end
    else
    end
    ::lbl_49::
    DelayedCallObjects[method] = nil
    DelayedCallThreads[method] = nil
  end
end
function RecreateNotifyStructures()
  for k, v in pairs(DelayedCallThreads) do
    DelayedCallThreads[k] = DelayedCallObjects[k] and CreateGameTimeThread(DoNotify(k)) or nil
  end
end
function Notify(obj, method)
  if not obj then
    return
  end
  local now = GameTime()
  if NotifyLastTimeCalled ~= now then
    RecreateNotifyStructures()
    NotifyLastTimeCalled = now
  end
  local thread = DelayedCallThreads[method]
  if not thread then
    thread = CreateGameTimeThread(DoNotify(method))
    DelayedCallThreads[method] = thread
    DelayedCallObjects[method] = {
      obj,
      [obj] = true
    }
  else
    local objs = DelayedCallObjects[method]
    if not objs[obj] then
      objs[#objs + 1] = obj
      objs[obj] = true
    end
  end
end
function ListNotify(objects_to_call, method)
  if #objects_to_call < 1 then
    return
  end
  Notify(objects_to_call[1], method)
  local objs = DelayedCallObjects[method]
  for i = 2, #objects_to_call do
    local obj = objects_to_call[i]
    if not objs[obj] then
      objs[#objs + 1] = obj
      objs[obj] = true
    end
  end
end
function CancelNotify(obj, method)
  local objs = DelayedCallObjects[method]
  if objs[obj] then
    objs[obj] = nil
    for i = 1, #objs do
      if objs[i] == obj then
        objs[i] = false
        return
      end
    end
  end
end
