config.SaveObjectsOrder = {
  {"GridMarker"}
}
Libs.Volumes = true
config.Sim = false
config.Mods = true
config.GedFunctionObjectsTestHarness = true
config.SaveGameScreenshot = true
config.GamepadTestOnly = false
config.ScreenshotsWithUI = true
config.AutosaveAllowed = true
if Platform.developer then
  config.RegisterSavFileHandler = true
end
if insideHG() then
  local bender_folder = "Zulu"
  if Platform.pc then
    config.CrashFolder = string.format("\\\\bender.haemimontgames.com\\%s\\Logs\\Crashes", bender_folder)
  elseif Platform.linux then
    config.CrashFolder = string.format("/media/bender/%s/Logs/Crashes", bender_folder)
  elseif Platform.osx then
    config.CrashFolder = string.format("/Volumes/%s/Logs/Crashes", bender_folder)
  end
  config.DesyncPath = string.format("\\\\bender.haemimontgames.com\\%s\\Logs\\Desyncs", bender_folder)
end
const.PerObjectHandlePool = 8192
function OnMsg.XInputInited()
  local lock = GetUIStyleGamepad() and 0 or 1
  hr.XBoxLeftThumbLocked = lock
  hr.XBoxRightThumbLocked = lock
end
UserVersion = "Version 0.01"
UserVersionNum = "0.01"
config.Vibration = 1
config.EditorWarnings = 1
config.FullscreenMode = 2
const.MaxScale = 200
config.RunUnfocused = 1
config.ClipCursor = 2
config.XInput = 1
config.XInputRefreshTime = 30
config.LightModelUnusedFeatures = {
  ["water foam"] = true,
  ["water waves"] = true,
  dist_blur_desat = true
}
if Platform.desktop or Platform.ps5 or Platform.xbox_series_x then
  config.ObjectPoolMem = 147456
  config.CBMemory = 33554432
  config.BonesMemory = 8388608
else
  config.ObjectPoolMem = 147456
  config.CBMemory = 20971520
  config.BonesMemory = 6291456
end
config.MemorySavegameSize = 100663296
config.MemoryScreenshotSize = 16777216
config.MainMenu = 1
config.GedLanguageEnglish = Platform.desktop
config.postProcPredicates = {}
config.FloatingTextEnabled = true
config.ConsoleDim = 0
config.OSVersionMajorReq = 0
config.OSVersionMinorReq = 0
if Platform.pc then
  config.OSVersionMajorReq = 6
  config.OSVersionMinorReq = 0
elseif Platform.osx then
  config.OSVersionMajorReq = 10
  config.OSVersionMinorReq = 7
elseif Platform.linux then
  config.OSVersionMajorReq = 3
  config.OSVersionMinorReq = 0
