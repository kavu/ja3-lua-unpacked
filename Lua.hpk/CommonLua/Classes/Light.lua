DefineClass.LightCCD = {
  __parents = {
    "ComponentCustomData"
  },
  flags = {cfLight = true}
}
function LightCCD:GetLightType()
  return band(self:GetCustomData(9), 7)
end
function LightCCD:SetLightType(type)
  local flags = self:GetCustomData(9)
  flags = maskset(flags, 7, type)
  self:SetCustomData(9, flags)
end
local lightmodel_lights = {
  "A",
  "B",
  "C",
  "D"
}
DefineClass.Light = {
  __parents = {
    "Object",
    "InvisibleObject",
    "ComponentAttach",
    "LightCCD"
  },
  flags = {
    cfConstructible = false,
    gofRealTimeAnim = true,
    efShadow = false,
    efSunShadow = false,
    gofDetailClass0 = true,
    gofDetailClass1 = true
  },
  properties = {
    {
      id = "DetailClass",
      name = "Detail Class",
      editor = "dropdownlist",
      items = {
        "Default",
        "Essential",
        "Optional",
        "Eye Candy"
      },
      default = "Eye Candy"
    },
    {
      category = "Visuals",
      id = "Color",
      editor = "color",
      default = RGB(255, 255, 255),
      autoattach_prop = true,
      dont_save = function(obj)
        if not IsValid(obj) then
          return false
        end
        if obj:GetLightmodelColorIndexNumber() ~= 0 then
          return true
        end
        return false
      end,
      read_only = function(obj)
        if not IsValid(obj) then
          return false
        end
        if obj:GetLightmodelColorIndexNumber() ~= 0 then
          return true
        end
        return false
      end
    },
    {
      category = "Visuals",
      id = "LightmodelColorIndex",
      editor = "set",
      items = lightmodel_lights,
      max_items_in_set = 1,
      default = {},
      autoattach_prop = true
    },
    {
      category = "Visuals",
      id = "OriginalColor",
      editor = "color",
      default = RGB(255, 255, 255),
      no_edit = true,
      dont_save = true
    },
    {
      category = "Visuals",
      id = "Intensity",
      editor = "number",
      default = 100,
      min = 0,
      max = 255,
      slider = true,
      autoattach_prop = true
    },
    {
      category = "Visuals",
      id = "Exterior",
      editor = "bool",
      default = true,
      autoattach_prop = true
    },
    {
      category = "Visuals",
      id = "Interior",
      editor = "bool",
      default = true,
      autoattach_prop = true
    },
    {
      category = "Visuals",
      id = "InteriorAndExteriorWhenHasShadowmap",
      editor = "bool",
      default = true,
      autoattach_prop = true
    },
    {
      category = "Visuals",
      id = "Volume",
      helper = "volume",
      editor = "object",
      default = false,
      base_class = "Volume"
    },
    {
      category = "Visuals",
      id = "ConstantIntensity",
      editor = "number",
      default = 0,
      autoattach_prop = true,
      slider = true,
      max = 127,
      min = -128
    },
    {
      category = "Visuals",
      id = "AttenuationShape",
      editor = "number",
      default = 0,
      autoattach_prop = true,
      slider = true,
      max = 255,
      min = 0
    },
    {
      category = "Visuals",
      id = "CastShadows",
      editor = "bool",
      default = false,
      autoattach_prop = true
    },
    {
      category = "Visuals",
      id = "DetailedShadows",
      editor = "bool",
      default = false,
      autoattach_prop = true
    },
    {
      id = "ColorModifier",
      editor = false
    },
    {id = "Occludes", editor = false},
    {id = "Walkable", editor = false},
    {
      id = "ApplyToGrids",
      editor = false
    },
    {id = "Collision", editor = false},
    {id = "Color1", editor = false},
    {
      id = "ParentSIModulation",
      editor = "number",
      default = 100,
      min = 0,
      max = 255,
      slider = true,
      autoattach_prop = true,
      no_edit = function(o)
        return IsKindOf(o, "CObject")
      end,
      help = "To be used by the AutoAttach system."
    }
  },
  Color = RGB(255, 255, 255),
  Intensity = 100,
  Interior = true,
  Exterior = true,
  InteriorAndExteriorWhenHasShadowmap = true,
  CastShadows = false,
  DetailedShadows = false,
  Init = function(self)
    self:SetColor(self.Color)
    self:SetIntensity(self.Intensity)
    self:SetInterior(self.Interior)
    self:SetExterior(self.Exterior)
    self:SetInteriorAndExteriorWhenHasShadowmap(self.InteriorAndExteriorWhenHasShadowmap)
    self:SetConstantIntensity(0)
    self:SetAttenuationShape(0)
    self:SetLightmodelColorIndex(empty_table)
    self:SetCastShadows(self.CastShadows)
    self:SetDetailedShadows(self.DetailedShadows)
  end,
  SetConstantIntensity = function(self, value)
    value = value + 128 & 255
    local old_data = self:GetCustomData(11)
    self:SetCustomData(11, maskset(old_data, 255, value))
  end,
  GetConstantIntensity = function(self)
    return (self:GetCustomData(11) & 255) - 128
  end,
  SetAttenuationShape = function(self, value)
    local old_data = self:GetCustomData(11)
    self:SetCustomData(11, maskset(old_data, 65280, value << 8))
  end,
  GetAttenuationShape = function(self)
    return (self:GetCustomData(11) & 65280) >> 8
  end,
  SetVolume = function(self, value)
    if value then
      self:SetCustomData(12, value.handle)
    else
      self:SetCustomData(12, 0)
    end
  end,
  GetVolume = function(self)
    local handle = self:GetCustomData(12)
    if not handle or handle == 0 then
      return false
    end
    return HandleToObject[handle]
  end,
  GetCastShadows = function(self)
    return self:GetLightFlags(const.elfCastShadows)
  end,
  SetCastShadows = function(self, cast)
    return self:SetLightFlags(const.elfCastShadows, cast)
  end,
  GetDetailedShadows = function(self)
    return self:GetLightFlags(const.elfDetailedShadows)
  end,
  SetDetailedShadows = function(self, cast)
    return self:SetLightFlags(const.elfDetailedShadows, cast)
  end,
  GetColor = function(self)
    local index = self:GetLightmodelColorIndexNumber()
    if index ~= 0 then
      return GetSceneParam("LightColor" .. index)
    end
    return self:GetColor0()
  end,
  SetColor = function(self, rgb)
    self:SetColor0(rgb)
    self:SetColor1(rgb)
  end,
  GetColor0 = function(self)
    return self:GetColorI(0)
  end,
  SetColor0 = function(self, rgb)
    self:SetColorI(0, rgb)
    self:SetColorModifier(rgb or 0)
  end,
  GetColor1 = function(self)
    return self:GetColorI(1)
  end,
  SetColor1 = function(self, rgb)
    self:SetColorI(1, rgb)
  end,
  GetColorI = function(self, idx)
    local r, g, b = GetRGB(self:GetCustomData(idx))
    return RGB(r, g, b)
  end,
  SetColorI = function(self, idx, value)
    local r, g, b = GetRGB(value or 0)
    local _, _, _, a = GetRGBA(self:GetCustomData(idx))
    self:SetCustomData(idx, RGBA(r, g, b, a))
  end,
  GetExterior = function(self)
    return self:GetLightFlags(const.elfExterior)
  end,
  SetExterior = function(self, val)
    self.Exterior = val
    self:SetLightFlags(const.elfExterior, val)
  end,
  GetInterior = function(self)
    return self:GetLightFlags(const.elfInterior)
  end,
  SetInterior = function(self, val)
    self.Interior = val
    self:SetLightFlags(const.elfInterior, val)
  end,
  GetInteriorAndExteriorWhenHasShadowmap = function(self)
    return self:GetLightFlags(const.elfInteriorAndExteriorWhenHasShadowmap)
  end,
  SetInteriorAndExteriorWhenHasShadowmap = function(self, val)
    self.InteriorAndExteriorWhenHasShadowmap = val
    self:SetLightFlags(const.elfInteriorAndExteriorWhenHasShadowmap, val)
  end,
  SetLightmodelColorIndex = function(self, val)
    local index = 0
    local activated_key = false
    for key, value in pairs(val or empty_table) do
      if value then
        activated_key = key
      end
    end
    if activated_key then
      index = table.find(lightmodel_lights, activated_key)
    end
    local old = self:GetCustomData(9)
    self:SetCustomData(9, maskset(old, 7 << const.elfColorIndexShift, index << const.elfColorIndexShift))
  end,
  GetLightmodelColorIndexNumber = function(self)
    local index = self:GetCustomData(9) >> const.elfColorIndexShift & 7
    return index
  end,
  GetLightmodelColorIndex = function(self)
    local index = self:GetLightmodelColorIndexNumber()
    if index == 0 then
      return {}
    end
    return {
      [lightmodel_lights[index]] = true
    }
  end,
  GetIntensity = function(self)
    return self:GetIntensity0()
  end,
  SetIntensity = function(self, value)
    self:SetIntensity0(value)
    self:SetIntensity1(value)
  end,
  GetIntensity0 = function(self)
    return self:GetIntensityI(0)
  end,
  SetIntensity0 = function(self, value)
    self:SetIntensityI(0, value)
  end,
  GetIntensity1 = function(self)
    return self:GetIntensityI(1)
  end,
  SetIntensity1 = function(self, value)
    self:SetIntensityI(1, value)
  end,
  GetIntensityI = function(self, idx)
    local _, _, _, a = GetRGBA(self:GetCustomData(idx))
    return a
  end,
  SetIntensityI = function(self, idx, value)
    local r, g, b = GetRGB(self:GetCustomData(idx))
    self:SetCustomData(idx, RGBA(r, g, b, value or 0))
  end,
  GetAlwaysRenderable = function(self)
    return self:GetGameFlags(const.gofAlwaysRenderable)
  end,
  SetAlwaysRenderable = function(self, value)
    if value == true then
      self:SetGameFlags(const.gofAlwaysRenderable)
    else
      self:ClearGameFlags(const.gofAlwaysRenderable)
    end
  end,
  GetLightFlags = function(self, mask)
    return band(self:GetCustomData(9), mask) == mask
  end,
  SetLightFlags = function(self, mask, bSet)
    local flags = self:GetCustomData(9)
    if bSet then
      self:SetCustomData(9, FlagSet(flags, mask))
    else
      self:SetCustomData(9, FlagClear(flags, mask))
    end
  end,
  GetTimes = function(self)
    return self:GetCustomData(5), self:GetCustomData(6)
  end,
  SetTimes = function(self, time0, time1)
    self:SetCustomData(5, time0)
    self:SetCustomData(6, time1)
  end,
  SetBehavior = function(self, b)
    self:SetLightFlags(const.elfFlicker, b == "flicker")
  end,
  CurrTime = function(self)
    if self:GetGameFlags(const.gofRealTimeAnim) > 0 then
      return RealTime()
    end
    return GameTime()
  end,
  Fade = function(self, color, intensity, time)
    self:SetBehavior("fade")
    self:SetTimes(self:CurrTime(), self:CurrTime() + time)
    self:SetColor0(self:GetColor1())
    self:SetColor1(color)
    self:SetIntensity0(self:GetIntensity1())
    self:SetIntensity1(intensity)
  end,
  Flicker = function(self, color, intensity, period, phase)
    self:SetBehavior("flicker")
    phase = self:CurrTime() - (phase or AsyncRand(period))
    self:SetTimes(phase, phase + period * 300)
    self:SetColor(color)
    self:SetIntensity0(0)
    self:SetIntensity1(intensity)
  end,
  Steady = function(self, color, intensity)
    self:SetColor(color)
    self:SetBehavior("fade")
    self:SetTimes(-1, -1)
    self:SetIntensity(intensity)
  end,
  SetParentSIModulation = function(self, value)
    local parent = self:GetParent()
    if parent then
      parent:SetSIModulation(value)
    end
  end,
  GetParentSIModulation = function(self)
    local parent = self:GetParent()
    if parent then
      return parent:GetSIModulation()
    end
    return 100
  end,
  SetContourOuterID = empty_func
}
function Light:OnEditorSetProperty(prop_id)
  if prop_id == "DetailClass" then
    self:DestroyRenderObj()
  end
