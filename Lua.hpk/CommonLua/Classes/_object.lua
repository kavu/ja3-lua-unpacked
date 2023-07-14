DefineClass.Object = {
  __parents = {"CObject", "InitDone"},
  __hierarchy_cache = true,
  flags = {cfLuaObject = true},
  spawned_by_template = false,
  handle = false,
  reserved_handles = 0,
  NetOwner = false,
  GameInit = empty_func,
  properties = {
    {
      id = "Handle",
      editor = "number",
      default = "",
      read_only = true,
      dont_save = true
    },
    {
      id = "spawned_by_template",
      name = "Spawned by template",
      editor = "object",
      read_only = true,
      dont_save = true
    }
  }
}
RecursiveCallMethods.GameInit = "procall"
local HandlesAutoPoolStart = const.HandlesAutoPoolStart or 1000000
local HandlesAutoPoolSize = (const.HandlesAutoPoolSize or 999000000) - (const.PerObjectHandlePool or 1024)
local HandlesAutoStart = const.HandlesAutoStart or 1000000000
local HandlesAutoSize = const.HandlesAutoSize or 900000000
local HandlesMapLoadingStart = HandlesAutoStart + HandlesAutoSize
local HandlesMapLoadingSize = 100000000
local HandlePoolMask = bnot((const.PerObjectHandlePool or 1024) - 1)
function IsLoadingHandle(h)
  return h and h >= HandlesMapLoadingStart and h <= HandlesMapLoadingStart + HandlesMapLoadingSize
end
function GetHandlesAutoLimits()
  return HandlesAutoStart, HandlesAutoSize
end
function GetHandlesAutoPoolLimits()
  return HandlesAutoPoolStart, HandlesAutoPoolSize, const.PerObjectHandlePool or 1024
end
MapVar("HandleToObject", {})
MapVar("GameInitThreads", {})
MapVar("GameInitAfterLoading", {})
function OnMsg.GameTimeStart()
  local list = GameInitAfterLoading
  local i = 1
  while i <= #list do
    local obj = list[i]
    if IsValid(obj) then
      obj:GameInit()
    end
    i = i + 1
  end
  GameInitAfterLoading = false
end
function CancelGameInit(obj, bCanDeleteCurrentThread)
  local thread = GameInitThreads[obj]
  if thread then
    DeleteThread(thread, bCanDeleteCurrentThread)
    GameInitThreads[obj] = nil
    return
  end
  local list = GameInitAfterLoading
  if list then
    for i = #list, 1, -1 do
      if list[i] == obj then
        list[i] = false
        return
      end
    end
  end
