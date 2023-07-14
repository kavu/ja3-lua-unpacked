DefineClass.BaseLightObject = {
  __parents = {"CObject"}
}
function BaseLightObject:UpdateLight(lm, delayed)
end
DefineClass.LightObject = {
  __parents = {
    "ComponentAttach",
    "EditorCallbackObject",
    "BaseLightObject"
  },
  flags = {cofComponentSound = true},
  properties = {
    {
      category = "Visuals",
      name = "Night mode",
      id = "night_mode",
      editor = "dropdownlist",
      items = {
        "Off",
        "On",
        "HaloOnly",
        "Random"
      },
      default = "On"
    },
    {
      category = "Visuals",
      name = "Day mode",
      id = "day_mode",
      editor = "dropdownlist",
      items = {
        "Off",
        "On",
        "HaloOnly",
        "Random"
      },
      default = "Off"
    },
    {
      category = "Visuals",
      id = "Radius",
      editor = "range",
      min = 0 * guim,
      max = 30 * guim,
      helper = "srange",
      color = RGB(255, 50, 50),
      color2 = RGB(50, 50, 255),
      scale = "m"
    },
    {
      category = "Visuals",
      id = "Intensity",
      editor = "number",
      default = 100,
      min = 0,
      max = 200,
      slider = true
    },
    {id = "StateText", editor = false}
  },
  light_color = "",
  light_class = "PointLight",
  light_offset = false,
  light_halo_class = "Halo",
  light_halo_offset = false,
  lit_state = "idle",
  light_obj = false,
  light_halo_obj = false,
  light_sound = false,
  light_sound_thread = false,
  CastShadow = true,
  FadeTime = 5000,
  Radius = range(5 * guim, 7 * guim),
  ConeAngle = 45,
  Mask = false,
  ScaleMask = false,
  Period = 100,
  FlickerIntensity = 50,
  BoxWidth = 5 * guim,
  BoxHeight = 5 * guim,
  BoxDepth = 5 * guim
}
function LightObject:AdjustHelpers()
  if not self.light_offset then
    return
  end
  local helpers = PropertyHelpers[self]
  if not helpers then
    return
  end
  local radius = helpers.Radius
  if not radius then
    return
  end
  local scale = self:GetScale()
  radius.sphere_from.sphere:SetAttachOffset(MulDivTrunc(self.light_offset, scale, 100))
  radius.sphere_to.sphere:SetAttachOffset(MulDivTrunc(self.light_offset, scale, 100))
end
function LightObject:GetCastShadow()
  return self.CastShadow
end
function LightObject:SetCastShadow(value)
  self.CastShadow = value
end
function LightObject:GetRadius()
  return self.Radius
end
function LightObject:SetRadius(value)
  self.Radius = value
end
function LightObject:CopyProperties(source, properties)
  PropertyObject.CopyProperties(self, source, properties)
  if LightmodelOverride or CurrentLightmodel[1] then
    self:UpdateLight(LightmodelOverride or CurrentLightmodel[1])
  end
end
function LightObject:PostLoad()
  self:UpdateLight(CurrentLightmodel[1])
end
function LightObject:EditorCallbackPlace()
  self:UpdateLight(CurrentLightmodel[1])
end
function LightObject:EditorCallbackClone()
  self:UpdateLight(CurrentLightmodel[1])
end
if FirstLoad then
  EditorForceNight = false
end
function ToggleEditorForceNight()
  EditorForceNight = not EditorForceNight
  MapForEach("map", "LightObject", function(x)
    x:UpdateLight(CurrentLightmodel[1])
  end)
end
function LightObject:IsLit(lm)
  if not lm then
    return
  end
  local mode = (lm.night or EditorForceNight) and self.night_mode or self.day_mode
  local light_on = mode == "On" or mode == "Random" and AsyncRand(100) < config.RandLightsPerc
  local halo_on = light_on or mode == "HaloOnly"
  return light_on, halo_on
end
local CreateHalo = function(class)
  if IsParticleSystem(class) then
    return PlaceParticles(class, nil, const.cofComponentAttach)
  else
    return PlaceObject(class, nil, const.cofComponentAttach)
  end
end
local LightObject_UpdateLightProps = {
  "night_mode",
  "day_mode",
  "Radius",
  "Intensity",
  "CastShadow"
}
function LightObject:OnEditorSetProperty(prop_id, old_value)
  if table.find(LightObject_UpdateLightProps, prop_id) then
    self:UpdateLight(CurrentLightmodel[1])
  end
