DefineClass.XEditorPlacementHelper = {
  __parents = {"InitDone"},
  operation_started = false,
  local_cs = false,
  snap = false,
  HasLocalCSSetting = false,
  HasSnapSetting = false,
  InXPlaceObjectTool = false,
  InXSelectObjectsTool = false,
  AllowRotationAfterPlacement = false,
  UsesCodeRenderables = false,
  Title = "None",
  Description = false,
  ActionSortKey = "0",
  ActionIcon = "CommonAssets/UI/Editor/Tools/VertexNudge.tga",
  ActionShortcut = "",
  ActionShortcut2 = ""
}
function XEditorPlacementHelper:GetDescription()
end
function XEditorPlacementHelper:CheckStartOperation(mouse_pos)
end
function XEditorPlacementHelper:StartOperation(mouse_pos, objects)
  self.operation_started = true
end
function XEditorPlacementHelper:PerformOperation(mouse_pos, objects)
end
function XEditorPlacementHelper:EndOperation(objects)
  self.operation_started = false
end
DefineClass.XEditorGizmo = {
  __parents = {
    "XEditorPlacementHelper",
    "Mesh"
  },
  InXSelectObjectsTool = true,
  UsesCodeRenderables = true,
  thickness = 75,
  opacity = 110,
  scale = 85,
  sensitivity = 100,
  update_thread = false
}
function XEditorGizmo:GetProperties()
  return empty_table
end
function XEditorGizmo:Init()
  self.update_thread = CreateRealTimeThread(function()
    while IsValid(self) do
      self.thickness = XEditorSettings:GetGizmoThickness()
      self.opacity = XEditorSettings:GetGizmoOpacity()
      self.scale = XEditorSettings:GetGizmoScale()
      self.sensitivity = XEditorSettings:GetGizmoSensitivity()
      self:Render()
      WaitNextFrame()
    end
  end)
end
function XEditorGizmo:Done()
  DeleteThread(self.update_thread)
end
function XEditorGizmo:Render()
end
DefineClass.XObjectPlacementHelper = {
  __parents = {
    "XEditorPlacementHelper"
  },
  InXPlaceObjectTool = true,
  InXSelectObjectsTool = true,
  init_drag_position = false,
  init_move_positions = false,
  init_orientations = false
}
function XObjectPlacementHelper:CheckStartOperation(mouse_pos)
  local obj = GetObjectAtCursor()
  return obj and editor.IsSelected(obj)
end
function XObjectPlacementHelper:StartOperation(mouse_pos, objects)
  SuspendPassEditsForEditOp(objects)
  self:StartMoveObjects(mouse_pos, objects)
  self.operation_started = true
end
function XObjectPlacementHelper:PerformOperation(mouse_pos, objects)
  self:MoveObjects(mouse_pos, objects)
end
function XObjectPlacementHelper:EndOperation(objects)
  self.init_drag_position = false
  self.init_move_positions = false
  self.init_orientations = false
  self.operation_started = false
  ResumePassEditsForEditOp()
end
function XObjectPlacementHelper:StartMoveObjects(mouse_pos, objects)
  self.init_drag_position = GetTerrainCursor()
  self.init_move_positions = {}
  self.init_orientations = {}
  for i, o in ipairs(objects) do
    self.init_move_positions[i] = o:GetPos()
    self.init_orientations[i] = {
      o:GetOrientation()
    }
  end
end
function XObjectPlacementHelper:MoveObjects(mouse_pos, objects)
  local vMove = (GetTerrainCursor() - self.init_drag_position):SetZ(0)
  for i, obj in ipairs(objects) do
    obj:SetPos(self.init_move_positions[i] + vMove)
  end
  Msg("EditorCallback", "EditorCallbackMove", objects)
end
local helper_classes
function helpers_button_list(tool_class)
  if not helper_classes then
    helper_classes = ClassLeafDescendantsList("XEditorPlacementHelper")
    table.sort(helper_classes, function(a, b)
      return g_Classes[a].ActionSortKey < g_Classes[b].ActionSortKey
    end)
  end
  local buttons = {}
  for _, class_name in ipairs(helper_classes) do
    local class = g_Classes[class_name]
    if class["In" .. tool_class] then
      table.insert(buttons, {
        toggle = true,
        func = function(self, root, prop_id, ged, param)
          self:SetHelperClass(param)
        end,
        is_toggled = function(self)
          return self:GetHelperClass() == class_name
        end,
        name = class_name,
        param = class_name,
        icon = class.ActionIcon,
        icon_scale = 100,
        rollover = class.Title .. (class.Description and [[


]] .. table.concat(class.Description, [[


]]) or ""),
        shortcut = class.ActionShortcut,
        shortcut2 = class.ActionShortcut2
      })
    end
  end
  return buttons
