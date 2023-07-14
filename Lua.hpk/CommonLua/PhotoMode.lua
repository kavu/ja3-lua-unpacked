if FirstLoad then
  g_PhotoMode = false
  g_PhotoModeShotNum = false
  g_PhotoModeShotThread = false
  PhotoModeObj = false
  g_PrePhotoModeStoredVisuals = false
  g_PhotoFilter = false
  g_PhotoFilterData = false
  g_PhotoModeInitialCamera = false
end
function StartPhotoMode()
  g_PrePhotoModeStoredVisuals = {}
  PhotoModeBegin()
  SetInGameInterfaceMode(config.InGameSelectionMode)
  PhotoModeDialogOpen()
end
function PhotoModeDialogOpen()
  OpenDialog("PhotoMode")
end
local ActivateFreeCamera = function()
  Msg("PhotoModeFreeCameraActivated")
  local _, _, camType, zoom, properties, fov = GetCamera()
  g_PhotoModeInitialCamera = {
    camType = camType,
    zoom = zoom,
    properties = properties,
    fov = fov
  }
  cameraFly.Activate(1)
  if g_MouseConnected then
    SetMouseDeltaMode(true)
  end
end
local DeactivateFreeCamera = function()
  if cameraFly.IsActive() then
    if g_MouseConnected then
      SetMouseDeltaMode(false)
    end
    local current_pos, current_look_at = GetCamera()
    SetCamera(current_pos, current_look_at, g_PhotoModeInitialCamera.camType, g_PhotoModeInitialCamera.zoom, g_PhotoModeInitialCamera.properties, g_PhotoModeInitialCamera.fov)
    g_PhotoModeInitialCamera = false
  end
  Msg("PhotoModeFreeCameraDeactivated")
end
function PhotoModeBegin()
  Msg("PhotoModeBegin")
  g_PhotoMode = true
  table.change(hr, "photo_mode", {
    InterfaceInScreenshot = 0,
    LODDistanceModifier = Max(hr.LODDistanceModifier, 200),
    DistanceModifier = Max(hr.DistanceModifier, 100),
    ObjectLODCapMin = Min(hr.ObjectLODCapMin, 0),
    EnablePostProcDOF = 1,
    Anisotropy = 4
  })
  local lm_name = CurrentLightmodel[1].id or ""
  g_PrePhotoModeStoredVisuals.lightmodel = lm_name ~= "" and lm_name or CurrentLightmodel[1]
  g_PrePhotoModeStoredVisuals.dof_params = {
    GetDOFParams()
  }
end
function PhotoModeEnd()
  if PhotoModeObj then
    CreateMapRealTimeThread(function()
      PhotoModeObj:Save()
    end)
  end
  if g_PhotoFilter and g_PhotoFilter.deactivate then
    g_PhotoFilter.deactivate(g_PhotoFilter.filter, g_PhotoFilterData)
  end
  g_PhotoMode = false
  g_PhotoFilter = false
  g_PhotoFilterData = false
  table.restore(hr, "photo_mode")
  PP_Rebuild()
  SetLightmodel(1, g_PrePhotoModeStoredVisuals.lightmodel, 0)
  table.insert(g_PrePhotoModeStoredVisuals.dof_params, 0)
  SetDOFParams(unpack_params(g_PrePhotoModeStoredVisuals.dof_params))
  if PhotoModeObj.freeCamera then
    DeactivateFreeCamera()
  end
  Msg("PhotoModeEnd")
