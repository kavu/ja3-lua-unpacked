GameDisabledOptions = {}
if FirstLoad then
  OptionsObj = false
  OptionsObjOriginal = false
  OptionFixups = {}
end
g_PlayStationControllerText = T(521078061184, "Controller")
g_PlayStationWirelessControllerText = T(424526275353, "Wireless Controller")
if config.DisableOptions then
  return
end
MapVar("g_SessionOptions", {})
DefineClass.OptionsObject = {
  __parents = {
    "PropertyObject"
  },
  shortcuts = false,
  props_cache = false,
  fixups_meta = false,
  properties = {
    {
      name = T(590606477665, "Preset"),
      id = "VideoPreset",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().VideoPreset
    },
    {
      name = T(864821413961, "Antialiasing"),
      id = "Antialiasing",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Antialiasing
    },
    {
      name = T(809013434667, "Resolution Percent"),
      id = "ResolutionPercent",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().ResolutionPercent
    },
    {
      name = T(964510417589, "Shadows"),
      id = "Shadows",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Shadows
    },
    {
      name = T(940888056560, "Textures"),
      id = "Textures",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Textures
    },
    {
      name = T(946251115875, "Anisotropy"),
      id = "Anisotropy",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Anisotropy
    },
    {
      name = T(871664438848, "Terrain"),
      id = "Terrain",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Terrain
    },
    {
      name = T(318842515247, "Effects"),
      id = "Effects",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Effects
    },
    {
      name = T(484841493487, "Lights"),
      id = "Lights",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Lights
    },
    {
      name = T(682371259474, "Postprocessing"),
      id = "Postprocess",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Postprocess
    },
    {
      name = T(668281727636, "Bloom"),
      id = "Bloom",
      category = "Video",
      storage = "local",
      editor = "bool",
      on_value = "On",
      off_value = "Off",
      default = GetDefaultEngineOptions().Bloom
    },
    {
      name = T(886248401356, "Eye Adaptation"),
      id = "EyeAdaptation",
      category = "Video",
      storage = "local",
      editor = "bool",
      on_value = "On",
      off_value = "Off",
      default = GetDefaultEngineOptions().EyeAdaptation
    },
    {
      name = T(281819101205, "Vignette"),
      id = "Vignette",
      category = "Video",
      storage = "local",
      editor = "bool",
      on_value = "On",
      off_value = "Off",
      default = GetDefaultEngineOptions().Vignette
    },
    {
      name = T(364284725511, "Chromatic Aberration"),
      id = "ChromaticAberration",
      category = "Video",
      storage = "local",
      editor = "bool",
      on_value = "On",
      off_value = "Off",
      default = GetDefaultEngineOptions().ChromaticAberration
    },
    {
      name = T(739108258248, "SSAO"),
      id = "SSAO",
      category = "Video",
      storage = "local",
      editor = "bool",
      on_value = "On",
      off_value = "Off",
      default = GetDefaultEngineOptions().SSAO
    },
    {
      name = T(743968865763, "Reflections"),
      id = "SSR",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().SSR
    },
    {
      name = T(799060022637, "View Distance"),
      id = "ViewDistance",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().ViewDistance
    },
    {
      name = T(595681486860, "Object Detail"),
      id = "ObjectDetail",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().ObjectDetail
    },
    {
      name = T(717555024369, "Framerate Counter"),
      id = "FPSCounter",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().FPSCounter
    },
    {
      name = T(489981061317, "Sharpness"),
      id = "Sharpness",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Sharpness
    },
    {
      name = T(723387039210, "Master Volume"),
      id = "MasterVolume",
      category = "Audio",
      storage = "local",
      editor = "number",
      min = 0,
      max = const.MasterMaxVolume or 1000,
      slider = true,
      default = GetDefaultEngineOptions().MasterVolume,
      step = (const.MasterMaxVolume or 1000) / 100
    },
    {
      name = T(490745782890, "Music"),
      id = "Music",
      category = "Audio",
      storage = "local",
      editor = "number",
      min = 0,
      max = const.MusicMaxVolume or 600,
      slider = true,
      default = GetDefaultEngineOptions().Music,
      step = (const.MusicMaxVolume or 600) / 100,
      no_edit = function()
        return not IsSoundOptionEnabled("Music")
      end
    },
    {
      name = T(397364000303, "Voice"),
      id = "Voice",
      category = "Audio",
      storage = "local",
      editor = "number",
      min = 0,
      max = const.VoiceMaxVolume or 1000,
      slider = true,
      default = GetDefaultEngineOptions().Voice,
      step = (const.VoiceMaxVolume or 1000) / 100,
      no_edit = function()
        return not IsSoundOptionEnabled("Voice")
      end
    },
    {
      name = T(163987433981, "Sounds"),
      id = "Sound",
      category = "Audio",
      storage = "local",
      editor = "number",
      min = 0,
      max = const.SoundMaxVolume or 1000,
      slider = true,
      default = GetDefaultEngineOptions().Sound,
      step = (const.SoundMaxVolume or 1000) / 100,
      no_edit = function()
        return not IsSoundOptionEnabled("Sound")
      end
    },
    {
      name = T(316134644192, "Ambience"),
      id = "Ambience",
      category = "Audio",
      storage = "local",
      editor = "number",
      min = 0,
      max = const.AmbienceMaxVolume or 1000,
      slider = true,
      default = GetDefaultEngineOptions().Ambience,
      step = (const.AmbienceMaxVolume or 1000) / 100,
      no_edit = function()
        return not IsSoundOptionEnabled("Ambience")
      end
    },
    {
      name = T(706332531616, "UI"),
      id = "UI",
      category = "Audio",
      storage = "local",
      editor = "number",
      min = 0,
      max = const.UIMaxVolume or 1000,
      slider = true,
      default = GetDefaultEngineOptions().UI,
      step = (const.UIMaxVolume or 1000) / 100,
      no_edit = function()
        return not IsSoundOptionEnabled("UI")
      end
    },
    {
      name = T(362201382843, "Mute when Minimized"),
      id = "MuteWhenMinimized",
      category = "Audio",
      storage = "local",
      editor = "bool",
      default = GetDefaultEngineOptions().MuteWhenMinimized,
      no_edit = Platform.console
    },
    {
      name = T(3583, "Radio Station"),
      id = "RadioStation",
      category = "Audio",
      editor = "choice",
      default = GetDefaultEngineOptions().RadioStation,
      items = function()
        return DisplayPresetCombo("RadioStationPreset")()
      end,
      no_edit = not config.Radio
    },
    {
      name = Platform.playstation and g_PlayStationControllerText or T(704811499954, "Controller"),
      id = "Gamepad",
      category = "Controls",
      SortKey = 100000,
      storage = "account",
      editor = "bool",
      default = GetDefaultEngineOptions().Gamepad,
      no_edit = Platform.console,
      read_only = function()
        return not IsXInputControllerConnected() and not Platform.console
      end,
      read_only_tile = Platform.playstation and g_PlayStationControllerText or T(704811499954, "Controller"),
      read_only_text = Platform.playstation and T(647264878338, "No controller is detected!") or T(835199065706, "No controller is detected!")
    },
    {
      name = T(243042020683, "Language"),
      id = "Language",
      category = "Gameplay",
      SortKey = -1000,
      storage = "account",
      editor = "choice",
      default = GetDefaultEngineOptions().Language,
      no_edit = Platform.console
    },
    {
      name = T(267365977133, "Camera Shake"),
      id = "CameraShake",
      category = "Gameplay",
      SortKey = -900,
      storage = "local",
      editor = "bool",
      on_value = "On",
      off_value = "Off",
      default = GetDefaultEngineOptions().CameraShake
    },
    {
      name = T(273206229320, "Fullscreen Mode"),
      id = "FullscreenMode",
      category = "Display",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().FullscreenMode
    },
    {
      name = T(124888650840, "Resolution"),
      id = "Resolution",
      category = "Display",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Resolution
    },
    {
      name = T(276952502249, "Vsync"),
      id = "Vsync",
      category = "Display",
      storage = "local",
      editor = "bool",
      default = GetDefaultEngineOptions().Vsync
    },
    {
      name = T(731920619011, "Graphics API"),
      id = "GraphicsApi",
      category = "Display",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().GraphicsApi,
      no_edit = function()
        return not Platform.pc
      end
    },
    {
      name = T(899898011812, "Graphics Adapter"),
      id = "GraphicsAdapterIndex",
      category = "Display",
      storage = "local",
      dont_save = true,
      editor = "choice",
      default = GetDefaultEngineOptions().GraphicsAdapterIndex,
      no_edit = function()
        return not Platform.pc
      end
    },
    {
      name = T(418391988068, "Frame Rate Limit"),
      id = "MaxFps",
      category = "Display",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().MaxFps
    },
    {
      name = T(313994466701, "Display Area Margin"),
      id = "DisplayAreaMargin",
      category = Platform.console and "Gameplay" or "Display",
      SortKey = Platform.console and -1100 or nil,
      storage = "local",
      editor = "number",
      min = const.MinDisplayAreaMargin,
      max = const.MaxDisplayAreaMargin,
      slider = true,
      default = GetDefaultEngineOptions().DisplayAreaMargin,
      no_edit = not Platform.xbox and Platform.goldmaster
    },
    {
      name = T(106738401126, "UI Scale"),
      id = "UIScale",
      category = Platform.console and "Gameplay" or "Display",
      SortKey = Platform.console and -1100 or nil,
      storage = "local",
      editor = "number",
      min = function()
        return const.MinUserUIScale
      end,
      max = function()
        return const.MaxUserUIScaleHighRes
      end,
      slider = true,
      default = GetDefaultEngineOptions().UIScale,
      step = 5,
      snap_offset = 5
    },
    {
      name = T(106487158051, "Brightness"),
      id = "Brightness",
      category = Platform.console and "Gameplay" or "Display",
      SortKey = Platform.console and -1100 or nil,
      storage = "local",
      editor = "number",
      min = -50,
      max = 1050,
      slider = true,
      default = GetDefaultEngineOptions().Brightness,
      step = 50,
      snap_offset = 50
    }
  }
}
function OptionsObject:GetShortcuts()
  self.shortcuts = {}
  self.props_cache = false
  if Platform.console and not g_KeyboardConnected then
    return
  end
  local actions = XShortcutsTarget and XShortcutsTarget:GetActions()
  if actions then
    for _, action in ipairs(actions) do
      if action.ActionBindable then
        local id = action.ActionId
        local defaultActions = false
        if action.default_ActionShortcut and action.default_ActionShortcut ~= "" then
          defaultActions = defaultActions or {}
          defaultActions[1] = action.default_ActionShortcut
        end
        if action.default_ActionShortcut2 and action.default_ActionShortcut2 ~= "" then
          defaultActions = defaultActions or {}
          defaultActions[2] = action.default_ActionShortcut2
        end
        if action.default_ActionGamepad and action.default_ActionGamepad ~= "" then
          defaultActions = defaultActions or {}
          defaultActions[3] = action.default_ActionGamepad
        end
        self[id] = defaultActions
        table.insert(self.shortcuts, {
          name = action.ActionName,
          id = id,
          sort_key = action.ActionSortKey,
          mode = action.ActionMode or "",
          category = "Keybindings",
          action_category = action.BindingsMenuCategory,
          storage = "shortcuts",
          editor = "hotkey",
          keybinding = true,
          default = defaultActions,
          mouse_bindable = action.ActionMouseBindable,
          single_key = action.ActionBindSingleKey
        })
      end
    end
  end
  table.stable_sort(self.shortcuts, function(a, b)
    if a.action_category == b.action_category then
      return a.sort_key < b.sort_key
    else
      return a.action_category < b.action_category
    end
  end)
  local currentCategory = false
  for i, s in ipairs(self.shortcuts) do
    local newCategory = s.action_category
    if currentCategory ~= newCategory then
      local preset = table.get(Presets, "BindingsMenuCategory", "Default", newCategory)
      s.separator = preset and preset.Name or Untranslated(newCategory)
    end
    currentCategory = newCategory
  end
