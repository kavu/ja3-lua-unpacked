function OnMsg.NewMapLoaded()
  ResetVoxelStealthParamsCache()
end
DefineClass.TallGrass = {
  __parents = {"Grass"},
  flags = {efVsGrass = true}
}
PointLight.flags = PointLight.flags or {}
PointLight.flags.efVsPointLight = true
SpotLight.flags = SpotLight.flags or {}
SpotLight.flags.efVsSpotLight = true
SpotLight.flags.efVsPointLight = false
function OnMsg.LightsStateUpdated()
  ResetVoxelStealthParamsCache()
end
function IsIlluminated(target, voxels, sync, step_pos)
  if not IsValid(target) or IsPoint(target) or not target:IsValidPos() then
    return
  end
  if not GameState.Night and not GameState.Underground then
    return true
  end
  local env_factors = GetVoxelStealthParams(step_pos or target)
  if env_factors ~= 0 and band(env_factors, const.vsFlagIlluminated) ~= 0 then
    return true
  end
  if IsKindOf(target, "Unit") then
    local _, __, weapons = target:GetActiveWeapons()
    for i, w in ipairs(weapons) do
      if w:HasComponent("IgnoreInTheDark") then
        return true
      end
    end
  end
  if next(g_DistToFire) == nil then
    return
  end
  if not voxels then
    if IsKindOf(target, "Unit") then
      voxels = step_pos and target:GetVisualVoxels(step_pos) or target:GetVisualVoxels()
    else
      local x, y, z = WorldToVoxel(target)
      voxels = {
        point_pack(x, y, z)
      }
    end
  end
  return AreVoxelsInFireRange(voxels)
end
function OnMsg.ClassesGenerate(classdefs)
  local classdef = classdefs.Light
  local old_gameinit = classdef.GameInit
  local old_done = classdef.Done
  local old_fade = classdef.Fade
  function classdef:GameInit(...)
    if old_gameinit then
      old_gameinit(self, ...)
    end
    ResetVoxelStealthParamsCache()
  end
  function classdef:Done(...)
    KillStealthLightForLight(self)
    if old_done then
      old_done(self, ...)
    end
    ResetVoxelStealthParamsCache()
  end
  function classdef:Fade(color, intensity, time)
    old_fade(self, color, intensity, time)
    if self.stealth_light then
      old_fade(self.stealth_light, color, intensity, time)
    end
  end
end
DefineClass.StealthLight = {
  __parents = {"Object"},
  original_light = false
}
DefineClass.StealthPointLight = {
  __parents = {
    "PointLight",
    "StealthLight"
  },
  flags = {
    cfLight = false,
    efVsPointLight = true,
    gofRealTimeAnim = false
  },
  entity = "InvisibleObject"
}
DefineClass.StealthPointLightFlicker = {
  __parents = {
    "PointLightFlicker",
    "StealthLight"
  },
  flags = {
    cfLight = false,
    efVsPointLight = true,
    gofRealTimeAnim = false
  },
  entity = "InvisibleObject"
}
DefineClass.StealthSpotLightFlicker = {
  __parents = {
    "SpotLightFlicker",
    "StealthLight"
  },
  flags = {
    cfLight = false,
    efVsPointLight = false,
    efVsSpotLight = true,
    gofRealTimeAnim = false
  },
  entity = "InvisibleObject"
}
DefineClass.StealthSpotLight = {
  __parents = {
    "SpotLight",
    "StealthLight"
  },
  flags = {
    cfLight = false,
    efVsPointLight = false,
    efVsSpotLight = true,
    gofRealTimeAnim = false
  },
  entity = "InvisibleObject"
}
MapVar("StealthLights", {})
function NetSyncEvents.SyncLights(in_data)
  for i, data in ipairs(in_data) do
    local h = data[1]
    local sl = HandleToObject[h]
    if IsValid(sl) then
      sl:SetPos(data[2])
      sl:SetAxisAngle(data[4], data[3])
    end
  end
  ResetVoxelStealthParamsCache()
  if g_Combat then
    g_Combat.visibility_update_hash = false
  end
end
MapGameTimeRepeat("StealthLights", -1, function()
  if netInGame and not NetIsHost() then
    Halt()
  end
  while #StealthLights > 0 do
    local data = {}
    for i, sl in ipairs(StealthLights) do
      local ol = sl.original_light
      table.insert(data, {
        sl.handle,
        ol:GetVisualPos(),
        ol:GetVisualAngle(),
        ol:GetVisualAxis()
      })
    end
    NetSyncEvent("SyncLights", data)
    Sleep(250)
  end
  WaitWakeup()
end)
function CreateStealthLight(light)
  if IsValid(light.stealth_light) then
    return
  end
  local stealth_light_cls = "Stealth" .. light.class
  if g_Classes[stealth_light_cls] then
    local sl = PlaceObject(stealth_light_cls)
    sl:CopyProperties(light)
    sl.original_light = light
    light.stealth_light = sl
    sl:SetAxisAngle(axis_z, 0)
    sl:DetachFromMap()
    sl:MakeSync()
    ResetVoxelStealthParamsCache()
    table.insert(StealthLights, sl)
    Wakeup(PeriodicRepeatThreads.StealthLights)
  end
