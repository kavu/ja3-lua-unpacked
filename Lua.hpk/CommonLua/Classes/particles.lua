function TestParticle(editor, obj, prop)
  obj:SetPath(obj.par_name)
end
function GetParticleSystemList()
  local list = {}
  for key, item in GetParticleSystemIterator() do
    local item_name = item:GetId()
    table.insert(list, item)
    list[item_name] = item
  end
  return list
end
function GetParticleSystemNameList(ui)
  ui = ui or false
  local list = {}
  for key, item in GetParticleSystemIterator() do
    local item_name = item:GetId()
    if item.ui == ui then
      table.insert(list, item_name)
    end
  end
  return list
end
function GetParticleSystemIterator()
  return pairs(ParticleSystemPresets)
end
function GetParticleSystem(name)
  local preset = ParticleSystemPresets[name]
  if preset then
    return preset
  end
end
function GetParticleSystemNameListFromDisk()
  local list = {}
  for _, folder in ipairs(ParticleDirectories()) do
    for idx, preset in ipairs(io.listfiles(folder, "*.bin")) do
      table.insert(list, preset)
    end
  end
  return list
end
function ParticleDirectories()
  local dirs = {
    "Data/ParticleSystemPreset"
  }
  for _, folder in ipairs(DlcFolders or empty_table) do
    local dir = folder .. "/Presets/ParticleSystemPreset"
    if io.exists(dir) then
      table.insert(dirs, dir)
    end
  end
  return dirs
end
function GetParticleSystemForReloading(name)
  return {
    GetParticleSystem(name)
  }
end
function EditParticleSystem(name)
  local sys = GetParticleSystem(name)
  if IsKindOf(sys, "ParticleSystemPreset") then
    sys:OpenEditor()
  end
end
DefineClass.ParSystemBase = {
  __parents = {
    "ComponentCustomData"
  },
  flags = {
    cfParticles = true,
    cfConstructible = false,
    efSelectable = false,
    efWalkable = false,
    efCollision = false,
    efApplyToGrids = false,
    efShadow = false
  },
  entity = "",
  dynamic_params = false,
  polyline = false,
  properties = {
    {
      id = "ParticlesName",
      editor = "combo",
      default = "",
      items = ParticlesComboItems,
      autoattach_prop = true,
      buttons = {
        {
          name = "Apply",
          func = "ParSystemNameApply"
        }
      }
    },
    {
      id = "CollectionIndex",
      name = "Collection Index",
      editor = "number",
      default = 0,
      read_only = true
    },
    {
      id = "CollectionName",
      name = "Collection Name",
      editor = "dropdownlist",
      items = GetCollectionNames,
      default = "",
      dont_save = true
    },
    {
      id = "CastShadow",
      name = "Shadow from All",
      editor = "bool",
      default = false
    }
  }
}
DefineClass.ParSystem = {
  __parents = {
    "InvisibleObject",
    "ComponentAttach",
    "ParSystemBase",
    "EditorCallbackObject"
  },
  HelperEntity = "ParticlePlaceholder",
  HelperScale = 10,
  HelperCursor = true
}
function ParSystem:EditorGetText()
  return self:GetParticlesName()
end
local RecreateParticle = function(par)
  par:DestroyRenderObj()
end
local ParSystemPlayFX = function(par, no_delay)
  if no_delay then
    RecreateParticle(par)
  elseif EditorSettings:GetTestParticlesOnChange() then
    DelayedCall(500, RecreateParticle, par)
  end
end
ParSystem.EditorCallbackMove = ParSystemPlayFX
ParSystem.EditorCallbackRotate = ParSystemPlayFX
ParSystem.EditorCallbackMoveScale = ParSystemPlayFX
function OnMsg.EditorSelectionChanged(objects)
  for _, obj in ipairs(objects or empty_tample) do
    if IsKindOf(obj, "ParSystem") then
      ParSystemPlayFX(obj)
      return
    end
  end
end
function RecreateSelectedParticle(no_delay)
  local selection = editor.GetSel()
  for _, sel_obj in ipairs(selection) do
    if IsKindOf(sel_obj, "ParSystem") then
      ParSystemPlayFX(sel_obj, no_delay)
      return
    end
  end
end
DefineClass.ParSystemUI = {
  __parents = {
    "ParSystemBase"
  },
  flags = {gofUILObject = true}
}
function ParSystemNameApply(editor, obj)
  if obj:GetGameFlags(const.gofRealTimeAnim) == const.gofRealTimeAnim then
    obj:SetCustomData(0, RealTime())
  else
    obj:SetCustomData(0, GameTime())
  end
  obj:DestroyRenderObj()
  obj:ApplyDynamicParams()
end
function ParSystem:ShouldBeGameTime()
  local name = self:GetParticlesName()
  if not name then
    return false
  end
  if name == "" then
    return false
  end
  local flags = ParticlesGetBehaviorFlags(name, -1)
  if not flags then
    return false
  end
  return flags.gametime and true
end
function ParSystem:PostLoad()
  self:ApplyDynamicParams()
end
if FirstLoad then
  g_DynamicParamsDefs = {}
end
function OnMsg.DoneMap()
  g_DynamicParamsDefs = {}
end
function ParGetDynamicParams(name)
  local defs = g_DynamicParamsDefs
  local def = defs[name]
  if not def then
    def = ParticlesGetDynamicParams(name) or empty_table
    defs[name] = def
  end
  return def
