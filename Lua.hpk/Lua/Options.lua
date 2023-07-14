local lUIViewModes = {
  {
    value = "Always",
    text = T(296490837983, "Always")
  },
  {
    value = "Combat",
    text = T(124570697841, "Combat Only")
  }
}
local Difficulties = {
  {
    value = "Normal",
    text = T(389262521478, "First Blood")
  },
  {
    value = "Hard",
    text = T(285690646012, "Commando")
  },
  {
    value = "VeryHard",
    text = T(120945667693, "Mission Impossible")
  }
}
local lInteractableHighlightMode = {
  {
    value = "Toggle",
    text = T(252778189879, "Toggle")
  },
  {
    value = "Hold",
    text = T(645245601207, "Hold")
  }
}
local lAspectRatioItems = {
  {
    value = 1,
    text = T(601695937982, "None"),
    real_value = -1
  },
  {
    value = 2,
    text = T(375403058307, "16:9"),
    real_value = 1.7777777777777777
  },
  {
    value = 3,
    text = T(830202883779, "21:9"),
    real_value = 2.3333333333333335
  }
}
local game_properties = {
  {
    category = "Controls",
    id = "InvertRotation",
    name = T(210910950476, "Invert Camera Rotation"),
    editor = "bool",
    default = false,
    storage = "account",
    help = T(557409301877, "Inverts the camera rotation.")
  },
  {
    category = "Controls",
    id = "InvertLook",
    name = T(175826014125, "Invert Camera Rotation (Y axis)"),
    editor = "bool",
    default = false,
    storage = "account",
    no_edit = not Platform.trailer
  },
  {
    category = "Controls",
    id = "FreeCamRotationSpeed",
    name = T(939095110164, "Controller Rotation Speed"),
    editor = "number",
    default = 2000,
    storage = "account",
    min = 100,
    max = 4000,
    step = 5,
    no_edit = not Platform.trailer
  },
  {
    category = "Controls",
    id = "FreeCamPanSpeed",
    name = T(188537213687, "Controller Pan Speed"),
    editor = "number",
    default = 1000,
    storage = "account",
    min = 50,
    max = 2000,
    step = 5,
    no_edit = not Platform.trailer
  },
  {
    category = "Controls",
    id = "MouseScrollOutsideWindow",
    name = T(3587, "Panning outside window"),
    editor = "bool",
    default = false,
    storage = "account",
    no_edit = Platform.console,
    help = T(787712595891, "Allows camera pan when the mouse cursor is outside the game window.")
  },
  {
    category = "Controls",
    id = "LeftClickMoveExploration",
    name = T(988837649188, "Left-Click Move (Exploration)"),
    editor = "bool",
    default = false,
    storage = "account",
    help = T(344343486722, "Use left-click to move mercs while exploring a sector out of combat.")
  },
  {
    category = "Gameplay",
    id = "HideActionBar",
    name = T(805746173830, "Hide Action Bar (Exploration)"),
    editor = "bool",
    default = true,
    storage = "account",
    help = T(915209994351, "Hides the action bar UI while not in combat.")
  },
  {
    category = "Gameplay",
    id = "ActionCamera",
    name = T(227204678948, "Targeting Action Camera"),
    editor = "bool",
    default = false,
    storage = "account",
    help = T(819569684768, [[
A special cinematic camera view will be used while aiming an attack.

The action camera is always used with long-range weapons like sniper rifles.]])
  },
  {
    category = "Gameplay",
    id = "PauseOperationStart",
    name = T(195176176002, "Auto-pause: Operation Start"),
    editor = "bool",
    default = false,
    storage = "account",
    SortKey = 1200,
    help = T(783599794850, "Pause time in SatView mode whenever an Operation is started and the Operations menu is closed.")
  },
  {
    category = "Gameplay",
    id = "PauseActivityDone",
    name = T(219275271774, "Auto-pause: Operation Done"),
    editor = "bool",
    default = true,
    storage = "account",
    SortKey = 1200,
    help = T(861937087426, "Pause time in SatView mode whenever an Operation is completed.")
  },
  {
    category = "Gameplay",
    id = "AutoPauseDestReached",
    name = T(220585419104, "Auto-pause: Sector Reached"),
    editor = "bool",
    default = true,
    storage = "account",
    SortKey = 1000,
    help = T(679389220889, "Pause time in SatView mode whenever a squad reaches its destination sector.")
  },
  {
    category = "Gameplay",
    id = "AutoPauseConflict",
    name = T(292439424575, "Auto-pause: Sector Conflict"),
    editor = "bool",
    default = true,
    storage = "account",
    SortKey = 1100,
    help = T(271690416933, "Pause time in SatView mode whenever a squad is in conflict.")
  },
  {
    category = "Gameplay",
    id = "PauseSquadMovement",
    name = T(700874998799, "Auto-pause: Squad Movement"),
    editor = "bool",
    default = false,
    storage = "account",
    SortKey = 1100,
    help = T(269721155831, "Pause time in SatView mode whenever a squad travel order is given.")
  },
  {
    category = "Gameplay",
    id = "ShowNorth",
    name = T(397596571548, "Show North"),
    editor = "bool",
    default = true,
    storage = "account",
    help = T(968463817287, "Indicates North with an icon on the screen border.")
  },
  {
    category = "Gameplay",
    id = "ShowCovers",
    name = T(693926475349, "Show Covers Shields"),
    editor = "choice",
    default = "Combat",
    storage = "account",
    items = lUIViewModes,
    help = T(549744366946, "Allows cover shields to be visible when not in combat.")
  },
  {
    category = "Gameplay",
    id = "AlwaysShowBadges",
    name = T(834175857662, "Show Merc Badges"),
    editor = "choice",
    default = "Combat",
    storage = "account",
    items = lUIViewModes,
    help = T(526076106085, "Shows UI elements with detailed information above the merc's heads.")
  },
  {
    category = "Gameplay",
    id = "ShowLOF",
    name = T(304702880820, "Show Line of Fire"),
    editor = "bool",
    default = true,
    storage = "account",
    help = T(426202778816, "Allows line of fire lines to be visible when in combat.")
  },
  {
    category = "Gameplay",
    id = "PauseConversation",
    name = T(146071242733, "Pause conversations"),
    editor = "bool",
    default = true,
    storage = "account",
    help = T(118088730513, "Wait for input before continuing to the next conversation line.")
  },
  {
    category = "Gameplay",
    id = "AutoSave",
    name = T(571339674334, "AutoSave"),
    editor = "bool",
    default = true,
    storage = "account",
    SortKey = -1500,
    help = T(690186765577, "Automatically create a savegame when a new day starts, when a sector is entered, when a combat starts or ends, when a conflict starts in SatView, and on exit.")
  },
  {
    category = "Gameplay",
    id = "InteractableHighlight",
    name = T(770074868053, "Highlight mode"),
    editor = "choice",
    default = "Toggle",
    storage = "account",
    items = lInteractableHighlightMode,
    help = T(705105646677, "Interactables can highlighted for a time when a button is pressed or held down.")
  },
  {
    category = "Gameplay",
    id = "ForgivingModeToggle",
    name = T(836950884858, "Forgiving Mode"),
    editor = "bool",
    default = false,
    storage = "local",
    no_edit = function(self)
      return not Game
    end,
    read_only = function()
      return netInGame and not NetIsHost()
    end,
    SortKey = -1600,
    help = T(885105596551, "Lowers the impact of attrition and makes it easier to recover from bad situations (faster healing and repair, better income).<newline><newline><flavor>You can change this option at any time during gameplay.</flavor>")
  },
  {
    category = "Display",
    id = "AspectRatioConstraint",
    name = T(125094445172, "UI Aspect Ratio"),
    editor = "choice",
    default = 1,
    items = lAspectRatioItems,
    storage = "local",
    help = T(433997797079, "Constrain UI elements like the HUD to the set aspect ratio. Useful for Ultra Wide and Super Ultra Wide resolutions.")
  }
}
const.MaxUserUIScaleHighRes = 100
function OnMsg.ClassesGenerate(classdefs)
  table.iappend(classdefs.OptionsObject.properties, game_properties)
  if not Platform.developer then
    local uiScale = table.find_value(classdefs.OptionsObject.properties, "id", "UIScale")
    if uiScale then
      uiScale.no_edit = true
    end
  end
  local gamepadOption = table.find_value(classdefs.OptionsObject.properties, "id", "Gamepad")
  if gamepadOption then
    gamepadOption.no_edit = true
  end
