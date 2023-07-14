SetupVarTable(const, "const.")
const.FallbackSize = 64
if Platform.cmdline then
  return
end
const.Scale = {
  m = guim,
  cm = guic,
  voxelSizeX = const.SlabSizeX,
  deg = 60,
  sec = 1000,
  ["%"] = 1,
  ["\226\128\176"] = 1
}
const.GameObjectMaxCollectionIndex = 4095
const.GameObjectMaxRadius = 60 * guim
const.DefaultMouseCursor = "CommonAssets/UI/cursor.tga"
red = RGB(255, 0, 0)
green = RGB(0, 255, 0)
blue = RGB(0, 0, 255)
black = RGB(0, 0, 0)
white = RGB(255, 255, 255)
yellow = RGB(255, 255, 0)
purple = RGB(128, 0, 128)
magenta = RGB(255, 0, 255)
orange = RGB(255, 165, 0)
cyan = RGB(0, 255, 255)
const.HyperlinkColors = {}
const.PredefinedSceneActors = {}
const.CameraEditorDefaultSharpness = 10
const.InterfaceAnimDuration = 100
const.CutsceneNearZ = 20
const.CameraClipExtendRadius = 20 * guic
const.CameraShakeFOV = 7200
const.ShakeRadiusInSight = 30 * guim
const.ShakeRadiusOutOfSight = 10 * guim
const.MaxShakeOffset = 3 * guic
const.MaxShakeRoll = 15
const.MaxShakeDuration = 700
const.MinShakeDuration = 300
const.ShakeTick = 25
const.MaxShakePower = 1000
const.ParticleHandlesToggleRadius = 10
const.AnimMomentsToolObjDistToNearPlane = 8
const.DefaultTimeFactor = 1000
const.MinTimeFactor = 10
const.MaxTimeFactor = 1000000
const.MaxSaneTimeFactor = 100000
const.CameraControllerStateUpdateTime = "0.5"
const.mouse_rotates_camera = false
const.InvalidZ = 2147483647
const.clrBlack = RGB(0, 0, 0)
const.clrWhite = RGB(255, 255, 255)
const.clrRed = RGB(255, 0, 0)
const.clrGreen = RGB(0, 255, 0)
const.clrCyan = RGB(0, 255, 255)
const.clrBlue = RGB(0, 0, 255)
const.clrPaleBlue = RGB(127, 159, 255)
const.clrPink = RGB(255, 127, 127)
const.clrYellow = RGB(255, 255, 0)
const.clrPaleYellow = RGB(255, 255, 127)
const.clrGray = RGB(190, 190, 190)
const.clrStoneGray = RGB(191, 191, 207)
const.clrSilverGray = RGB(192, 192, 192)
const.clrDarkGray = RGB(169, 169, 169)
const.clrNoModifier = RGB(100, 100, 100)
const.clrOrange = RGB(255, 165, 0)
const.clrMagenta = RGB(255, 0, 255)
const.RolloverTime = 150
const.RolloverDestroyTime = const.RolloverTime
if Platform.ged then
  const.RolloverTime = 750
  const.RolloverDestroyTime = 0