end
function IsLightAttachedOnPlayerUnit(obj, parent)
  local parent = parent or obj and GetTopmostParent(obj)
  if IsKindOf(parent, "Unit") and parent.team and (parent.team.side == "player1" or parent.team.side == "player2") then
    return true
  end
end
function ShouldSyncFXLightLua(obj, parent)
  local parent = parent or obj and GetTopmostParent(obj)
  if not IsValid(parent) then
    return false
  end
  if IsLightAttachedOnPlayerUnit(obj, parent) then
    return false
  end
  return true
end
function Stealth_HandleLight(obj, force_sl)
  if not IsLightSetupToAffectStealth(obj) then
    return
  end
  if IsLightAttachedOnPlayerUnit(obj) then
    return
  end
  obj:ClearGameFlags(const.gofRealTimeAnim)
  if not force_sl and not obj.stealth_light and not obj:IsAttachedToBone() then
    obj:MakeSync()
    ResetVoxelStealthParamsCache()
    return true
  else
    CreateStealthLight(obj)
  end
end
function CreateStealthLights()
  if GetMapName() == "" then
    return
  end
  ResetVoxelStealthParamsCache()
  CreateGameTimeThread(function()
    MapForEach("map", "Light", Stealth_HandleLight)
    ResetVoxelStealthParamsCache()
  end)
end
OnMsg.ChangeMapDone = CreateStealthLights
function NetSyncEvents.OnLightModelChanged()
  CreateStealthLights()
end
function OnMsg.LightmodelChange()
  if IsChangingMap() then
    return
  end
  NetSyncEvent("OnLightModelChanged")
end
if FirstLoad then
  lights_on_save = false
end
function OnMsg.PreSaveMap()
  lights_on_save = {}
  MapForEach("map", "Light", nil, nil, const.gofPermanent, function(o)
    o:MakeNotSync()
    table.insert(lights_on_save, o)
  end)
end
function OnMsg.SaveMapDone()
  for i = 1, #lights_on_save do
    lights_on_save[i]:MakeSync()
  end
  lights_on_save = false
end
function Light:MakeSync()
  if self:IsSyncObject() then
    return
  end
  local h = self.handle
  if not IsHandleSync(h) then
    self.old_handle = h
  end
  Object.MakeSync(self)
  self:NetUpdateHash("LightMakeSync", self:GetIntensity(), self:GetAttenuationShape(), const.vsConstantLightIntensity)
end
function Light:MakeNotSync()
  if not self:IsSyncObject() then
    return
  end
  local oh = self.old_handle
  self:ClearGameFlags(const.gofSyncObject)
  local obj = oh and HandleToObject[oh]
  oh = not (obj ~= self and obj) and oh or false
  self:SetHandle(oh or self:GenerateHandle())
end
AppendClass.Light = {stealth_light = false, old_handle = false}
AppendClass.ActionFXLight = {
  properties = {
    {
      category = "Light",
      id = "Sync",
      editor = "bool",
      default = false
    }
  }
}
function ActionFXLight:OnLightPlaced(fx, actor, target, obj, spot, posx, posy, posz, angle, axisx, axisy, axisz, action_pos, action_dir)
  if not self.Sync then
    return
  end
  if not IsValid(fx) or not IsKindOf(fx, "Light") then
    return
  end
  if not IsGameTimeThread() then
    if Platform.developer then
      print("Async light created from fx! This light won't affect stealth.")
      print("In order to affect stealth, use GameTime and do not attach it to an animated spot.")
    end
    return
  end
  Stealth_HandleLight(fx, "force_sl")
end
function KillStealthLightForLight(light)
  local o = light.stealth_light
  if o then
    table.remove_entry(StealthLights, o)
    DoneObject(o)
    light.stealth_light = nil
  end
end
function ActionFXLight:OnLightDone(fx)
  KillStealthLightForLight(fx)
end
function GetFXLightFromVisualObj(obj)
  local light = obj:GetAttach("Light")
  if light then
    return light
  end
  light = obj:GetAttach("SpawnFXObject")
  light = light and light:GetAttach("Light") or false
  return light
end