end
function OnMsg.ApplyAccountOptions()
  if AccountStorage then
    hr.CameraScrollOutsideWindow = GetAccountStorageOptionValue("MouseScrollOutsideWindow") == false and 0 or 1
    const.CameraControlInvertLook = GetAccountStorageOptionValue("InvertLook")
    const.CameraControlInvertRotation = GetAccountStorageOptionValue("InvertRotation")
    const.CameraControlControllerPanSpeed = GetAccountStorageOptionValue("FreeCamPanSpeed")
    hr.CameraFlyRotationSpeed = GetAccountStorageOptionValue("FreeCamRotationSpeed") / 1000.0
    UpdateAllBadgesAndModes()
  end
end
function SaveAccStorageAfterCameraSpeedOptionChange()
  SaveAccountStorage(2000)
end
function SyncCameraControllerSpeedOptions()
  SetAccountStorageOptionValue("FreeCamPanSpeed", const.CameraControlControllerPanSpeed)
  SetAccountStorageOptionValue("FreeCamRotationSpeed", hr.CameraFlyRotationSpeed * 1000)
  DelayedCall(1000, SaveAccStorageAfterCameraSpeedOptionChange)
end
function ApplyOptions(host, next_mode)
  CreateRealTimeThread(function(host)
    local obj = ResolvePropObj(host:ResolveId("idScrollArea").context)
    local original_obj = ResolvePropObj(host.idOriginalOptions.context)
    local category = host:GetCategoryId()
    if not obj:WaitApplyOptions(original_obj) then
      WaitMessage(terminal.desktop, T(824112417429, "Warning"), T(862733805364, "Changes could not be applied and will be reverted."), T(325411474155, "OK"))
    else
      local object_detail_changed = obj.ObjectDetail ~= original_obj.ObjectDetail
      obj:CopyCategoryTo(original_obj, category)
      SaveEngineOptions()
      SaveAccountStorage(5000)
      if category == "Keybindings" then
        ReloadShortcuts()
      elseif category == "Gameplay" then
        ApplyLanguageOption()
        ApplyDifficultyOption()
        ApplyGameplayOption()
        if Platform.console then
          terminal.desktop:OnSystemSize(UIL.GetScreenSize())
        end
      elseif category == "Video" and object_detail_changed then
        SetObjectDetail(obj.ObjectDetail)
      end
      Msg("GameOptionsChanged", category)
    end
    if not next_mode then
    else
    end
  end, host)