end
function OptionsObject:GetProperties()
  if self.props_cache then
    return self.props_cache
  end
  local props = {}
  local static_props = PropertyObject.GetProperties(self)
  if not self.shortcuts or not next(self.shortcuts) then
    self:GetShortcuts()
  end
  props = table.copy(static_props, "deep")
  table.stable_sort(props, function(a, b)
    return (a.SortKey or 0) < (b.SortKey or 0)
  end)
  props = table.iappend(props, self.shortcuts)
  self.props_cache = props
  return props
end
function OptionsObject:SaveToTables()
  local storage_tables = {
    ["local"] = EngineOptions,
    account = AccountStorage and AccountStorage.Options,
    session = g_SessionOptions,
    shortcuts = AccountStorage and AccountStorage.Shortcuts
  }
  for _, prop in ipairs(self:GetProperties()) do
    local storage = prop.storage or "account"
    local storage_table = storage_tables[storage]
    if storage_table then
      local saved_value
      local value = self:GetProperty(prop.id)
      local default = prop_eval(prop.default, self, prop)
      if value ~= default then
        if type(value) == "table" then
          saved_value = table.copy(value)
          for key, val in pairs(saved_value or empty_table) do
            if default and default[key] == val then
              saved_value[key] = nil
            end
          end
          if not next(saved_value) then
            saved_value = nil
          end
        else
          saved_value = prop_eval(value, self, prop)
        end
      end
      storage_table[prop.id] = saved_value
    end
  end
  self:SaveOptionFixupsMeta(storage_tables)
