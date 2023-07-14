local l_PreviousOpacities = {}
local l_PreviousInvisibleObjectHelpersEnabled = false
local l_PreviousVisibilities = {}
function ShowWithoutSelectionMarkers(current_selection)
  for _, obj in ipairs(current_selection) do
    local parentObj = obj:GetParent()
    while parentObj do
      GameToolsShowObject(parentObj)
      parentObj = parentObj:GetParent()
    end
    GameToolsShowObject(obj)
  end
end
function RestoreSelectionMarkers(current_selection)
  if IsEditorActive() then
    for _, obj in ipairs(current_selection) do
      if IsKindOf(obj, "Light") then
        local opacity = l_PreviousOpacities[obj] or 100
        obj:SetOpacity(opacity)
      elseif IsKindOf(obj, "DecorStateFXObjectNoSound") then
        local visible = l_PreviousVisibilities[obj]
        if visible and 0 < visible then
          obj:SetEnumFlags(const.efVisible)
        end
      end
    end
  end
end
function GetIsolatedObjectScreenshotSelection()
  local is_editor = IsEditorActive()
  return is_editor and editor.GetSel() or Selection
end
function IsolatedObjectScreenshot()
  local is_editor = IsEditorActive()
  if is_editor then
    if not selo() then
      return
    end
  elseif not Selection or #Selection == 0 then
    return
  end
  local selection = GetIsolatedObjectScreenshotSelection()
  CreateRealTimeThread(function()
    local time_factor = GetTimeFactor()
    SetTimeFactor(0)
    local isolated_features_off = {
      RenderBillboards = 0,
      RenderTerrain = 0,
      RenderSky = 0,
      EnableAutoExposure = 0,
      RenderClutter = 0,
      RenderRain = 0
    }
    table.change(hr, "IsolatedObjectScreenshot", isolated_features_off)
    PauseInfiniteLoopDetection("IsolatedObjectScreenshot")
    SuspendPassEdits("IsolatedObjectScreenshot", true)
    MapForEach("map", "attached", false, "CObject", nil, const.efVisible, function(obj)
      if not editor.HiddenManually[obj] then
        editor.HiddenManually[obj] = true
        GameToolsHideObject(obj)
      end
    end)
    local current_selection = table.copy(selection, false)
    ShowWithoutSelectionMarkers(current_selection)
    if is_editor then
      l_PreviousInvisibleObjectHelpersEnabled = InvisibleObjectHelpersEnabled
      SetInvisibleObjectHelpersEnabled(false)
      table.clear(l_PreviousOpacities)
      table.clear(l_PreviousVisibilities)
      for _, obj in ipairs(current_selection) do
        obj:ClearHierarchyGameFlags(const.gofEditorSelection | const.gofEditorHighlight)
        if IsKindOf(obj, "Light") then
          l_PreviousOpacities[obj] = obj:GetOpacity()
          obj:SetOpacity(0)
        elseif IsKindOf(obj, "DecorStateFXObjectNoSound") then
          l_PreviousVisibilities[obj] = obj:GetEnumFlags(const.efVisible)
          obj:ClearEnumFlags(const.efVisible)
        end
      end
    end
    SetSceneParam(1, "StarsIntensity", 0)
    SetSceneParam(1, "StarsBlueTint", 0)
    SetSceneParam(1, "MilkyWayIntensity", 0)
    SetSceneParam(1, "MilkyWayBlueTint", 0)
    LockCamera("IsolatedObjectScreenshot")
    WaitNextFrame(5)
    MovieWriteScreenshot(GenerateScreenshotFilename("SSAA", "AppData/"), 0, 64, false)
    SetTimeFactor(time_factor)
    UnlockCamera("IsolatedObjectScreenshot")
    table.restore(hr, "IsolatedObjectScreenshot")
    SetInvisibleObjectHelpersEnabled(l_PreviousInvisibleObjectHelpersEnabled)
    SetSceneParam(1, "StarsIntensity", CurrentLightmodel[1].stars_intensity)
    SetSceneParam(1, "StarsBlueTint", CurrentLightmodel[1].stars_blue_tint)
    SetSceneParam(1, "MilkyWayIntensity", CurrentLightmodel[1].mw_intensity)
    SetSceneParam(1, "MilkyWayBlueTint", CurrentLightmodel[1].mw_blue_tint)
    RestoreSelectionMarkers(current_selection)
    local hidden = editor.HiddenManually
    editor.HiddenManually = setmetatable({}, weak_keys_meta)
    for obj in pairs(hidden) do
      GameToolsShowObject(obj)
    end
    ResumePassEdits("IsolatedObjectScreenshot", true)
    ResumeInfiniteLoopDetection("IsolatedObjectScreenshot")
    if is_editor then
      editor.ClearSel()
      for _, obj in ipairs(current_selection) do
        editor.AddObjToSel(obj)
      end
    end
  end)
end