end
function CancelOptions(host, clear)
  CreateRealTimeThread(function(host)
    if host.window_state == "destroying" then
      return
    end
    local obj = OptionsObj
    local original_obj = ResolvePropObj(host.idOriginalOptions.context)
    local category = host:GetCategoryId()
    original_obj:WaitApplyOptions()
    original_obj:CopyCategoryTo(obj, category)
    if clear then
      local sideButtuonsDialog = GetDialog(host):ResolveId("idMainMenuButtonsContent")
      if sideButtuonsDialog and GetDialogMode(sideButtuonsDialog) == "keybindings" then
        GetDialog(host):ResolveId("idMainMenuButtonsContent"):SetMode("mm")
      else
        local mmDialog = GetDialog("InGameMenu") or GetDialog("PreGameMenu")
        mmDialog:SetMode("")
      end
      GetDialog(host):SetMode("empty")
    end
    GetDialog(host):ResolveId("idSubSubContent"):SetMode("empty")
  end, host)
end
function ApplyDisplayOptions(host, next_mode)
  CreateRealTimeThread(function(host)
    if host.window_state == "destroying" then
      return
    end
    local obj = ResolvePropObj(host:ResolveId("idScrollArea").context)
    local original_obj = ResolvePropObj(host.idOriginalOptions.context)
    local graphics_api_changed = obj.GraphicsApi ~= original_obj.GraphicsApi
    local graphics_adapter_changed = obj.GraphicsAdapterIndex ~= original_obj.GraphicsAdapterIndex
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
    local restartRequiredOptionT
    if graphics_api_changed and graphics_adapter_changed then
      restartRequiredOptionT = T(918368138749, "More than one option will only take effect after the game is restarted.")
    elseif graphics_api_changed then
      restartRequiredOptionT = T(419298766048, "Changing the Graphics API option will only take effect after the game is restarted.")
    elseif graphics_adapter_changed then
      restartRequiredOptionT = T(133453226856, "Changing the Graphics Adapter option will only take effect after the game is restarted.")
    end
    if restartRequiredOptionT then
      WaitMessage(terminal.desktop, T(1000599, "Warning"), restartRequiredOptionT, T(325411474155, "OK"))
    end
  end, host)