end
function GetTableWithStorageDefaults(storage)
  local obj = OptionsObject:new()
  local defaults_table = {}
  for _, prop in ipairs(obj:GetProperties()) do
    local prop_storage = prop.storage or "account"
    if not storage or prop_storage == storage then
      defaults_table[prop.id] = prop_eval(prop.default, obj, prop)
    end
  end
  return defaults_table
end
function OptionsObject:SetProperty(id, value)
  local ret = PropertyObject.SetProperty(self, id, value)
  local preset = self.VideoPreset
  if OptionsData.VideoPresetsData[preset] and PresetVideoOptions[id] and value ~= OptionsData.VideoPresetsData[preset][id] then
    PropertyObject.SetProperty(self, "VideoPreset", "Custom")
    ObjModified(self)
  end
  return ret
end
function IsSoundOptionEnabled(option)
  return config.SoundOptionGroups[option]
end
function OptionsObject:SetMasterVolume(x)
  self.MasterVolume = x
  for option in pairs(config.SoundOptionGroups) do
    self:UpdateOptionVolume(option)
  end
end
function OptionsObject:UpdateOptionVolume(option, volume)
  volume = volume or self[option]
  self[option] = volume
  SetOptionVolume(option, volume * self.MasterVolume / 1000)
end
function OnMsg.ClassesPreprocess()
  for option in sorted_pairs(config.SoundOptionGroups) do
    OptionsObject["Set" .. option] = function(self, x)
      self:UpdateOptionVolume(option, x)
    end
  end