end
local black = RGB(0, 0, 0)
function LightObject:UpdateLight(lm, delayed)
  local color = GetLightmodelColor(lm, self.light_color)
  local light_on, halo_on = self:IsLit(lm)
  local scale = self:GetScale()
  self:SetState((light_on or halo_on) and self.lit_state or "idle")
  if light_on and color ~= black then
    local light_class = self.light_class
    local light = self.light_obj
    if not IsValid(light) then
      light = PlaceObject(light_class, {Color = 0}, const.cofComponentAttach)
      light:SetScale(scale)
      self:Attach(light, self:GetRandomSpot("Light"))
      if self.light_offset then
        light:SetAttachOffset(MulDivTrunc(self.light_offset, scale, 100))
      end
      self.light_obj = light
    end
    if light:IsKindOf("PointLight") then
      light:SetRadius(self.Radius or range(self.MinRadius, self.MaxRadius))
      if light:IsKindOf("LightFlicker") then
        light:Flicker(color, self.Intensity, self.Period)
        light:SetIntensity0(self.FlickerIntensity)
      end
    end
    if light:IsKindOf("MaskLight") then
      light:SetMask(self.Mask)
      light:SetScaleMask(self.ScaleMask)
      if light:IsKindOf("SpotLight") then
        light:SetConeAngle(self.ConeAngle)
      end
      if light:IsKindOf("BoxLight") then
        light:SetBoxWidth(self.BoxWidth)
        light:SetBoxHeight(self.BoxHeight)
        light:SetBoxDepth(self.BoxDepth)
      end
    end
    if not light:IsKindOf("LightFlicker") then
      if delayed then
        light:SetIntensity(0)
        light:Fade(color, self.Intensity, self.FadeTime)
      else
        light:SetIntensity(self.Intensity)
        light:SetColor(color)
      end
    end
  elseif self.light_obj then
    DoneObject(self.light_obj)
    self.light_obj = nil
  end
  if not self.CastShadow or self.light_obj and self.Shadow then
    self:ClearEnumFlags(const.efShadow)
  else
    self:SetEnumFlags(const.efShadow)
  end
  if halo_on then
    if not self.light_halo_obj then
      self.light_halo_obj = {}
      local first, last
      if self:HasSpot("Halo") then
        first, last = self:GetSpotRange("Halo")
      else
        first, last = self:GetSpotRange("Origin")
      end
      for i = first, last do
        local h = CreateHalo(self.light_halo_class)
        if h then
          h:SetScale(scale)
          self:Attach(h, i)
          if self.light_halo_offset then
            h:SetAttachOffset(MulDivTrunc(self.light_halo_offset, scale, 100))
          end
          self.light_halo_obj[1 + #self.light_halo_obj] = h
        end
      end
      if self.light_sound and not self.light_sound_thread then
        self.light_sound_thread = CreateGameTimeThread(function(self)
          Sleep(1000 + AsyncRand(1000))
          self.light_sound_thread = nil
          if IsValid(self) and self.light_halo_obj then
            self:SetSound(self.light_sound, 1000, 0)
          end
        end, self)
      end
    end
  elseif self.light_halo_obj then
    DoneObjects(self.light_halo_obj)
    self.light_halo_obj = false
    if self.light_sound then
      self:StopSound(1000)
    end
  end
end
DefineClass.LightmodelLight = {
  __parents = {
    "Light",
    "BaseLightObject"
  },
  light_color = ""
}
function LightmodelLight:Init()
  self:UpdateLight(CurrentLightmodel[1])
end
function LightmodelLight:UpdateLight(lm, delayed)
  self:SetColor(GetLightmodelColor(lm, self.light_color))
end
DefineClass.LightHaloBase = {
  __parents = {
    "CObject",
    "ComponentAttach",
    "ComponentExtraTransform"
  },
  flags = {efSunShadow = false, efShadow = false},
  orient_mode = const.soFacing,
  orient_mode_bias = -50 * guic,
  distortion_scale = 300,
  tex_scroll_time = 6000,
  properties = {
    {
      id = "UseFacing",
      name = "Use facing",
      default = false,
      editor = "bool",
      help = "Let object use facing, specified in its class"
    }
  }
}
function LightHaloBase:new(...)
  local obj = CObject.new(self, ...)
  obj:SetUseFacing(true)
  return obj
end
function LightHaloBase:SetUseFacing(value)
  self:SetSpecialOrientation(value and self.orient_mode, value and self.orient_mode_bias)
end
function LightHaloBase:GetUseFacing()
  return self:GetSpecialOrientation() == self.orient_mode
end
DefineClass.Halo = {
  __parents = {
    "LightHaloBase"
  }
}
if FirstLoad then
  UpdateLightsThread = false
end
function OnMsg.DoneMap()
  UpdateLightsThread = false
end
function UpdateLights(lm, delayed)
  MapForEach("map", "BaseLightObject", function(obj, lm, delayed)
    obj:UpdateLight(lm, delayed)
  end, lm, delayed)
end
function UpdateLightsDelayed(lm, delayed_time)
  DeleteThread(UpdateLightsThread)
  UpdateLightsThread = false
  if 0 < delayed_time then
    UpdateLightsThread = CreateGameTimeThread(function(lm, delayed_time)
      Sleep(delayed_time)
      UpdateLights(lm, true)
      UpdateLightsThread = false
    end, lm, delayed_time)
  else
    UpdateLights(lm)
  end
end
function OnMsg.LightmodelChange(view, lm, time)
  UpdateLightsDelayed(lm, time / 2)
end