end
function CancelDisplayOptions(host, clear)
  local obj = ResolvePropObj(host:ResolveId("idScrollArea").context)
  local original_obj = ResolvePropObj(host.idOriginalOptions.context)
  original_obj:CopyCategoryTo(obj, "Display")
  obj:SetProperty("Resolution", point(GetResolution()))
  if clear then
    GetDialog(host):SetMode("empty")
    local mmDialog = GetDialog("InGameMenu") or GetDialog("PreGameMenu")
    mmDialog:SetMode("")
    GetDialog(host):ResolveId("idSubSubContent"):SetMode("empty")
  end
end
function OnMsg.OptionsChanged()
  local mm = GetDialog("InGameMenu") or GetDialog("PreGameMenu")
  if mm then
    local resetApplyButtons = mm:ResolveId("idSubMenu"):ResolveId("idOptionsActionsCont")[1]
    local applyOpt = resetApplyButtons:ResolveId("idapplyOptions") or resetApplyButtons:ResolveId("idapplyDisplayOptions")
    if applyOpt then
      applyOpt.action.enabled = true
      applyOpt:SetEnabled(true)
      ObjModified("action-button-mm")
    end
    local resetOpt = resetApplyButtons:ResolveId("idresetToDefaults")
    if resetOpt then
      resetOpt.action.enabled = true
      resetOpt:SetEnabled(true)
      ObjModified("action-button-mm")
    end
  end
