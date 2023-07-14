DefineClass.XEditorTool = {
  __parents = {
    "XDialog",
    "XEditorToolSettings"
  },
  properties = {
    {
      id = "DisplayInGame",
      editor = "bool",
      default = true,
      shared_setting = true,
      no_edit = true
    }
  },
  HandleMouse = true,
  UsesCodeRenderables = false,
  ToolTitle = "None",
  ToolSection = false,
  ToolKeepSelection = false,
  Description = false,
  ActionSortKey = "99",
  ActionIcon = false,
  ActionShortcut = false,
  ActionShortcut2 = false,
  FocusPropertyInSettings = false,
  PropertyTabs = false
}
function XEditorTool:SetContext(context)
  for key, value in pairs(context or empty_table) do
    if self:HasMember(key) then
      self[key] = value
    end
  end
end
function XEditorTool:OnMouseButtonDown(pos, button)
  if not camera.IsLocked(1) and button == "R" then
    if not XEditorIsDefaultTool() then
      XEditorSetDefaultTool()
      return "break"
    end
    if #editor.GetSel() == 0 then
      local obj = GetObjectAtCursor()
      if obj then
        editor.AddToSel(editor.SelectionPropagate({obj}))
      end
    end
    local sel_count = #editor.GetSel()
    local open_context_menu = terminal.IsKeyPressed(const.vkControl) == (EditorSettings:GetCtrlRightClickOpens() == "ContextMenu")
    if open_context_menu then
      local context = "NoSelection"
      if sel_count == 1 then
        context = "SingleSelection"
      elseif 1 < sel_count then
        context = "MultipleSelection"
      end
      XEditorOpenContextMenu(context, pos)
    elseif 0 < sel_count then
      OpenGedGameObjectEditor(editor.GetSel())
    end
    return "break"
  end
end
function XEditorTool:OnShortcut(shortcut, source, ...)
  if shortcut == "Escape" and not XEditorIsDefaultTool() then
    XEditorSetDefaultTool()
    return "break"
  end
  return XDialog.OnShortcut(self, shortcut, source, ...)
end
if FirstLoad then
  XEditorSettingsGed = false
  XEditorSettingsJustOpened = false
  XEditorSettingsUpdateThread = false
end
function OnMsg.GameEnterEditor()
  if not IsValidThread(XEditorSettingsUpdateThread) then
    XEditorSettingsUpdateThread = CreateRealTimeThread(function()
      while true do
        XEditorSettingsUpdate()
        Sleep(100)
      end
    end)
  end
end
local editable_prop_count = function(class)
  local count = 0
  for _, prop in ipairs(class:GetProperties()) do
    if not prop_eval(prop.no_edit, class, prop) then
      count = count + 1
    end
  end
  return count
end
local room_tools_visible = function(visible)
  local room_tools = GetDialog("XEditorRoomTools")
  if room_tools then
    room_tools:SetVisibleInstant(visible)
  end
end
function XEditorSettingsUpdate()
  local editor_tool = XEditorGetCurrentTool()
  local should_open = editor_tool and editable_prop_count(editor_tool) ~= 0
  if not XEditorSettingsGed and should_open then
    XEditorSettingsGed = OpenGedApp("XEditorToolSettingsPanel", editor_tool, nil, nil, editor_tool:GetDisplayInGame())
    XEditorSettingsJustOpened = editor_tool.FocusPropertyInSettings
    room_tools_visible(not editor_tool:GetDisplayInGame())
  end
  if XEditorSettingsGed then
    if not should_open or editor_tool:GetDisplayInGame() ~= XEditorSettingsGed.context.in_game then
      local settings = XEditorSettingsGed
      XEditorSettingsGed = false
      CloseGedApp(settings, "wait")
      room_tools_visible(true)
    elseif XEditorSettingsGed:ResolveObj("root") ~= editor_tool then
      XEditorSettingsGed:BindObj("root", editor_tool)
    end
  end
  local desktop = terminal.desktop
  local focused_ctrl = desktop:GetKeyboardFocus()
  if desktop:GetMouseTarget(terminal.GetMousePos()) == editor_tool or XEditorSettingsJustOpened then
    if XEditorSettingsGed and XEditorSettingsGed.context.in_game then
      if editor_tool.FocusPropertyInSettings then
        local settings_dialog = GetDialog("XEditorToolSettingsPanel")
        local prop_editor = settings_dialog and settings_dialog.idPropPanel:LocateEditorById(editor_tool.FocusPropertyInSettings)
        if prop_editor and focused_ctrl ~= prop_editor.idEdit then
          desktop:RemoveKeyboardFocus(settings_dialog, true)
          desktop:SetKeyboardFocus(prop_editor.idEdit)
          XEditorSettingsJustOpened = false
        end
      else
        local focused_app = GetParentOfKind(focused_ctrl, "GedApp")
        if focused_app and focused_app.AppId == "XEditorToolSettingsPanel" then
          desktop:RemoveKeyboardFocus(focused_app, true)
        end
      end
    end
    XEditorRemoveFocusFromToolbars()
  end
