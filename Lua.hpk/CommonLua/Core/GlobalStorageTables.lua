if FirstLoad then
  g_FirstTimeUser = false
  g_LocalStorageFile = "AppData/" .. (Platform.ged and "LocalStorageGed.lua" or "LocalStorage.lua")
end
local InitWithDefault = function(storage, default)
  if storage == "invalid" then
    storage = false
  else
    if storage == "default" then
      storage = {}
    end
    if getmetatable(default) and not ObjectClass(storage) and ObjectClass(default) then
      storage = g_Classes[default.class]:new(storage)
    end
    table.set_defaults(storage, default, "deep")
  end
  return storage
end
function SetPlatformDefaultEngineOptions()
  local result_options = table.copy(DefaultEngineOptions.default_options)
  if Platform.desktop then
    table.overwrite(result_options, DefaultEngineOptions.desktop)
  elseif Platform.xbox_one and not Platform.xbox_one_x then
    table.overwrite(result_options, DefaultEngineOptions.xbox_one)
  elseif Platform.xbox_one and Platform.xbox_one_x then
    table.overwrite(result_options, DefaultEngineOptions.xbox_one_x)
  elseif Platform.xbox_series and not Platform.xbox_series_x then
    table.overwrite(result_options, DefaultEngineOptions.xbox_series)
  elseif Platform.xbox_series and Platform.xbox_series_x then
    table.overwrite(result_options, DefaultEngineOptions.xbox_series_x)
  elseif Platform.ps4 and not Platform.ps4_pro then
    table.overwrite(result_options, DefaultEngineOptions.ps4)
  elseif Platform.ps4 and Platform.ps4_pro then
    table.overwrite(result_options, DefaultEngineOptions.ps4_pro)
  elseif Platform.ps5 then
    table.overwrite(result_options, DefaultEngineOptions.ps5)
  elseif Platform.switch then
    table.overwrite(result_options, DefaultEngineOptions.switch)
  end
  PlatformDefaultEngineOptions = result_options
end
function GetDefaultEngineOptions(platform_overwrites_only)
  if platform_overwrites_only then
    if Platform.desktop then
      return DefaultEngineOptions.desktop
    elseif Platform.xbox_one and not Platform.xbox_one_x then
      return DefaultEngineOptions.xbox_one
    elseif Platform.xbox_one and Platform.xbox_one_x then
      return DefaultEngineOptions.xbox_one_x
    elseif Platform.xbox_series and not Platform.xbox_series_x then
      return DefaultEngineOptions.xbox_series
    elseif Platform.xbox_series and Platform.xbox_series_x then
      return DefaultEngineOptions.xbox_series_x
    elseif Platform.ps4 and not Platform.ps4_pro then
      return DefaultEngineOptions.ps4
    elseif Platform.ps4 and Platform.ps4_pro then
      return DefaultEngineOptions.ps4_pro
    elseif Platform.ps5 then
      return DefaultEngineOptions.ps5
    elseif Platform.switch then
      return DefaultEngineOptions.switch
    end
  end
  return PlatformDefaultEngineOptions
end
function SetDefaultEngineOptionsMetaTable()
  setmetatable(EngineOptions, {
    __index = GetDefaultEngineOptions()
  })