end
function OptionsObject:SetMuteWhenMinimized(x)
  self.MuteWhenMinimized = x
  config.DontMuteWhenInactive = not x
end
function OptionsObject:SetBrightness(x)
  self.Brightness = x
  ApplyBrightness(x)
end
function OptionsObject:SetDisplayAreaMargin(x)
  if self.DisplayAreaMargin == x then
    return
  end
  self.DisplayAreaMargin = x
  self:UpdateUIScale()
end
function OptionsObject:UpdateUIScale()
  if Platform.playstation or not const.UIScaleDAMDependant then
    return
  end
  local dam_value = self.DisplayAreaMargin or 0
  local ui_scale_value = self.UIScale or 100
  local mapped_value = MapRange(dam_value, const.MinUserUIScale, const.MaxUserUIScaleHighRes, const.MaxDisplayAreaMargin, const.MinDisplayAreaMargin)
  local prop_meta = self:GetPropertyMetadata("UIScale")
  local step = prop_meta and prop_meta.step or 1
  self.UIScale = Min(ui_scale_value, round(mapped_value, step))
end
function OptionsObject:SetUIScale(x)
  if self.UIScale == x then
    return
  end
  self.UIScale = x
  self:UpdateDisplayAreaMargin()
end
function OptionsObject:UpdateDisplayAreaMargin()
  if Platform.playstation or not const.UIScaleDAMDependant then
    return
  end
  local dam_value = self.DisplayAreaMargin or 0
  local ui_scale_value = self.UIScale or 100
  local mapped_value = MapRange(ui_scale_value, const.MinDisplayAreaMargin, const.MaxDisplayAreaMargin, const.MaxUserUIScaleHighRes, const.MinUserUIScale)
  local prop_meta = self:GetPropertyMetadata("DisplayAreaMargin")
  local step = prop_meta and prop_meta.step or 1
  self.DisplayAreaMargin = Min(dam_value, round(mapped_value, step))