end
const.ShadowDirsComboItems = {
  [IndexOfHighestSetBit(const.eLightDirX) + 1] = {name = "+X"},
  [IndexOfHighestSetBit(const.eLightDirNegX) + 1] = {name = "-X"},
  [IndexOfHighestSetBit(const.eLightDirY) + 1] = {name = "+Y"},
  [IndexOfHighestSetBit(const.eLightDirNegY) + 1] = {name = "-Y"},
  [IndexOfHighestSetBit(const.eLightDirZ) + 1] = {name = "+Z"},
  [IndexOfHighestSetBit(const.eLightDirNegZ) + 1] = {name = "-Z"}
}
local shadowDirsDefault = 0
DefineClass.PointLight = {
  __parents = {"Light"},
  entity = "PointLight",
  properties = {
    {
      category = "Visuals",
      id = "SourceRadius",
      name = "Source Radius (cm)",
      editor = "number",
      min = guic,
      max = 20 * guim,
      default = 10 * guic,
      scale = guic,
      slider = true,
      helper = "sradius",
      color = RGB(200, 200, 0),
      autoattach_prop = true
    },
    {
      category = "Visuals",
      id = "AttenuationRadius",
      name = "Attenuation Radius",
      editor = "number",
      min = 0 * guim,
      max = 500 * guim,
      default = 10 * guim,
      scale = "m",
      slider = true,
      helper = "sradius",
      color = RGB(255, 0, 0),
      autoattach_prop = true
    },
    {
      category = "Visuals",
      id = "ShadowDirs",
      name = "Shadow Dirs (To disable)",
      editor = "flags",
      items = const.ShadowDirsComboItems,
      default = shadowDirsDefault,
      size = 6,
      autoattach_prop = true
    }
  },
  ShadowDirsDefault = shadowDirsDefault,
  SourceRadius = 1 * guic,
  AttenuationRadius = 10 * guim,
  Init = function(self)
    self:SetSourceRadius(self.SourceRadius)
    self:SetAttenuationRadius(self.AttenuationRadius)
    self:SetLightType(const.eLightTypePoint)
    self:SetShadowDirs(shadowDirsDefault)
  end,
  SetSourceRadius = function(self, r)
    self:SetCustomData(3, r)
  end,
  GetSourceRadius = function(self, r)
    return self:GetCustomData(3)
  end,
  SetAttenuationRadius = function(self, r)
    self:SetCustomData(4, r)
  end,
  GetAttenuationRadius = function(self, r)
    return self:GetCustomData(4)
  end,
  SetShadowDirs = function(self, dirs)
    self:SetCustomData(7, dirs)
  end,
  GetShadowDirs = function(self)
    return self:GetCustomData(7)
  end
}
DefineClass.LightFlicker = {
  __parents = {"InitDone"},
  entity = "PointLight",
  properties = {
    {id = "Color", editor = false},
    {id = "Intensity", editor = false},
    {
      category = "Visuals",
      id = "Color0",
      editor = "color",
      default = RGB(255, 255, 255),
      autoattach_prop = true
    },
    {
      category = "Visuals",
      id = "Intensity0",
      editor = "number",
      default = 0,
      min = 0,
      max = 255,
      slider = true,
      autoattach_prop = true
    },
    {
      category = "Visuals",
      id = "Color1",
      editor = "color",
      default = RGB(255, 255, 255),
      autoattach_prop = true
    },
    {
      category = "Visuals",
      id = "Intensity1",
      editor = "number",
      default = 100,
      min = 0,
      max = 255,
      slider = true,
      autoattach_prop = true
    },
    {
      category = "Visuals",
      id = "Period",
      editor = "number",
      default = 500,
      min = 0,
      max = 100000,
      scale = 1000,
      slider = true,
      autoattach_prop = true
    }
  },
  Period = 40000
}
function LightFlicker:Init()
  self:SetBehavior("flicker")
  self:SetColor(self.Color)
  self:SetIntensity0(0)
  self:SetIntensity1(self.Intensity)
  self:SetPeriod(self.Period)