end
DefineClass.XEditorPlacementHelperHost = {
  __parents = {
    "InitDone",
    "XEditorToolSettings"
  },
  helper_class = false,
  placement_helper = false,
  prop_cache = false,
  props_from_helper = false
}
function XEditorPlacementHelperHost:Init()
  self.placement_helper = g_Classes[self.helper_class]:new()
end
function XEditorPlacementHelperHost:Done()
  self.placement_helper:delete()
end
function XEditorPlacementHelperHost:GetToolTitle()
  return self.placement_helper.Title or self.ToolTitle
end
function XEditorPlacementHelperHost:GetProperties()
  if not self.prop_cache then
    local props = {}
    for _, prop_meta in ipairs(InitDone.GetProperties(self)) do
      props[#props + 1] = table.copy(prop_meta)
    end
    self.props_from_helper = {}
    for _, prop_meta in ipairs(self.placement_helper and self.placement_helper:GetProperties()) do
      self.props_from_helper[prop_meta.id] = true
      props[#props + 1] = table.copy(prop_meta)
    end
    self.prop_cache = props
  end
  return self.prop_cache
end
function XEditorPlacementHelperHost:GetProperty(prop)
  if self.props_from_helper and self.props_from_helper[prop] then
    return self.placement_helper:GetProperty(prop)
  end
  return PropertyObject.GetProperty(self, prop)
end
function XEditorPlacementHelperHost:SetProperty(prop, value)
  if self.props_from_helper and self.props_from_helper[prop] then
    self.placement_helper:SetProperty(prop, value)
    return
  end
  PropertyObject.SetProperty(self, prop, value)
end
function XEditorPlacementHelperHost:GetHelperClass()
  return self.helper_class
end
function XEditorPlacementHelperHost:SetHelperClass(class_name, properties)
  self.prop_cache = nil
  self.props_from_helper = nil
  self.helper_class = class_name
  if not IsKindOf(self.placement_helper, class_name) then
    self.placement_helper:delete()
    self.placement_helper = g_Classes[class_name]:new(properties)
  end
  local statusbar = GetDialog("XEditorStatusbar")
  if statusbar then
    statusbar:ActionsUpdated()
  end
  self:UpdatePlacementHelper()
  ObjModified(self)
  Msg("EditorToolChanged", GetDialog("XEditor").Mode, self.helper_class)
end
function XEditorPlacementHelperHost:UpdatePlacementHelper()
end
function XEditorPlacementHelperHost:OnShortcut(shortcut, source, ...)
  local buttons = helpers_button_list(self.class)
  local button = table.find_value(buttons, "shortcut", shortcut) or table.find_value(buttons, "shortcut2", shortcut)
  if button then
    if self.placement_helper.operation_started then
      self.desktop:SetMouseCapture()
    end
    self:SetHelperClass(button.name)
    return "break"
  end
  if self.placement_helper:HasMember("OnShortcut") then
    return self.placement_helper:OnShortcut(shortcut, source, ...)
  end
end
function XEditorPlacementHelperHost:OnMouseButtonDown(pt, button)
  if button == "L" then
    local ret = self.placement_helper:CheckStartOperation(pt, "btn_pressed")
    if ret == "break" then
      return "break"
    elseif ret then
      SuspendPassEditsForEditOp()
      self.placement_helper:StartOperation(pt, editor.GetSel())
      self.desktop:SetMouseCapture(self)
      return "break"
    end
  end
end
function XEditorPlacementHelperHost:OnMousePos(pt)
  if self.placement_helper.operation_started then
    self.placement_helper:PerformOperation(pt, editor.GetSel())
    return "break"
  end
end
function XEditorPlacementHelperHost:OnMouseButtonUp(pt, button)
  if self.placement_helper.operation_started then
    self.desktop:SetMouseCapture()
    return "break"
  end
end
function XEditorPlacementHelperHost:OnCaptureLost()
  if self.placement_helper.operation_started then
    self.placement_helper:EndOperation(editor.GetSel())
    ResumePassEditsForEditOp()
  end
end
