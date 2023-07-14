SetupVarTable(editor, "editor.")
if FirstLoad then
  XEditorHideTexts = false
end
XEditorHRSettings = {
  ResolutionPercent = 100,
  EnablePreciseSelection = 1,
  ObjectCounter = 1,
  VerticesCounter = 1,
  FarZ = 10000 * guim
}
function IsEditorActive()
  return editor.Active
end
function EditorActivate()
  if Platform.editor and GetMap() ~= "" then
    editor.Active = true
    NetPauseUpdateHash("Editor")
    Msg("GameEnteringEditor")
    OpenDialog("XEditor")
    Msg("GameEnterEditor")
    SuspendDesyncErrors("Editor")
  end
end
function EditorDeactivate()
  if not editor.Active then
    return
  end
  editor.Active = false
  Msg("GameExitEditor")
  CloseDialog("XEditor")
  NetResumeUpdateHash("Editor")
  ResumeDesyncErrors("Editor")
end
function OnMsg.ChangeMap(map)
  if map == "" then
    EditorDeactivate()
  end
end
DefineClass.XEditor = {
  __parents = {"XDialog"},
  Dock = "box",
  InitialMode = "XEditorTool",
  ZOrder = -1,
  mode = false,
  mode_dialog = false,
  play_box = false,
  toolbar_context = false
}
function XEditor:Open(...)
  local size = terrain.GetMapSize()
  XChangeCameraTypeLayer:new({
    CameraType = "cameraMax",
    CameraClampXY = size,
    CameraClampZ = 2 * size
  }, self)
  XPauseLayer:new({togglePauseDialog = false, keep_sounds = true}, self)
  XShortcutsSetMode("Editor", function()
    EditorDeactivate()
  end)
  XEditorHRSettings.EnableCloudsShadow = EditorSettings:GetCloudShadows() and 1 or 0
  table.change(hr, "Editor", XEditorHRSettings)
  SetSplitScreenEnabled(false, "Editor")
  ShowMouseCursor("Editor")
  self.toolbar_context = {
    filter_buttons = LocalStorage.FilteredCategories,
    roof_visuals_enabled = LocalStorage.FilteredCategories.Roofs
  }
  OpenDialog("XEditorToolbar", XShortcutsTarget, self.toolbar_context):SetVisible(EditorSettings:GetEditorToolbar())
  OpenDialog("XEditorStatusbar", XShortcutsTarget, self.toolbar_context)
  self:CreateThread("toolbar_update", function()
    while true do
      WaitMsg(self.toolbar_context)
      ObjModified(self.toolbar_context)
      Sleep(500)
    end
  end)
  if EditorSettings:GetShowPlayArea() then
    self.play_box = PlaceTerrainBox(GetPlayBox(), nil, nil, nil, nil, "depth test")
  end
  XDialog.Open(self, ...)
  CreateRealTimeThread(XEditorUpdateHiddenTexts)
  self:NotifyEditorObjects("EditorEnter")
  ShowConsole(false)
  if IsKindOf(XShortcutsTarget, "XDarkModeAwareDialog") then
    XShortcutsTarget:SetDarkMode(GetDarkModeSetting())
  end
  self:SetMode("XSelectObjectsTool")
  editor.SetSel(SelectedObj and {
    SelectedObj
  } or Selection)
end
function XEditor:Close(...)
  XShortcutsSetMode("Game")
  table.restore(hr, "Editor")
  SetSplitScreenEnabled(true, "Editor")
  HideMouseCursor("Editor")
  CloseDialog("XEditorToolbar")
  CloseDialog("XEditorStatusbar")
  CloseDialog("XEditorRoomTools")
  editor.ClearSel()
  XShortcutsTarget:SetStatusTextLeft("")
  XShortcutsTarget:SetStatusTextRight("")
  if IsValid(self.play_box) then
    DoneObject(self.play_box)
  end
  self:NotifyEditorObjects("EditorExit")
  XDialog.Close(self, ...)
end
function XEditor:NotifyEditorObjects(method)
  SuspendPassEdits("Editor")
  MapForEach(true, "EditorObject", function(obj)
    if not EditorCursorObjs[obj] then
      obj[method](obj)
    end
  end)
  ResumePassEdits("Editor")
end
function XEditor:SetMode(mode, context)
  if mode == self.Mode and context == self.mode_param then
    return
  end
  if self.mode_dialog then
    self.mode_dialog:Close()
    XPopupMenu.ClosePopupMenus()
  end
  self:UpdateStatusText()
  self.mode_dialog = OpenDialog(mode, self, context)
  self.mode_param = context
  self.Mode = mode
  self:ActionsUpdated()
  GetDialog("XEditorToolbar"):ActionsUpdated()
  GetDialog("XEditorStatusbar"):ActionsUpdated()
  XEditorUpdateToolbars()
  if not self.mode_dialog.ToolKeepSelection then
    editor.ClearSel()
  end
  self.mode_dialog:SetFocus()
  Msg("EditorToolChanged", mode, IsKindOf(self.mode_dialog, "XEditorPlacementHelperHost") and self.mode_dialog.helper_class)