end
const.RolloverRefreshDistance = 75
const.RolloverWidth = 300
const.alignLeft = 1
const.alignRight = 2
const.alignTop = 3
const.alignBottom = 4
const.MaxColorizationMaterials = 3
const.VerticalTextureZThreshold = "0.7"
const.BiomeSlopeAngleThreshold = 300
const.KbdAutoRepeatInterval = 400
const.RepeatButtonStart = 300
const.RepeatButtonInterval = 250
const.gsIdle = 1
const.gsWalk = 2
const.gsRun = 3
const.gsAttack = 4
const.gsDeflect = 5
const.gsDeflectIdle = 6
const.gsDie = 7
const.nConsoleHistoryMaxSize = 20
const.MaxDestsAroundObject = 16
const.TracksFadeOutDist = 3 * guim
const.surfNoCollision = 0
const.surfImpassableVolume = 1
const.surfImpassableTerrain = 2
const.surfWalkableSurface = 3
const.surfPassableTerrain = 4
const.WalkableMaxRadius = 30 * guim
const.SequenceDefaultLoopDelay = 1573
const.CustomGameColors = {
  [const.clrBlack] = "black",
  [const.clrWhite] = "white",
  [const.clrRed] = "red",
  [const.clrCyan] = "cyan",
  [const.clrGreen] = "green",
  [const.clrBlue] = "blue",
  [const.clrPaleBlue] = "pale blue",
  [const.clrPink] = "pink",
  [const.clrYellow] = "yellow",
  [const.clrOrange] = "orange",
  [const.clrPaleYellow] = "pale yellow",
  [const.clrStoneGray] = "stone gray"
}
const.ColorList = {
  const.clrGreen,
  const.clrBlue,
  const.clrRed,
  const.clrWhite,
  const.clrCyan,
  const.clrYellow,
  const.clrPink,
  const.clrOrange,
  const.clrPaleBlue,
  const.clrPaleYellow,
  const.clrStoneGray,
  const.clrBlack
}
if Platform.editor then
  const.ebtNull = 20
  const.ErodeIterations = 3
  const.ErodeAmount = 50
  const.ErodePersist = 5
  const.ErodeThreshold = 50
  const.ErodeCoefDiag = 500
  const.ErodeCoefRect = 1000
  const.RenderGizmoScreenDist = "20.0"
  const.AxisCylinderRadius = "0.10"
  const.AxisCylinderHeight = "4.0"
  const.AxisCylinderSlices = 10
  const.AxisConusRadius = "0.45"
  const.AxisConusHeight = "1.0"
  const.AxisConusSlices = 10
  const.PlaneLineRadius = "0.05"
  const.PlaneLineHeight = "2.5"
  const.PlaneLineSlices = 10
  const.XAxisColor = RGB(192, 0, 0)
  const.YAxisColor = RGB(0, 192, 0)
  const.ZAxisColor = RGB(0, 0, 192)
  const.XAxisColorSelected = RGB(255, 255, 0)
  const.YAxisColorSelected = RGB(255, 255, 0)
  const.ZAxisColorSelected = RGB(255, 255, 0)
  const.PlaneColor = RGBA(255, 255, 0, 200)
  const.MaxSingleScale = "3.0"
  const.PyramidSize = "1.5"
  const.PyramidSideRadius = "0.10"
  const.PyramidSideSlices = 10
  const.PyramidColor = RGB(0, 192, 192)
  const.SelectedSideColor = RGBA(255, 255, 0, 200)
  const.MapDirections = 8
  const.AxisRadius = "0.05"
  const.AxisLength = "1.5"
  const.AxisSlices = 5
  const.TorusRadius1 = "2.30"
  const.TorusRadius2 = "0.15"
  const.TorusRings = 15
  const.TorusSlices = 10
  const.TangentRadius = "0.1"
  const.TangentLength = "2.5"
  const.TangentSlices = 5
  const.TangentColor = RGB(255, 0, 255)
  const.TangentConusHeight = "0.50"
  const.TangentConusRadius = "0.30"
  const.BigTorusColor = RGB(0, 192, 192)
  const.BigTorusColorSelected = RGB(255, 255, 0)
  const.SphereColor = RGBA(128, 128, 128, 100)
  const.SphereRings = 15
  const.SphereSlices = 15
  const.BigTorusRadius = "3.5"
  const.BigTorusRadius2 = "0.15"
  const.BigTorusRings = 15
  const.BigTorusSlices = 10
  const.SnapRadius = 20
  const.SnapBoxSize = "0.1"
  const.SnapDistXYTolerance = 10
  const.SnapDistZTolerance = 2
  const.SnapScaleTolerance = 200
  const.SnapAngleTolerance = 720
  const.SnapDistXYCoef = 1
  const.SnapDistZCoef = 3
  const.SnapAngleCoef = 3
  const.SnapScaleCoef = 2
  const.SnapDrawWarningFitnessTreshold = 4000
  const.MinBrushDensity = 30
  const.MaxBrushDensity = 97