end
function OptionsCreateAndLoad()
  local storage_tables = {
    ["local"] = EngineOptions,
    account = AccountStorage and AccountStorage.Options,
    session = g_SessionOptions,
    shortcuts = AccountStorage and AccountStorage.Shortcuts
  }
  EngineOptions.DisplayIndex = GetMainWindowDisplayIndex()
  Options.InitVideoModesCombo()
  local obj = OptionsObject:new()
  for _, prop in ipairs(obj:GetProperties()) do
    local storage = prop.storage or "account"
    local storage_table = storage_tables[storage]
    if storage_table then
      local default = prop_eval(prop.default, obj, prop)
      local value = storage_table[prop.id]
      local loaded_val
      if value ~= default then
        if type(value) == "table" then
          loaded_val = table.copy(value)
          table.set_defaults(loaded_val, default)
        elseif value ~= nil then
          loaded_val = prop_eval(value, obj, prop)
        else
          loaded_val = default
        end
      end
      if loaded_val ~= nil then
        obj:SetProperty(prop.id, loaded_val)
      end
    end
  end
  Options.InitGraphicsAdapterCombo(obj.GraphicsApi)
  obj:GatherOptionFixupsMeta(storage_tables)
  return obj
end
function OptionsObject:SetGraphicsApi(api)
  self.GraphicsApi = api
  local adapterData = EngineOptions.GraphicsAdapter or {}
  Options.InitGraphicsAdapterCombo(api)
  self:SetProperty("GraphicsAdapterIndex", GetRenderDeviceAdapterIndex(api, adapterData))
end
function OptionsObject:SetGraphicsAdapterIndex(adapterIndex)
  self.GraphicsAdapterIndex = adapterIndex
  EngineOptions.GraphicsAdapter = GetRenderDeviceAdapterData(self.GraphicsApi, adapterIndex)
end
function OptionsObject:SetVideoPreset(preset)
  self.VideoPreset = preset
  for k, v in pairs(OptionsData.VideoPresetsData[preset]) do
    self[k] = v
  end
end
function GetDefaultOptionFixupsMeta()
  return {
    AppliedOptionFixups = {},
    last_applied_fixup_revision = 0
  }
end
function OptionsObject:GatherOptionFixupsMeta(storage_tables)
  local loc = storage_tables["local"]
  local acc = storage_tables.account
  self.fixups_meta = {
    ["local"] = loc and loc.fixups_meta and type(loc.fixups_meta.AppliedOptionFixups) == "table" and loc.fixups_meta or GetDefaultOptionFixupsMeta(),
    account = acc and acc.fixups_meta and type(acc.fixups_meta.AppliedOptionFixups) == "table" and acc.fixups_meta or GetDefaultOptionFixupsMeta()
  }
end
function OptionsObject:SaveOptionFixupsMeta(storage_tables)
  if storage_tables["local"] then
    storage_tables["local"].fixups_meta = self.fixups_meta["local"]
  end
  if storage_tables.account then
    storage_tables.account.fixups_meta = self.fixups_meta.account
  end