end
function LightFlicker:GetPeriod()
  local t0, t1 = self:GetTimes()
  return t1 - t0
end
function LightFlicker:SetPeriod(period)
  period = Max(period, 1)
  local phase = AsyncRand(period)
  local time = self:CurrTime()
  if phase > self:CurrTime() then
    self:SetTimes(0, period)
  else
    self:SetTimes(time - phase, time - phase + period)
  end
end
DefineClass.PointLightFlicker = {
  __parents = {
    "PointLight",
    "LightFlicker"
  }
}
DefineClass.SpotLightFlicker = {
  __parents = {
    "SpotLight",
    "LightFlicker"
  }
}
DefineClass.MaskedLight = {
  __parents = {"Light"},
  properties = {
    {
      category = "Visuals",
      id = "Mask",
      editor = "browse",
      folder = "Textures/Misc/LightMasks",
      help = "Specifies the texture that is going to be applied to modify the light appearance"
    },
    {
      category = "Visuals",
      id = "AnimX",
      editor = "number",
      min = 1,
      max = 16,
      help = "How many cuts on the X axis are specified in the mask texture. The animation is traversed left to right."
    },
    {
      category = "Visuals",
      id = "AnimY",
      editor = "number",
      min = 1,
      max = 16,
      help = "How many cuts on the Y axis are specified in the mask texture. The animation is traversed top to bottom."
    },
    {
      category = "Visuals",
      id = "AnimPeriod",
      editor = "number",
      min = 0,
      max = 256,
      scale = 10,
      help = "The period of the animation. If zero is specified, the animation is not applied."
    },
    {
      category = "Visuals",
      id = "ScaleMask",
      editor = "bool",
      default = false
    }
  },
  Mask = "Textures/Misc/LightMasks/angle-attn.tga",
  ScaleMask = false,
  AnimX = 1,
  AnimY = 1,
  AnimPeriod = 256,
  Init = function(self)
    self:SetMask(self.Mask)
    self:SetScaleMask(self.ScaleMask)
    self:SetAnimX(self.AnimX)
    self:SetAnimY(self.AnimY)
    self:SetAnimPeriod(self.AnimPeriod)
  end,
  GetScaleMask = function(self)
    return self:GetLightFlags(const.elfScaleMask)
  end,
  SetScaleMask = function(self, scale)
    self:SetLightFlags(const.elfScaleMask, scale)
  end,
  GetAnim = function(self, nshift)
    local flags = self:GetCustomData(2)
    local anim_size = band(shift(flags, -nshift), const.elAnimMask) + 1
    return anim_size
  end,
  SetAnim = function(self, nshift, num)
    local flags = self:GetCustomData(2)
    local new_data = maskset(flags, shift(const.elAnimMask, nshift), shift(num - 1, nshift))
    self:SetCustomData(2, new_data)
  end,
  GetAnimX = function(self)
    return self:GetAnim(const.elAnimXShift)
  end,
  SetAnimX = function(self, num)
    self:SetAnim(const.elAnimXShift, num)
  end,
  GetAnimY = function(self)
    return self:GetAnim(const.elAnimYShift)
  end,
  SetAnimY = function(self, num)
    self:SetAnim(const.elAnimYShift, num)
  end,
  GetMask = _GetCustomString,
  SetMask = _SetCustomString,
  GetAnimPeriod = function(self)
    return shift(band(self:GetCustomData(2), const.elAnimPeriodMask), -const.elAnimPeriodShift)
  end,
  SetAnimPeriod = function(self, period)
    local params = self:GetCustomData(2)
    local new_params = maskset(params, const.elAnimPeriodMask, shift(period, const.elAnimPeriodShift))
    self:SetCustomData(2, new_params)
  end
}
DefineClass.BoxLight = {
  __parents = {
    "MaskedLight"
  },
  entity = "PointLight",
  properties = {
    {
      category = "Visuals",
      id = "BoxWidth",
      editor = "number",
      min = guim / 10,
      max = 50 * guim,
      default = 5 * guim,
      slider = true,
      helper = "box3"
    },
    {
      category = "Visuals",
      id = "BoxHeight",
      editor = "number",
      min = guim / 10,
      max = 50 * guim,
      default = 5 * guim,
      slider = true,
      helper = "box3"
    },
    {
      category = "Visuals",
      id = "BoxDepth",
      editor = "number",
      min = guim / 10,
      max = 50 * guim,
      default = 8 * guim,
      slider = true,
      helper = "box3"
    }
  },
  BoxWidth = 5 * guim,
  BoxHeight = 5 * guim,
  BoxDepth = 5 * guim,
  Init = function(self)
    self:SetBoxWidth(self.BoxWidth)
    self:SetBoxHeight(self.BoxHeight)
    self:SetBoxDepth(self.BoxDepth)
    self:SetLightType(const.eLightTypeBox)
  end,
  GetBoxWidth = function(self)
    return self:GetCustomData(3)
  end,
  SetBoxWidth = function(self, v)
    self:SetCustomData(3, v)
  end,
  GetBoxHeight = function(self)
    return self:GetCustomData(4)
  end,
  SetBoxHeight = function(self, v)
    self:SetCustomData(4, v)
  end,
  GetBoxDepth = function(self)
    return self:GetCustomData(8)
  end,
  SetBoxDepth = function(self, v)
    self:SetCustomData(8, v)
  end
}
DefineClass.SpotLight = {
  __parents = {
    "PointLight",
    "MaskedLight"
  },
  entity = "PointLight",
  properties = {
    {
      category = "Visuals",
      id = "ConeInnerAngle",
      editor = "number",
      min = 5,
      max = 175,
      default = 45,
      slider = true,
      helper = "spotlighthelper",
      autoattach_prop = true
    },
    {
      category = "Visuals",
      id = "ConeOuterAngle",
      editor = "number",
      min = 5,
      max = 175,
      default = 45,
      slider = true,
      helper = "spotlighthelper",
      autoattach_prop = true
    }
  },
  ConeInnerAngle = 45,
  ConeOuterAngle = 90,
  target_helper = false,
  Init = function(self)
    self:SetConeInnerAngle(self.ConeInnerAngle)
    self:SetConeOuterAngle(self.ConeOuterAngle)
    self:SetLightType(const.eLightTypeSpot)
  end,
  GetConeInnerAngle = function(self)
    return self:GetCustomData(8)
  end,
  GetConeOuterAngle = function(self)
    return self:GetCustomData(10)
  end
}
if Platform.developer then
  function SpotLight:SetConeInnerAngle(v)
    self:SetCustomData(8, v)
    if v > self:GetConeOuterAngle() then
      self:SetCustomData(10, v)
    end
  end
  function SpotLight:SetConeOuterAngle(v)
    self:SetCustomData(10, v)
    if v < self:GetConeInnerAngle() then
      self:SetCustomData(8, v)
    end
  end