end
AppendClass.OptionsObject = {
  properties = {
    {
      category = "Gameplay",
      id = "Difficulty",
      name = T(944075953376, "Difficulty"),
      editor = "choice",
      SortKey = -1900,
      default = "Normal",
      items = Difficulties,
      storage = "local",
      read_only = function()
        return netInGame and not NetIsHost()
      end,
      help = T(146186342821, "Changing the difficulty level of the game affects loot drops, financial rewards, and enemy toughness.<newline><newline><flavor>You can change the difficulty of the game at any time during gameplay.</flavor>")
    },
    {
      category = "Gameplay",
      id = "Language",
      name = T(243042020683, "Language"),
      SortKey = -2000,
      editor = "choice",
      default = GetDefaultEngineOptions().Language,
      help = T(769937279342, "Sets the game language.")
    },
    {
      name = T(267365977133, "Camera Shake"),
      id = "CameraShake",
      category = "Gameplay",
      SortKey = 0,
      storage = "local",
      editor = "bool",
      on_value = "On",
      off_value = "Off",
      default = GetDefaultEngineOptions().CameraShake,
      help = T(456226716309, "Allow camera shake effects.")
    },
    {
      name = T(989416075981, "Analytics Enabled"),
      id = "AnalyticsEnabled",
      category = "Gameplay",
      SortKey = 5000,
      storage = "account",
      editor = "bool",
      on_value = "On",
      off_value = "Off",
      default = "Off",
      help = T(700491171054, "Enables or disables tracking anonymous usage data for analytics.")
    },
    {
      name = T(273206229320, "Fullscreen Mode"),
      id = "FullscreenMode",
      category = "Display",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().FullscreenMode,
      help = T(597120074418, "The game may run in a window or on the entire screen.")
    },
    {
      name = T(124888650840, "Resolution"),
      id = "Resolution",
      category = "Display",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Resolution,
      help = T(515304581653, "The number of pixels rendered on the screen; higher resolutions provide sharper and more detailed images.")
    },
    {
      name = T(276952502249, "Vsync"),
      id = "Vsync",
      category = "Display",
      storage = "local",
      editor = "bool",
      default = GetDefaultEngineOptions().Vsync,
      help = T(456307855876, "Synchronizes the game's frame rate with the screen's refresh rate thus eliminating screen tearing. Enabling it may reduce performance.")
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
      end,
      help = T(184665121668, "The DirectX version used by the game renderer.")
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
      end,
      help = T(988464636767, "The GPU that would be used for rendering. Please use the dedicated GPU if possible.")
    },
    {
      name = T(418391988068, "Frame Rate Limit"),
      id = "MaxFps",
      category = "Display",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().MaxFps,
      help = T(190152008288, "Limits the maximum number of frames that the GPU will render per second.")
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
      no_edit = true
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
      snap_offset = 5,
      help = T(316233466560, "Affects the size of the user interface elements, such as menus and text.")
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
      snap_offset = 50,
      help = T(144889353073, "Affects the overall brightness level.")
    },
    {
      name = T(590606477665, "Preset"),
      id = "VideoPreset",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().VideoPreset,
      help = T(582113441661, "A predefined settings preset for different levels of hardware performance.")
    },
    {
      name = T(864821413961, "Antialiasing"),
      id = "Antialiasing",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Antialiasing,
      help = T(753609256525, "Smooths out jagged edges, reduces shimerring, and improves overall visual quality.")
    },
    {
      name = T(809013434667, "Resolution Percent"),
      id = "ResolutionPercent",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().ResolutionPercent,
      help = T(114560361364, "Reduces the internal resolution used to render the game, improving performance at the expense on visual quality.")
    },
    {
      name = T(964510417589, "Shadows"),
      id = "Shadows",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Shadows,
      help = T(500018129164, "Affects the quality and visibility of in-game sun shadows.")
    },
    {
      name = T(940888056560, "Textures"),
      id = "Textures",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Textures,
      help = T(532136930067, "Affects the resolution of in-game textures.")
    },
    {
      name = T(946251115875, "Anisotropy"),
      id = "Anisotropy",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Anisotropy,
      help = T(808058265518, "Affects the clarity of textures viewed at oblique angles.")
    },
    {
      name = T(871664438848, "Terrain"),
      id = "Terrain",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Terrain,
      help = T(545382529099, "Affects the quality of in-game terrain textures and geometry.")
    },
    {
      name = T(318842515247, "Effects"),
      id = "Effects",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Effects,
      help = T(563094626410, "Affects the quality of in-game visual effects.")
    },
    {
      name = T(484841493487, "Lights"),
      id = "Lights",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Lights,
      help = T(307628509612, "Affects the quality and visibility of in-game lights and shadows.")
    },
    {
      name = T(682371259474, "Postprocessing"),
      id = "Postprocess",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Postprocess,
      help = T(291876705355, "Adds additional effects to improve the overall visual quality.")
    },
    {
      name = T(668281727636, "Bloom"),
      id = "Bloom",
      category = "Video",
      storage = "local",
      editor = "bool",
      on_value = "On",
      off_value = "Off",
      default = GetDefaultEngineOptions().Bloom,
      help = T(441093875283, "Simulates scattering light, creating a glow around bright objects.")
    },
    {
      name = T(886248401356, "Eye Adaptation"),
      id = "EyeAdaptation",
      category = "Video",
      storage = "local",
      editor = "bool",
      on_value = "On",
      off_value = "Off",
      default = GetDefaultEngineOptions().EyeAdaptation,
      help = T(663427521283, "Affects the exposure of the image based on the brightess of the scene.")
    },
    {
      name = T(281819101205, "Vignette"),
      id = "Vignette",
      category = "Video",
      storage = "local",
      editor = "bool",
      on_value = "On",
      off_value = "Off",
      default = GetDefaultEngineOptions().Vignette,
      help = T(177496557870, "Creates a darker border around the edges for a more cinematic feel.")
    },
    {
      name = T(800958396604, "Chromatic Aberration"),
      id = "ChromaticAberration",
      category = "Video",
      storage = "local",
      editor = "bool",
      on_value = "On",
      off_value = "Off",
      default = GetDefaultEngineOptions().ChromaticAberration,
      help = T(584969955603, "Simulates chromatic abberation due to camera lens imperfections around the image's edges for a more cinematic feel.")
    },
    {
      name = T(739108258248, "SSAO"),
      id = "SSAO",
      category = "Video",
      storage = "local",
      editor = "bool",
      on_value = "On",
      off_value = "Off",
      default = GetDefaultEngineOptions().SSAO,
      help = T(113014960666, "Simulates the darkening ambient light by nearby objects to improve the depth and composition of the scene.")
    },
    {
      name = T(743968865763, "Reflections"),
      id = "SSR",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().SSR,
      help = T(806489659507, "Adjust the quality of in-game screen-space reflections.")
    },
    {
      name = T(799060022637, "View Distance"),
      id = "ViewDistance",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().ViewDistance,
      help = T(987276010188, "Affects how far the game will render objects and effects in the distance.")
    },
    {
      name = T(595681486860, "Object Detail"),
      id = "ObjectDetail",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().ObjectDetail,
      help = T(351986265823, "Affects the number of less important objects and the overall level of detail.")
    },
    {
      name = T(717555024369, "Framerate Counter"),
      id = "FPSCounter",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().FPSCounter,
      SortKey = 1000,
      help = T(773245251495, "Displays a framerate counter in the upper-right corner of the screen.")
    },
    {
      name = T(489981061317, "Sharpness"),
      id = "Sharpness",
      category = "Video",
      storage = "local",
      editor = "choice",
      default = GetDefaultEngineOptions().Sharpness,
      help = T(540870423363, "Affects ths sharpness of the image")
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
      step = (const.MasterMaxVolume or 1000) / 100,
      help = T(963240239070, "Sets the overall audio volume.")
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
      end,
      help = T(186072536391, "Sets the volume for the music.")
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
      end,
      help = T(792392113273, "Sets the volume for all voiced content.")
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
      end,
      help = T(582366412662, "Sets the volume for the sound effects like gunshots and explosions.")
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
      end,
      help = T(674715210365, "Sets the volume for the non-ambient sounds like the sounds of waves and rain")
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
      end,
      help = T(597810411326, "Sets the volume for the user interface sounds.")
    },
    {
      name = T(362201382843, "Mute when Minimized"),
      id = "MuteWhenMinimized",
      category = "Audio",
      storage = "local",
      editor = "bool",
      default = GetDefaultEngineOptions().MuteWhenMinimized,
      no_edit = Platform.console,
      help = T(365470337843, "All sounds will be muted when the game is minimized.")
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
    }
  }
}
local lDialogsToApplyAspectRatioTo = {
  function()
    local igi = GetInGameInterface()
    return igi and igi.mode_dialog
  end,
  function()
    local weaponMod = GetDialog("ModifyWeaponDlg")
    return weaponMod and weaponMod.idModifyDialog
  end,
  function()
    local menu = GetDialog("PreGameMenu")
    return menu and menu.idMainMenu
  end,
  function()
    local menu = GetDialog("InGameMenu")
    return menu and menu.idMainMenu
  end
}
function GetUIScale(res)
  local screen_size = Platform.ged and UIL.GetOSScreenSize() or res or UIL.GetScreenSize()
  local xrez, yrez = screen_size:xy()
  local aspectRatioContraint = GetAspectRatioConstraintAmount("unscaled")
  xrez = xrez - aspectRatioContraint * 2
  local scale_x, scale_y = 1000 * xrez / 1920, 1000 * yrez / 1080
  local scale = (scale_x + scale_y) / 2
  scale = Min(scale, scale_x * 120 / 100)
  scale = Min(scale, scale_y * 120 / 100)
  if 1000 < scale then
    scale = 1000 + (scale - 1000) * 900 / 1000
  end
  local controller_scale = table.get(AccountStorage, "Options", "Gamepad") and IsXInputControllerConnected() and const.ControllerUIScale or 100
  return MulDivRound(scale, GetUserUIScale(scale) * controller_scale, 10000)