end
function XEditor:UpdateStatusText()
  XShortcutsTarget:SetStatusTextLeft(GetMapName() .. (mapdata.group ~= "Default" and " (" .. mapdata.group .. ")" or ""))
  XShortcutsTarget:SetStatusTextRight(string.format("Object details: %s (Ctrl-Alt-/)", GetObjectDetailsName()))
end
function OnMsg.EditorSelectionChanged()
  local xeditor = GetDialog("XEditor")
  if xeditor then
    ObjModified(xeditor.toolbar_context)
  end
end
function OnMsg.DevMenuVisible(visible)
  local toolbar = GetDialog("XEditorToolbar")
  if toolbar then
    toolbar:SetVisible(visible and EditorSettings:GetEditorToolbar())
  end
end
function OnMsg.ChangeMapDone()
  if IsEditorActive() then
    local dlg = GetDialog("XEditor")
    dlg:NotifyEditorObjects("EditorEnter")
    dlg:UpdateStatusText()
    if not cameraMax.IsActive() then
      cameraMax.Activate()
    end
  end
end
function OnMsg.EditorToolChanged(mode, helper_class)
  if (g_Classes[mode].UsesCodeRenderables or helper_class and g_Classes[helper_class].UsesCodeRenderables) and hr.RenderCodeRenderables == 0 then
    hr.RenderCodeRenderables = 1
    local statusbar = GetDialog("XEditorStatusbar")
    if statusbar then
      statusbar:ActionsUpdated()
    end
    ExecuteWithStatusUI("Code renderables turned ON!", function()
      Sleep(2000)
    end)
  end
end
function OnMsg.EditorSelectionChanged(sel)
  if hr.RenderCodeRenderables == 0 and 0 < #sel then
    ExecuteWithStatusUI([[
Code renderables are OFF!

Press Alt-Shift-R to show selection.]], function()
      Sleep(1000)
    end)
  end
end
if FirstLoad then
  XEditorContextMenu = false
end
function XEditorOpenContextMenu(context, pos)
  XEditorContextMenu = XShortcutsTarget:OpenContextMenu(context, pos)
end
function XEditorIsContextMenuOpen()
  return XEditorContextMenu and XEditorContextMenu.window_state == "open"
end
if FirstLoad then
  EditorAutosaveThread = false
  EditorAutosaveNextTime = false
end
function EditorCreateAutosaveThread()
  EditorDeleteAutosaveThread()
  EditorAutosaveThread = CreateRealTimeThread(function()
    if EditorSettings:GetAutosaveTime() == 0 then
      return
    end
    EditorAutosaveNextTime = EditorAutosaveNextTime or now() + EditorSettings:GetAutosaveTime() * 60 * 1000
    while true do
      if EditorAutosaveNextTime > now() then
        Sleep(EditorAutosaveNextTime - now())
      end
      XEditorSaveMap()
      EditorAutosaveNextTime = now() + EditorSettings:GetAutosaveTime() * 60 * 1000
    end
  end)
end
function EditorDeleteAutosaveThread()
  DeleteThread(EditorAutosaveThread)
end
OnMsg.GameEnterEditor = EditorCreateAutosaveThread
OnMsg.GameExitEditor = EditorDeleteAutosaveThread
function XEditorGetCurrentTool()
  return GetDialog("XEditor") and GetDialog("XEditor").mode_dialog
end
function XEditorIsDefaultTool()
  return GetDialogMode("XEditor") == "XSelectObjectsTool"
end
function XEditorSetDefaultTool(helper_class, properties)
  SetDialogMode("XEditor", "XSelectObjectsTool")
  if helper_class then
    GetDialog("XEditor").mode_dialog:SetHelperClass(helper_class, properties)
  end
end
function XEditorRemoveFocusFromToolbars()
  local focused_ctrl = terminal.desktop:GetKeyboardFocus()
  if focused_ctrl and (GetDialog(focused_ctrl) == GetDialog("XEditorToolbar") or GetDialog(focused_ctrl) == GetDialog("XEditorStatusbar")) then
    terminal.desktop:RemoveKeyboardFocus(focused_ctrl, true)
  end
end
function XEditorUpdateToolbars()
  Msg(GetDialog("XEditor").toolbar_context)
end
function XEditorSaveMap(skipBackup, force)
  WaitChangeMapDone()
  ExecuteWithStatusUI("Saving map...", function()
    SaveMap(skipBackup, force)
  end, "wait")
end
function XEditorGetVisibleObjects(filter_func)
  local frame = (GetFrameMark() / 1024 - 1) * 1024
  filter_func = filter_func or function()
    return true
  end
  return MapGet("map", "attached", false, nil, const.efVisible, function(x)
    return x:GetFrameMark() - frame > 0 and filter_func(x)
  end) or empty_table