end
config.MapSlotsBand = 0
config.DefaultTerrainTileSize = 8000
config.MinimapScreenshotSize = 2048
config.LuaDebugInfo = true
config.SSRThresholdParentDistance = 0.05
hr.D3D11ParallelCompilation = 0
hr.EnableCloudsShadow = 1
hr.RenderTerrainFirst = 1
hr.AutoFadeDistanceScale = 2200
hr.FadeCullRadius = 550
hr.ObjAnimDefaultCrossfadeTime = 300
const.Camera3pRealTime = true
const.CameraControlRotationSpeed = 60
config.TileSizeTerrainBrushStep = false
config.MaxTerrainBrushStrength = 300
config.MinTerrainBrushStrength = 10
config.MaxTerrainBrushSize = 300
config.MinTerrainBrushSize = 10
config.MaxTerrainBrushHeightChange = 100
config.MinTerrainBrushHeightChange = 100
config.SmoothBrushInfluenceMin = 7
config.SmoothBrushInfluenceMax = 100
const.SelectionEnumRadius = 2000
hr.ShowSurfacesRange = 1000
hr.PreciseSelectionWidth = 9
config.EnableVoiceChat = true
config.DeprecatedParticleNames = {"_old", "test_"}
config.SerializeCompressAlgo = "zstd"
config.WalkablesEnumExtend = 120
config.LoadAutoAttachData = true
config.AllowInvites = true
config.VideoPresetAutodetect = {
  {
    preset = "SteamDeck",
    {
      "amd.*vangogh",
      "amd.*0405"
    }
  },
  {
    preset = "Ultra",
    {
      "geforce.*4%d[789]%d",
      "geforce.*3%d[89]%d",
      "radeon.*rx.*[67][89]%d%d"
    }
  },
  {
    preset = "High",
    {
      "titan",
      "vega.*[456]%d",
      "vii",
      "geforce.*4%d[56]%d",
      "geforce.*3%d[567]%d",
      "geforce.*2%d[6789]%d",
      "geforce.*1%d[789]%d",
      "radeon.*rx.*[567][67]%d%d",
      "radeon.*rx.*5[89]%d",
      "intel.*arc.*7%d%d"
    }
  },
  {
    preset = "Medium",
    {
      "geforce.*[12]%d[56]%d",
      "geforce.*9[78]%d",
      "radeon.*rx.*6%d%d%d",
      "radeon.*rx.*5%d%d%d",
      "radeon.*rx.*[45][567]%d",
      "radeon.*rx.*4[678]%d",
      "intel.*arc.*3%d%d"
    }
  },
  {
    preset = "Low",
    {
      "intel",
      "vega",
      "geforce.*%d%d%d",
      "radeon.*r9",
      "radeon.*r7",
      "radeon.*hd"
    }
  }
}
config.TextureMemoryThresholds = {
  {threshold = 1500, value = "Low"},
  {threshold = 3000, value = "Medium"}
}
config.PasswordMinLen = 6
config.PasswordMaxLen = 128
config.PasswordHasMixedDigits = false
config.PasswordAllowCommon = true
config.SavegameRequiredLuaRevision = 332662
config.SupportedSavegameLuaRevision = 315737
config.InferParticleShaders = true
config.InitialInGameInterfaceMode = "IModeExploration"
config.DeveloperGrids = {
  "square_grid"
}
config.DeveloperGridDefaultProperties = {
  GridLineThickness = 75,
  GridSquareSize = 1200,
  GridBoxMinX = 0,
  GridBoxMinY = 0,
  GridBoxMaxX = 10000000,
  GridBoxMaxY = 10000000
}
config.TerrainHeightSlabOffset = MulDivRound(guim, -5, 100)
config.DefaultTerrainHeight = const.SlabSizeZ * 10 + config.TerrainHeightSlabOffset
config.MapSavedGameFlags = {
  const.gofMirrored,
  const.gofOnRoof,
  const.gofDontHideWithRoom,
  const.gofWarped,
  const.gofTerrainColorization,
  const.gofDetailClass0,
  const.gofDetailClass1,
  const.gofLowerLOD,
  const.gofGameSpecific2,
  const.gofGameSpecific3
}
config.MapSavedEnumFlags = {
  const.efWalkable,
  const.efApplyToGrids,
  const.efCollision,
  const.efVisible,
  const.efCameraMakeTransparent,
  const.efCameraRepulse,
  const.efSunShadow,
  const.efShadow
}
config.FloatingTextClass = "ZuluFloatingText"
LoadPersistFlagTables()
config.AutoTestSaveMap = "H-2 - Town of Erny"
config.VideoSettingsMap = "I-1 - Flag Hill"
config.RenderingTestsMap = "_RenderingTests"
hr.VoxelCoverRaysLengthPercents = 110
hr.VoxelCoverRaysHiThreshold = 30
hr.VoxelCoverRaysLoThreshold = 30
config.ParticleDynamicParams = true
config.PDASatelliteMercsDragAndDrop = false
GameColors = {
  DarkA = RGB(52, 55, 61),
  DarkB = RGB(32, 35, 47),
  Light = RGB(230, 222, 202),
  Grey = RGB(130, 128, 120),
  LightLighter = RGB(249, 249, 219),
  LightDarker = RGB(195, 189, 172),
  Enemy = RGB(191, 67, 77),
  EnemyLighter = RGB(232, 121, 128),
  Player = RGB(61, 122, 153),
  PlayerLighter = RGB(92, 163, 185),
  Sand = RGB(196, 175, 117),
  Yellow = RGB(215, 159, 80),
  LightGreen = RGB(124, 130, 96),
  DarkGreen = RGB(88, 92, 68),
  Hyperlink = RGB(76, 62, 255),
  HyperlinkClicked = RGB(127, 65, 195)
}
const.WindModifierMaskFlags = {
  "Bush",
  "Corn",
  "Grass"
}
const.HyperlinkColors = {
  IMP = RGB(127, 65, 195)
}
GameColors.A = GameColors.DarkA
GameColors.B = GameColors.DarkB
GameColors.C = GameColors.Light
GameColors.D = GameColors.Grey
GameColors.E = GameColors.LightLighter
GameColors.F = GameColors.LightDarker
GameColors.G = GameColors.LightGreen
GameColors.H = GameColors.DarkGreen
GameColors.I = GameColors.Enemy
GameColors.I1 = GameColors.EnemyLighter
GameColors.J = GameColors.Player
GameColors.J1 = GameColors.PlayerLighter
GameColors.K = GameColors.Sand
GameColors.L = GameColors.Yellow
GameColors.M = RGB(222, 60, 75)
GameColors.N = RGB(81, 45, 57)
function GetColorWithAlpha(color, alpha)
  local r, g, b = GetRGB(color)
  return RGBA(r, g, b, alpha)
end
const.DefaultSharpness = "High"
const.MaxRoomVoxelSizeX = 52
const.MaxRoomVoxelSizeY = 52
const.MaxRoomVoxelSizeZ = 52
const.ControllerUIScale = 100
if Platform.trailer then
  config.AutoControllerHandling = false
  config.AutoControllerHandlingType = false
  if rawget(_G, "SwitchControls") then
    CreateRealTimeThread(SwitchControls, false)
  end
else
  config.AutoControllerHandling = true
  config.AutoControllerHandlingType = "auto"
end
config.IdleAimingDelay = 500
config.DebugReplayDesync = true
