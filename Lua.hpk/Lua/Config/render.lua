if not FirstLoad then
  return
end
hr.TrimParticles = 1
hr.MaxVisHeight = 100
hr.EnablePostProcRadialBlur = 0
hr.EnablePostProcDistanceBlur = 0
hr.EnableScreenSpaceAmbientObscurance = 0
hr.EnablePostProcAA = 1
hr.Shadowmap = 1
hr.ShadowPCFSize = 3
hr.ShadowCSMCascades = 4
hr.ShadowCSMRangeMinimum = 30
hr.ShadowCSMRangeMultiplier = 200
hr.ShadowSDSMEnable = true
hr.SSRZThickness = 0.07
hr.SSRZThicknessCoef = 0.005
hr.EnableDeposition = 1
hr.MaxTrails = 128
hr.GrassFadeRangeMin = 80
hr.GrassFadeRangeMax = 120
hr.FarZ = 2895872
hr.NearZ = 500
hr.CameraMaxZoomSlow = "0.05"
hr.CameraMaxZoomSpeed = "0.5"
hr.CameraMaxPanSpeed = 3
hr.CameraMaxPanSpeedFast = 40
hr.CameraMaxClampZ = 1200000
hr.CameraMaxClampXY = 700000
ShadingConst = {}
SetupVarTable(ShadingConst, "ShadingConst.")
SetVarTableLock(ShadingConst, true)
ShadingConst.ConstructionStage0Color = RGBA(40, 125, 130, 30)
ShadingConst.ConstructionStage1Color = RGBA(50, 70, 130, 30)
ShadingConst.ConstructionStage2Color = RGBA(45, 185, 25, 30)
ShadowBias = {
  Small = {
    clamp = "0.0",
    slope = "0.0",
    offset = "0.0"
  },
  Medium = {
    clamp = "0.0",
    slope = "0.0",
    offset = "0.0"
  },
  Large = {
    clamp = "0.0",
    slope = "0.0",
    offset = "0.0"
  },
  LowSlope = {
    clamp = "0.0",
    slope = "0.0",
    offset = "0.0"
  },
  Terrain = {
    clamp = "0.0",
    slope = "0.0",
    offset = "0.0"
  }
}
hr.ShadowmapSize = 4096
hr.LightShadowsSize = 4096
hr.NumberOfLightsWithShadows = 64
if Platform.neo or Platform.scorpio then
  hr.UIL_TextureWidth = 4096
  hr.UIL_TextureHeight = 4096
else
  hr.UIL_TextureWidth = 2048
  hr.UIL_TextureHeight = 2048
end
hr.FovAngle = 4200
hr.FovAngleAutoMinY = 40
hr.FovAngleAutoMaxY = 60
hr.FovAngleAutoLimits = 0
hr.HorizonWaterRange = 3000000
hr.ShadowFrustumNearCapOffset = 130
ShaderLists = {}
hr.ShadowFadeOutRangePercent = 30
hr.ForceRefractionCopy = 1
hr.EnableShaderCompilation = 1
hr.TODSunriseTime = 230
hr.TODSunriseAzi = 6840
hr.TODSunsetTime = 1210
hr.TODSunsetAzi = 14760
hr.TODSunMaxElevation = 3600
hr.TODSunShadowMinAltitude = 900
const.MovieCorrectionDesaturation = 0
const.MovieCorrectionGamma = 1700
hr.ShadowSDSMReadbackLatency = 1
if Platform.xbox then
  hr.EnableShaderCompilation = 0
end
InsertProceduralMeshShaders({
  {
    shaderid = "RangeContours.fx",
    defines = {
      "RANGE_CONTOUR"
    },
    name = "range_contour",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {
      "RANGE_CONTOUR_DEFAULT"
    },
    name = "range_contour_default",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {
      "INSIDE_BORDER"
    },
    name = "inside_border_active",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {
      "COMBAT_BORDER"
    },
    name = "combat_border",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "runtime"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {
      "INSIDE_BORDER",
      "INACTIVE"
    },
    name = "inside_border_inactive",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {
      "INSIDE_BORDER",
      "INACTIVE"
    },
    name = "enemy_aware_range",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "never"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {
      "RANGE_CONTOUR"
    },
    name = "path_contour",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "runtime"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {
      "CENTERED_LINE"
    },
    name = "centered_line",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "runtime"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {
      "VISION_LINE"
    },
    name = "vision_line",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "runtime"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {"EXIT_ZONE"},
    name = "exit_zone",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {"CONE"},
    name = "cone",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "runtime"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {"MAP_BORDER"},
    name = "map_border",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {
      "GROUND_STROKES"
    },
    name = "ground_strokes",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "runtime"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {
      "DEPLOYMENT_GRID"
    },
    name = "deployment_grid",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  },
  {
    shaderid = "Overwatch.fx",
    defines = {
      "AOE_TILES_SECTOR"
    },
    name = "aoe_tiles_sector",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  },
  {
    shaderid = "Overwatch.fx",
    defines = {
      "OVERWATCH_WALLS"
    },
    name = "overwatch_lines",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  },
  {
    shaderid = "Overwatch.fx",
    defines = {
      "GRENADE_SPHERE"
    },
    name = "grenade_sphere",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  },
  {
    shaderid = "Overwatch.fx",
    defines = {
      "GRENADE_AOE_TILES_SPHERE"
    },
    name = "grenade_aoe_tiles_sphere",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {
      "MELEE_AOE_TILES"
    },
    name = "melee_aoe_tiles",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {
      "AOE_TILES_CIRCLE"
    },
    name = "aoe_tiles_circle",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {
      "AOE_TILES_CYLINDER"
    },
    name = "aoe_tiles_cylinder",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  },
  {
    shaderid = "RangeContours.fx",
    defines = {
      "AWARENESS_INDICATOR"
    },
    name = "awareness_indicator",
    topology = const.ptTriangleList,
    cull_mode = const.cullModeNone,
    blend_mode = const.blendNormal,
    depth_test = "always"
  }
})
hr.HairRoughness = 100
hr.HairMetallic = 50