end
function GetAspectRatioConstraintAmount(unscaled)
  local screen_size = Platform.ged and UIL.GetOSScreenSize() or UIL.GetScreenSize()
  local x, y = screen_size:xy()
  local constraint = lAspectRatioItems[EngineOptions.AspectRatioConstraint]
  constraint = constraint and constraint.real_value or 0
  local constraintMargin = 0
  if 0 < constraint and constraint < (0.0 + x) / y then
    local smallerWidth = round(y * constraint, 1)
    local xx = DivRound(x - smallerWidth, 2)
    if not unscaled then
      local scale = GetUIScale()
      constraintMargin = MulDivRound(xx, 1000, scale)
    else
      constraintMargin = xx
    end
  end
  return constraintMargin
end
function ApplyAspectRatioConstraint()
  local constraintMargin = GetAspectRatioConstraintAmount()
  for i, dlg in ipairs(lDialogsToApplyAspectRatioTo) do
    local dlgInstance = false
    if type(dlg) == "function" then
      dlgInstance = dlg()
    elseif type(dlg) == "string" then
      dlgInstance = GetDialog(dlg)
    end
    if dlgInstance then
      dlgInstance:SetMargins(box(constraintMargin, 0, constraintMargin, 0))
    end
  end
end
function OnMsg.IGIModeChanging()
  ApplyAspectRatioConstraint()