end
if config.ParticleDynamicParams then
  function ParSystem:ApplyDynamicParams()
    local proto = self:GetParticlesName()
    local dynamic_params = ParGetDynamicParams(proto)
    if dynamic_params then
      self.dynamic_params = dynamic_params
      local set_value = self.SetParamDef
      for k, v in pairs(dynamic_params) do
        set_value(self, v, v.default_value)
      end
    end
  end
  function ParSystem:SetParam(param, value)
    local dynamic_params = self.dynamic_params
    local def = dynamic_params and rawget(dynamic_params, param)
    if def then
      self:SetParamDef(def, value)
    end
  end
  function ParSystem:SetParamDef(def, value)
    local ptype = def.type
    if ptype == "number" then
      self:SetCustomData(def.index, value)
    elseif ptype == "color" then
      self:SetCustomData(def.index, value)
    elseif ptype == "point" then
      local x, y, z = value:xyz()
      local idx = def.index
      local set = self.SetCustomData
      set(self, idx, x)
      set(self, idx + 1, y)
      set(self, idx + 2, z or 0)
    elseif ptype == "bool" then
      self:SetCustomData(def.index, value and 1 or 0)
    end
  end
  function ParSystem:GetParam(param, value)
    local dynamic_params = self.dynamic_params
    local p = dynamic_params and rawget(dynamic_params, param)
    if p then
      local ptype = p.type
      if ptype == "number" then
        return self:GetCustomData(p.index)
      elseif ptype == "color" then
        return self:GetCustomData(p.index)
      elseif ptype == "point" then
        local idx = p.index
        local get = self.GetCustomData
        return point(get(self, idx), get(self, idx + 1), get(self, idx + 2))
      elseif ptype == "bool" then
        return self:GetCustomData(p.index) ~= 0
      end
    end
  end
else
  ParSystem.ApplyDynamicParams = empty_func
  ParSystem.SetParam = empty_func
  ParSystem.GetParam = empty_func
  ParSystem.SetParamDef = empty_func
end
function ParSystem:SetPolyline(polyline, parent)
  local count = #polyline
  if count <= 4 then
    local set = self.SetCustomData
    for i = 1, count do
      local v1, v2 = polyline[i]:xy()
      set(self, 2 * i, v1)
      set(self, 2 * i + 1, v2)
    end
    set(self, 1, count)
  end
end
function OnMsg.LoadGame()
  local empty = pstr("")
  MapForEach(true, "ParSystem", function(o)
    if o.polyline then
      o.polyline = o.polyline or empty
      o:SetCustomData(1, o.polyline)
    end
  end)
end
function PlaceParticles(name, class, components)
  if type(name) ~= "string" or name == "" then
    return
  end
  local o = PlaceObject(class or "ParSystem", nil, components)
  if not o then
    return
  end
  if not o:SetParticlesName(name) then
    DoneObject(o)
    return
  end
  o:ApplyDynamicParams()
  return o
end
local WaitClearParticle = function(obj, max_timeout)
  local kill_time = now() + (max_timeout or 10000)
  while IsValid(obj) and obj:HasParticles() and now() - kill_time < 0 do
    Sleep(1000)
  end
  DoneObject(obj)
end
function StopParticles(obj, wait, max_timeout)
  if not IsValid(obj) then
    return
  end
  if obj:IsParticleSystemVanishing() or not obj:HasParticles() then
    DoneObject(obj)
    return
  end
  obj:StopEmitters()
  if wait then
    WaitClearParticle(obj, max_timeout)
  elseif obj:GetGameFlags(const.gofRealTimeAnim) == const.gofRealTimeAnim then
    CreateMapRealTimeThread(WaitClearParticle, obj, max_timeout)
  else
    CreateGameTimeThread(WaitClearParticle, obj, max_timeout)
  end
end
function StopMultipleParticles(objs, max_timeout)
  if type(objs) ~= "table" or #objs == 0 then
    return
  end
  CreateMapRealTimeThread(function(objs, max_timeout)
    local kill_time = now() + (max_timeout or 10000)
    for i = 1, #objs do
      local obj = objs[i]
      if IsValid(obj) then
        if obj:IsParticleSystemVanishing() or not obj:HasParticles() then
          DoneObject(obj)
        else
          obj:StopEmitters()
        end
      end
    end
    while true do
      local has_time = now() - kill_time < 0
      local loop
      for i = 1, #objs do
        local obj = objs[i]
        if IsValid(obj) then
          if has_time and obj:HasParticles() then
            loop = true
            break
          else
            DoneObject(obj)
          end
        end
      end
      if not loop then
        break
      end
      Sleep(1000)
    end
  end, objs, max_timeout)
end
function PlaceParticlesOnce(particles, pos, angle, axis)
  local o = PlaceParticles(particles)
  if axis then
    o:SetAxis(axis)
  end
  if angle then
    o:SetAngle(angle)
  end
  if pos then
    o:SetPos(pos)
  end
  CreateMapRealTimeThread(function(o)
    Sleep(2000)
    StopParticles(o, true)
  end, o)
  return o
end
function GetAttachParticle(obj, name)
  for i = 1, obj:GetNumAttaches() do
    local o = obj:GetAttach(i)
    if o:IsKindOf("ParSystem") and o:GetProperty("ParticlesName") == name then
      return o
    end
  end
end
function GetParticleAttaches(obj, name)
  local attaches = obj:GetNumAttaches()
  local list = {}
  for i = 1, attaches do
    local o = obj:GetAttach(i)
    if IsKindOf(o, "ParSystem") and o:GetProperty("ParticlesName") == name then
      table.insert(list, o)
    end
  end
  return list
end
