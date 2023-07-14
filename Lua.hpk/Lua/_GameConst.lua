CombatRaycastEnumFlags = const.efVisible + const.efCollision
const.TagLookupTable.left_click = "<image UI/Icons/left_click.tga 1400>"
const.TagLookupTable.right_click = "<image UI/Icons/right_click.tga 1400>"
const.TagLookupTable.middle_click = "<image UI/Icons/middle_click.tga 1400>"
const.TagLookupTable.mouse_button_4 = "<image UI/Icons/button_4.tga 1400>"
const.TagLookupTable.mouse_button_5 = "<image UI/Icons/button_5.tga 1400>"
const.TagLookupTable.mouse_wheel_up = "<image UI/Icons/scroll_up.tga 1400>"
const.TagLookupTable.mouse_wheel_down = "<image UI/Icons/scroll_down.tga 1400>"
const.BlueEMColor = "<color 21 132 138>"
const.TagLookupTable.em = "<color EmStyle>"
const.TagLookupTable["/em"] = "</color>"
const.TagLookupTable.flavor = "<color FlavorStyle>"
const.TagLookupTable["/flavor"] = "</color>"
const.TagLookupTable.error = "<color InfopanelError>"
const.TagLookupTable["/error"] = "</color>"
const.TagLookupTable.bullet_tab = " "
const.TagLookupTable.bullet_point = "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 130 128 120>"
const.TagLookupTable["/bullet_point"] = ""
const.TagLookupTable.bullet_point_em = "<image UI/Conversation/T_Dialogue_IconBackgroundCircle.tga 400 196 175 117><style InventoryRolloverHintEm>"
const.TagLookupTable["/bullet_point_em"] = "</style>"
const.TagLookupTable.red = "<color 191 67 77><shadowcolor 1 60 40>"
const.TagLookupTable["/red"] = "</shadowcolor></color>"
const.TagLookupTable.green = "<color 124 130 96>"
const.TagLookupTable["/green"] = "</color>"
const.TagLookupTable.item_green = "<color 144 151 111>"
const.TagLookupTable["/item_green"] = "</color>"
const.TagLookupTable.yellow = "<color 244 228 117>"
const.TagLookupTable["/yellow"] = "</color>"
const.TagLookupTable.white = "<color 248 242 230>"
const.TagLookupTable["/white"] = "</color>"
for k, v in pairs(GameColors) do
  const.TagLookupTable["GameColor" .. k] = string.format("<color %d %d %d>", GetRGB(v))
  const.TagLookupTable["/GameColor" .. k] = "</color>"