else
  function SpotLight:SetConeInnerAngle(v)
    self:SetCustomData(8, v)
  end
  function SpotLight:SetConeOuterAngle(v)
    self:SetCustomData(10, v)
  end
end
function SpotLight:OnEditorSetProperty(...)
  Light.OnEditorSetProperty(self, ...)
  PropertyHelpers_UpdateAllHelpers(self)
end
function SpotLight:ConfigureTargetHelper()
  if not self.target_helper or not IsValid(self.target_helper) then
    self.target_helper = PlaceObject("SpotHelper")
    self.target_helper.obj = self
  end
  local axis = self:GetOrientation()
  local pos = self:GetVisualPos()
  local o, closest, normal = IntersectSegmentWithClosestObj(pos, pos - axis * guim)
  if closest and normal and o ~= self.target_helper then
    self.target_helper:SetPos(closest)
  else
    local newPos = terrain.IntersectRay(pos, pos + axis)
    if newPos then
      self.target_helper:SetPos(newPos:SetZ(const.InvalidZ))
    end
  end
end
function OnMsg.EditorSelectionChanged(objs)
  local isSpotLight = false
  for _, obj in ipairs(objs) do
    if obj.class == "SpotLight" then
      isSpotLight = true
      obj:ConfigureTargetHelper()
    elseif obj.class == "SpotHelper" then
      isSpotLight = true
    end
  end
  if not isSpotLight then
    MapForEach(true, "SpotHelper", function(spot_helper)
      DoneObject(spot_helper)
    end)
  end