end
function OptionsObject:FixupOptions()
  if not self.fixups_meta then
    return
  end
  local meta = self.fixups_meta
  local count, applied = 0, {}
  for fixup, func in sorted_pairs(OptionFixups) do
    local applied_local = meta["local"].AppliedOptionFixups[fixup]
    local applied_account = meta.account.AppliedOptionFixups[fixup]
    if (not applied_local or not applied_account) and type(func) == "function" then
      procall(func, self, applied_local and meta.account.last_applied_fixup_revision or meta["local"].last_applied_fixup_revision)
      count = count + 1
      applied[#applied + 1] = fixup
      meta["local"].AppliedOptionFixups[fixup] = true
      meta.account.AppliedOptionFixups[fixup] = true
      meta["local"].last_applied_fixup_revision = LuaRevision
      meta.account.last_applied_fixup_revision = LuaRevision
    end
  end
  if 0 < count then
    DebugPrint(string.format("Applied %d option fixup(s): %s\n", count, table.concat(applied, ", ")))
  end
  return count
end
function OptionsObject:WaitApplyOptions(original_obj)
  self:SaveToTables()
  Options.ApplyEngineOptions(EngineOptions)
  WaitNextFrame(2)
  Msg("OptionsApply")
  return true
end
function ApplyVideoPreset(preset)
  local obj = OptionsCreateAndLoad()
  obj:SetVideoPreset(preset)
  ApplyOptionsObj(obj)
end
function ApplyOptionsObj(obj)
  obj:SaveToTables()
  Options.ApplyEngineOptions(EngineOptions)
  Msg("OptionsApply")
end
function OptionsObject:CopyCategoryTo(other, category)
  for _, prop in ipairs(self:GetProperties()) do
    if prop.category == category then
      local value = self:GetProperty(prop.id)
      value = type(value) == "table" and table.copy(value) or value
      other:SetProperty(prop.id, value)
    end
  end
end
function WaitChangeVideoMode()
  while GetVideoModeChangeStatus() == 1 do
    Sleep(50)
  end
  if GetVideoModeChangeStatus() ~= 0 then
    return false
  end
  for i = 1, 2 do
    WaitNextFrame()
  end
  return true
end
function OptionsObject:FindValidVideoMode(display)
  local modes = GetVideoModes(display, 1024, 720)
  table.sort(modes, function(a, b)
    if a.Height ~= b.Height then
      return a.Height > b.Height
    end
    return a.Width > b.Width
  end)
  local best = modes[1]
  self.Resolution = point(best.Width, best.Height)
end
function OptionsObject:IsValidVideoMode(display)
  local modes = GetVideoModes(display, 1024, 720)
  for _, mode in ipairs(modes) do
    if mode.Width == self.Resolution:x() and mode.Height == self.Resolution:y() then
      return true
    end
  end
  return false
end
function OptionsObject:ApplyVideoMode()
  local display = GetMainWindowDisplayIndex()
  ChangeVideoMode(self.Resolution:x(), self.Resolution:y(), self.FullscreenMode, self.Vsync, false)
  if not WaitChangeVideoMode() then
    return false
  end
  SetupViews()
  EngineOptions.DisplayIndex = display
  EngineOptions.UIScale = self.UIScale
  if terminal.desktop then
    terminal.desktop:OnSystemSize(UIL.GetScreenSize())
  end
  local value = table.find_value(OptionsData.Options.MaxFps, "value", self.MaxFps)
  if value then
    for k, v in pairs(value.hr or empty_table) do
      hr[k] = v
    end
  end
  Msg("VideoModeApplied")
  if self.FullscreenMode > 0 then
    return "confirmation"
  end
  return true
end
function OptionsObject:ResetOptionsByCategory(category, sub_category, additional_skip_props)
  additional_skip_props = additional_skip_props or {}
  if category == "Keybindings" then
    if sub_category then
      for key, shortcut in pairs(AccountStorage.Shortcuts) do
        local actionCat = table.find_value(OptionsObj:GetProperties(), "id", key).action_category
        if actionCat == sub_category then
          AccountStorage.Shortcuts[key] = nil
        end
      end
    else
      AccountStorage.Shortcuts = {}
    end
    ReloadShortcuts()
    self:GetShortcuts()
  end
  local skip_props = {}
  if category == "Display" then
    skip_props = {FullscreenMode = true, Resolution = true}
  end
  for _, prop in ipairs(self:GetProperties()) do
    local isFromSubCat = sub_category and prop.action_category == sub_category or not sub_category
    if prop.category == category and not skip_props[prop.id] and not additional_skip_props[prop.id] and not GameDisabledOptions[prop.id] and not prop_eval(prop.no_edit, self, prop) and isFromSubCat then
      local default = table.find_value(OptionsData.Options[prop.id], "default", true)
      local default_prop_value = self:GetDefaultPropertyValue(prop.id)
      default = default and default.value or default_prop_value and prop_eval(default_prop_value, self, prop) or false
      if type(default) == "table" then
        default = table.copy(default)
      end
      self:SetProperty(prop.id, default)
    end
  end
end
function OptionsObject:SetRadioStation(station)
  local old = rawget(self, "RadioStation")
  if not old or old ~= station then
    self.RadioStation = station
    StartRadioStation(station)
  end
end
function GetAccountStorageOptionValue(prop_id)
  local value = table.get(AccountStorage, "Options", prop_id)
  if value ~= nil then
    return value
  end
  return rawget(OptionsObject, prop_id)
end
function SyncCameraControllerSpeedOptions()
end
function SetAccountStorageOptionValue(prop_id, val)
  if AccountStorage and AccountStorage.Options and AccountStorage.Options[prop_id] then
    AccountStorage.Options[prop_id] = val
  end
end
function ApplyOptions(host, next_mode)
  CreateRealTimeThread(function(host)
    local obj = ResolvePropObj(host.context)
    local original_obj = ResolvePropObj(host.idOriginalOptions.context)
    local category = host:GetCategoryId()
    if not obj:WaitApplyOptions(original_obj) then
      WaitMessage(terminal.desktop, T(824112417429, "Warning"), T(862733805364, "Changes could not be applied and will be reverted."), T(325411474155, "OK"))
    else
      local object_detail_changed = obj.ObjectDetail ~= original_obj.ObjectDetail
      obj:CopyCategoryTo(original_obj, category)
      SaveEngineOptions()
      SaveAccountStorage(5000)
      ReloadShortcuts()
      ApplyLanguageOption()
      if Platform.console then
        terminal.desktop:OnSystemSize(UIL.GetScreenSize())
      end
      if object_detail_changed then
        SetObjectDetail(obj.ObjectDetail)
      end
      Msg("GameOptionsChanged", category)
    end
    if not next_mode then
      SetBackDialogMode(host)
    else
      SetDialogMode(host, next_mode)
    end
  end, host)
end
function CancelOptions(host, next_mode)
  CreateRealTimeThread(function(host)
    if host.window_state == "destroying" then
      return
    end
    local obj = ResolvePropObj(host.context)
    local original_obj = ResolvePropObj(host.idOriginalOptions.context)
    local category = host:GetCategoryId()
    original_obj:WaitApplyOptions()
    original_obj:CopyCategoryTo(obj, category)
    if not next_mode then
      SetBackDialogMode(host)
    else
      SetDialogMode(host, next_mode)
    end
  end, host)
end
function ApplyDisplayOptions(host, next_mode)
  CreateRealTimeThread(function(host)
    if host.window_state == "destroying" then
      return
    end
    local obj = ResolvePropObj(host.context)
    local original_obj = ResolvePropObj(host.idOriginalOptions.context)
    local graphics_device_changed = obj.GraphicsApi ~= original_obj.GraphicsApi
    if not graphics_device_changed then
      local originalAdapter = GetRenderDeviceAdapterData(original_obj.GraphicsApi, original_obj.GraphicsAdapterIndex)
      local adapter = GetRenderDeviceAdapterData(obj.GraphicsApi, obj.GraphicsAdapterIndex)
      graphics_device_changed = originalAdapter.vendorId ~= adapter.vendorId or originalAdapter.deviceId ~= adapter.deviceId or originalAdapter.localId ~= adapter.localId
    end
    local ok = obj:ApplyVideoMode()
    if ok == "confirmation" then
      ok = WaitQuestion(terminal.desktop, T(145768933497, "Video mode change"), T(751908098091, "The video mode has been changed. Keep changes?"), T(689884995409, "Yes"), T(782927325160, "No")) == "ok"
    end
    obj:SetProperty("Resolution", point(GetResolution()))
    if ok then
      obj:CopyCategoryTo(original_obj, "Display")
      original_obj:SaveToTables()
      SaveEngineOptions()
    else
      original_obj:ApplyVideoMode()
      original_obj:CopyCategoryTo(obj, "Display")
    end
    if graphics_device_changed then
      WaitMessage(terminal.desktop, T(1000599, "Warning"), T(714163709235, "Changing the Graphics API or Graphics Adapter options will only take effect after the game is restarted."), T(325411474155, "OK"))
    end
    if not next_mode then
      SetBackDialogMode(host)
    else
      SetDialogMode(host, next_mode)
    end
  end, host)
end
function CancelDisplayOptions(host, next_mode)
  local obj = ResolvePropObj(host.context)
  local original_obj = ResolvePropObj(host.idOriginalOptions.context)
  original_obj:CopyCategoryTo(obj, "Display")
  obj:SetProperty("Resolution", point(GetResolution()))
  if not next_mode then
    SetBackDialogMode(host)
  else
    SetDialogMode(host, next_mode)
  end
end
function DbgLoadOptions(video_preset, options_obj)
  if video_preset and video_preset ~= "Custom" then
    options_obj:SetVideoPreset(video_preset)
  end
  CreateRealTimeThread(function()
    options_obj:ApplyVideoMode()
  end)
  ApplyOptionsObj(options_obj)
end
function GetOptionsString()
  local options_obj = OptionsCreateAndLoad()
  function options_obj:IsDefaultPropertyValue(id, prop, value)
    return prop.storage == "shortcuts" and true or false
  end
  return string.format("DbgLoadOptions(\"%s\", %s)\n", options_obj.VideoPreset, ValueToLuaCode(options_obj))
end