end
function OnMsg.SystemSize()
  ApplyAspectRatioConstraint()
end
function OnMsg.DialogOpen()
  ApplyAspectRatioConstraint()
end
local baseSetDisplayAreaMargin = OptionsObject.SetDisplayAreaMargin
function OptionsObject:SetDisplayAreaMargin(x)
  baseSetDisplayAreaMargin(self, 0)
end
function OptionsObject:SetAspectRatioConstraint(x)
  self.AspectRatioConstraint = x
  ApplyAspectRatioConstraint()
end
function ApplyDifficultyOption()
  if not Game then
    return
  end
  local newValue = OptionsObj and OptionsObj.Difficulty
  if netInGame then
    NetSyncEvent("MP_ApplyDifficulty", newValue)
  else
    ApplyDifficulty(newValue)
  end
end
function NetSyncEvents.MP_ApplyDifficulty(newValue)
  ApplyDifficulty(newValue)
end
function ApplyDifficulty(newValue)
  if newValue and Game.game_difficulty ~= newValue then
    Game.game_difficulty = newValue
    Msg("DifficultyChange")
  end
  if OptionsObj then
    OptionsObj:SetProperty("Difficulty", newValue)
    ObjModified(OptionsObj)
  end
  SetDifficultyOption()
end
function ChangeGameRule(rule, value)
  if Game and IsGameRuleActive(rule) ~= value then
    if value then
      Game:AddGameRule(rule)
    else
      Game:RemoveGameRule(rule)
    end
    Msg("ChangeGameRule", rule, value)
  end
end
function SetForgivingModeOption(val)
  OptionsObj = OptionsObj or OptionsCreateAndLoad()
  OptionsObj:SetProperty("ForgivingModeToggle", val ~= nil and val or IsGameRuleActive("ForgivingMode"))
  ApplyOptionsObj(OptionsObj)
end
function ApplyGameplayOption()
  local newValue = OptionsObj and OptionsObj.ForgivingModeToggle
  NetSyncEvent("ChangeForgivingMode", newValue)
end
function NetSyncEvents.ChangeForgivingMode(newValue)
  ChangeGameRule("ForgivingMode", newValue)
  if OptionsObj then
    OptionsObj:SetProperty("ForgivingModeToggle", newValue)
    ObjModified(OptionsObj)
  end
  SetForgivingModeOption(newValue)
end
function OnMsg.ZuluGameLoaded(game)
  SetForgivingModeOption()
  SetDifficultyOption()
end
function SetDifficultyOption()
  OptionsObj = OptionsObj or OptionsCreateAndLoad()
  OptionsObj:SetProperty("Difficulty", Game.game_difficulty)
  ApplyOptionsObj(OptionsObj)
end
function OnMsg.NetGameLoaded()
  if not NetIsHost() then
    SetForgivingModeOption()
    SetDifficultyOption()
  end
end
local s_oldHideObjectsByDetailClass = HideObjectsByDetailClass
function HideObjectsByDetailClass(optionals, future_extensions, eye_candies, ...)
  return s_oldHideObjectsByDetailClass(optionals, future_extensions, eye_candies, true)
end