end
function OnMsg.EditorCallback(id, objects, ...)
  if id == "EditorCallbackMove" or id == "EditorCallbackRotate" or id == "EditorCallbackPlace" then
    for _, obj in ipairs(objects) do
      if obj.class == "SpotLight" then
        obj:ConfigureTargetHelper()
      end
    end
    if id == "EditorCallbackMove" then
      for _, obj in ipairs(objects) do
        if obj.class == "SpotHelper" and obj.obj.class == "SpotLight" then
          obj.obj:SetOrientation(Normalize(obj.obj:GetVisualPos() - obj:GetVisualPos()), 0)
        end
      end
    end
  elseif id == "EditorCallbackDelete" then
    for _, obj in ipairs(objects) do
      if obj.class == "SpotLight" then
        DoneObject(obj.target_helper)
        obj.target_helper = false
      end
    end
  end
end
if Platform.developer and false then
  function OnMsg.NewMapLoaded()
    local masks = {}
    MapForEach("map", "Light", function(light)
      if light:HasMember("GetMask") then
        masks[light:GetMask()] = true
      end
    end)
    for mask, _ in pairs(masks) do
      local id = ResourceManager.GetResourceID(mask)
      if id == const.InvalidResourceID then
        printf("once", "Light mask texture '%s' is not present", mask)
      end
    end
  end
