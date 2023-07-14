if FirstLoad then
  ParentTableCache = setmetatable({}, weak_keys_meta)
end
ParentTableCacheIgnoreKeys = {
  mod = true,
  env = true,
  own_mod = true,
  __index = true
}
local no_loops = function(t)
  local processed = {}
  while t and not processed[t] do
    processed[t] = true
    t = ParentTableCache[t]
  end
  return not processed[t]
end
local function __PopulateParentTableCache(t, processed, ignore_keys)
  for key, value in pairs(t) do
    if not ignore_keys[key] and type(value) == "table" and not IsT(value) and not processed[value] then
      local old_value = ParentTableCache[value]
      ParentTableCache[value] = t
      processed[value] = true
      if no_loops(value) then
        __PopulateParentTableCache(value, processed, ignore_keys)
      else
        ParentTableCache[value] = old_value
      end
    end
  end
end
function PopulateParentTableCache(t)
  PauseInfiniteLoopDetection("PopulateParentTableCache")
  __PopulateParentTableCache(t, {}, ParentTableCacheIgnoreKeys)
  ResumeInfiniteLoopDetection("PopulateParentTableCache")
end
function UpdateParentTable(t, parent)
  ParentTableCache[t] = parent
end
function ParentTableModified(value, parent, recursive)
  if ParentTableCache[parent] and type(value) == "table" and not IsT(value) then
    ParentTableCache[value] = parent
    if recursive then
      PopulateParentTableCache(value)
    end
  end
end
function GetParentTable(t)
  return ParentTableCache[t]
end
function GetParentTableOfKindNoCheck(t, ...)
  local parent = ParentTableCache[t]
  while parent and not IsKindOfClasses(parent, ...) do
    parent = ParentTableCache[parent]
  end
  return parent
end
function GetParentTableOfKind(t, ...)
  return GetParentTableOfKindNoCheck(t, ...)
end
