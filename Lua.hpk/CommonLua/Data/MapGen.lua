PlaceObj("MapGen", {
  "SaveIn",
  "Common",
  "Id",
  "BiomeCreator",
  "OnChange",
  "",
  "Lightmodel",
  "LevelDesign",
  "LoadSeed",
  true,
  "Dump",
  true
}, {
  PlaceObj("GridOpRun", {
    "Sequence",
    "WM_ReadGrids"
  }),
  PlaceObj("GridOpRun", {
    "Sequence",
    "WM_ProcessGrids"
  }),
  PlaceObj("GridOpRun", {
    "Sequence",
    "WM_MapReset"
  }),
  PlaceObj("GridOpDbg", {
    "RunModes",
    set("Debug"),
    "Show",
    "clear"
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Colorize terrain"
  }),
  PlaceObj("GridOpMapImport", {
    "Operation",
    "Color",
    "InputName",
    "ColorMap",
    "ColorRed",
    -1000,
    "ColorGreen",
    -1000,
    "ColorBlue",
    -1000
  }),
  PlaceObj("GridOpDbg", {
    "Enabled",
    false,
    "RunModes",
    set("Debug"),
    "Grid",
    "WaterMap",
    "AllowInspect",
    true
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Match biomes"
  }),
  PlaceObj("GridOpMapBiomeMatch", {
    "UseParams",
    true,
    "OutputName",
    "BiomeMap",
    "AllowInspect",
    true,
    "BiomeGroupParam",
    "BiomeGroup",
    "HeightMap",
    "HeightMapDistort",
    "SlopeMap",
    "SlopeMapSmooth",
    "WetMap",
    "WetMapSmooth",
    "HardnessMap",
    "HardnessMap",
    "OrientMap",
    "OrientMap",
    "SeaLevelMap",
    "SeaLevelMap",
    "WaterDistMap",
    "WaterDistDistort"
  }),
  PlaceObj("GridOpMapImport", {
    "Operation",
    "Biome",
    "InputName",
    "BiomeMap"
  }),
  PlaceObj("GridOpDbg", {
    "RunModes",
    set("Debug"),
    "Show",
    "biome",
    "Grid",
    "ColorMap",
    "AllowInspect",
    true,
    "ColorRand",
    true
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Set terrain textures"
  }),
  PlaceObj("GridOpMapPrefabTypes", {
    "InputName",
    "BiomeMap",
    "OutputName",
    "PrefabTypeMap",
    "AllowEmptyTypes",
    true
  }),
  PlaceObj("GridOpMapBiomeTexture", {
    "InputName",
    "PrefabTypeMap",
    "AllowInspect",
    true,
    "FlowMap",
    "FlowMap",
    "FlowMax",
    100,
    "HeightMap",
    "HeightMap",
    "GrassMap",
    "GrassMap"
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Place prefabs"
  }),
  PlaceObj("BiomeFiller", {
    "InputName",
    "PrefabTypeMap",
    "SlopeGrid",
    "SlopeMap",
    "LoadPrefabLoc",
    true,
    "SavePrefabLoc",
    true
  }),
  PlaceObj("GridOpComment", {"Comment", "Finalize"}),
  PlaceObj("GridOpRun", {
    "Sequence",
    "PostProcessRandomMap"
  })
})
PlaceObj("MapGen", {
  "SaveIn",
  "Common",
  "Id",
  "BiomeFiller",
  "OnChange",
  ""
}, {
  PlaceObj("GridOpMapExport", {
    "Operation",
    "Biome",
    "OutputName",
    "BiomeMap"
  }),
  PlaceObj("GridOpMapPrefabTypes", {
    "InputName",
    "BiomeMap",
    "OutputName",
    "PrefabTypeMap",
    "AllowEmptyTypes",
    true
  }),
  PlaceObj("GridOpDistort", {
    "InputName",
    "PrefabTypeMap",
    "OutputName",
    "PrefabTypeMap",
    "Frequency",
    50,
    "Octave_1",
    64,
    "Octave_2",
    128,
    "Octave_4",
    512,
    "Octave_5",
    1024,
    "Octave_6",
    512,
    "Octave_7",
    256,
    "Octave_8",
    128,
    "Octave_9",
    64,
    "Strength",
    40
  }),
  PlaceObj("BiomeFiller", {
    "InputName",
    "PrefabTypeMap"
  })
})
PlaceObj("MapGen", {
  "SaveIn",
  "Common",
  "Id",
  "ImportHeight"
}, {
  PlaceObj("GridOpDir", {
    "BaseDir",
    "svnAssets/Bin/win32/Bin/AppData/temp/"
  }),
  PlaceObj("GridOpRead", {
    "OutputName",
    "HM",
    "FileName",
    "WorldMap.raw",
    "FileFormat",
    "raw16"
  }),
  PlaceObj("GridOpMapImport", {
    "Operation",
    "Height",
    "InputName",
    "HM"
  })
})
PlaceObj("MapGen", {
  "SaveIn",
  "Common",
  "Id",
  "MountainDemo",
  "OnChange",
  "",
  "Randomize",
  true
}, {
  PlaceObj("GridOpComment", {
    "Comment",
    "Obtain a mountain pattern. Needs a random shape in the biome grid as input. Used to demonstrate the documentation found in Docs/Internal/MapGenDemo.html."
  }),
  PlaceObj("GridOpMapExport", {
    "Operation",
    "Biome",
    "OutputName",
    "Mountain"
  }),
  PlaceObj("GridOpWrite", {
    "RunModes",
    set("Debug"),
    "InputName",
    "Mountain",
    "FileName",
    "Pattern.png",
    "FileFormat",
    "image"
  }),
  PlaceObj("GridOpChangeLim", {
    "Operation",
    "Mask",
    "InputName",
    "Mountain",
    "OutputName",
    "Mountain",
    "Max",
    0
  }),
  PlaceObj("GridOpConvert", {
    "InputName",
    "Mountain",
    "OutputName",
    "Mountain"
  }),
  PlaceObj("GridOpConvert", {
    "Operation",
    "Repack",
    "InputName",
    "Mountain",
    "OutputName",
    "Mountain",
    "GridType",
    "float"
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Calculate distance transform:"
  }),
  PlaceObj("GridOpDistance", {
    "InputName",
    "Mountain",
    "OutputName",
    "Mountain"
  }),
  PlaceObj("GridOpWrite", {
    "RunModes",
    set("Debug"),
    "InputName",
    "Mountain",
    "FileName",
    "Distance.png",
    "FileFormat",
    "image"
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Generate Perlin noise between 0 and 1:"
  }),
  PlaceObj("GridOpNoise", {
    "OutputName",
    "Noise",
    "RefName",
    "Mountain"
  }),
  PlaceObj("GridOpWrite", {
    "RunModes",
    set("Debug"),
    "InputName",
    "Noise",
    "FileName",
    "Noise.png",
    "FileFormat",
    "image"
  }),
  PlaceObj("GridOpChangeLim", {
    "InputName",
    "Noise",
    "OutputName",
    "Noise"
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Combine the noise and the distance:"
  }),
  PlaceObj("GridOpMulDivAdd", {
    "InputName",
    "Mountain",
    "OutputName",
    "Mountain",
    "MulName",
    "Noise"
  }),
  PlaceObj("GridOpWrite", {
    "RunModes",
    set("Debug"),
    "InputName",
    "Mountain",
    "FileName",
    "Combined.png",
    "FileFormat",
    "image"
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Distort the product:"
  }),
  PlaceObj("GridOpDistort", {
    "InputName",
    "Mountain",
    "OutputName",
    "Mountain",
    "Octave_1",
    256,
    "Octave_3",
    1024,
    "Octave_4",
    512,
    "Octave_5",
    256,
    "Octave_6",
    128,
    "Octave_7",
    64,
    "Octave_8",
    32,
    "Octave_9",
    16,
    "Strength",
    80
  }),
  PlaceObj("GridOpWrite", {
    "RunModes",
    set("Debug"),
    "InputName",
    "Mountain",
    "FileName",
    "Distort.png",
    "FileFormat",
    "image"
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Apply errosion:"
  }),
  PlaceObj("GridOpMapErosion", {
    "InputName",
    "Mountain",
    "OutputName",
    "Mountain",
    "Iterations",
    200
  }),
  PlaceObj("GridOpWrite", {
    "RunModes",
    set("Debug"),
    "InputName",
    "Mountain",
    "FileName",
    "Erosion.png",
    "FileFormat",
    "image"
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Apply the the height map:"
  }),
  PlaceObj("GridOpMapImport", {
    "Operation",
    "Height",
    "InputName",
    "Mountain",
    "Normalize",
    true,
    "HeightMax",
    30000
  })
})
PlaceObj("MapGen", {
  "Group",
  "SubProc",
  "SaveIn",
  "Common",
  "Id",
  "MapClear"
}, {
  PlaceObj("GridOpMapReset", nil),
  PlaceObj("GridOpMapReset", {
    "Operation",
    "Height",
    "Type",
    "TerrainGray"
  }),
  PlaceObj("GridOpMapReset", {"Operation", "Grass"}),
  PlaceObj("GridOpMapReset", {
    "Operation",
    "Objects",
    "Type",
    "dirt"
  }),
  PlaceObj("GridOpMapReset", {"Operation", "Color"})
})
PlaceObj("MapGen", {
  "Group",
  "SubProc",
  "SaveIn",
  "Common",
  "Id",
  "MapParams",
  "RunOnce",
  true
}, {
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "MapGridSize",
    "ParamValue",
    "point(terrain.TypeMapSize())"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "MapGridWidth",
    "ParamValue",
    "MapGridSize:x()"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "MapGridHeight",
    "ParamValue",
    "MapGridSize:y()"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "HeightScale",
    "ParamValue",
    "const.TerrainHeightScale"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "MapMaxHeight",
    "ParamValue",
    "const.MaxTerrainHeight / HeightScale"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "HeightTile",
    "ParamValue",
    "const.HeightTileSize"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "SlabSizeZ",
    "ParamValue",
    "const.SlabSizeZ"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "SlabSizeX",
    "ParamValue",
    "const.SlabSizeX"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "BiomeGroup",
    "ParamValue",
    "mapdata.BiomeGroup"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "HeightMin",
    "ParamValue",
    "mapdata.HeightMin / HeightScale"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "HeightMax",
    "ParamValue",
    "mapdata.HeightMax / HeightScale"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "WetMin",
    "ParamValue",
    "mapdata.WetMin"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "WetMax",
    "ParamValue",
    "mapdata.WetMax"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "GrassGridSize",
    "ParamValue",
    "point(terrain.GrassMapSize())"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "GrassGridWidth",
    "ParamValue",
    "GrassGridSize:x()"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "GrassGridHeight",
    "ParamValue",
    "GrassGridSize:y()"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "MaxSlope",
    "ParamValue",
    "const.MaxPassableTerrainSlope"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "MaxWaterDist",
    "ParamValue",
    "const.BiomeMaxWaterDist"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "MinSeaLevel",
    "ParamValue",
    "const.BiomeMinSeaLevel / HeightScale"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "MaxSeaLevel",
    "ParamValue",
    "const.BiomeMaxSeaLevel / HeightScale"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "SeaLevelSub",
    "ParamValue",
    "mapdata.SeaLevel > 0 and -mapdata.SeaLevel / HeightScale"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "PassBorder",
    "ParamValue",
    "mapdata.PassBorder"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "InfinityPositive",
    "ParamValue",
    "max_int"
  }),
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "InfinityNegative",
    "ParamValue",
    "min_int"
  })
})
PlaceObj("MapGen", {
  "Group",
  "SubProc",
  "SaveIn",
  "Common",
  "Id",
  "PostProcessRandomMap"
}, {
  PlaceObj("GridOpRun", {
    "Operation",
    "Code",
    "Code",
    function(state, grid)
      mapdata.IsRandomMap = true
    end
  })
})
PlaceObj("MapGen", {
  "Group",
  "SubProc",
  "SaveIn",
  "Common",
  "Id",
  "ResampleGrids"
}, {
  PlaceObj("GridOpRun", {"Sequence", "MapParams"}),
  PlaceObj("GridOpResample", {
    "UseParams",
    true,
    "InputName",
    "HeightMap",
    "OutputName",
    "HeightMap",
    "WidthParam",
    "MapGridWidth",
    "HeightParam",
    "MapGridHeight"
  }),
  PlaceObj("GridOpResample", {
    "UseParams",
    true,
    "InputName",
    "FlowMap",
    "OutputName",
    "FlowMap",
    "WidthParam",
    "MapGridWidth",
    "HeightParam",
    "MapGridHeight"
  }),
  PlaceObj("GridOpResample", {
    "UseParams",
    true,
    "InputName",
    "WetMap",
    "OutputName",
    "WetMap",
    "WidthParam",
    "MapGridWidth",
    "HeightParam",
    "MapGridHeight"
  }),
  PlaceObj("GridOpResample", {
    "Optional",
    true,
    "UseParams",
    true,
    "InputName",
    "WaterDist",
    "OutputName",
    "WaterDist",
    "WidthParam",
    "MapGridWidth",
    "HeightParam",
    "MapGridHeight"
  }),
  PlaceObj("GridOpResample", {
    "Optional",
    true,
    "UseParams",
    true,
    "InputName",
    "HardnessMap",
    "OutputName",
    "HardnessMap",
    "WidthParam",
    "MapGridWidth",
    "HeightParam",
    "MapGridHeight"
  })
})
PlaceObj("MapGen", {
  "Group",
  "SubProc",
  "SaveIn",
  "Common",
  "Id",
  "WM_MapReset"
}, {
  PlaceObj("GridOpMapImport", {
    "Operation",
    "Height",
    "InputName",
    "HeightMap"
  }),
  PlaceObj("GridOpMapReset", {
    "Operation",
    "Objects",
    "Type",
    "dirt",
    "FilterFlagsAll",
    set(),
    "FilterFlagsAny",
    set("Generated", "Permanent")
  }),
  PlaceObj("GridOpMapReset", {
    "Operation",
    "Grass",
    "Type",
    "dirt"
  }),
  PlaceObj("GridOpMapReset", nil),
  PlaceObj("GridOpMapReset", {"Operation", "Color"}),
  PlaceObj("GridOpDbg", {"Show", "clear"})
})
PlaceObj("MapGen", {
  "Group",
  "SubProc",
  "SaveIn",
  "Common",
  "Id",
  "WM_ProcessGrids",
  "RunMode",
  "Debug"
}, {
  PlaceObj("GridOpRun", {"Sequence", "MapParams"}),
  PlaceObj("GridOpConvert", {
    "Operation",
    "Repack",
    "InputName",
    "HeightMap",
    "OutputName",
    "HeightMapFloat",
    "GridType",
    "float"
  }),
  PlaceObj("GridOpFilter", {
    "Operation",
    "Convolution",
    "InputName",
    "HeightMapFloat",
    "OutputName",
    "HeightMapFloat",
    "Strength",
    50,
    "Kernel",
    {
      1,
      2,
      1,
      2,
      4,
      2,
      1,
      2,
      1
    },
    "Scale",
    16,
    "RestoreLims",
    true
  }),
  PlaceObj("GridOpConvert", {
    "Operation",
    "Repack",
    "InputName",
    "HeightMapFloat",
    "OutputName",
    "HeightMap",
    "RefName",
    "HeightMap",
    "GridRound",
    true
  }),
  PlaceObj("GridOpDistort", {
    "InputName",
    "HeightMap",
    "OutputName",
    "HeightMapDistort",
    "Octave_4",
    186,
    "Octave_5",
    98,
    "Octave_6",
    269,
    "Octave_7",
    205,
    "Octave_8",
    170
  }),
  PlaceObj("GridOpFilter", {
    "InputName",
    "WetMap",
    "OutputName",
    "WetMapSmooth",
    "Intensity",
    3,
    "Kernel",
    {
      1,
      2,
      1,
      2,
      4,
      2,
      1,
      2,
      1
    },
    "Scale",
    16,
    "RestoreLims",
    true
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Slope map ----------------------------------------------"
  }),
  PlaceObj("GridOpMapSlope", {
    "InputName",
    "HeightMapFloat",
    "OutputName",
    "SlopeMap",
    "Units",
    "minutes"
  }),
  PlaceObj("GridOpFilter", {
    "InputName",
    "SlopeMap",
    "OutputName",
    "SlopeMapSmooth",
    "Scale",
    16
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Orient map ----------------------------------------------"
  }),
  PlaceObj("GridOpMapSlope", {
    "Operation",
    "Orientation",
    "InputName",
    "HeightMapFloat",
    "OutputName",
    "OrientMap",
    "Units",
    ""
  }),
  PlaceObj("GridOpChangeLim", {
    "Operation",
    "Remap",
    "InputName",
    "OrientMap",
    "OutputName",
    "OrientMap",
    "Min",
    -1,
    "Remap",
    true,
    "RemapMax",
    1000
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Water dist ----------------------------------------------"
  }),
  PlaceObj("GridOpDistort", {
    "Optional",
    true,
    "InputName",
    "WaterDist",
    "OutputName",
    "WaterDistDistort",
    "Octave_4",
    186,
    "Octave_5",
    98,
    "Octave_6",
    269,
    "Octave_7",
    205,
    "Octave_8",
    170
  }),
  PlaceObj("GridOpFilter", {
    "Optional",
    true,
    "InputName",
    "WaterDist",
    "OutputName",
    "WaterDistCoef",
    "Intensity",
    5,
    "Scale",
    16,
    "RestoreLims",
    true
  }),
  PlaceObj("GridOpConvert", {
    "Optional",
    true,
    "Operation",
    "Abs",
    "InputName",
    "WaterDistCoef",
    "OutputName",
    "WaterDistCoef"
  }),
  PlaceObj("GridOpMulDivAdd", {
    "Optional",
    true,
    "UseParams",
    true,
    "InputName",
    "WaterDistCoef",
    "OutputName",
    "WaterDistCoef",
    "DivParam",
    "MaxWaterDist"
  }),
  PlaceObj("GridOpMulDivAdd", {
    "Optional",
    true,
    "InputName",
    "WaterDistDistort",
    "OutputName",
    "WaterDistDistort",
    "MulName",
    "WaterDistCoef"
  }),
  PlaceObj("GridOpLerp", {
    "Optional",
    true,
    "InputName",
    "WaterDist",
    "OutputName",
    "WaterDistDistort",
    "TargetName",
    "WaterDistDistort",
    "MaskName",
    "WaterDistCoef"
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Sea level ----------------------------------------------"
  }),
  PlaceObj("GridOpMulDivAdd", {
    "Optional",
    true,
    "UseParams",
    true,
    "InputName",
    "HeightMapFloat",
    "OutputName",
    "SeaLevelMap",
    "AddParam",
    "SeaLevelSub"
  }),
  PlaceObj("GridOpChangeLim", {
    "Optional",
    true,
    "UseParams",
    true,
    "Operation",
    "Clamp",
    "InputName",
    "SeaLevelMap",
    "OutputName",
    "SeaLevelMap",
    "MinParam",
    "MinSeaLevel",
    "MaxParam",
    "MaxSeaLevel"
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Color map ----------------------------------------------"
  }),
  PlaceObj("GridOpNoise", {
    "UseParams",
    true,
    "OutputName",
    "ColorNoise",
    "RefName",
    "SlopeMap",
    "Width",
    4096,
    "Height",
    4096,
    "GridType",
    "float",
    "Frequency",
    70,
    "Octave_1",
    16,
    "Octave_2",
    32,
    "Octave_3",
    64,
    "Octave_5",
    256,
    "Octave_6",
    512,
    "Octave_7",
    1024,
    "Octave_8",
    512,
    "Octave_9",
    256
  }),
  PlaceObj("GridOpChangeLim", {
    "InputName",
    "ColorNoise",
    "OutputName",
    "ColorNoise",
    "Max",
    50,
    "MaxParam",
    "MapMaxHeight"
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Leave the flow in the slopes only, while the noise will cover the plains:"
  }),
  PlaceObj("GridOpLerp", {
    "InputName",
    "ColorNoise",
    "OutputName",
    "ColorMap",
    "TargetName",
    "FlowMap",
    "MaskName",
    "SlopeMap"
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Flow map ----------------------------------------------"
  }),
  PlaceObj("GridOpChangeLim", {
    "Operation",
    "Mask",
    "InputName",
    "SlopeMap",
    "OutputName",
    "InvFlatMask",
    "Min",
    900,
    "Max",
    100000
  }),
  PlaceObj("GridOpMulDivAdd", {
    "InputName",
    "FlowMap",
    "OutputName",
    "FlowMap",
    "MulName",
    "InvFlatMask"
  })
})
PlaceObj("MapGen", {
  "Group",
  "SubProc",
  "SaveIn",
  "Common",
  "Id",
  "WM_ReadGrids",
  "RunOnce",
  true
}, {
  PlaceObj("GridOpComment", {
    "Comment",
    "The base directory name matches the loaded map name"
  }),
  PlaceObj("GridOpDir", {
    "Enabled",
    false,
    "BaseDir",
    "svnAssets/Source/MapGen/alt_02/"
  }),
  PlaceObj("GridOpRun", {"Sequence", "MapParams"}),
  PlaceObj("GridOpComment", {"Comment", "Wet map"}),
  PlaceObj("GridOpRead", {
    "OutputName",
    "WetMap",
    "FileName",
    "wear.raw"
  }),
  PlaceObj("GridOpConvert", {
    "Operation",
    "Repack",
    "InputName",
    "WetMap",
    "OutputName",
    "WetMap",
    "GridType",
    "float"
  }),
  PlaceObj("GridOpChangeLim", {
    "UseParams",
    true,
    "Operation",
    "Remap",
    "InputName",
    "WetMap",
    "OutputName",
    "WetMap",
    "Max",
    255,
    "Remap",
    true,
    "RemapMinParam",
    "WetMin",
    "RemapMax",
    100,
    "RemapMaxParam",
    "WetMax"
  }),
  PlaceObj("GridOpComment", {"Comment", "Height map"}),
  PlaceObj("GridOpRead", {
    "OutputName",
    "HeightMap",
    "FileName",
    "height.r16"
  }),
  PlaceObj("GridOpChangeLim", {
    "UseParams",
    true,
    "InputName",
    "HeightMap",
    "OutputName",
    "HeightMap",
    "MinParam",
    "HeightMin",
    "MaxParam",
    "HeightMax"
  }),
  PlaceObj("GridOpComment", {"Comment", "Flow map"}),
  PlaceObj("GridOpRead", {
    "OutputName",
    "FlowMap",
    "FileName",
    "flow.raw"
  }),
  PlaceObj("GridOpConvert", {
    "Operation",
    "Repack",
    "InputName",
    "FlowMap",
    "OutputName",
    "FlowMap",
    "GridType",
    "float"
  }),
  PlaceObj("GridOpChangeLim", {
    "Operation",
    "Remap",
    "InputName",
    "FlowMap",
    "OutputName",
    "FlowMap",
    "Max",
    255,
    "Remap",
    true,
    "RemapMax",
    100
  }),
  PlaceObj("GridOpChangeLim", {
    "Operation",
    "Clamp",
    "InputName",
    "FlowMap",
    "OutputName",
    "FlowMap",
    "Max",
    50,
    "Smooth",
    true,
    "Remap",
    true,
    "RemapMax",
    100
  }),
  PlaceObj("GridOpComment", {"Comment", "Water map"}),
  PlaceObj("GridOpRead", {
    "Optional",
    true,
    "OutputName",
    "WaterMap",
    "FileName",
    "water.r16"
  }),
  PlaceObj("GridOpConvert", {
    "Optional",
    true,
    "Operation",
    "Repack",
    "InputName",
    "WaterMap",
    "OutputName",
    "WaterMap",
    "GridType",
    "float"
  }),
  PlaceObj("GridOpRun", {
    "Optional",
    true,
    "Operation",
    "Func",
    "InputName",
    "WaterMap",
    "OutputName",
    "WaterDist",
    "Func",
    "BiomeWaterDist"
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Hardness map"
  }),
  PlaceObj("GridOpRead", {
    "Optional",
    true,
    "OutputName",
    "HardnessMap",
    "FileName",
    "hardness.raw"
  }),
  PlaceObj("GridOpConvert", {
    "Optional",
    true,
    "Operation",
    "Repack",
    "InputName",
    "HardnessMap",
    "OutputName",
    "HardnessMap",
    "GridType",
    "float"
  }),
  PlaceObj("GridOpChangeLim", {
    "Operation",
    "Remap",
    "InputName",
    "HardnessMap",
    "OutputName",
    "HardnessMap",
    "Max",
    255,
    "Remap",
    true,
    "RemapMax",
    100
  }),
  PlaceObj("GridOpComment", {
    "Comment",
    "Resample in developer mode to use the same grids over different map sizes"
  }),
  PlaceObj("GridOpRun", {
    "Sequence",
    "ResampleGrids"
  }),
  PlaceObj("GridOpComment", {"Comment", "Grass map"}),
  PlaceObj("GridOpNoise", {
    "UseParams",
    true,
    "OutputName",
    "GrassMap",
    "WidthParam",
    "GrassGridWidth",
    "HeightParam",
    "GrassGridHeight",
    "GridType",
    "uint16",
    "Frequency",
    70,
    "Octave_1",
    16,
    "Octave_2",
    32,
    "Octave_3",
    64,
    "Octave_5",
    256,
    "Octave_6",
    512,
    "Octave_7",
    1024,
    "Octave_8",
    512,
    "Octave_9",
    256
  }),
  PlaceObj("GridOpChangeLim", {
    "InputName",
    "GrassMap",
    "OutputName",
    "GrassMap",
    "Max",
    100
  }),
  PlaceObj("GridOpConvert", {
    "Operation",
    "Repack",
    "InputName",
    "GrassMap",
    "OutputName",
    "GrassMap",
    "GridType",
    "uint8"
  })
})
PlaceObj("MapGen", {
  "Group",
  "Tools",
  "SaveIn",
  "Common",
  "Id",
  "MapBackupRestore",
  "OnChange",
  "",
  "RunMode",
  "Debug",
  "Randomize",
  true
}, {
  PlaceObj("GridOpMapReset", {"Operation", "Backup"})
})
PlaceObj("MapGen", {
  "Group",
  "Tools",
  "SaveIn",
  "Common",
  "Id",
  "MapBackupStore",
  "OnChange",
  "",
  "RunMode",
  "Debug",
  "Randomize",
  true
}, {
  PlaceObj("GridOpMapReset", {
    "Operation",
    "Backup",
    "Overwrite",
    true
  })
})
PlaceObj("MapGen", {
  "Group",
  "Tools",
  "SaveIn",
  "Common",
  "Id",
  "MapHeightMove",
  "OnChange",
  ""
}, {
  PlaceObj("GridOpParamEval", {
    "ParamName",
    "HeightChange",
    "ParamValue",
    "10 * guim"
  }),
  PlaceObj("GridOpRun", {
    "Operation",
    "Code",
    "Code",
    function(state, grid)
      ChangeMapZ(state.params.HeightChange)
    end
  })
})
PlaceObj("MapGen", {
  "Group",
  "Tools",
  "SaveIn",
  "Common",
  "Id",
  "ShowGrassDensity",
  "OnChange",
  "",
  "RunMode",
  "Debug"
}, {
  PlaceObj("GridOpRun", {"Sequence", "MapParams"}),
  PlaceObj("GridOpMapExport", {
    "Operation",
    "Grass",
    "OutputName",
    "DbgGrid"
  }),
  PlaceObj("GridOpResample", {
    "UseParams",
    true,
    "InputName",
    "DbgGrid",
    "OutputName",
    "DbgGrid",
    "WidthParam",
    "MapGridWidth",
    "HeightParam",
    "MapGridHeight"
  }),
  PlaceObj("GridOpDbg", {
    "Grid",
    "DbgGrid",
    "Normalize",
    false,
    "ValueMax",
    100
  })
})
PlaceObj("MapGen", {
  "Group",
  "Tools",
  "SaveIn",
  "Common",
  "Id",
  "ShowSoundSources",
  "OnChange",
  "",
  "RunMode",
  "Debug"
}, {
  PlaceObj("GridOpRun", {
    "Operation",
    "Code",
    "OutputName",
    "DbgGrid",
    "Code",
    function(state, grid)
      local mw, mh = terrain.GetMapSize()
      local gw, gh = terrain.TypeMapSize()
      local g = NewComputeGrid(gw, gh, "u", 16)
      local hash_to_value = {}
      local values = 0
      MapForEach("map", "SoundSource", function(obj)
        local h = obj:GetSoundHash()
        local v = hash_to_value[h]
        if not v then
          v = values + 1
          hash_to_value[h] = v
          values = v
        end
        local mr = obj:ResolveLoudDistance()
        if 0 < mr then
          local gr = mr * gw / mw
          local mx, my = obj:GetPosXYZ()
          local gx, gy = mx * gw / mw, my * gh / mh
          GridCircleSet(g, v, gx, gy, gr)
        end
      end)
      return nil, g
    end
  }),
  PlaceObj("GridOpDbg", {
    "Grid",
    "DbgGrid",
    "ColorRand",
    true,
    "InvalidValue",
    0,
    "ColorFrom",
    RGBA(255, 0, 0, 0),
    "ColorTo",
    RGBA(128, 0, 0, 255),
    "Normalize",
    false,
    "ValueMax",
    2
  })
})
PlaceObj("MapGen", {
  "Group",
  "Tools",
  "SaveIn",
  "Common",
  "Id",
  "ShowTerrainTypes",
  "RunMode",
  "Debug"
}, {
  PlaceObj("GridOpMapExport", {"OutputName", "DbgGrid"}),
  PlaceObj("GridOpDbg", {
    "Grid",
    "DbgGrid",
    "ColorRand",
    true
  })
})