end
function PointLight:ConfigureInvisibleObjectHelper(helper)
  if not helper then
    return
  end
  local important = self:GetDetailClass() == "Essential"
  helper:SetScale(important and 100 or 60)
  if important then
    helper:SetColorModifier(self:GetCastShadows() and RGB(100, 10, 10) or RGB(20, 80, 100))
  else
    helper:SetColorModifier(self:GetCastShadows() and RGB(100, 30, 30) or RGB(40, 80, 100))
  end
end
DefineClass.AttachLightPropertyObject = {
  __parents = {
    "PropertyObject"
  },
  properties = {
    {
      category = "Lights",
      id = "AttachLight",
      name = "Attach Light",
      editor = "bool",
      default = true
    }
  }
}
local detail_class_weight = {
  Essential = 1,
  Optional = 2,
  ["Eye Candy"] = 3
}
function GetLights(filter)
  if GetMap() == "" then
    return
  end
  local lights = MapGet("map", "Light", const.efVisible, filter) or empty_table
  table.sort(lights, function(light1, light2)
    local weight1 = detail_class_weight[light1:GetDetailClass()] or 4
    local weight2 = detail_class_weight[light2:GetDetailClass()] or 4
    if weight1 == weight2 then
      return light1.handle < light2.handle
    else
      return weight1 < weight2
    end
  end)
  return lights