end
const.ObstructOpacity = 0
const.ObstructOpacityFadeOutTime = 300
const.ObstructOpacityFadeInTime = 300
const.ObstructViewRefreshTime = 50
const.ObstructOpacityRefreshTime = 20
const.ObstructViewMaxObjectSize = 9000
function GetEasingCombo(def_value, def_text)
  def_value = def_value or false
  def_text = def_text or ""
  local combo = {
    {value = def_value, text = def_text}
  }
  for i, name in ipairs(GetEasingNames()) do
    combo[#combo + 1] = {
      value = i - 1,
      text = name
    }
  end
  return combo
end
const.__string_reference = {
  "type",
  "easing",
  "flags",
  "start",
  "duration",
  "originalRect",
  "targetRect",
  "startValue",
  "endValue",
  "center",
  "startAngle",
  "endAngle",
  "child",
  "sub",
  "n",
  "hex",
  "rand",
  "detached",
  "map",
  "attached",
  "object_circles",
  "CObject",
  "collected",
  "collection",
  "shuffle",
  "DPadLeft",
  "DPadRight",
  "DPadUp",
  "DPadDown",
  "ButtonA",
  "ButtonB",
  "ButtonX",
  "ButtonY",
  "LeftThumbClick",
  "RightThumbClick",
  "Start",
  "Back",
  "LeftShoulder",
  "RightShoulder",
  "LeftTrigger",
  "RightTrigger",
  "LeftThumb",
  "RightThumb",
  "TouchPadClick"
}
const.VoiceChatForcedSampleRate = 11025
const.VoiceChatSoundType = "VoiceChat"
const.VoiceChatMaxSilence = 10000
const.VoiceChatFadeTime = 300
const.MinUserUIScale = 65
const.MaxUserUIScaleLowRes = 110
const.MaxUserUIScaleHighRes = 135
const.ControllerUIScale = const.ControllerUIScale or 111
const.MinDisplayAreaMargin = 0
const.MaxDisplayAreaMargin = 10
const.UIScaleDAMDependant = false
const.PrefabWorkRatio = 8
const.PrefabMaxPlayAngle = 180
const.PrefabMinPlayRadius = 40 * guim
const.PrefabAvgObjRadius = 6 * guim
const.PrefabMaxObjRadius = 60 * guim
const.PrefabRasterParallelDiv = 8
const.PrefabMaxMapSize = 8192 * guim
const.PrefabFeatureDensity = {
  {radius = 0, count = 1},
  {
    radius = 50 * guim,
    count = 2
  },
  {
    radius = 150 * guim,
    count = 3
  }
}
if Platform.desktop then
  const.PrefabRasterCacheMemory = 134217728
else
  const.PrefabRasterCacheMemory = 67108864
end
const.PrefabVersionOverride = false
const.PrefabVersionLog = false
const.PrefabRepeatReductPct = 20
const.PrefabGroupSimilarDistPct = 100
const.PrefabGroupSimilarWeight = 100
const.PrefabBasePropCount = 12
const.BiomeMaxWaterDist = 100 * guim
const.BiomeMinSeaLevel = -50 * guim
const.BiomeMaxSeaLevel = 50 * guim
const.EntityVolumeSmall = guim * guim * guim
const.EntityVolumeMedium = 3 * const.EntityVolumeSmall
const.WindMaxStrength = 4096
const.WindMarkerMaxRange = 50 * guim
const.WindMarkerAttenuationRange = 80 * guim
const.StrongWindThreshold = 100
const.WindModifierMaskComboItems = {
  {text = "None", value = 0},
  {text = "All", value = -1}
}