end
if FirstLoad then
  DefaultEngineOptions = {
    default_options = {
      VideoPreset = "High",
      Antialiasing = "FXAA",
      ResolutionPercent = "100",
      Shadows = "High",
      Textures = "High",
      Anisotropy = "4x",
      Terrain = "High",
      Effects = "High",
      Lights = "High",
      Postprocess = "High",
      Bloom = "On",
      EyeAdaptation = "On",
      Vignette = "On",
      ChromaticAberration = "On",
      SSAO = "On",
      SSR = "High",
      ViewDistance = "High",
      ObjectDetail = "High",
      FPSCounter = "Off",
      Sharpness = const.DefaultSharpness or "Low",
      MasterVolume = const.MasterDefaultVolume or 500,
      Music = const.MusicDefaultVolume or 300,
      Voice = const.VoiceDefaultVolume or 1000,
      Sound = const.SoundDefaultVolume or 650,
      Ambience = const.AmbienceDefaultVolume or 1000,
      UI = const.UIDefaultVolume or 1000,
      MuteWhenMinimized = true,
      RadioStation = const.Music and const.Music.DefaultRadioStation or "",
      Gamepad = (Platform.console or Platform.steamdeck) and true or false,
      Language = "Auto",
      CameraShake = "On",
      FullscreenMode = 0,
      Resolution = point(1920, 1080),
      Vsync = true,
      GraphicsApi = GetDefaultGraphicsApi(),
      GraphicsAdapterIndex = 0,
      MaxFps = "240",
      DisplayAreaMargin = 0,
      UIScale = 100,
      Brightness = 500
    },
    desktop = {
      Resolution = Platform.developer and point(1920, 1080) or false,
      FullscreenMode = Platform.developer and 0 or 1
    },
    xbox_one = {
      Resolution = point(1920, 1080),
      FullscreenMode = 1,
      Vsync = true,
      GraphicsApi = "d3d12",
      VideoPreset = "XboxOne"
    },
    xbox_one_x = {
      Resolution = point(2560, 1440),
      FullscreenMode = 1,
      Vsync = true,
      GraphicsApi = "d3d12",
      VideoPreset = "XboxOneX"
    },
    xbox_series = {
      Resolution = point(2560, 1440),
      FullscreenMode = 1,
      Vsync = true,
      GraphicsApi = "d3d12",
      VideoPreset = "XboxSeriesS"
    },
    xbox_series_x = {
      Resolution = point(3840, 2160),
      FullscreenMode = 1,
      Vsync = true,
      GraphicsApi = "d3d12",
      VideoPreset = "XboxSeriesX"
    },
    ps4 = {
      Resolution = point(1920, 1080),
      FullscreenMode = 1,
      Vsync = true,
      GraphicsApi = "gnm",
      VideoPreset = "PS4"
    },
    ps4_pro = {
      Resolution = point(2240, 1260),
      FullscreenMode = 1,
      Vsync = true,
      GraphicsApi = "gnm",
      VideoPreset = "PS4Pro"
    },
    ps5 = {
      Resolution = point(3840, 2160),
      FullscreenMode = 1,
      Vsync = true,
      GraphicsApi = "agc",
      VideoPreset = "PS5"
    },
    switch = {
      Resolution = point(1280, 720),
      FullscreenMode = 1,
      Vsync = true,
      FPSCounter = "Off",
      UIScale = 100,
      GraphicsApi = "NVN",
      VideoPreset = "Switch"
    }
  }
  DefaultAccountStorage = {
    Shortcuts = {},
    achievements = {
      unlocked = {},
      progress = {},
      target = {}
    },
    tips = {current_tip = 0},
    Options = {
      Gamepad = Platform.console
    },
    LoadMods = {}
  }
  DefaultLocalStorage = {
    id_old_rect = {},
    dlgBugReport = {},
    MovieRecord = {},
    editor = {},
    FilteredCategories = {},
    LockedCategories = {}
  }
  PlatformDefaultEngineOptions = {}
  SetPlatformDefaultEngineOptions()
  EngineOptions = {}
  SetDefaultEngineOptionsMetaTable()
end
function OverrideWithDefaultEngineOptions(options)
  if options and Platform.console then
    for k, v in pairs(GetDefaultEngineOptions("platform_overwrites_only")) do
      options[k] = v
    end
  end
end
function SetAccountStorage(storage)
  storage = InitWithDefault(storage, DefaultAccountStorage)
  AccountStorage = storage
  Msg("AccountStorageChanged")
end
local InitLocalStorage = function()
  if not io.exists(g_LocalStorageFile) then
    return InitWithDefault("default", DefaultLocalStorage)
  end
  local fenv = LuaValueEnv()
  local t = dofile(g_LocalStorageFile, fenv)
  if not t then
    g_FirstTimeUser = true
  end
  t = InitWithDefault(t or "default", DefaultLocalStorage)
  OverrideWithDefaultEngineOptions(t.Options)
  if t.Options and not t.Developer then
    t.Developer = {
      General = t.Options.General,
      EditorHiddenTextOptions = t.Options.EditorHiddenTextOptions,
      MapStartup = t.Options.MapStartup
    }
    t.Options.General = nil
    t.Options.EditorHiddenTextOptions = nil
    t.Options.MapStartup = nil
  end
  t.LuaRevision = t.LuaRevision or 0
  if not Platform.developer and t.LuaRevision == 0 then
    t = InitWithDefault("default", DefaultLocalStorage)
  end
  return t
end
if FirstLoad then
  AccountStorage = false
end
function SaveEngineOptions()
  Msg("EngineOptionsSaved")
  return SaveLocalStorage()
end
if FirstLoad then
  DefaultLocalStorage.Options = EngineOptions
  LocalStorage = InitLocalStorage()
  EngineOptions = LocalStorage.Options
  SetDefaultEngineOptionsMetaTable()
end
function SaveLocalStorage()
  LocalStorage.LuaRevision = LuaRevision
  local code = pstr("return ", 1024)
  TableToLuaCode(LocalStorage, nil, code)
  ThreadLockKey(g_LocalStorageFile)
  local err = AsyncStringToFile(g_LocalStorageFile, code, -2, 0)
  ThreadUnlockKey(g_LocalStorageFile)
  if err then
    print("once", "Failed to save a storage table to", g_LocalStorageFile, ":", err)
    return false, err
  end
  return true
end
function SaveLocalStorageDelayed()
  DelayedCall(0, SaveLocalStorage)
end