end
if Platform.developer then
  function Light:SetCastShadows(cast)
    self:SetLightFlags(const.elfCastShadows, cast)
    self:ConfigureInvisibleObjectHelper(self:GetAttach("InvisibleObjectHelper"))
  end
  if FirstLoad then
    DbgClusterCameraPos = false
    DbgClusterCameraLookAt = false
    StatsLightShadowsThread = false
  end
  function DBGLightsShowFirstLight(store_camera)
    CreateRealTimeThread(function()
      if store_camera then
        DbgClusterCameraPos, DbgClusterCameraLookAt = cameraMax.GetPosLookAt()
      else
        cameraMax.SetCamera(DbgClusterCameraPos, DbgClusterCameraLookAt)
        WaitNextFrame(10)
      end
      DbgClearVectors()
      hr.DbgAutoClearLimit = 20000
      hr.LightsClusterWireframe = 3
    end)
  end
  function HideLightShadowsStats()
    hr.LightShadowsGOStatistics = 0
    if IsValidThread(StatsLightShadowsThread) then
      DeleteThread(StatsLightShadowsThread)
      MapForEach("map", "Light", function(light)
        local text = rawget(light, "StatsText")
        if text ~= nil then
          text:Detach()
          text:delete()
          rawset(light, "StatsText", nil)
        end
      end)
    end
    StatsLightShadowsThread = false
  end
  function ShowLightShadowsStats(frequency)
    HideLightShadowsStats()
    hr.LightShadowsGOStatistics = 1
    StatsLightShadowsThread = CreateRealTimeThread(function()
      local prev_frame = GetRenderFrame() - 1
      while true do
        local curr_frame = GetRenderFrame()
        local frames = curr_frame - prev_frame
        prev_frame = curr_frame
        local lights = GetLights()
        for _, light in ipairs(lights) do
          if rawget(light, "StatsText") == nil then
            local text = Text:new({hide_in_editor = false})
            rawset(light, "StatsText", text)
            light:Attach(text)
          end
          if light:GetCastShadows() then
            local rops_per_frame = DivRound(light:GetCustomData(13), Max(frames, 1))
            local polygons_per_frame = DivRound(light:GetCustomData(14), Max(frames, 1))
            light:SetCustomData(13, 0)
            light:SetCustomData(14, 0)
            light.StatsText:SetText(string.format([[
%s(%s)%s
%d Objects/frame
%d Polygons/frame
]], light.class, light:GetDetailClass(), light:GetDetailClass() == "Optional" and "[Visible due to CastShadow=true]" or "", rops_per_frame, polygons_per_frame))
            if 5000 < rops_per_frame or 300000 < polygons_per_frame then
              light.StatsText:SetColor(const.clrRed)
            elseif 2000 < rops_per_frame or 100000 < polygons_per_frame then
              light.StatsText:SetColor(const.clrYellow)
            else
              light.StatsText:SetColor(const.clrGreen)
            end
          else
            light.StatsText:SetText(string.format([[
%s(%s)
No Shadow]], light.class, light:GetDetailClass()))
            light.StatsText:SetColor(const.clrGreen)
          end
        end
        Sleep(frequency)
      end
    end)
  end
  if FirstLoad then
    g_LightSelected = false
    g_CapturedScreenLights = false
  end
  function CaptureScreenLights(clear)
    if clear then
      g_CapturedScreenLights = false
      print("Captured Lights on Screen cleared")
      return
    end
    g_CapturedScreenLights = GatherObjectsInScreenRect(point20, point(GetResolution()), "Light")
    print(string.format("Captured %d/%d Lights on Screen", #g_CapturedScreenLights, #GetLights()))
  end
  function ViewNextLight(dir, screen_lights)
    local lights = screen_lights and (g_CapturedScreenLights or empty_table) or GetLights()
    if #lights == 0 then
      return
    end
    g_LightSelected = (g_LightSelected or 0) + dir
    if g_LightSelected > #lights then
      g_LightSelected = 1
    elseif g_LightSelected < 1 then
      g_LightSelected = #lights
    end
    local light = lights[g_LightSelected]
    if not screen_lights then
      ViewObject(light)
    end
    editor.ClearSel()
    editor.AddObjToSel(light)
    ViewObject(light)
    print(string.format("%sLight(%s-%s) %d/%d", screen_lights and "Screen " or "", light.class, light:GetDetailClass(), g_LightSelected, #lights))
  end
  function OnMsg.NewMapLoaded()
    g_LightSelected = false
    g_CapturedScreenLights = false
  end
end