end
local ApproxDisplayColor = function(color)
  local r, g, b = GetRGB(color)
  local upper_bound = Max(100, Max(r, Max(g, b)))
  r = MulDivRound(r, 255, upper_bound)
  g = MulDivRound(g, 255, upper_bound)
  b = MulDivRound(b, 255, upper_bound)
  return RGB(r, g, b)
end
function GetTerrainTexturesItems()
  local items = {}
  for _, descr in pairs(TerrainTextures) do
    local image = GetTerrainImage(descr.basecolor)
    items[#items + 1] = {
      text = descr.id,
      value = descr.id,
      color = ApproxDisplayColor(descr.color_modifier),
      image = image
    }
  end
  table.sortby_field(items, "value")
  return items
end
function GetDarkModeSetting()
  local setting = XEditorSettings:GetDarkMode()
  if setting == "Follow system" then
    return GetSystemDarkModeSetting()
  else
    return setting and setting ~= "Light"
  end
end
function CanSelect(obj)
  if (not obj or not editor.CanSelect(obj)) and (not const.SlabSizeX or not IsKindOf(obj, "EditorLineGuide")) then
    return false
  end
  return XEditorFilters:CanSelect(obj)
end
function GetObjectAtCursor()
  local sel = GetNextObjectAtScreenPos(function(o)
    return IsKindOfClasses(o, "Decal", "WaterObj") and editor.IsSelected(o)
  end, "topmost")
  if sel then
    return sel
  end
  local solid, transparent = GetPreciseCursorObj()
  local obj = CanSelect(transparent) and transparent or CanSelect(solid) and solid
  obj = obj or XEditorSettings:GetSmartSelection() and GetNextObjectAtScreenPos(CanSelect, "topmost")
  return obj or GetNextObjectAtScreenPos(function(o)
    return IsKindOfClasses(o, "Decal", "WaterObj") and CanSelect(o)
  end, "topmost")
end
function HasAlignedObjs(objs)
  for _, obj in ipairs(objs) do
    if obj:IsKindOf("AlignedObj") then
      return true
    end
  end
end
function XEditorSnapPos(obj, initial_pos, delta, by_slabs)
  if obj:IsKindOf("AlignedObj") then
    if obj.AlignObj ~= AlignedObj.AlignObj then
      obj:AlignObj(initial_pos + delta)
    end
  elseif by_slabs then
    obj:SetPos(initial_pos + XEditorSettings:PosSnap(delta, "by_slabs"))
  else
    obj:SetPos(XEditorSettings:PosSnap(initial_pos + delta))
  end
end
function XEditorSetPosAxisAngle(obj, pos, axis, angle)
  if obj:IsKindOf("AlignedObj") then
    obj:AlignObj(pos, angle, axis)
  else
    obj:SetPos(pos)
    if axis and angle then
      obj:SetAxisAngle(axis, angle)
    end
  end
end
local suspend_id = 1
function SuspendPassEditsForEditOp(objs)
  NetPauseUpdateHash("EditOp")
  table.change(config, "XEditor" .. suspend_id, {
    PartialPassEdits = #(objs or editor.GetSel()) < 500
  })
  SuspendPassEdits("XEditor" .. suspend_id)
  suspend_id = suspend_id + 1
end
function ResumePassEditsForEditOp()
  suspend_id = suspend_id - 1
  ResumePassEdits("XEditor" .. suspend_id, true)
  table.restore(config, "XEditor" .. suspend_id, true)
  NetResumeUpdateHash("EditOp")
end
function ArePassEditsForEditOpSuspended()
  return 1 < suspend_id
end
function XEditorGroupsComboItems(objects)
  local items = {}
  local read_only = #objects == 0
  local group_names = table.keys2(Groups or empty_table, "sorted")
  for _, name in ipairs(group_names) do
    local group = Groups[name]
    if next(group) then
      local in_group_count = #table.intersection(group, objects)
      items[#items + 1] = {
        id = name,
        value = not read_only and in_group_count == #objects and true or 0 < in_group_count and Undefined() or false,
        read_only = read_only
      }
    end
  end
  return items
end
local cam_pos, cam_lookat, stored_sel
function XEditorShowObjects(objs, show)
  if show == "select_permanently" then
    editor.ClearSel("dont_notify")
    editor.SetSel(objs)
    ViewObjects(objs)
    cam_pos, cam_lookat, stored_sel = nil, nil, nil
  elseif show then
    cam_pos, cam_lookat = GetCamera()
    stored_sel = editor.GetSel()
    editor.SetSel(objs, "dont_notify")
    ViewObjects(objs)
  elseif cam_pos then
    SetCamera(cam_pos, cam_lookat)
    editor.SetSel(stored_sel, "dont_notify")
  end
end
function XEditorUpdateHiddenTexts()
  for _, obj in ipairs(MapGet("map", "Text")) do
    if obj.hide_in_editor then
      obj:SetVisible(not XEditorHideTexts)
    end
  end
end