end
function OnMsg.GedClosing(id)
  if XEditorSettingsGed and GedConnections[id].app_template == "XEditorToolSettingsPanel" then
    local editor_tool = XEditorGetCurrentTool()
    if editor_tool then
      editor_tool:SetDisplayInGame(true)
    end
  end
end
function GedXEditorSettingsDescription()
  local editor_tool = XEditorGetCurrentTool()
  local descr = editor_tool and editor_tool.Description
  descr = type(descr) == "function" and descr(editor_tool) or descr
  descr = type(descr) == "table" and descr or {descr}
  return descr and table.concat(descr, [[


]]) or ""
end
function OnMsg.ShortcutsReloaded()
  local action_toolbar_section = "No Section"
  for _, class_name in ipairs(ClassLeafDescendantsList("XEditorTool")) do
    local tool = g_Classes[class_name]
    if tool.ActionIcon then
      local shortcut = tool.ActionShortcut and " (" .. tool.ActionShortcut .. ")" or ""
      local shortcut2 = tool.ActionShortcut2 and " (" .. tool.ActionShortcut2 .. ")" or ""
      local description = type(tool.Description) == "function" and tool.Description() or tool.Description
      local rolloverText = "<style XEditorRolloverBold>" .. tool.ToolTitle .. shortcut .. shortcut2 .. "</style>\n" .. table.concat(description, [[


]])
      XAction:new({
        ActionId = tool.ToolTitle,
        ActionMode = "Editor",
        ActionName = tool.ToolTitle,
        ActionTranslate = false,
        ActionIcon = tool.ActionIcon,
        ActionShortcut = tool.ActionShortcut,
        ActionShortcut2 = tool.ActionShortcut2,
        ActionSortKey = tool.ActionSortKey,
        ActionToolbarSection = tool.ToolSection or action_toolbar_section,
        RolloverText = rolloverText,
        ActionToolbar = "XEditorToolbar",
        ActionToggle = true,
        ActionToggled = function(self, host)
          return GetDialogMode("XEditor") == class_name
        end,
        ActionState = tool.ToolActionState or empty_func,
        OnAction = function(self, host)
          if GetDialogMode("XEditor") ~= class_name then
            SetDialogMode("XEditor", class_name)
          end
        end
      }, XShortcutsTarget)
    end
  end
  for _, class_name in ipairs(ClassLeafDescendantsList("XEditorPlacementHelper")) do
    local tool = g_Classes[class_name]
    if tool.ActionIcon then
      do
        local shortcut = tool.ActionShortcut and " (" .. tool.ActionShortcut .. ")" or ""
        local rolloverText = "<style XEditorRolloverBold>" .. tool.Title .. "</style>"
        XAction:new({
          ActionId = tool.Title,
          ActionMode = "Editor",
          ActionName = tool.Title,
          ActionIcon = tool.ActionIcon,
          ActionShortcut = tool.ActionShortcut,
          ActionShortcut2 = tool.ActionShortcut2,
          ActionSortKey = tool.ActionSortKey,
          RolloverText = rolloverText,
          ActionToolbar = "XEditorStatusbar",
          ActionToggle = true,
          ActionToggled = function(self, host)
            local dialog = GetDialog("XSelectObjectsTool") or GetDialog("XPlaceObjectTool")
            return dialog and dialog:GetHelperClass() == class_name
          end,
          ActionState = function(self, host)
            if GetDialog("XSelectObjectsTool") and tool.InXSelectObjectsTool then
              return true
            elseif GetDialog("XPlaceObjectTool") and tool.InXPlaceObjectTool then
              return true
            end
            return "hidden"
          end,
          OnAction = function(self, host)
            local dialog = GetDialog("XSelectObjectsTool") or GetDialog("XPlaceObjectTool")
            if not dialog then
              SetDialogMode("XEditor", "XSelectObjectsTool")
              dialog = GetDialog("XSelectObjectsTool")
            end
            GetDialog(dialog.class):SetHelperClass(class_name)
          end
        }, XShortcutsTarget)
      end
    end
  end
end