end
const.TagLookupTable.aggressive = ""
const.TagLookupTable["/aggressive"] = ""
const.TagLookupTable.joking = ""
const.TagLookupTable["/joking"] = ""
const.TagLookupTable.sarcastic = ""
const.TagLookupTable["/sarcastic"] = ""
const.TagLookupTable.concentrated = ""
const.TagLookupTable["/concentrated"] = ""
const.TagLookupTable.scared = ""
const.TagLookupTable["/scared"] = ""
const.TagLookupTable.teasing = ""
const.TagLookupTable["/teasing"] = ""
const.TagLookupTable.happy = ""
const.TagLookupTable["/happy"] = ""
const.TagLookupTable.surprised = ""
const.TagLookupTable["/surprised"] = ""
const.TagLookupTable.friendly = ""
const.TagLookupTable["/friendly"] = ""
const.TagLookupTable.disgusted = ""
const.TagLookupTable["/disgusted"] = ""
const.TagLookupTable.calm = ""
const.TagLookupTable["/calm"] = ""
const.TagLookupTable.critical = ""
const.TagLookupTable["/critical"] = ""
const.TagLookupTable.confused = ""
const.TagLookupTable["/confused"] = ""
const.TagLookupTable.excited = ""
const.TagLookupTable["/excited"] = ""
const.TagLookupTable.seductive = ""
const.TagLookupTable["/seductive"] = ""
const.PrefabAvgObjRadius = 1 * guim
const.VisibleUIColorModifier = const.clrWhite
const.DimmedUIColorModifier = RGB(20, 20, 20)
const.CoverUIColorModifier = RGB(12, 38, 50)
const.InactiveCoverUIColorModifier = RGB(50, 11, 16)
const.CoverDimmedUIColorModifier = RGB(3, 13, 14)
const.CoverCombatUIColorModifier = RGB(29, 26, 6)
const.CoverCombatDimmedUIColorModifier = RGB(14, 13, 3)
const.SurroundUIColorModifier = RGB(30, 3, 3)
const.SurroundDimmedUIColorModifier = RGB(15, 1, 1)
const.CoverFaceUpdateTime = 5000
const.WorldDirections = {
  "North",
  "South",
  "East",
  "West"
}
const.UIButtonPressDelay = 300
const.UIButtonStay = 1000
const.RolloverTime = 0
const.RolloverDestroyTime = const.RolloverTime
const.PulseTime = 1300
const.PulseSize = 1180
const.DefaultMouseCursor = "UI/Cursors/Cursor.tga"
const.DefaultPdaMouseCursor = "UI/Cursors/Pda_Cursor.tga"
StoryBitActivate.EditorExcludeAsNested = true
StoryBitEnableRandom.EditorExcludeAsNested = true
const.DifficultyPresets = {
  {text = "Easy (30)", id = 30},
  {
    text = "Medium (50)",
    id = 50
  },
  {text = "Hard (70)", id = 70},
  {
    text = "Very Hard (90)",
    id = 90
  },
  {text = "Impossible", id = -1}
}
const.DifficultyPresetsWisdomMarkers = {
  {text = "Easy (80)", id = 80},
  {
    text = "Medium (85)",
    id = 85
  },
  {text = "Hard (90)", id = 90},
  {
    text = "Very Hard (95)",
    id = 95
  },
  {text = "Impossible", id = -1}
}
const.DifficultyPresetsNew = {
  {
    text = "None (0)",
    id = "None",
    value = 0
  },
  {
    text = "Easy (30)",
    id = "Easy",
    value = 30
  },
  {
    text = "Medium (50)",
    id = "Medium",
    value = 50
  },
  {
    text = "Hard (70)",
    id = "Hard",
    value = 70
  },
  {
    text = "Very Hard (90)",
    id = "VeryHard",
    value = 90
  },
  {
    text = "Always (100)",
    id = "Always",
    value = 100
  },
  {
    text = "Impossible",
    id = "Impossible",
    value = -1
  }
}
const.DifficultyPresetsWisdomMarkersNew = {
  {
    text = "Trivial (75)",
    id = "Trivial",
    value = 75
  },
  {
    text = "Easy (80)",
    id = "Easy",
    value = 80
  },
  {
    text = "Medium (85)",
    id = "Medium",
    value = 85
  },
  {
    text = "Hard (90)",
    id = "Hard",
    value = 90
  },
  {
    text = "Very Hard (95)",
    id = "VeryHard",
    value = 95
  },
  {
    text = "Always (100)",
    id = "Always",
    value = 100
  },
  {
    text = "Impossible",
    id = "Impossible",
    value = -1
  }
}
const.WeaponModDifficultyPresets = {
  {
    text = "Trivial (-25)",
    id = -25
  },
  {text = "Easy (-10)", id = -10},
  {text = "Normal (0)", id = 0},
  {text = "Hard (10)", id = 10},
  {
    text = "Very Hard (20)",
    id = 20
  }
}
const.DifficultyToItemModifier = {
  Trivial = 0,
  Easy = 0,
  Medium = 1,
  Hard = 1,
  VeryHard = 2,
  Always = 3,
  Impossible = 3
}
const.AnimMomentHookTraverseVegetationRadius = 2 * guim
const.AnimMomentHookEnumDecalWaterRadius = 10 * guim
const.UIBaseColorPalette = {
  [1777453] = RGBA(27, 31, 45, 255),
  [5263435] = RGBA(80, 80, 75, 255),
  [12828076] = RGBA(195, 189, 172, 255),
  [14407629] = RGBA(219, 215, 205, 255),
  [5921603] = RGBA(90, 91, 67, 255),
  [14313480] = RGBA(218, 104, 8, 255),
  [1410186] = RGBA(21, 132, 138, 255),
  [13919496] = RGBA(212, 101, 8, 255)
}
const.PDAUIColors = {
  noClr = RGBA(255, 255, 255, 0),
  selBorderColor = RGB(111, 109, 97),
  titleColor = RGB(52, 55, 61)
}
const.HUDUIColors = {
  selectedColored = RGB(230, 222, 203),
  defaultColor = RGB(30, 37, 47)
}
const.FXWaterMinOffsetZ = -2 * const.SlabSizeZ
const.FXShallowWaterOffsetZ = guim / 3
const.ConversationPortraitsCustomOffset = {
  MD = -80,
  Red = -80,
  Barry = -80,
  HeadshotHue = -80,
  GreasyBasil = -60
}
const.vsIlluminationThresholdPerLightTestPoint = 24