end
function PhotoModeApply(pm_object, prop_id)
  if prop_id == "filter" then
    if g_PhotoFilter and g_PhotoFilter.deactivate then
      g_PhotoFilter.deactivate(g_PhotoFilter.filter, g_PhotoFilterData)
    end
    local filter = PhotoFilterPresetMap[pm_object.filter]
    if filter and filter.shader_file ~= "" then
      g_PhotoFilterData = {}
      if filter.activate then
        filter.activate(filter, g_PhotoFilterData)
      end
      g_PhotoFilter = filter:GetShaderDescriptor()
    else
      g_PhotoFilter = false
      g_PhotoFilterData = false
    end
    if not filter then
      pm_object:SetProperty("filter", PhotoModeObject.filter)
    end
    PP_Rebuild()
  elseif prop_id == "fogDensity" then
    SetSceneParam(1, "FogGlobalDensity", pm_object.fogDensity, 0, 0)
  elseif prop_id == "bloomStrength" then
    SetSceneParamVector(1, "Bloom", 0, pm_object.bloomStrength, 0, 0)
  elseif prop_id == "exposure" then
    SetSceneParam(1, "GlobalExposure", pm_object.exposure, 0, 0)
  elseif prop_id == "ae_key_bias" then
    SetSceneParam(1, "AutoExposureKeyBias", pm_object.ae_key_bias, 0, 0)
  elseif prop_id == "vignette" then
    SetSceneParamFloat(1, "VignetteDarkenOpacity", pm_object:GetPropertyMetadata("vignette").scale, pm_object.vignette, 0, 0)
  elseif prop_id == "colorSat" then
    SetSceneParam(1, "Desaturation", -pm_object.colorSat, 0, 0)
  elseif prop_id == "depthOfField" or prop_id == "focusDepth" or prop_id == "defocusStrength" then
    local detail = 3
    local focus_depth = Lerp(hr.NearZ, hr.FarZ, pm_object.focusDepth ^ detail, 100 ^ detail)
    local dof = Lerp(0, hr.FarZ - hr.NearZ, pm_object.depthOfField ^ detail, 100 ^ detail)
    local strength = sqrt(pm_object.defocusStrength * 100)
    SetDOFParams(strength, Max(focus_depth - dof / 3, hr.NearZ), Max(focus_depth - dof / 6, hr.NearZ), strength, Min(focus_depth + dof / 3, hr.FarZ), Min(focus_depth + dof * 2 / 3, hr.FarZ), 0)
  elseif prop_id == "freeCamera" then
    if pm_object.freeCamera then
      ActivateFreeCamera()
    else
      DeactivateFreeCamera()
    end
  end
end
function PhotoModeDoTakeScreenshot(frame_duration, max_frame_duration)
  g_PhotoModeShotNum = g_PhotoModeShotNum or 0
  frame_duration = frame_duration or 0
  local folder = "AppPictures/"
  local proposed_name = string.format("Screenshot%04d.png", g_PhotoModeShotNum)
  if io.exists(folder .. proposed_name) then
    local files = io.listfiles(folder, "Screenshot*.png")
    for i = 1, #files do
      g_PhotoModeShotNum = Max(g_PhotoModeShotNum, tonumber(string.match(files[i], "Screenshot(%d+)%.png") or 0))
    end
    g_PhotoModeShotNum = g_PhotoModeShotNum + 1
    proposed_name = string.format("Screenshot%04d.png", g_PhotoModeShotNum)
  end
  local width, height = GetResolution()
  WaitNextFrame(3)
  LockCamera("Screenshot")
  local quality = Lerp(128, 128, frame_duration, max_frame_duration)
  MovieWriteScreenshot(folder .. proposed_name, frame_duration, quality, frame_duration, width, height)
  UnlockCamera("Screenshot")
  g_PhotoModeShotNum = g_PhotoModeShotNum + 1
  local file_path = ConvertToOSPath(folder .. proposed_name)
  Msg("PhotoModeScreenshotTaken", file_path)
  if Platform.steam and IsSteamAvailable() then
    SteamAddScreenshotToLibrary(file_path, "", width, height)
  end
end
function PhotoModeTake(frame_duration, max_frame_duration)
  g_PhotoModeShotThread = IsValidThread(g_PhotoModeShotThread) and g_PhotoModeShotThread or CreateMapRealTimeThread(function()
    PhotoModeDoTakeScreenshot(frame_duration, max_frame_duration)
  end, frame_duration, max_frame_duration)
end
function PhotoObjectCreateAndLoad()
  local obj = PhotoModeObject:new()
  local props = obj:GetProperties()
  if AccountStorage.PhotoMode then
    for _, prop in ipairs(props) do
      local value = AccountStorage.PhotoMode[prop.id]
      if value ~= nil then
        obj:SetProperty(prop.id, value)
      end
    end
  end
  PhotoModeObj = obj
  return obj
end
function OnMsg.AfterLightmodelChange()
  if g_PhotoMode and GetTimeFactor() ~= 0 then
    local lm_name = CurrentLightmodel[1].id or ""
    g_PrePhotoModeStoredVisuals.lightmodel = lm_name ~= "" and lm_name or CurrentLightmodel[1]
  end
end
function GetPhotoModeFilters()
  local filters = {}
  ForEachPreset("PhotoFilterPreset", function(preset, group, filters)
    filters[#filters + 1] = {
      value = preset.id,
      text = preset.displayName
    }
  end, filters)
  return filters
end
function PhotoModeGetPropStep(gamepad_val, mouse_val)
  return GetUIStyleGamepad() and gamepad_val or mouse_val