end
function Object.new(class, luaobj, components, ...)
  local self = CObject.new(class, luaobj, components)
  local h = self.handle
  if h then
    local prev_obj = HandleToObject[h]
    if prev_obj and prev_obj ~= self then
      h = false
    end
  end
  if not h then
    h = self:GenerateHandle()
    self.handle = h
  end
  HandleToObject[h] = self
  OnHandleAssigned(h)
  if self.GameInit ~= empty_func then
    local loading = GameInitAfterLoading
    if loading then
      loading[#loading + 1] = self
    else
      GameInitThreads[self] = CreateGameTimeThread(function(self)
        if IsValid(self) then
          self:GameInit()
        end
        GameInitThreads[self] = nil
      end, self)
    end
  end
  self:NetUpdateHash("Init")
  self:Init(...)
  return self
end
function Object:delete(fromC)
  if not self[true] then
    return
  end
  local h = self.handle
  HandleToObject[h] = nil
  DeletedCObjects[self] = true
  self:Done()
  CObject.delete(self, fromC)
end
AutoResolveMethods.PostLoad = true
Object.PostLoad = empty_func
function Object:CopyProperties(obj, properties)
  PropertyObject.CopyProperties(self, obj, properties)
  self:PostLoad()
end
function CCopyProperties(dest, source)
  dest:CopyProperties(source)
  return dest
end
function ChangeClassMeta(obj, classname)
  local classdef = g_Classes[classname]
  if not classdef then
    return
  end
  setmetatable(obj, classdef)
end
HandleRand = AsyncRand
function Object:GenerateHandle()
  if self:IsSyncObject() then
    return GenerateSyncHandle(self)
  end
  local range = self.reserved_handles
  local h
  if range == 0 then
    local start, size = HandlesAutoStart, HandlesAutoSize
    if ChangingMap then
      start, size = HandlesMapLoadingStart, HandlesMapLoadingSize
    end
    repeat
      h = start + HandleRand(size)
    until not HandleToObject[h]
  else
    repeat
      h = band(HandlesAutoPoolStart + HandleRand(HandlesAutoPoolSize), HandlePoolMask)
    until not HandleToObject[h]
  end
  return h
end
function Object:GetHandle()
  return self.handle
end
function Object:SetHandle(h)
  h = tonumber(h) or h or false
  if self.handle == h then
    return h
  end
  if h and HandleToObject[h] then
    h = self:GenerateHandle()
  end
  HandleToObject[self.handle] = nil
  if h then
    HandleToObject[h] = self
  end
  self.handle = h
  OnHandleAssigned(h)
  return h
end
function Object:RegenerateHandle()
  self:SetHandle(self:GenerateHandle())
end
function Object:LifetimeRandom(range, key, ...)
  return abs(xxhash(self.handle, key, ...)) % range
end
function Object:ResetSpawn()
  if self.reserved_handles == 0 then
    return
  end
  local handle = self.handle + 1
  local max_handle = self.handle + self.reserved_handles
  while handle < max_handle do
    local obj = HandleToObject[handle]
    if obj then
      handle = handle + 1 + obj.reserved_handles
      obj:ResetSpawn()
      DoneObject(obj)
    else
      handle = handle + 1
    end
  end
end
function Object:NetState()
  if IsValid(self.NetOwner) then
    return self.NetOwner:NetState()
  end
  return false
end
RecursiveCallMethods.GetDynamicData = "call"
RecursiveCallMethods.SetDynamicData = "call"
function Object:GetDynamicData(data)
  if IsValid(self.NetOwner) then
    data.NetOwner = self.NetOwner
  end
  if self:IsValidPos() and not self:GetParent() then
    local vpos_time = self:TimeToPosInterpolationEnd()
    if vpos_time ~= 0 then
      data.vpos = self:GetVisualPos()
      data.vpos_time = vpos_time
    end
  end
  local vangle_time = self:TimeToAngleInterpolationEnd()
  if vangle_time ~= 0 then
    data.vangle = self:GetVisualAngle()
    data.vangle_time = vangle_time
  end
  local gravity = self:GetGravity()
  if gravity ~= 0 then
    data.gravity = gravity
  end
end
function Object:SetDynamicData(data)
  self.NetOwner = data.NetOwner
  if data.gravity then
    self:SetGravity(data.gravity)
  end
  if data.pos then
    self:SetPos(data.pos)
  end
  if data.angle then
    self:SetAngle(data.angle or 0)
  end
  if data.vpos then
    local pos = self:GetPos()
    self:SetPos(data.vpos)
    self:SetPos(pos, data.vpos_time)
  end
  if data.vangle then
    local angle = self:GetAngle()
    self:SetAngle(data.vangle)
    self:SetAngle(angle, data.vangle_time)
  end
end
local ResolveHandle = ResolveHandle
local SetObjPropertyList = SetObjPropertyList
local SetArray = SetArray
function Object:__fromluacode(props, arr, handle)
  local obj = ResolveHandle(handle)
  if obj and obj[true] then
    StoreErrorSource(obj, "Duplicate handle", handle)
    obj = nil
  end
  obj = self:new(obj)
  SetObjPropertyList(obj, props)
  SetArray(obj, arr)
  return obj
end
function Object:__toluacode(indent, pstr, GetPropFunc)
  if not pstr then
    local props = ObjPropertyListToLuaCode(self, indent, GetPropFunc)
    local arr = ArrayToLuaCode(self, indent)
    return string.format("PlaceObj('%s', %s, %s, %s)", self.class, props or "nil", arr or "nil", tostring(self.handle or "nil"))
  else
    pstr:appendf("PlaceObj('%s', ", self.class)
    if not ObjPropertyListToLuaCode(self, indent, GetPropFunc, pstr) then
      pstr:append("nil")
    end
    pstr:append(", ")
    if not ArrayToLuaCode(self, indent, pstr) then
      pstr:append("nil")
    end
    return pstr:append(", ", self.handle or "nil", ")")
  end
end
DefineClass.SyncObject = {
  __parents = {"Object"},
  flags = {gofSyncObject = true}
}
function Object:MakeSync()
  if self:IsSyncObject() then
    return
  end
  self:SetGameFlags(const.gofSyncObject)
  self:SetHandle(self:GenerateHandle())
  self:NetUpdateHash("MakeSync", self:GetPos(), self:GetAngle(), self:GetEntity(), self:GetStateText())
end
function Object:TableRand(tbl, key)
  if not tbl then
    return
  elseif #tbl < 2 then
    return tbl[1]
  end
  local idx = self:Random(#tbl, key)
  idx = idx + 1
  return tbl[idx], idx
end
function Object:TableWeightedRand(tbl, calc_weight, key)
  if not tbl then
    return
  elseif #tbl < 2 then
    return tbl[1]
  end
  local seed = self:Random(max_int, key)
  return table.weighted_rand(tbl, calc_weight, seed)
end
function Object:RandRange(min, max, ...)
  return min + self:Random(max - min + 1, ...)
end
function Object:RandSeed(key)
  return self:Random(max_int, key)
end
local HandlesSyncStart = const.HandlesSyncStart or 2000000000
local HandlesSyncSize = const.HandlesSyncSize or 147483647
local HandlesSyncEnd = HandlesSyncStart + HandlesSyncSize - 1
MapVar("CustomSyncHandles", {})
MapVar("NextSyncHandle", HandlesSyncStart)
function IsHandleSync(handle)
  return handle >= HandlesSyncStart and handle <= HandlesSyncEnd or CustomSyncHandles[handle]
end
function GenerateSyncHandle()
  local h = NextSyncHandle
  while HandleToObject[h] do
    h = h + 1 <= HandlesSyncEnd and h + 1 or HandlesSyncStart
    if h == NextSyncHandle then
      break
    end
  end
  NextSyncHandle = h + 1 <= HandlesSyncEnd and h + 1 or HandlesSyncStart
  NetUpdateHash("GenerateSyncHandle", h)
  return h
end
DefineClass.StripObjectProperties = {
  __parents = {
    "StripCObjectProperties",
    "Object"
  },
  properties = {
    {id = "Entity"},
    {id = "Pos"},
    {id = "Angle"},
    {id = "ForcedLOD"},
    {id = "Groups"},
    {
      id = "CollectionIndex"
    },
    {
      id = "CollectionName"
    },
    {
      id = "spawned_by_template"
    },
    {id = "Handle"}
  }
}