end
DefineClass.PhotoModeObject = {
  __parents = {
    "PropertyObject"
  },
  properties = {
    {
      name = T(335331914221, "Free Camera"),
      id = "freeCamera",
      editor = "bool",
      default = false,
      dont_save = true
    },
    {
      name = T(915562435389, "Photo Filter"),
      id = "filter",
      editor = "choice",
      default = "None",
      items = GetPhotoModeFilters
    },
    {
      name = T(650173703450, "Motion Blur"),
      id = "frameDuration",
      editor = "number",
      slider = true,
      default = 0,
      min = 0,
      max = 100,
      step = function()
        return PhotoModeGetPropStep(5, 1)
      end,
      dpad_only = true,
      no_edit = true
    },
    {
      name = T(281819101205, "Vignette"),
      id = "vignette",
      editor = "number",
      slider = true,
      default = 0,
      min = 0,
      max = 255,
      scale = 255,
      step = function()
        return PhotoModeGetPropStep(10, 1)
      end,
      dpad_only = true
    },
    {
      name = T(394842812741, "Exposure"),
      id = "exposure",
      editor = "number",
      slider = true,
      default = 0,
      min = -200,
      max = 200,
      step = function()
        return PhotoModeGetPropStep(20, 1)
      end,
      dpad_only = true,
      no_edit = function(obj)
        return hr.EnableAutoExposure == 1
      end
    },
    {
      name = T(394842812741, "Exposure"),
      id = "ae_key_bias",
      editor = "number",
      slider = true,
      default = 0,
      min = -3000000,
      max = 3000000,
      step = function()
        return PhotoModeGetPropStep(100000, 1)
      end,
      dpad_only = true,
      no_edit = function(obj)
        return hr.EnableAutoExposure == 0
      end
    },
    {
      name = T(764862486527, "Fog Density"),
      id = "fogDensity",
      editor = "number",
      slider = true,
      default = 0,
      min = 0,
      max = 1000,
      step = function()
        return PhotoModeGetPropStep(50, 1)
      end,
      dpad_only = true
    },
    {
      name = T(493626846649, "Depth of Field"),
      id = "depthOfField",
      editor = "number",
      slider = true,
      default = 100,
      min = 0,
      max = 100,
      step = 1,
      dpad_only = true
    },
    {
      name = T(775319101921, "Focus Depth"),
      id = "focusDepth",
      editor = "number",
      slider = true,
      default = 0,
      min = 0,
      max = 100,
      step = 1,
      dpad_only = true
    },
    {
      name = T(194124087753, "Defocus Strength"),
      id = "defocusStrength",
      editor = "number",
      slider = true,
      default = 10,
      min = 0,
      max = 100,
      step = 1,
      dpad_only = true
    },
    {
      name = T(462459069592, "Bloom Strength"),
      id = "bloomStrength",
      editor = "number",
      slider = true,
      default = 0,
      min = 0,
      max = 100,
      step = function()
        return PhotoModeGetPropStep(5, 1)
      end,
      dpad_only = true
    },
    {
      name = T(778534179054, "Color"),
      id = "colorSat",
      editor = "number",
      slider = true,
      default = 0,
      min = -100,
      max = 100,
      dpad_only = true
    }
  }
}
function PhotoModeObject:SetProperty(id, value)
  local ret = PropertyObject.SetProperty(self, id, value)
  PhotoModeApply(self, id)
  return ret
end
function PhotoModeObject:ResetProperties()
  for i, prop in ipairs(self:GetProperties()) do
    if not prop.dont_save then
      self:SetProperty(prop.id, nil)
    end
  end
  self:SetProperty("fogDensity", CurrentLightmodel[1].fog_density)
  self:SetProperty("bloomStrength", CurrentLightmodel[1].pp_bloom_strength)
  self:SetProperty("exposure", CurrentLightmodel[1].exposure)
  self:SetProperty("ae_key_bias", CurrentLightmodel[1].ae_key_bias)
  self:SetProperty("colorSat", -CurrentLightmodel[1].desaturation)
  self:SetProperty("vignette", CurrentLightmodel[1].vignette_darken_opacity)
end
function PhotoModeObject:Save()
  AccountStorage.PhotoMode = {}
  local storage_table = AccountStorage.PhotoMode
  for _, prop in ipairs(self:GetProperties()) do
    if not prop.dont_save then
      local value = self:GetProperty(prop.id)
      storage_table[prop.id] = value
    end
  end
  SaveAccountStorage(5000)
end
function PhotoModeObject:Pause()
  Pause(self)
end
function PhotoModeObject:Resume(force)
  Resume(self)
  local lm_name = CurrentLightmodel[1].id or ""
  if (lm_name ~= "" and lm_name or CurrentLightmodel[1]) ~= g_PrePhotoModeStoredVisuals.lightmodel then
    SetLightmodel(1, g_PrePhotoModeStoredVisuals.lightmodel, 0)
  end
end
