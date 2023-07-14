function GedPropValueToT(value)
  return type(value) == "table" and setmetatable(table.copy(value), TMeta) or ""
end
function GedTToPropValue(value, default)
  if value == "" then
    return type(default) == "table" and "" or default
  end
  value[2] = ReplaceNonStandardCharacters(value[2])
  if value == default then
    return table.raw_copy(default)
  end
  if IsT(default) and TGetID(value) == TGetID(default or "") then
    return {
      RandomLocId(),
      value[2]
    }
  end
  return table.raw_copy(value)
end
GedPropEditors = {}
GedPropEditors.buttons = "GedPropEditor"
DefineClass.GedPropEditor = {
  __parents = {
    "XContextControl"
  },
  IdNode = true,
  LayoutHSpacing = 2,
  LayoutVSpacing = 2,
  FoldWhenHidden = true,
  RolloverAnchor = "left",
  RolloverTemplate = "GedPropRollover",
  SelectionBackground = RGB(204, 232, 255),
  BorderColor = RGBA(0, 0, 0, 0),
  BorderWidth = 2,
  prop_meta = false,
  parent_obj_id = false,
  panel = false,
  obj = false,
  last_set_value = false,
  selectable = true,
  selected = false,
  highlight_search_match = false
}
function GedPropEditor:ReassignFocusOrders(x, y)
  return y + 1
end
function GedPropEditor:QueueReassignFocusOrders()
  local obj = GetParentOfKind(self, "GedPropPanel")
  if obj then
    obj:QueueReassignFocusOrders()
  end
end
function GedPropEditor:SetSelected(selected)
  self.selected = selected
  self:Invalidate()
end
function GedPropEditor:CalcBackground()
  if self.enabled and self.selected then
    return self.SelectionBackground
  end
  return XContextControl.CalcBackground(self)
end
function GedPropEditor:SetHighlightSearchMatch(value)
  self.highlight_search_match = value
end
function GedPropEditor:UpdatePropertyNames(internal, prop_name)
  local prop_meta = self.prop_meta
  local prop_name = prop_name or internal and prop_meta.id or prop_meta.name or prop_meta.id
  local prefix, suffix = "", ""
  if prop_meta.dlc_name then
    prefix = "<style GedHighlight>[" .. prop_meta.dlc_name .. "]</style> "
  end
  if prop_meta.scale_name then
    suffix = " (" .. prop_meta.scale_name .. ")"
  end
  if self.highlight_search_match then
    prop_name = GedPanelBase.MatchMark .. prop_name
  end
  local rollover
  local editor = prop_meta.editor
  if self.panel.ShowUnusedPropertyWarnings and editor ~= "help" and editor ~= "buttons" and editor ~= "linked_presets" then
    local prop_stats = self.panel:Obj("root|prop_stats")
    if prop_stats and prop_stats[prop_meta.id] then
      local used_in = prop_stats[prop_meta.id]
      if used_in == 0 then
        prefix = "<image CommonAssets/UI/Ged/warning.tga 900 127 127 127> " .. prefix
        rollover = "<style GedHighlight>Property is default for all presets."
      else
        prefix = "<image CommonAssets/UI/Ged/warning.tga 900 127 180 127> " .. prefix
        rollover = "<style GedHighlight>Property is only set in " .. used_in .. "."
      end
    end
  end
  self.idLabel:SetText(prefix .. prop_name .. suffix)
  if editor ~= "help" and editor ~= "linked_presets" then
    self:SetRolloverText(prop_meta.help and rollover and prop_meta.help .. [[


]] .. rollover or prop_meta.help or rollover or false)
  end
end
function GedPropEditor:ShouldShowButtonForFunc(func_name)
  return self.panel:ShouldShowButtonForFunc(func_name)
end
function GedPropEditor:Init(parent, context, prop_meta)
  self.prop_meta = prop_meta
  self.RolloverText = prop_meta.help or nil
  self.RolloverAnchor = "smart"
  local win = XWindow:new({
    Id = "idLabelHost",
    Dock = prop_meta.name_on_top and "top" or "left",
    FoldWhenHidden = true
  }, self)
  XText:new({
    Id = "idLabel",
    Dock = "left",
    VAlign = "center",
    MinWidth = 150
  }, win)
  XTextButton:new({
    Id = "idResetToDefault",
    Dock = "right",
    VAlign = "center",
    Text = "x",
    MaxWidth = 20,
    MaxHeight = 16,
    LayoutHSpacing = 0,
    Padding = box(1, 1, 1, 1),
    Background = RGBA(0, 0, 0, 0),
    RolloverBackground = RGB(204, 232, 255),
    PressedBackground = RGB(121, 189, 241),
    OnPress = function()
      self.panel:SetPanelFocused()
      self:SetProp(nil, "force")
    end
  }, win)
  win:SetVisibleInstant(not prop_meta.hide_name)
  local editor = prop_meta.editor
  if editor == "buttons" then
    win:SetDock("ignore")
    win:SetVisible(false)
  end
  if self.prop_meta.buttons then
    local buttons_host = XWindow:new({
      Id = "idButtonsHost",
      Dock = (editor == "linked_presets" or editor == "buttons") and "bottom" or "right",
      HAlign = "center",
      LayoutMethod = "HWrap",
      LayoutHSpacing = 2,
      Padding = box(2, 1, 0, 0)
    }, self)
    for _, data in ipairs(prop_meta.buttons or empty_table) do
      if self:ShouldShowButtonForFunc(data.func) then
        local button
        if data.toggle then
          button = XTemplateSpawn("GedToolbarToggleButtonSmall", buttons_host)
          button:SetIcon(data.icon)
          button:SetToggled(data.toggled)
        elseif data.icon then
          button = XTemplateSpawn("GedToolbarButtonSmall", buttons_host)
          button:SetIcon(data.icon)
        else
          button = XTemplateSpawn("GedPropertyButton", buttons_host)
          button:SetText(data.name)
        end
        if data.icon_scale then
          local scale = data.icon_scale * 10
          button:SetIconScale(point(scale, scale))
        end
        function button.OnPress(button)
          button:SetFocus()
          self.panel:Op("GedPropEditorButton", self.panel.context, self.panel.RootObjectBindName or "root", prop_meta.id, data.name, data.func, data.param)
          button:SetFocus(false)
        end
        button:SetRolloverText(data.rollover or "")
        button:SetDock(false)
      end
    end
  end
end
function GedPropEditor:GetProp()
  local obj = self.panel:Obj(self.obj)
  local value = obj and obj[self.prop_meta.id]
  if value == nil then
    value = self.prop_meta.default
  end
  return value
end
function GedPropEditor:SetProp(value, force, slider_drag_id)
  if self.prop_meta.read_only then
    return
  end
  if value == Undefined() then
    return
  end
  if value == nil and not force then
    return
  end
  local lua_value = ValueToLuaCode(value)
  if self.last_set_value == lua_value then
    return
  end
  self.last_set_value = lua_value
  LaunchRealTimeThread(function(self, value)
    local err = self.panel:RemoteSetProperty(self.obj, self.prop_meta.id, value, self.parent_obj_id, slider_drag_id)
    if rawget(self, "idResetToDefault") then
      if err then
        self.idResetToDefault:SetVisible(true)
        self.idResetToDefault:SetTextStyle("GedError")
      else
        self.idResetToDefault:SetVisible(value ~= nil and self.prop_meta.default ~= nil and value ~= self.prop_meta.default and not self.prop_meta.read_only)
      end
    end
    self:SetPropResult(err)
  end, self, value)
end
function GedPropEditor:OnKillFocus()
  if not self.prop_meta.read_only then
    self:SendValueToGame()
  end
end
function GedPropEditor:SendValueToGame()
end
function GedPropEditor:UpdateValue()
  local value = self:GetProp()
  if self:HasMember("idResetToDefault") then
    self.idResetToDefault:SetVisible(value ~= nil and self.prop_meta.default ~= nil and value ~= self.prop_meta.default and not self.prop_meta.read_only)
  end
  self.last_set_value = ValueToLuaCode(value)
  Msg("GedPropertyUpdated", self)
end
function GedPropEditor:SetPropResult(err)
  if self.window_state == "destroying" then
    return
  end
  if rawget(self, "idError") then
    self.idError:Close()
  end
  if err and err ~= "" then
    XLabel:new({
      Id = "idError",
      Dock = "bottom",
      ZOrder = -1,
      TextStyle = "GedError"
    }, self):Open()
    self.idError:SetText(err)
  end
end
local search_display_text = function(text, filter)
  text = tostring(text):gsub("<[^>]+>", "")
  text = string.lower(text)
  return text:find(filter, 1, true)
end
local function get_children_of_classes(win, results, ...)
  results = results or {}
  for _, child in ipairs(win) do
    if IsKindOfClasses(child, ...) then
      table.insert(results, child)
    end
    get_children_of_classes(child, results, ...)
  end
  return results
end
function GedPropEditor:FindText(search_text, highlight_text)
  local text_controls = get_children_of_classes(self, nil, "XText", "XEditableText")
  if #text_controls == 0 then
    return true
  end
  local found
  for _, win in ipairs(text_controls) do
    if search_display_text(win.text, search_text) then
      found = true
    end
    if IsKindOf(win, "XTextEditor") then
      local plugin = win:FindPluginOfKind("XHighlightTextPlugin")
      if not plugin then
        plugin = XHighlightTextPlugin:new()
        win:AddPlugin(plugin)
      end
      plugin.highlighted_text = highlight_text
      plugin.ignore_case = true
      win:Invalidate()
    end
  end
  return found
end
function GedPropEditor:HighlightAndSelect(text)
  local focus = self:GetRelativeFocus(point(0, 0), "next") or self
  if focus then
    local text_controls = get_children_of_classes(self, nil, "XEditableText")
    if #text_controls == 0 then
      if text then
        focus:SetFocus()
      end
      return focus
    end
    CreateRealTimeThread(function(text_controls, focus)
      if self.window_state == "destroying" then
        return
      end
      for _, ctrl in ipairs(text_controls) do
        if text and ctrl:SelectFirstOccurence(text, "ignore_case") then
          ctrl:SetFocus()
          return
        end
        ctrl:ClearSelection()
      end
      if text then
        focus:SetFocus()
      end
    end, text_controls, focus)
  end
  return focus
end
function GedPropEditor:DetachForReuse()
  self:SetParent(false)
  self.last_set_value = false
end
function GedPropEditor:OnShortcut(shortcut, source, ...)
  if shortcut == "Escape" and not self.prop_meta.read_only and self.SendValueToGame ~= GedPropEditor.SendValueToGame then
    self.panel:SetFocus()
    local value = self:GetProp()
    self:SendValueToGame()
    self:SetProp(value, "force")
    return "break"
  end
end
GedPropEditors.script = "GedPropScript"
DefineClass.GedPropScript = {
  __parents = {
    "GedPropEmbeddedObject"
  }
}
function GedPropScript:Init(parent, context, prop_meta)
  local edit_button = self.idCreateItemButton
  edit_button:SetParent(self.idLabelHost)
  edit_button:SetIcon("CommonAssets/UI/Ged/explorer.tga")
  edit_button:SetRolloverText("Edit script")
  edit_button:SetZOrder(-2)
  function edit_button.OnPress()
    self.panel.app:Op("GedCreateOrEditScript", self.panel.context, self.prop_meta.id, self.prop_meta.class)
  end
  self.idCopyButton:SetParent(self.idLabelHost)
  self.idCopyButton:SetZOrder(0)
  function self.idCopyButton.OnPress(button)
    self.panel.app:Op("GedNestedObjCopy", self.panel.context, self.prop_meta.id, self.prop_meta.class)
  end
  self.idPasteButton:SetParent(self.idLabelHost)
  self.idPasteButton:SetZOrder(-1)
  function self.idPasteButton.OnPress(button)
    self.panel.app:Op("GedNestedObjPaste", self.panel.context, self.prop_meta.id, self.prop_meta.class)
    self.panel.app:Op("GedCreateOrEditScript", self.panel.context, self.prop_meta.id, self.prop_meta.class)
  end
  self.idLabelHost:SetDock("top")
  XScrollArea:new({
    Id = "idEditHost",
    IdNode = false,
    VScroll = "idScroll",
    MaxHeight = 160,
    BorderWidth = 1,
    CalcBackground = function()
      return self.idScript:CalcBackground()
    end
  }, self)
  XText:new({
    Id = "idScript",
    WordWrap = false,
    BorderWidth = 0,
    TextStyle = "GedScript"
  }, self.idEditHost)
  XSleekScroll:new({
    Id = "idScroll",
    Target = "idEditHost",
    Dock = "right",
    Margins = box(2, 0, 0, 0),
    AutoHide = true
  }, self.idEditHost)
  self.idScroll:SetHorizontal(false)
end
function GedPropScript:UpdateValue()
  local prop = self:GetProp()
  if prop == Undefined() then
    self.idScript:SetText("Undefined")
    self.idScript:SetEnabled(false)
    self.idCopyButton:SetVisible(false)
    GedPropEditor.UpdateValue(self)
    return
  end
  self.idScript:SetText(prop)
  self.idScript:SetEnabled(not prop:starts_with("empty"))
  self.idCopyButton:SetVisible(not prop:starts_with("empty"))
  GedPropEditor.UpdateValue(self)
end
GedPropEditors.help = "GedPropHelp"
DefineClass.GedPropHelp = {
  __parents = {
    "GedPropEditor"
  }
}
function GedPropHelp:Init(parent, context, prop_meta)
  self.idLabelHost:SetDock("ignore")
  self.idLabelHost:SetVisible(false)
  if (prop_meta.help or "") ~= "" then
    XText:new({
      Dock = "top",
      Id = "idHelp",
      Padding = box(2, 2, 2, 0)
    }, self)
    self.idHelp:SetText(prop_meta.help)
    XWindow:new({
      Dock = "top",
      MaxHeight = 1,
      MinHeight = 1,
      Margins = box(7, 0, 7, 3),
      Background = RGB(128, 128, 128)
    }, self)
  end
  self.RolloverText = nil
end
GedPropEditors.text = "GedPropText"
GedPropEditors.prop_table = "GedPropText"
DefineClass.GedPropText = {
  __parents = {
    "GedPropEditor"
  },
  text_value = false,
  update_thread = false
}
function GedPropText:Init(parent, context, prop_meta)
  local lines = prop_meta.lines or self.lines
  if lines then
    self.idLabelHost:SetDock("top")
    XWindow:new({
      Id = "idEditHost",
      BorderWidth = 1,
      CalcBackground = function()
        return self.idEdit:CalcBackground()
      end
    }, self)
    XMultiLineEdit:new({
      Id = "idEdit",
      VScroll = "idScroll",
      MinVisibleLines = lines,
      MaxVisibleLines = Max(prop_meta.max_lines or self.max_lines or 10, lines),
      MaxLen = prop_meta.max_len,
      WordWrap = prop_meta.wordwrap,
      TextStyle = prop_meta.text_style,
      Filter = prop_meta.allowed_chars or ".",
      NewLine = "\n",
      BorderWidth = 0
    }, self.idEditHost)
    XSleekScroll:new({
      Id = "idScroll",
      Target = "idEdit",
      Dock = "right",
      Margins = box(2, 0, 0, 0),
      AutoHide = true
    }, self.idEditHost)
    self.idScroll:SetHorizontal(false)
  else
    XEdit:new({
      Id = "idEdit",
      VAlign = "center",
      TextStyle = prop_meta.text_style,
      Filter = prop_meta.allowed_chars or "."
    }, self)
  end
  local plugins = {}
  if prop_meta.translate then
    plugins[#plugins + 1] = "XSpellcheckPlugin"
  end
  if prop_meta.code then
    plugins[#plugins + 1] = "XCodeEditorPlugin"
  end
  self.idEdit:SetTranslate(prop_meta.translate or false)
  self.idEdit:SetPlugins(plugins)
  self.idEdit:SetEnabled(not prop_meta.read_only)
  self.idEdit:SetAutoSelectAll((prop_meta.read_only or prop_meta.auto_select_all) and not prop_meta.no_auto_select)
  if prop_meta.realtime_update and not prop_meta.read_only then
    self.update_thread = self:CreateThread("update_thread", self.UpdateThread, self)
  end
end
function GedPropText:ReassignFocusOrders(x, y)
  self.idEdit:SetFocusOrder(point(x, y))
  return y + 1
end
function GedPropText:UpdateThread()
  while true do
    Sleep(250)
    if self.idEdit:IsFocused() and self.idEdit:GetText() ~= self.text_value then
      self:SendValueToGame()
    end
  end
end
function GedPropText:UpdateValue()
  if not self.idEdit:IsFocused() or self.idEdit:GetText() == self.text_value then
    local prop = self:GetProp()
    local translate = self.prop_meta.translate
    local text
    if prop == Undefined() then
      text = ""
      self.idEdit:SetHint(translate and Untranslated("Undefined") or "Undefined")
    elseif prop == false then
      text = ""
      self.idEdit:SetHint(translate and Untranslated("false") or "false")
    else
      text = self:ConvertToText(prop) or ""
      self.idEdit:SetHint("")
    end
    self.text_value = text
    self.idEdit:SetText(text)
  end
  GedPropEditor.UpdateValue(self)
end
function GedPropText:OnShortcut(shortcut, source, ...)
  if (shortcut == "Enter" or shortcut == "Ctrl-Enter") and not self.prop_meta.read_only then
    self:SendValueToGame()
    return "break"
  end
  return GedPropEditor.OnShortcut(self, shortcut, source, ...)
end
function GedPropText:SendValueToGame()
  self:SetValueFromText()
end
function GedPropText:SetValueFromText(no_text_update)
  local text = self.idEdit:GetText()
  if type(text) == "string" and self.prop_meta.trim_spaces ~= false and string.trim_spaces(text) ~= text then
    text = string.trim_spaces(text)
    if rawget(self, "idEdit") and not no_text_update then
      self.idEdit:SetText(text)
    end
  end
  if text ~= self.text_value then
    local value, is_invalid, recalc_text = self:ConvertFromText(text)
    if is_invalid then
      return
    end
    if value ~= nil then
      if recalc_text then
        text = self:ConvertToText(value)
      end
      self.text_value = text
      self:SetProp(value)
    end
    if (value == nil or recalc_text) and rawget(self, "idEdit") and not no_text_update then
      self.idEdit:SetText(self.text_value)
    end
  end
end
function GedPropText:ConvertToText(value)
  return self.prop_meta.translate and GedPropValueToT(value) or type(value) == "string" and value or ""
end
function GedPropText:ConvertFromText(value)
  return self.prop_meta.translate and GedTToPropValue(value, self.prop_meta.default) or value
end
function GedPropText:DetachForReuse()
  self.text_value = false
  GedPropEditor.DetachForReuse(self)
end
GedPropEditors.number = "GedPropNumber"
GedPropEditors.radius = "GedPropNumber"
GedPropEditors.time = "GedPropNumber"
DefineClass.GedPropNumber = {
  __parents = {
    "GedPropEditor"
  },
  display_scale = 1,
  slider_drag_id = false
}
function GedPropNumber:Init(parent, context, prop_meta)
  if type(prop_meta.scale) == "string" then
    self.display_scale = const.Scale[prop_meta.scale]
  else
    self.display_scale = prop_meta.scale or 1
  end
  local step = prop_meta.buttons_step or prop_meta.step or self.display_scale or 1
  local edit, top, bottom = CreateNumberEditor(self, "idEdit", function(multiplier)
    if type(self:GetProp()) == "number" then
      self:TrySetProp(self:GetProp() + step * multiplier, "update_scrollbar")
    end
  end, function(multiplier)
    if type(self:GetProp()) == "number" then
      self:TrySetProp(self:GetProp() - step * multiplier, "update_scrollbar")
    end
  end, prop_meta.slider and "no_buttons")
  if not prop_meta.slider then
    top:SetEnabled(not prop_meta.read_only)
    bottom:SetEnabled(not prop_meta.read_only)
  end
  if prop_meta.slider then
    self.idNumberEditor.parent:SetDock("left")
    self.idEdit:SetMinWidth(50)
    local scroll = function(multiplier)
      if type(self:GetProp()) == "number" then
        self:TrySetProp(self:GetProp() + step * multiplier, "update_scrollbar")
      end
    end
    XSleekScroll:new({
      Id = "idScroll",
      Dock = "box",
      Margins = box(2, 2, 2, 2),
      Min = prop_meta.min,
      Max = (prop_meta.max or 0) + 1,
      Horizontal = true,
      Target = "node",
      StepSize = prop_meta.step or 1,
      StartScroll = function(...)
        self.slider_drag_id = AsyncRand()
        return XSleekScroll.StartScroll(...)
      end,
      OnCaptureLost = function(...)
        self:DeleteThread("scroll_update_thread")
        self.slider_drag_id = false
        self:TrySetProp(self:SliderToPropValue(self.idScroll:GetScroll()), false)
        XSleekScroll.OnCaptureLost(...)
      end,
      OnMouseWheelForward = function()
        if terminal.IsKeyPressed(const.vkControl) then
          scroll(1)
          return "break"
        end
      end,
      OnMouseWheelBack = function()
        if terminal.IsKeyPressed(const.vkControl) then
          scroll(-1)
          return "break"
        end
      end
    }, self)
    self.idScroll:SetEnabled(not prop_meta.read_only)
  end
  self.idEdit:SetAutoSelectAll((prop_meta.read_only or prop_meta.auto_select_all) and not prop_meta.no_auto_select)
  self.idEdit:SetEnabled(not prop_meta.read_only)
end
function GedPropNumber:ReassignFocusOrders(x, y)
  self.idEdit:SetFocusOrder(point(x, y))
  return y + 1
end
function GedPropNumber:OnScrollTo(value)
  if not self:IsThreadRunning("scroll_update_thread") then
    self:CreateThread("scroll_update_thread", function()
      Sleep(75)
      self:TrySetProp(self:SliderToPropValue(self.idScroll:GetScroll()), false)
    end)
  end
end
function GedPropNumber:UpdateValue()
  local has_slider = self.prop_meta.slider
  if not self.idEdit:IsFocused(true) and (not has_slider or self.desktop:GetMouseCapture() ~= self.idScroll) then
    local value = self:GetProp()
    self:SetSliderValue(value)
    self:SetEditedValue(value)
  end
  GedPropEditor.UpdateValue(self)
end
function GedPropNumber:OnShortcut(shortcut, source, ...)
  if shortcut == "Enter" or shortcut == "Ctrl-Enter" then
    self:TrySetProp(self:GetEditedValue(), "update_scrollbar")
    return "break"
  end
  return GedPropEditor.OnShortcut(self, shortcut, source, ...)
end
function GedPropNumber:SendValueToGame()
  self:TrySetProp(self:GetEditedValue(), "update_scrollbar")
end
function GedPropNumber:SliderToPropValue(slider_value)
  if self.prop_meta.exponent and self.prop_meta.slider then
    local exponential_value = LinearToExponential(slider_value, self.prop_meta.exponent, self.prop_meta.min, self.prop_meta.max)
    local step = self.prop_meta.step or 1
    return exponential_value / step * step
  else
    return slider_value
  end
end
function GedPropNumber:PropToSliderValue(prop_value)
  if prop_value == Undefined() then
    prop_value = self.prop_meta.min or 0
  end
  if self.prop_meta.exponent and self.prop_meta.slider then
    return ExponentialToLinear(prop_value, self.prop_meta.exponent, self.prop_meta.min, self.prop_meta.max)
  else
    return prop_value
  end
end
function GedPropNumber:TrySetProp(prop_value, update_scrollbar)
  if self.window_state == "destroying" or self.prop_meta.read_only then
    return
  end
  if not prop_value then
    return
  end
  if self.prop_meta.max and prop_value > self.prop_meta.max then
    prop_value = self.prop_meta.max
  end
  if self.prop_meta.min and prop_value < self.prop_meta.min then
    prop_value = self.prop_meta.min
  end
  self:SetProp(prop_value, false, self.slider_drag_id)
  self:SetEditedValue(prop_value)
  if update_scrollbar then
    self:SetSliderValue(prop_value)
  end
end
function GedPropNumber:SetSliderValue(prop_value)
  if type(prop_value) ~= "number" then
    prop_value = self.prop_meta.min or 0
  end
  if self.prop_meta.slider then
    local slider_value = self:PropToSliderValue(prop_value)
    self.idScroll:SetScroll(slider_value)
  end
end
function GedPropNumber:SetEditedValue(value)
  if value == Undefined() then
    self.idEdit:SetHint("Undefined")
    self.idEdit:SetText("")
    return
  end
  local number = tonumber(value)
  if not number then
    self.idEdit:SetText("")
    self.idEdit:SetHint(tostring(value))
  else
    self.idEdit:SetText(FormatNumberProp(number, self.display_scale))
    self.idEdit:SetHint("")
  end
end
function GedPropNumber:GetEditedValue()
  local num = tonumber(self.idEdit:GetText())
  return num and floatfloor(num * self.display_scale + 0.5) or nil
end
GedPropEditors.ui_image = "GedPropUIImage"
DefineClass.GedPropUIImage = {
  __parents = {
    "GedPropBrowse"
  },
  in_mod_editor = false
}
local GetSegments = function(path)
  path = path:gsub("[\\/]+", "/")
  local segments = {}
  for segment in string.gmatch(path, "[^/]+") do
    table.insert(segments, segment)
  end
  return segments
end
local GetRelativePath = function(path, base, game_path)
  path = GetSegments(path)
  base = GetSegments(base)
  game_path = GetSegments(game_path)
  for key, value in ipairs(base) do
    if value ~= path[key] then
      return false
    end
  end
  return table.concat(table.move(path, #base + 1, #path, #game_path + 1, game_path), "/")
end
function GedPropUIImage:BuildUIForPath(path)
  if self.prop_meta.dont_validate or self.in_mod_editor then
    return
  end
  local dir, name, ext = SplitPath(path)
  if io.exists("svnAssets/Source/" .. dir .. name .. ".png") and not io.exists(dir .. name .. ".dds") and not io.exists(dir .. name .. ".tga") then
    local app = self.panel.app
    if not app:IsThreadRunning("BuildUIThread") then
      app:CreateThread("BuildUIThread", function()
        local assets_path = ConvertToOSPath("svnAssets/")
        local project_path = ConvertToOSPath("svnProject/")
        local err, exit_code = AsyncExec(string.format("cmd /c echo Running 'build UI' to include the selected UI image in the build. Please commit the resulting files! & %s/Build UI-win32", project_path))
        if err then
          return
        end
        err, exit_code = AsyncExec(string.format("cmd /c echo Please use the SVN dialog that popped to commit the built UI image files! & TortoiseProc /command:commit /path:%s", assets_path))
        if err then
        end
      end)
    end
  end
end
function GedPropUIImage:OpenBrowseDialog(path, filter, exists, multiple, initial_file, folders)
  if self.in_mod_editor then
    if (filter or "") == "" then
      filter = "PNG files|*.png"
    end
    path = g_GedApp.mod_os_path
  else
    if (filter or "") == "" then
      filter = "All files|*.*"
    end
    local prop = self:GetProp()
    if prop and prop ~= "" and prop ~= Undefined() then
      path = SplitPath(prop)
      path = Platform.developer and path:starts_with("UI/") and "svnAssets/Source/" .. path or path
      if not io.exists(path) then
        path = folders[1].game_path
        path = Platform.developer and path:starts_with("UI/") and "svnAssets/Source/" .. path or path
      end
      path = ConvertToOSPath(path)
    end
  end
  local image_path = GedPropBrowse.OpenBrowseDialog(self, path, filter, true, false, initial_file)
  if image_path then
    if self.in_mod_editor then
      path = ConvertToOSPath(path)
      image_path = ConvertToOSPath(image_path)
      if not image_path:starts_with(path) then
        local dir, file, ext = SplitPath(image_path)
        local org_file = file
        local dst_path = SlashTerminate(path)
        dst_path = SlashTerminate(dst_path .. "Images")
        AsyncCreatePath(dst_path)
        local new_image_path, i
        while true do
          new_image_path = dst_path .. file .. ext
          if io.exists(new_image_path) then
            i = (i or 1) + 1
            file = string.format("%s %d", org_file, i)
          else
            break
          end
        end
        local err = AsyncCopyFile(image_path, new_image_path, "raw")
        if err then
          self:SetPropResult("Failed to import the image: " .. err)
          return ""
        end
        image_path = new_image_path
      end
      image_path = GetRelativePath(image_path, path, g_GedApp.mod_content_path)
    else
      local dir, file, ext = SplitPath(image_path)
      image_path = dir .. file
    end
  end
  return image_path
end
function GedPropUIImage:Init(parent, context, prop_meta)
  self.in_mod_editor = g_GedApp.AppId == "ModEditor"
  local image_preview_size = prop_meta.image_preview_size or 0
  local edit_container = self
  if 0 < image_preview_size then
    edit_container = XWindow:new({
      Dock = "bottom",
      ZOrder = -1,
      Margins = box(0, 3, 0, 0)
    }, self)
  end
  XImage:new({
    Id = "idImage",
    ImageFit = "scale-down",
    MaxWidth = Max(image_preview_size, 28),
    MaxHeight = Max(image_preview_size, 28),
    HandleMouse = true,
    FoldWhenHidden = true
  }, XWindow:new({Dock = "right"}, self))
  self.idImage:SetVisible(false)
  self.idImage:SetRolloverTemplate("GedImageRollover")
end
function GedPropUIImage:Open(...)
  if self.in_mod_editor then
    self.idButtonBrowse:SetText("Import")
  end
  return GedPropBrowse.Open(self, ...)
end
function GedPropUIImage:UpdateValue()
  GedPropBrowse.UpdateValue(self)
  local prop = self:GetProp()
  if not prop or prop == Undefined() or prop == "" then
    self.idImage:SetVisible(false)
  else
    self.idImage:SetImage(prop)
    self.idImage:SetRolloverText(prop)
    self.idImage:SetVisible(true)
  end
end
function GedPropUIImage:SetProp(value, ...)
  GedPropBrowse.SetProp(self, value, ...)
  if value then
    self:BuildUIForPath(value)
  end
end
function FindUniqueFileName(folder_path, file, ext)
  local org_file = file
  local new_image_path, i
  while true do
    new_image_path = folder_path .. file .. ext
    if io.exists(new_image_path) then
      i = (i or 1) + 1
      file = string.format("%s %d", org_file, i)
    else
      return new_image_path
    end
  end
end
GedPropEditors.font = "GedPropFont"
DefineClass.GedPropFont = {
  __parents = {
    "GedPropBrowse"
  },
  in_mod_editor = false
}
function GedPropFont:Init()
  self.in_mod_editor = g_GedApp.AppId == "ModEditor"
end
function GedPropFont:Open(...)
  if self.in_mod_editor then
    self.idButtonBrowse:SetText("Import")
  end
  return GedPropBrowse.Open(self, ...)
end
function GedPropFont:OpenBrowseDialog(path, filter, exists, multiple, initial_file, folders)
  if (filter or "") == "" then
    filter = "Font files|*.ttf;*.otf"
  end
  if self.in_mod_editor then
    path = g_GedApp.mod_os_path
  end
  local font_path = GedPropBrowse.OpenBrowseDialog(self, path, filter, true, false, initial_file)
  if font_path and self.in_mod_editor then
    path = ConvertToOSPath(path)
    font_path = ConvertToOSPath(font_path)
    if not font_path:starts_with(path) then
      local dir, file, ext = SplitPath(font_path)
      local dst_path = SlashTerminate(path)
      dst_path = ConvertToOSPath(SlashTerminate(dst_path .. "Fonts"))
      AsyncCreatePath(dst_path)
      local new_font_path = FindUniqueFileName(dst_path, file, ext)
      local err = AsyncCopyFile(font_path, new_font_path, "raw")
      if err then
        self:SetPropResult("Failed to import the font: " .. err)
        return
      end
      return new_font_path
    end
  end
  return font_path
end
GedPropEditors.browse = "GedPropBrowse"
DefineClass.GedPropBrowse = {
  __parents = {
    "GedPropEditor"
  }
}
local NormalizeGamePath = function(path)
  path = path:gsub("\\", "/")
  local final_path = ""
  for segment in path:gmatch("[^/]+") do
    segment = segment:trim_spaces()
    if 0 < #segment then
      final_path = final_path .. segment .. "/"
    end
  end
  return final_path:lower()
end
local MatchFolder = function(path, folders)
  path = path or ""
  folders = folders or ""
  if path == "" or #folders == 0 then
    return
  end
  for _, folder in ipairs(folders) do
    if folder.game_path then
      local normalized_path = NormalizeGamePath(path)
      local normalized_folder = NormalizeGamePath(folder.game_path)
      if normalized_path:starts_with(normalized_folder, true) then
        return folder
      end
    end
    if folder.os_path then
      local normalized_path = ConvertToOSPath(path)
      local normalized_folder = ConvertToOSPath(folder.os_path)
      if string.starts_with(normalized_path, normalized_folder, true) then
        return folder
      end
    end
  end
end
local SelectGamePath = function(editor, prop_meta, folder, folders, initial)
  local path = editor:OpenBrowseDialog(folder.os_path, prop_meta.filter or "", not prop_meta.allow_missing, false, initial, folders)
  if path then
    local converted_path = ConvertFromOSPath(path, folder.game_path)
    if path ~= converted_path then
      return converted_path
    else
      local relative = GetRelativePath(converted_path, folder.os_path, folder.game_path)
      if relative then
        return relative
      end
      for _, folder in ipairs(folders) do
        local relative = GetRelativePath(converted_path, folder.os_path, folder.game_path)
        if relative then
          return relative
        end
      end
      if prop_meta.dont_validate then
        return path
      end
    end
  end
  return false
end
local SelectOSPath = function(editor, prop_meta, folder, folders, initial)
  local path = editor:OpenBrowseDialog(folder.os_path, prop_meta.filter or "", not prop_meta.allow_missing, false, initial, folders)
  local path, err = ConvertToOSPath(path)
  local folder_os_path, err2 = ConvertToOSPath(folder.os_path)
  if not err and not err2 and (prop_meta.dont_validate or path and string.starts_with(path, folder_os_path, true)) then
    return path
  elseif not path then
    return false
  end
end
function GedPropBrowse:Init(parent, context, prop_meta)
  local folders = self:GetPropMetaFolder()
  if 0 < #folders or prop_meta.os_path then
    local buttonswin = XWindow:new({
      Id = "idButtonsHost",
      Dock = "right",
      HAlign = "center",
      LayoutMethod = "HList",
      LayoutHSpacing = 2,
      Padding = box(2, 0, 0, 0)
    }, self)
    XTextButton:new({
      Id = "idButtonBrowse",
      Text = "...",
      Enabled = not prop_meta.read_only,
      Dock = "right",
      VAlign = "stretch",
      Margins = box(0, 1, 0, 1),
      MaxWidth = 50,
      BorderWidth = 1,
      BorderHeight = 1,
      Background = RGB(220, 220, 220),
      RolloverBackground = RGB(255, 255, 255),
      RolloverBorderColor = RGB(0, 0, 0),
      PressedBackground = RGB(220, 220, 255),
      PressedBorderColor = RGB(0, 0, 0),
      OnPress = function(button, gamepad)
        local prop = self:GetProp() or ""
        if prop == Undefined() then
          prop = ""
        end
        local path, name, ext = SplitPath(prop)
        if prop_meta.os_path then
          if (path or "") == "" then
            path = ConvertToOSPath(".")
          end
          path = self:OpenBrowseDialog(path, prop_meta.filter or "", not prop_meta.allow_missing)
          if path then
            self:SetProp(path)
          end
        else
          local folder = (path or "") ~= "" and MatchFolder(path, folders) or folders[1]
          local fn = folder.game_path and SelectGamePath or SelectOSPath
          path = fn(self, prop_meta, folder, folders, name .. ext)
          CreateRealTimeThread(function()
            Sleep(10)
            if self.window_state ~= "destroying" then
              if path then
                self:SetProp(path)
              elseif path ~= false then
                self:SetPropResult("File is not in any of: " .. (folder.game_path or folder.os_path))
              end
            end
          end)
        end
      end,
      Clip = "self"
    }, buttonswin)
  end
  XEdit:new({
    Id = "idEdit",
    VAlign = "center",
    OnShortcut = function(edit, shortcut, ...)
      if (shortcut == "Enter" or shortcut == "Ctrl-Enter") and not self.prop_meta.read_only then
        self:SendValueToGame()
        return "break"
      end
      return XEdit.OnShortcut(edit, shortcut, ...)
    end
  }, self):SetEnabled(not prop_meta.read_only)
  local image_preview_size = prop_meta.image_preview_size or 0
  local image_preview = 0 < image_preview_size
  XImage:new({
    Id = "idImage",
    ImageFit = "smallest",
    MaxWidth = image_preview_size,
    MaxHeight = image_preview_size,
    Dock = image_preview and "right" or "ignore"
  }, XWindow:new({Dock = "bottom"}, self))
  self.idImage:SetVisible(image_preview)
end
function GedPropBrowse:ReassignFocusOrders(x, y)
  self.idEdit:SetFocusOrder(point(x, y))
  return y + 1
end
function GedPropBrowse:OpenBrowseDialog(path, filter, exists, multiple, initial_file)
  return OpenBrowseDialog(path, filter, exists, multiple, initial_file)
end
function GedPropBrowse:UpdateValue()
  GedPropEditor.UpdateValue(self)
  local prop = self:GetProp()
  if prop == Undefined() then
    self.idEdit:SetHint("Undefined")
    self.idEdit:SetText("")
  elseif not prop then
    self.idEdit:SetHint("false")
    self.idEdit:SetText("")
  else
    self.idEdit:SetText(prop)
  end
end
function GedPropBrowse:GetPropMetaFolder()
  return self.prop_meta.folder or empty_table
end
function GedPropBrowse:SendValueToGame()
  local path = self.idEdit:GetText()
  if (path or "") == "" then
    return
  end
  local folders = self:GetPropMetaFolder()
  if next(folders) and not self.prop_meta.dont_validate and not MatchFolder(path, folders) then
    local serialize_fn = function(folder)
      return folder.game_path or folder.os_path
    end
    local paths = table.concat(table.map(folders, serialize_fn), ", ")
    self:SetPropResult("File is not in any of: " .. paths)
  else
    self:SetProp(path)
  end
end
function GedPropBrowse:SetProp(value, ...)
  local ext = self.prop_meta.force_extension
  if value and ext then
    local path, filename = SplitPath(value)
    local name = path .. filename
    value = ext == "" and name or ext:starts_with(".") and name .. ext or name .. "." .. ext
  end
  GedPropEditor.SetProp(self, value, ...)
end
GedPropEditors.point = "GedPropPoint"
DefineClass.GedPropPoint = {
  __parents = {
    "GedPropText"
  }
}
function GedPropPoint:Init(parent, context, prop_meta)
  local view_button = XTemplateSpawn("GedToolbarButtonSmall", self)
  view_button:SetIcon("CommonAssets/UI/Ged/preview.tga")
  view_button:SetRolloverText("View Map Pos")
  function view_button.OnPress(button)
    button:SetFocus()
    self.panel.app:Send("GedRpcViewPos", self.panel.context, prop_meta.id)
    button:SetFocus(false)
  end
end
function GedPropPoint:GetDisplayScale()
  local scale = self.prop_meta.scale
  if type(scale) == "string" then
    scale = const.Scale[scale]
  end
  if IsPoint(scale) then
    local x, y, z = scale:xyz()
    return x, y, z or 1
  end
  scale = scale or 1
  return scale, scale, scale
end
function GedPropPoint:GetMinMax()
  local min = self.prop_meta.min
  local minx, miny, minz = min, min, min
  if IsPoint(min) then
    minx, miny, minz = min:xyz()
  end
  local max = self.prop_meta.max
  local maxx, maxy, maxz = max, max, max
  if IsPoint(max) then
    maxx, maxy, maxz = max:xyz()
  end
  return minx or min_int, miny or min_int, minz or min_int, maxx or max_int, maxy or max_int, maxz or max_int
end
function GedPropPoint:ConvertToText(value)
  local result = ""
  if IsPoint(value) then
    local x, y, z = value:xyz()
    local sx, sy, sz = self:GetDisplayScale()
    result = FormatNumberProp(x, sx) .. ", " .. FormatNumberProp(y, sy)
    if z then
      result = result .. ", " .. FormatNumberProp(z, sz)
    end
  end
  return result
end
function GedPropPoint:ApplyScale(x, y, z)
  local sx, sy, sz = self:GetDisplayScale()
  x = floatfloor(x * sx + 0.5)
  y = floatfloor(y * sy + 0.5)
  z = z and floatfloor(z * sz + 0.5)
  local minx, miny, minz, maxx, maxy, maxz = self:GetMinMax()
  local x0, y0, z0 = x, y, z
  x = Clamp(x, minx, maxx)
  y = Clamp(y, miny, maxy)
  z = z and Clamp(z, minz, maxz)
  local changed = x0 ~= x or y0 ~= y or z0 ~= z
  return x, y, z, changed
end
function GedPropPoint:ConvertFromText(value)
  local changed
  local x, y, z = value:match("^([^,]+),([^,]+),([^,]+)$")
  if not x or not y then
    x, y = value:match("^([^,]+),([^,]+)$")
  end
  x, y, z = tonumber(x), tonumber(y), tonumber(z)
  if x and y then
    x, y, z, changed = self:ApplyScale(x, y, z)
    return z and point(x, y, z) or point(x, y), nil, changed
  end
end
GedPropEditors.box = "GedPropBox"
DefineClass.GedPropBox = {
  __parents = {
    "GedPropPoint"
  }
}
function GedPropBox:ConvertToText(value)
  if not value then
    return ""
  end
  local sx, sy, sz = self:GetDisplayScale()
  local boxMin = FormatNumberProp(value:minx(), sx) .. ", " .. FormatNumberProp(value:miny(), sx)
  local boxMax = FormatNumberProp(value:maxx(), sy) .. ", " .. FormatNumberProp(value:maxy(), sy)
  if value:IsValidZ() then
    boxMin = boxMin .. ", " .. FormatNumberProp(value:minz(), sz)
    boxMax = boxMax .. ", " .. FormatNumberProp(value:maxz(), sz)
  end
  return boxMin .. ", " .. boxMax
end
function GedPropBox:ConvertFromText(value)
  if value == "" then
    return
  end
  local changed1, changed2
  local minx, miny, minz, maxx, maxy, maxz = value:match("^([^,]+),([^,]+),([^,]+),([^,]+),([^,]+),([^,]+)$")
  minx, miny, minz, maxx, maxy, maxz = tonumber(minx), tonumber(miny), tonumber(minz), tonumber(maxx), tonumber(maxy), tonumber(maxz)
  local sx, sy, sz = self:GetDisplayScale()
  if minx and miny and minz and maxx and maxy and maxz then
    minx, miny, minz, changed1 = self:ApplyScale(minx, miny, minz)
    maxx, maxy, maxz, changed2 = self:ApplyScale(maxx, maxy, maxz)
    return box(minx, miny, minz, maxx, maxy, maxz), nil, changed1 or changed2
  end
  minx, miny, maxx, maxy = value:match("^([^,]+),([^,]+),([^,]+),([^,]+)$")
  minx, miny, maxx, maxy = tonumber(minx), tonumber(miny), tonumber(maxx), tonumber(maxy)
  if minx and miny and maxx and maxy then
    minx, miny, minz, changed1 = self:ApplyScale(minx, miny)
    maxx, maxy, maxz, changed2 = self:ApplyScale(maxx, maxy)
    return box(minx, miny, maxx, maxy), nil, changed1 or changed2
  end
end
GedPropEditors.rect = "GedPropRect"
DefineClass.GedPropRect = {
  __parents = {
    "GedPropText"
  }
}
function GedPropRect:ConvertToText(value)
  if not value then
    return ""
  end
  local boxMin = value:minx() .. ", " .. value:miny()
  local boxMax = value:maxx() .. ", " .. value:maxy()
  return boxMin .. ", " .. boxMax
end
function GedPropRect:ConvertFromText(value)
  local minx, miny, maxx, maxy = value:match("^([^,]+),([^,]+),([^,]+),([^,]+)$")
  minx, miny, maxx, maxy = tonumber(minx), tonumber(miny), tonumber(maxx), tonumber(maxy)
  if minx and miny and maxx and maxy then
    return box(minx, miny, maxx, maxy)
  end
end
GedPropEditors.bool = "GedPropBool"
DefineClass.GedPropBool = {
  __parents = {
    "GedPropEditor"
  },
  HAlign = "left"
}
function GedPropBool:Init(parent, context, prop_meta)
  XCheckButton:new({
    Id = "idCheck",
    Icon = "CommonAssets/UI/check-threestate-40.tga",
    IconRows = 3,
    OnChange = function(control, check)
      self:SetProp(check)
    end,
    OnPress = function(self)
      self:SetFocus()
      local row = self.IconRow + 1
      if 2 < row then
        row = 1
      end
      self:SetIconRow(row)
      self:OnRowChange(row)
    end,
    OnRowChange = function(self, row)
      if row ~= 3 then
        XCheckButton.OnRowChange(self, row)
      end
    end,
    Background = RGB(240, 240, 240),
    BorderWidth = 1,
    BorderColor = RGBA(0, 0, 0, 0),
    DisabledBorderColor = RGBA(0, 0, 0, 0)
  }, self)
  self.idCheck:SetEnabled(not prop_meta.read_only)
end
function GedPropBool:ReassignFocusOrders(x, y)
  self.idCheck:SetFocusOrder(point(x, y))
  return y + 1
end
function GedPropBool:UpdateValue()
  local prop = self:GetProp()
  local icon_row
  if prop == true then
    icon_row = 2
  elseif not prop then
    icon_row = 1
  else
    icon_row = 3
  end
  self.idCheck:SetIconRow(icon_row)
  GedPropEditor.UpdateValue(self)
end
GedPropEditors.combo = "GedPropCombo"
GedPropEditors.choice = "GedPropCombo"
GedPropEditors.dropdownlist = "GedPropCombo"
DefineClass.GedPropCombo = {
  __parents = {
    "GedPropEditor"
  },
  last_value = false
}
function GedPropCombo:Init(parent, context, prop_meta)
  XCombo:new({
    Id = "idCombo",
    Items = false,
    RefreshItemsOnOpen = true,
    DefaultValue = prop_meta.default or "",
    ArbitraryValue = prop_meta.editor == "combo",
    OnValueChanged = function(combo, value)
      self:ComboValueChanged(value)
    end,
    OnRequestItems = function(combo)
      return self.panel.connection:Call("rfnGetPropItems", self.panel.context, self.prop_meta.id)
    end,
    MRUStorageId = prop_meta.mru_storage_id,
    MRUCount = prop_meta.show_recent_items,
    VirtualItems = true
  }, self)
  self.idCombo:SetEnabled(not prop_meta.read_only)
end
function GedPropCombo:ReassignFocusOrders(x, y)
  self.idCombo:SetFocusOrder(point(x, y))
  return y + 1
end
function GedPropCombo:UpdateValue()
  local combo = self.idCombo
  combo.Items = false
  if not (combo:IsFocused() and combo.ArbitraryValue) or combo:GetValue() == combo:GetText() then
    self.last_value = self:GetProp()
    local combo_value = self.last_value
    self.idCombo:SetValue(combo_value, true)
  end
  GedPropEditor.UpdateValue(self)
end
function GedPropCombo:ComboValueChanged(value)
  if type(value) == "string" and self.prop_meta.trim_spaces ~= false and string.trim_spaces(value) ~= value then
    local items = self.idCombo.Items
    local is_new = not table.find(items, value)
    if is_new then
      value = string.trim_spaces(value)
      self.idCombo:SetValue(value)
    end
  end
  if self.last_value ~= value then
    self.last_value = value
    self:SetProp(value)
  end
end
function GedPropCombo:DetachForReuse()
  self.idCombo:UpdateMRUList()
  GedPropEditor.DetachForReuse(self)
end
GedPropEditors.expression = "GedPropExpr"
DefineClass.GedPropExpr = {
  __parents = {
    "GedPropFunc"
  },
  max_lines = 10
}
function GedPropExpr:Init(parent, context, prop_meta)
  if self.RolloverText == "" then
    self.RolloverText = string.format("function %s(%s)", prop_meta.id, prop_meta.params or "self")
  end
end
function GedPropExpr:Compile(code)
  local f, err = CompileExpression(self.prop_meta.id, self.prop_meta.params or "self", code)
  return err
end
GedPropEditors.func = "GedPropFunc"
DefineClass.GedPropFunc = {
  __parents = {
    "GedPropText"
  },
  lines = 1,
  max_lines = 20
}
local code_edit_plugin = {
  "XCodeEditorPlugin"
}
function GedPropFunc:UpdatePropertyNames(internal)
  local prop_meta = self.prop_meta
  local prop_name = internal and prop_meta.id or prop_meta.name or prop_meta.id
  prop_name = string.format("function %s(%s)", prop_name, prop_meta.params or "self")
  GedPropText.UpdatePropertyNames(self, internal, prop_name)
end
function GedPropFunc:TextEqualTo(value)
  return self.idEdit:GetText():trim_spaces() == (value or ""):trim_spaces()
end
function GedPropFunc:Init(parent, context, prop_meta)
  local prop_name = prop_meta.name or prop_meta.id
  self.idLabel:SetTranslate(false)
  self.idLabel:SetText(string.format("function %s(%s)", prop_meta.name or prop_meta.id, prop_meta.params or "self"))
  function self.idEdit.OnTextChanged(edit)
    self:UpdateCodeEditorUI()
    self:DeleteThread("set_value")
    self:CreateThread("set_value", function()
      Sleep(1500)
      self:UpdateCompilationError(self.idEdit:GetText())
    end)
  end
  self.idEdit:SetPlugins(code_edit_plugin)
  self.idEdit:SetWordWrap(false)
  self.idEdit:SetFoldWhenHidden(true)
  self.idEdit:SetAutoSelectAll((prop_meta.read_only or prop_meta.auto_select_all) and not prop_meta.no_auto_select)
  local collapse_button = XTemplateSpawn("GedToolbarToggleButtonSmall", self.idLabelHost)
  collapse_button:SetId("idCollapseButton")
  collapse_button:SetIcon("CommonAssets/UI/Ged/collapse.tga")
  collapse_button:SetRolloverText("Expand / collapse")
  function collapse_button.OnPress(button)
    self.idEdit:SetVisible(not self.idEdit:GetVisible())
    button:SetToggled(not button:GetToggled())
  end
  local live_panel = XWindow:new({
    Id = "idLivePanel",
    Dock = "bottom",
    Padding = box(2, 2, 2, 2),
    FoldWhenHidden = true
  }, self)
  XText:new({
    Dock = "left",
    TextStyle = "GedHighlight",
    Padding = box(2, 2, 2, 2)
  }, live_panel):SetText("Changes not sent to the game yet")
  XTextButton:new({
    Dock = "right",
    Padding = box(2, 2, 2, 2),
    Padding = box(2, 0, 2, 0),
    BorderWidth = 1,
    VAlign = "center",
    LayoutMethod = "VList",
    OnPress = function()
      self:SendValueToGame()
    end
  }, live_panel):SetText("Send now (Ctrl-Enter)")
  live_panel:SetVisible(false)
end
function GedPropFunc:SendValueToGame()
  self:SetValueFromText("no_text_updates")
  if self.window_state == "destroying" then
    return
  end
  self.idLivePanel:SetVisible(false)
end
function GedPropFunc:Compile(code)
  local f, err = CompileFunc(self.prop_meta.id, self.prop_meta.params or "self", code)
  return err
end
function GedPropFunc:UpdateCodeEditorUI(line, msg)
  local edit = self.idEdit
  local plugin = edit:FindPluginOfKind("XCodeEditorPlugin")
  plugin:SetDimText(self:TextEqualTo(self.prop_meta.default))
  plugin:SetError(line, msg)
  edit:InvalidateMeasure()
  edit:Invalidate()
  local value = self:GetProp()
  self.idLivePanel:SetVisible(type(value) ~= "string" or not self:TextEqualTo(value))
end
function GedPropFunc:UpdateCompilationError(code)
  if self.window_state == "destroying" then
    return
  end
  local err = self:Compile(code)
  local src, line, msg
  if err then
    src, line, msg = err:match("^([^:]+):([^:]+):(.+)$")
    line = tonumber(line)
    local edit = self.idEdit
    if not edit:IsFocused() then
      edit:SetCursor(line, 0)
    end
  end
  self:UpdateCodeEditorUI(line, msg)
end
function GedPropFunc:ConvertFromText(code)
  code = code:match("^(.-)%s*$") or code
  self:UpdateCompilationError(code)
  return code
end
GedPropFunc.ConvertToText = GedPropFunc.ConvertFromText
function GedPropFunc:DetachForReuse()
  self.idEdit:SetPlugins(code_edit_plugin)
  GedPropText.DetachForReuse(self)
end
function GedPropFunc:UpdateValue(initial)
  local value = self:GetProp()
  if initial or type(value) ~= "string" or not self:TextEqualTo(value) then
    GedPropText.UpdateValue(self)
    self.idEdit:FindPluginOfKind("XCodeEditorPlugin"):SetDimText(self:TextEqualTo(self.prop_meta.default))
  end
  if value == "" or value == false or value == Undefined() or type(value) == "string" and not value:find("\n", 1, true) then
    self.idEdit:SetVisible(true)
    self.idCollapseButton:SetVisible(false)
    self.idCollapseButton:SetToggled(false)
  else
    self.idCollapseButton:SetVisible(true)
  end
end
DefineClass.ColorEditor = {
  __parents = {"XWindow"},
  properties = {
    {
      id = "CopyPaste",
      editor = "bool",
      default = true
    },
    {
      id = "Value",
      editor = "color",
      default = RGB(0, 0, 0)
    },
    {
      id = "ReadOnly",
      editor = "bool",
      default = false
    },
    {
      id = "Alpha",
      editor = "bool",
      default = true
    }
  },
  IdNode = true,
  picker = false,
  editor_id = false
}
function ColorEditor:OnColorChanged(color)
end
function ColorEditor:OnEditingDone()
end
function ColorEditor:SetValue(color, dont_notify)
  if self.window_state == "destroying" then
    return
  end
  color = color or 0
  if color == Undefined() then
    color = 0
    self.idColorText:SetText("<color 128 128 128>Undefined")
  else
    self.idColorText:SetText("")
  end
  if not self.Alpha then
    color = RGB(GetRGB(color))
  end
  self.idColor:SetBackground(color)
  if self.Value ~= color then
    self.Value = color
    if not dont_notify then
      self:OnColorChanged(color)
    end
  end
end
function ColorEditor:Init(parent, context, prop_meta)
  if self.CopyPaste then
    local paste_button = XTemplateSpawn("GedToolbarButtonSmall", self)
    paste_button:SetIcon("CommonAssets/UI/Ged/paste.tga")
    paste_button:SetDock("right")
    paste_button:SetRolloverText("Paste")
    function paste_button.OnPress(button)
      button:SetFocus()
      local value = self:ConvertFromText(GetFromClipboard(1024))
      if value then
        self:SetValue(value)
        self:OnColorChanged(value)
      end
      button:SetFocus(false)
    end
    paste_button.IconScale = point(500, 500)
    local copy_button = XTemplateSpawn("GedToolbarButtonSmall", self)
    copy_button:SetIcon("CommonAssets/UI/Ged/copy.tga")
    copy_button:SetDock("right")
    copy_button:SetRolloverText("Copy")
    function copy_button.OnPress(b)
      local color = self.Value
      CopyToClipboard(self:ConvertToText(color))
    end
    copy_button.IconScale = point(500, 500)
  end
  XWindow:new({
    Id = "idContainer",
    Padding = box(1, 1, 1, 1),
    BorderWidth = 1
  }, self)
  XFrame:new({
    Id = "idColorBox",
    BorderColor = RGB(0, 0, 0),
    Image = "CommonAssets/UI/checker-pattern-40.tga",
    IdNode = false,
    TileFrame = true,
    ImageScale = point(450, 450)
  }, self.idContainer)
  XWindow:new({
    Id = "idColor",
    IdNode = false,
    HandleMouse = true,
    OnMouseButtonUp = function(image, pt, button)
      if button == "L" then
        self:ToggleCombo()
      end
    end,
    OnMouseButtonDown = function(image, pt, button)
      if button == "L" then
        return "break"
      end
    end
  }, self.idColorBox)
  XText:new({
    Id = "idColorText",
    HandleMouse = false
  }, self.idColorBox)
  local combo_button = XComboButton:new({
    OnPress = function(button)
      button:SetFocus()
      self:ToggleCombo()
      button:SetFocus(false)
    end
  }, self.idContainer)
  if self.ReadOnly then
    combo_button:SetEnabled(not self.ReadOnly)
  end
  local active_popup = rawget(rawget(_G, "g_GedApp") or self.desktop, "idColorPicker")
  if active_popup and active_popup.owner_color_editor.editor_id == self.editor_id then
    active_popup.owner_color_editor = self
  end
end
function ColorEditor:ToggleCombo()
  if self:CloseColorPicker() then
    return
  end
  if self.ReadOnly then
    return
  end
  local popup = XPopup:new({
    Id = "idColorPicker",
    owner_color_editor = self,
    OnMouseButtonUp = function(self, pt, button)
      if button == "L" then
        if not self:MouseInWindow(pt) then
          self:Close()
        end
        return "break"
      elseif button == "R" then
        self:Close()
        return "break"
      end
    end,
    DrawOnTop = true
  }, rawget(_G, "g_GedApp") or self.desktop)
  self.picker = XColorPicker:new({
    OnColorChanged = function(picker, color)
      popup.owner_color_editor:SetValue(color)
    end,
    AdditionalComponent = self.Alpha and "alpha" or "none",
    RolloverMode = function()
      local prop_editor = popup.owner_color_editor.parent
      prop_editor.panel.app:Send("GedRpcColorPickerRollover", prop_editor.panel.context, prop_editor.prop_meta.id)
      popup.owner_color_editor:CloseColorPicker()
    end
  }, popup)
  function popup.Close(popup)
    self:SetValue(self.picker:GetColor())
    self:OnEditingDone()
    self.picker = false
    XPopup.Close(popup)
  end
  function popup:OnShortcut(shortcut, ...)
    if shortcut == "Escape" then
      self:Close()
      return "break"
    end
    return XPopup.OnShortcut(self, shortcut, ...)
  end
  self.picker:SetColor(self.Value)
  popup:SetAnchor(self.idContainer.box)
  popup:SetAnchorType("drop")
  popup:Open()
  popup:SetModal()
  popup:SetFocus()
  local prop_editor = popup.owner_color_editor.parent
  prop_editor.panel.app:UpdateChildrenDarkMode(popup)
end
function ColorEditor:CloseColorPicker()
  local popup = rawget(rawget(_G, "g_GedApp") or self.desktop, "idColorPicker")
  if popup then
    popup:Close()
    return true
  end
end
function ColorEditor:ConvertToText(value)
  local r, g, b, a = GetRGBA(value)
  return r .. ", " .. g .. ", " .. b .. ", " .. a
end
function ColorEditor:ConvertFromText(value)
  return ConvertColorFromText(value)
end
GedPropEditors.color = "GedPropColor"
DefineClass.GedPropColor = {
  __parents = {
    "GedPropEditor"
  }
}
function GedPropColor:Init(parent, context, prop_meta)
  local last_update = now()
  ColorEditor:new({
    Id = "idColorEditor",
    editor_id = prop_meta.id .. self.panel.context,
    OnColorChanged = function(editor, color)
      if now() - last_update >= 100 then
        self:SetProp(color)
        last_update = now()
      end
      self:DeleteThread("update_thread")
      self:CreateThread("update_thread", function()
        Sleep(100)
        self:SetProp(color)
      end)
    end,
    OnEditingDone = function(editor, color)
      self:DeleteThread("update_thread")
    end,
    Alpha = prop_meta.alpha,
    ReadOnly = prop_meta.read_only and true
  }, self)
end
function GedPropColor:ReassignFocusOrders(x, y)
  return y + 1
end
function GedPropColor:UpdateValue()
  self.idColorEditor:SetValue(self:GetProp(), "dont_notify")
  GedPropEditor.UpdateValue(self)
end
DefineClass.GedPropEditorWithSubeditors = {
  __parents = {
    "GedPropEditor"
  },
  editors = false,
  subeditor_container = false
}
function GedPropEditorWithSubeditors:Init(parent, context, prop_meta)
  self.subeditor_container = XWindow:new({
    LayoutMethod = "VList",
    Margins = box(0, 2, 0, 0),
    BorderWidth = 1,
    Padding = box(2, 2, 2, 2)
  }, self)
end
function GedPropEditorWithSubeditors:MakeSubEditor(parent, class, meta)
  parent = parent or self.subeditor_container
  local win = class:new({
    SetProp = function(win, value)
      value = value or meta.default
      win.subeditor_value = value
      self:TrySetProp()
    end,
    GetProp = function(win, new_focus)
      return win.subeditor_value
    end,
    panel = self.panel,
    subeditor_value = meta.default
  }, parent, nil, meta)
  self.editors = self.editors or {}
  table.insert(self.editors, win)
  return win
end
function GedPropEditorWithSubeditors:UpdateValue()
  for _, editor in ipairs(self.editors) do
    editor:UpdateValue()
  end
  GedPropEditor.UpdateValue(self)
end
function GedPropEditorWithSubeditors:UpdatePropertyNames(internal)
  for _, editor in ipairs(self.editors) do
    editor:UpdatePropertyNames(internal)
  end
  GedPropEditor.UpdatePropertyNames(self, internal)
end
GedPropEditors.rgbrm = "GedPropMaterial"
DefineClass.GedPropMaterial = {
  __parents = {
    "GedPropEditorWithSubeditors"
  },
  color_editor = false,
  roughness_editor = false,
  metallic_editor = false
}
function GedPropMaterial:Init(parent, context, prop_meta)
  self.idLabelHost:SetDock("top")
  local default = prop_meta.default
  local r, g, b, ro, m = GetRGBRM(default)
  self.color_editor = self:MakeSubEditor(false, GedPropColor, {
    editor = "color",
    alpha = false,
    id = "Color_" .. prop_meta.id,
    name = "Color",
    default = RGB(r, g, b),
    read_only = prop_meta.read_only
  })
  self.roughness_editor = self:MakeSubEditor(false, GedPropNumber, {
    max = 127,
    min = -128,
    slider = true,
    default = ro,
    id = "Roughness",
    editor = "number",
    read_only = prop_meta.read_only
  })
  self.metallic_editor = self:MakeSubEditor(false, GedPropNumber, {
    max = 127,
    min = -128,
    slider = true,
    default = m,
    id = "Metallic",
    editor = "number",
    read_only = prop_meta.read_only
  })
end
function GedPropMaterial:TrySetProp()
  local rgb, roughness, metallic = self.color_editor.subeditor_value, self.roughness_editor.subeditor_value, self.metallic_editor.subeditor_value
  if rgb == Undefined() then
    rgb = self.color_editor.prop_meta.default
  end
  if roughness == Undefined() then
    roughness = self.roughness_editor.prop_meta.default
  end
  if metallic == Undefined() then
    metallic = self.metallic_editor.prop_meta.default
  end
  local value = RGBRM(rgb, roughness, metallic)
  if value ~= self:GetProp() then
    self:SetProp(value)
  end
end
function GedPropMaterial:ReassignFocusOrders(x, y)
  return y + 3
end
function GedPropMaterial:UpdateValue()
  local value = self:GetProp()
  local rgb, roughness, metallic
  if value == Undefined() then
    rgb = value
    roughness = value
    metallic = value
  else
    rgb, roughness, metallic = GetRGBRM3(value)
  end
  self.color_editor.subeditor_value = rgb
  self.roughness_editor.subeditor_value = roughness
  self.metallic_editor.subeditor_value = metallic
  GedPropEditorWithSubeditors.UpdateValue(self)
end
GedPropEditors.range = "GedPropRange"
DefineClass.GedPropRange = {
  __parents = {
    "GedPropText"
  }
}
function GedPropRange:GetDisplayScale()
  local scale = self.prop_meta.scale
  if type(scale) == "string" then
    scale = const.Scale[scale]
  end
  return scale or 1
end
function GedPropRange:ConvertToText(value)
  if IsRange(value) then
    local display_scale = self:GetDisplayScale()
    return FormatNumberProp(value.from, display_scale) .. ", " .. FormatNumberProp(value.to, display_scale)
  end
  return ""
end
function GedPropRange:ConvertFromText(value)
  local from, to = value:match("^([^,]+),([^,]+)$")
  from, to = tonumber(from), tonumber(to)
  if from and to and from <= to then
    local display_scale = self:GetDisplayScale()
    from = floatfloor(from * display_scale + 0.5)
    to = floatfloor(to * display_scale + 0.5)
    local min = self.prop_meta.min
    local max = self.prop_meta.max
    local changed
    if min and from < min then
      from = min
      changed = true
    end
    if max and to > max then
      to = max
      changed = true
    end
    return range(from, to), nil, changed
  end
end
GedPropEditors.set = "GedPropSet"
DefineClass.GedPropSet = {
  __parents = {
    "GedPropEditor"
  }
}
function GedPropSet:Init()
  local win = XWindow:new({
    Dock = "box",
    Id = "idContainer",
    LayoutMethod = "HWrap",
    VAlign = "center"
  }, self)
  if self.prop_meta.horizontal then
    self.idLabelHost:SetDock("top")
    win:SetBorderWidth(1)
  end
end
function GedPropSet:GetItems()
  local items = self.prop_meta.items or empty_table
  if IsSet(items) or #items == 0 then
    items = table.keys(items, true)
  end
  return items
end
function GedPropSet:UpdateValue()
  self.idContainer:DeleteChildren()
  local item_keys = {}
  for _, item in ipairs(self:GetItems() or empty_table) do
    self:CreateButton(item)
    item_keys[type(item) == "table" and (item.value or item.id) or item] = true
  end
  for key in pairs(self:GetProp() or empty_table) do
    if not item_keys[key] then
      self:CreateButton(key, nil, "invalid_item")
    end
  end
  Msg("XWindowRecreated", self)
  GedPropEditor.UpdateValue(self)
end
local GetItemCount = function(prop)
  local count = 0
  for _, value in pairs(prop) do
    if value ~= nil then
      count = count + 1
    end
  end
  return count
end
local RemoveOneItem = function(prop)
  for idx, value in pairs(prop) do
    if value ~= nil then
      prop[idx] = nil
      return
    end
  end
end
function GedPropSet:CreateButton(item, parent, invalid_item)
  if type(item) ~= "table" then
    local str = item
    if type(item) ~= "string" and not IsT(item) then
      str = tostring(item)
    end
    item = {text = str, value = item}
  end
  local max_items_in_set = self.prop_meta.max_items_in_set or 0
  local button = XToggleButton:new({
    Text = item.text,
    Toggled = self:GetProp() and self:GetProp()[item.value] and true,
    ToggledBackground = RGB(204, 232, 255),
    RolloverBackground = RGBA(0, 0, 0, 0),
    RolloverAnchor = "live-mouse",
    RolloverTemplate = "GedPropRollover",
    Padding = self.prop_meta.horizontal and box(0, 2, 0, 2) or box(0, 0, 0, 0),
    AltPress = self.prop_meta.three_state,
    CalcBackground = function(button)
      if self.prop_meta.three_state then
        local value
        local prop = self:GetProp()
        if prop then
          value = prop[item.value]
        end
        if value == nil then
          return RGBA(0, 0, 0, 0)
        end
        local color
        if button.state == "mouse-in" or button:IsFocused() then
          color = value and RGB(0, 128, 0) or RGB(160, 0, 0)
        else
          color = value and RGB(0, 96, 0) or RGB(128, 0, 0)
        end
        return GetDarkModeSetting() and color or color + RGB(80, 80, 80)
      end
      return XToggleButton.CalcBackground(button)
    end,
    OnPress = function(button)
      if self.prop_meta.three_state then
        button:DoToggle(nil, true, false)
        return
      end
      XToggleButton.OnPress(button)
    end,
    OnAltPress = function(button)
      if self.prop_meta.three_state then
        button:DoToggle(nil, false)
        return
      end
      XToggleButton.OnAltPress(button)
    end,
    OnChange = function(button, toggle)
      button:DoToggle(nil, true)
    end,
    DoToggle = function(button, val1, val2, val3)
      button:SetFocus()
      local prop = table.copy(self:GetProp() or set())
      local value = prop[item.value]
      if value == val1 then
        value = val2
      elseif value == val2 then
        value = val3
      elseif val3 == nil or value == val3 then
        value = val1
      end
      if max_items_in_set ~= 0 and max_items_in_set == GetItemCount(prop) then
        RemoveOneItem(prop)
      end
      prop[item.value] = value
      self:SetProp(prop)
      button:Invalidate()
      button:SetFocus(false)
    end
  }, parent or self.idContainer)
  if invalid_item then
    XWindow:new({
      Background = RGB(255, 0, 0),
      Dock = "bottom",
      MinHeight = 2,
      MaxHeight = 2
    }, button)
  end
  button:SetEnabled(not self.prop_meta.read_only)
  if item.help then
    button:SetRolloverText(item.help)
  end
  return button
end
function GedPropSet:FindText(search_text, highlight_text)
  local found = false
  local buttons = get_children_of_classes(self, nil, "XToggleButton")
  for _, button in ipairs(buttons) do
    local label = button.idLabel
    label:HighlightText(highlight_text, XHighlightTextPlugin.HighlightColor, true)
    found = found or search_display_text(label.text, search_text)
  end
  return found or GedPropEditor.FindText(self, search_text, highlight_text)
end
GedPropEditors.image = "GedPropImage"
DefineClass.GedPropImage = {
  __parents = {
    "GedPropEditor"
  },
  comp_modifier = false
}
function GedPropImage:Init()
  XImage:new({
    Id = "idImage",
    ImageFit = (self.prop_meta.img_width or self.prop_meta.img_height) and "largest" or "smallest",
    HAlign = "center",
    DrawContent = function(img, clip_rect)
      self:DrawImageContent(clip_rect)
    end
  }, self)
  XLabel:new({Id = "idErrLabel", Dock = "ignore"}, self)
end
function GedPropImage:UpdateValue()
  local prop = self:GetProp()
  local file_exists = prop ~= Undefined() and prop and io.exists(prop)
  if not file_exists and type(prop) == "string" then
    prop = string.gsub(prop, "\\", "/")
    local width, height = UIL.MeasureImage(prop)
    if width and height and 0 < width and 0 < height then
      file_exists = true
    end
  end
  self.idImage:SetDock(not file_exists and "ignore")
  self.idImage:SetVisible(file_exists)
  self.idErrLabel:SetDock(file_exists and "ignore" or "right")
  self.idErrLabel:SetVisible(not file_exists)
  if file_exists then
    self.idImage:SetImage(prop)
    local meta = self.prop_meta
    if meta.img_size and type(meta.img_size) == "number" and 0 < meta.img_size or meta.img_width or meta.img_height then
      self.idImage.MaxWidth = meta.img_width or meta.img_size
      self.idImage.MaxHeight = meta.img_height or meta.img_size
    end
    if meta.img_box and 0 < meta.img_box then
      self.idImage.BorderWidth = meta.img_box
    end
    if meta.img_back then
      self.idImage.Background = meta.img_back
    end
  else
    self.idErrLabel:SetText(prop ~= Undefined() and "File not found " .. prop or "Undefined")
  end
  if self.comp_modifier then
    self.idImage:RemoveModifier(self.comp_modifier)
    self.comp_modifier = false
  end
  if self.prop_meta.img_draw_alpha_only then
    self.comp_modifier = self.idImage:AddShaderModifier({
      modifier_type = const.modShader,
      shader_flags = const.modImageCompAlpha
    })
  end
  self.idImage:SetBaseColorMap(self.prop_meta.base_color_map)
  GedPropEditor.UpdateValue(self)
end
function GedPropImage:DrawImageContent(clip_rect)
  XImage.DrawContent(self.idImage, clip_rect)
  local meta = self.prop_meta
  local color = meta.img_polyline_color
  local polylines = meta.img_polyline
  if polylines and color then
    local content_box = self.idImage.content_box
    local pt, sizex, sizey = content_box:min(), content_box:sizex(), content_box:sizey()
    for _, polyline in ipairs(polylines) do
      if type(polyline) ~= "table" then
        break
      end
      for i = 2, #polyline do
        local p1 = pt + point(polyline[i - 1]:x() * sizex, polyline[i - 1]:y() * sizey) / 4096
        local p2 = pt + point(polyline[i]:x() * sizex, polyline[i]:y() * sizey) / 4096
        UIL.DrawLine(p1, p2, color)
      end
    end
  end
end
local LimitIntToSize = function(value, size)
  local mask = 0
  for i = 1, size do
    mask = shift(mask, 1)
    mask = bor(mask, 1)
  end
  return band(value, mask)
end
local sort_flags = function(a, b)
  local a_noname = string.starts_with(a.name, "bit")
  local b_noname = string.starts_with(b.name, "bit")
  if a_noname and not b_noname then
    return false
  elseif not a_noname and b_noname then
    return true
  else
    return a.name < b.name
  end
end
GedPropEditors.flags = "GedPropFlags"
DefineClass.GedPropFlags = {
  __parents = {
    "GedPropEditor"
  }
}
function GedPropFlags:Init()
  XCheckButtonCombo:new({
    Id = "idCombo",
    Items = function(check_combo)
      return self:GetComboItems()
    end,
    Editable = not self.prop_meta.read_only,
    OnCheckButtonChanged = function(checkbox, id, value)
      local items = self:GetComboItems()
      local item_idx = table.find(items, "id", id)
      if not item_idx then
        return
      end
      local flag_bit = items[item_idx] and items[item_idx].flag_bit
      local flags = self:GetProp()
      if not value then
        flags = band(flags, bnot(shift(1, flag_bit - 1)))
      else
        flags = bor(flags, shift(1, flag_bit - 1))
      end
      self:SetProp(LimitIntToSize(flags, self.prop_meta.size))
      self:UpdateValue()
    end
  }, self)
end
function GedPropFlags:GetComboItems(flags, flag_names)
  local items = {}
  local flags = self:GetProp()
  local flag_names = self.prop_meta.items
  for i = 1, self.prop_meta.size do
    local name = flag_names[i]
    local read_only = false
    if type(name) == "table" then
      read_only = name.read_only
      name = name.name
    end
    name = name or "bit " .. i
    local value = band(flags, shift(1, i - 1)) ~= 0
    table.insert(items, {
      id = name,
      flag_bit = i,
      name = name,
      read_only = read_only or flags == Undefined() or self.prop_meta.read_only,
      value = value
    })
  end
  table.sort(items, sort_flags)
  return items
end
function GedPropFlags:UpdateValue()
  GedPropEditor.UpdateValue(self)
  local flags = self:GetProp()
  if flags == Undefined() then
    self.idCombo:SetText("Undefined")
    return
  end
  local items = self:GetComboItems(flags)
  local filtered_items = {}
  for idx = 1, self.prop_meta.size do
    if band(flags, shift(1, idx - 1)) ~= 0 then
      local item_idx = table.find(items, "flag_bit", idx)
      if item_idx then
        table.insert(filtered_items, items[item_idx].name)
      end
    end
  end
  table.sort(filtered_items)
  self.idCombo:SetText(string.format("0x%x", flags) .. " : " .. table.concat(filtered_items, " | "))
end
GedPropEditors.empty = "GedPropEmpty"
DefineClass.GedPropEmpty = {
  __parents = {
    "GedPropEditor"
  }
}
function GedPropEmpty:Init()
  XLabel:new({Id = "idLabel", Dock = "box"}, self):SetText("Undefined")
end
if FirstLoad then
  GridToUnload = {}
  GridPreviewIdx = 1
end
GedPropEditors.grid = "GedPropGrid"
DefineClass.GedPropGrid = {
  __parents = {
    "GedPropEditor"
  },
  grid = false,
  grid_img = "",
  grid_hash = false,
  grid_size = false,
  grid_offset = false,
  max_size = 0,
  color = false,
  invalid_value = false,
  dont_normalize = false
}
function GedPropGrid:Done()
  self:SetGridImage(false)
end
function GedPropGrid:Init()
  XLabel:new({Id = "idNoData", Dock = "box"}, self):SetText("No Grid Data")
  local image = XImage:new({
    Id = "idImage",
    Dock = "box",
    ImageFit = "stretch",
    VAlign = "center",
    HAlign = "left",
    HandleMouse = true,
    RolloverAnchor = "live-mouse",
    RolloverTemplate = "GedPropRollover",
    Measure = function(self, width, height)
      return UIL.MeasureImage(self.Image)
    end
  }, self)
  function image.OnMousePos(image, pt)
    XRecreateRolloverWindow(image)
  end
  function image.GetRolloverText(image)
    local grid = self.grid
    if not grid then
      return
    end
    local pt = terminal.GetMousePos()
    local box = image.content_box
    if not pt:InBox(box) then
      return ""
    end
    local rw, rh = self.grid_size:xy()
    local gw, gh = grid:size()
    local bw, bh = box:sizexyz()
    local bx, by = (pt - box:min()):xy()
    local gx = MulDivTrunc(gw, bx, bw)
    local gy = MulDivTrunc(gh, by, bh)
    local rx = MulDivTrunc(rw, bx, bw)
    local ry = MulDivTrunc(rh, by, bh)
    local scale = 1000
    local v = GridGet(grid, gx, gy, scale)
    local sign = v < 0 and "-" or ""
    v = abs(v)
    local a, b = v / scale, v % scale
    local bs
    if b < 1 then
      bs = ""
    elseif b < 10 then
      bs = ".00" .. b
    elseif b < 100 then
      bs = ".0" .. b
    else
      bs = "." .. b
    end
    return string.format("(%i, %i) %s%d%s", rx, ry, sign, a, bs)
  end
end
function GedPropGrid:SetGridImage(img)
  local frame = GetRenderFrame()
  for unload_img, unload_frame in pairs(GridToUnload) do
    if 5 < frame - unload_frame and UIL.IsImageReady(unload_img) then
      local err = AsyncFileDelete(unload_img)
      GridToUnload[unload_img] = nil
    end
  end
  img = img or ""
  local prev_img = self.grid_img or ""
  if prev_img ~= "" then
    UIL.UnloadImage(prev_img)
    GridToUnload[prev_img] = frame
  end
  self.idImage:SetImage(img)
  self.grid_img = img
end
function GedPropGrid:UpdateValue()
  local prop_value = self:GetProp()
  local grid_str, grid_w, grid_h
  if type(prop_value) == "table" then
    grid_str, grid_w, grid_h = table.unpack(prop_value)
  else
    grid_str = prop_value
  end
  local hasgrid = type(grid_str) == "string" and grid_str ~= ""
  self.idImage:SetDock(hasgrid and "box" or "ignore")
  self.idNoData:SetDock(hasgrid and "ignore" or "box")
  self.idImage:SetVisible(hasgrid)
  self.idNoData:SetVisible(not hasgrid)
  if not hasgrid then
    self.grid = false
    return
  end
  local update
  local grid = self.grid
  local force_read_grid
  local grid_offset = self.prop_meta.grid_offset or false
  if grid_offset ~= self.grid_offset then
    force_read_grid = true
    self.grid_offset = grid_offset
  end
  local grid_hash = xxhash(grid_str)
  if not grid or force_read_grid or grid_hash ~= self.grid_hash then
    update = true
    self.grid_hash = grid_hash
    grid = GridReadStr(grid_str)
    if not grid then
      self.grid = false
      return
    end
    grid = GridRepack(grid, "F")
    if grid_offset then
      GridAdd(grid, grid_offset)
    end
    self.grid = grid
  end
  self.grid_size = grid_w and grid_h and point(grid_w, grid_h) or point(grid:size())
  local color = self.prop_meta.color or false
  if color ~= self.color then
    update = true
    self.color = color
  end
  local invalid_value = self.prop_meta.invalid_value or false
  if invalid_value ~= self.invalid_value then
    update = true
    self.invalid_value = invalid_value
  end
  local dont_normalize = self.prop_meta.dont_normalize or false
  if dont_normalize ~= self.dont_normalize then
    update = true
    self.dont_normalize = dont_normalize
  end
  local min_size = self.prop_meta.min or 0
  local max_size = self.prop_meta.max or 512
  if self.max_size ~= max_size then
    update = true
    self.max_size = max_size
  end
  local w, h = grid:size()
  if update then
    local size = Max(w, h)
    if not color then
      while not (size < 2 * max_size) do
        w, h = w / 2, h / 2
        grid = GridResample(grid, w, h)
      end
    elseif max_size < size then
      grid = GridResample(grid, w * max_size / size, h * max_size / size, false)
    end
    GridPreviewIdx = GridPreviewIdx + 1
    local new_img = "memoryfs/grid_" .. GridPreviewIdx .. ".tga"
    local color_fmt = color and "color" or "gray24"
    local normalize = not dont_normalize
    local err = GridToImage(new_img, grid, color_fmt, invalid_value, normalize)
    if err then
      new_img = ""
    end
    self:SetGridImage(new_img)
  end
  local frame = self.prop_meta.frame or 0
  self.idImage.BorderWidth = frame
  self.idImage.BorderHeight = frame
  if 0 < min_size then
    local s = Min(w, h)
    self.idImage.MinWidth = min_size * w / s
    self.idImage.MinHeight = min_size * h / s
  end
  if min_size < max_size then
    local s = Max(w, h)
    self.idImage.MaxWidth = max_size * w / s
    self.idImage.MaxHeight = max_size * h / s
  end
  GedPropEditor.UpdateValue(self)
end
GedPropEditors.preset_id = "GedPropPresetId"
DefineClass.GedPropPresetId = {
  __parents = {
    "GedPropEditor"
  }
}
function GedPropPresetId:Init()
  local prop_meta = self.prop_meta
  local create_button, open_button
  if not prop_meta.read_only and self:ShouldShowButtonForFunc("GedOpPresetIdNewInstance") then
    create_button = XTemplateSpawn("GedToolbarButtonSmall", self)
    create_button:SetIcon("CommonAssets/UI/Ged/plus-one.tga")
    create_button:SetRolloverText(string.format("New %s", prop_meta.preset_class))
    function create_button.OnPress(button)
      button:SetFocus()
      self.panel.app:Op("GedOpPresetIdNewInstance", self.panel.context, prop_meta.id, prop_meta.preset_class)
      self.idCombo.Items = false
      button:SetFocus(false)
    end
  end
  if self:ShouldShowButtonForFunc("GedRpcEditPreset") then
    open_button = XTemplateSpawn("GedToolbarButtonSmall", self)
    open_button:SetIcon("CommonAssets/UI/Ged/explorer.tga")
    open_button:SetRolloverText("Open Preset Editor")
    function open_button.OnPress(button)
      button:SetFocus()
      self.panel.app:Send("GedRpcEditPreset", self.panel.context, prop_meta.id)
      button:SetFocus(false)
    end
  end
  XCombo:new({
    Id = "idCombo",
    Items = false,
    RefreshItemsOnOpen = true,
    DefaultValue = prop_meta.default or "",
    ArbitraryValue = false,
    OnValueChanged = function(combo, value)
      self:SetProp(value)
    end,
    OnRequestItems = function(combo)
      return self.panel.connection:Call("rfnGetPresetItems", self.panel.context, self.prop_meta.id)
    end,
    MRUStorageId = prop_meta.mru_storage_id,
    MRUCount = prop_meta.show_recent_items,
    VirtualItems = true
  }, self)
  self.idCombo:SetEnabled(not prop_meta.read_only)
  if prop_meta.editor_preview then
    GedTextPanel:new({
      Title = "",
      Dock = "bottom",
      ZOrder = -1,
      Format = prop_meta.editor_preview
    }, self):SetContext(prop_meta.id .. ".ReferencedPreset")
  end
  if not Platform.developer then
    if open_button then
      open_button:SetVisible(false)
      open_button:SetDock("ignore")
    end
    if create_button then
      create_button:SetVisible(false)
      create_button:SetDock("ignore")
    end
  end
end
function GedPropPresetId:UpdateValue()
  local combo = self.idCombo
  combo.Items = false
  if not (combo:IsFocused() and combo.ArbitraryValue) or combo:GetValue() == combo:GetText() then
    self.last_value = self:GetProp()
    combo:SetValue(self.last_value, true)
  end
  if self.prop_meta.editor_preview then
    self.panel.app:Send("GedRpcBindPreset", self.prop_meta.id .. ".ReferencedPreset", self.panel.context, self.prop_meta.id)
  end
  GedPropEditor.UpdateValue(self)
end
function GedPropPresetId:ReassignFocusOrders(x, y)
  self.idCombo:SetFocusOrder(point(x, y))
  return y + 1
end
function GedPropPresetId:DetachForReuse()
  self.idCombo:UpdateMRUList()
  GedPropEditor.DetachForReuse(self)
end
DefineClass.GedPropEmbeddedObject = {
  __parents = {
    "GedPropEditor"
  }
}
function GedPropEmbeddedObject:Init(parent, context, prop_meta)
  local create_button = XTemplateSpawn("GedToolbarButtonSmall", self)
  create_button:SetId("idCreateItemButton")
  create_button:SetIcon("CommonAssets/UI/Ged/new.tga")
  create_button:SetRolloverText("Create Item")
  create_button:SetEnabled(not prop_meta.read_only)
  local paste_button = XTemplateSpawn("GedToolbarButtonSmall", self)
  paste_button:SetId("idPasteButton")
  paste_button:SetIcon("CommonAssets/UI/Ged/paste.tga")
  paste_button:SetRolloverText("Paste")
  paste_button:SetEnabled(not prop_meta.read_only)
  local copy_button = XTemplateSpawn("GedToolbarButtonSmall", self)
  copy_button:SetId("idCopyButton")
  copy_button:SetIcon("CommonAssets/UI/Ged/copy.tga")
  copy_button:SetRolloverText("Copy")
  if self:HasMember("idButtonsHost") then
    self.idButtonsHost:SetDock("right")
    self.idButtonsHost:SetZOrder(-1)
  end
  if prop_meta.editor ~= "script" then
    XText:new({
      Id = "idValueText",
      VAlign = "center",
      MaxHeight = 24,
      HandleMouse = false
    }, self)
  end
end
function GedPropEmbeddedObject:ReassignFocusOrders(x, y)
  self.idCreateItemButton:SetFocusOrder(point(x, y))
  return y + 1
end
GedPropEditors.nested_obj = "GedPropNestedObj"
GedPropEditors.property_array = "GedPropNestedObj"
DefineClass.GedPropNestedObj = {
  __parents = {
    "GedPropEmbeddedObject",
    "GedPanelBase"
  }
}
function GedPropNestedObj:Init(parent, context, prop_meta)
  function self.idCreateItemButton.OnPress(button)
    if prop_meta.editor == "property_array" then
      if self.window_state == "destroying" then
        return
      end
      button:SetFocus()
      self.app:Op("GedCreateNestedObj", self.panel.context, self.prop_meta.id, "GedDynamicProps")
      self.idPropPanel.expanded = true
      button:SetFocus(false)
      return
    end
    CreateRealTimeThread(function()
      local items = self.app:Call("GedGetNestedClassItems", self.panel.context, self.prop_meta.id)
      local title = string.format("New %s object", prop_meta.base_class)
      GedOpenCreateItemPopup(self, title, items, button, function(class)
        if self.window_state == "destroying" then
          return
        end
        self.app:Op("GedCreateNestedObj", self.panel.context, self.prop_meta.id, class)
        self.idPropPanel.expanded = true
      end)
    end)
  end
  self.idCreateItemButton:SetFoldWhenHidden(true)
  function self.idCopyButton.OnPress(button)
    self.panel:SetFocus()
    self.app:Op("GedNestedObjCopy", self.panel.context, self.prop_meta.id, self.prop_meta.base_class)
  end
  function self.idPasteButton.OnPress(button)
    self.panel:SetFocus()
    self.app:Op("GedNestedObjPaste", self.panel.context, self.prop_meta.id, self.prop_meta.base_class)
  end
  GedPropPanel:new({
    Id = "idPropPanel",
    Dock = "bottom",
    ZOrder = -1,
    Margins = box(10, 0, 0, 0),
    FoldWhenHidden = true,
    Embedded = true,
    Collapsible = true,
    HideFirstCategory = true,
    RootObjectBindName = self.panel.RootObjectBindName,
    Title = prop_meta.editor == "property_array" and "<empty>" or prop_meta.format or "<EditorView>",
    ActionsClass = "PropertyObject",
    Copy = "GedOpPropertyCopy",
    Paste = "GedOpPropertyPaste",
    StartsExpanded = prop_meta.auto_expand or false,
    SuppressProps = prop_meta.suppress_props
  }, self)
end
function GedPropNestedObj:DetachForReuse()
  self:UnbindViews()
  GedPropEditor.DetachForReuse(self)
end
function GedPropNestedObj:OnContextUpdate(context, view)
  GedPanelBase.OnContextUpdate(self, context, view)
  if view == nil then
    self.idPropPanel:SetContext(self.context)
  end
end
function GedPropNestedObj:UpdateValue()
  local value = self:GetProp()
  self.idValueText:SetText(value == Undefined() and "(undefined)" or "")
  value = value ~= Undefined() and value
  self.idPropPanel:SetVisible(value)
  self.idCreateItemButton:SetVisible(not value)
  self.connection:BindObj(self.context, {
    self.panel.context,
    self.prop_meta.id
  })
  GedPropEditor.UpdateValue(self)
end
function GedPropNestedObj:ReassignFocusOrders(x, y)
  y = GedPropEmbeddedObject.ReassignFocusOrders(self, x, y)
  y = self.idPropPanel:ReassignFocusOrders(x, y)
  return y
end
function GedPropNestedObj:UpdatePropertyNames(internal)
  self.idPropPanel:UpdatePropertyNames(internal)
  GedPropEditor.UpdatePropertyNames(self, internal)
end
DefineClass.GedNestedPropPanel = {
  __parents = {
    "GedPropPanel",
    "XListItem"
  },
  SelectionBackground = RGB(255, 255, 255),
  Embedded = true,
  Collapsible = true,
  HideFirstCategory = true,
  expanded = false,
  prop_id = false,
  item_addr = false,
  list_context = false,
  parent_obj_context = false,
  selection_mark = false
}
GedNestedPropPanel.OnMouseButtonDown = XControl.OnMouseButtonDown
function GedNestedPropPanel:InitControls()
  GedPropPanel.InitControls(self)
  local read_only = GetParentOfKind(self, "GedPropNestedList").prop_meta.read_only
  if self:ShouldShowButtonForFunc("GedOpListDeleteItem") then
    local delete_button = XTemplateSpawn("GedToolbarButtonSmall", self.idTitleContainer)
    delete_button:SetIcon("CommonAssets/UI/Ged/delete.tga")
    delete_button:SetRolloverText("Delete")
    function delete_button.OnPress(button)
      local idx = table.find(self.parent, self)
      button:SetFocus()
      self.app:Op("GedOpListDeleteItem", self.list_context, idx)
      self.app:Send("GedNotifyPropertyChanged", self.parent_obj_context, self.prop_id)
      button:SetFocus(false)
    end
    delete_button:SetEnabled(not read_only)
  end
  if self:ShouldShowButtonForFunc("GedOpListDuplicate") then
    local duplicate_button = XTemplateSpawn("GedToolbarButtonSmall", self.idTitleContainer)
    duplicate_button:SetIcon("CommonAssets/UI/Ged/duplicate.tga")
    duplicate_button:SetRolloverText("Duplicate")
    function duplicate_button.OnPress(button)
      local idx = table.find(self.parent, self)
      button:SetFocus()
      self.app:Op("GedOpListDuplicate", self.list_context, {idx})
      self.app:Send("GedNotifyPropertyChanged", self.parent_obj_context, self.prop_id)
      GetParentOfKind(self, "GedPropNestedList").new_item_idx = idx + 1
      button:SetFocus(false)
    end
    duplicate_button:SetEnabled(not read_only)
  end
  self.selection_mark = XWindow:new({
    MinWidth = 3,
    Dock = "left",
    ZOrder = 0,
    HandleMouse = true
  }, self)
  local current_list = GetParentOfKind(self, "GedPropNestedList")
  local prop_panel = GetParentOfKind(self, "GedPropPanel")
  repeat
    prop_panel = GetParentOfKind(prop_panel.parent, "GedPropPanel")
  until prop_panel.class == "GedPropPanel"
  if not prop_panel:IsThreadRunning("NestedItemRolloverThread") then
    prop_panel:CreateThread("NestedItemRolloverThread", function(self)
      local last_rollover
      while true do
        local pt = terminal.GetMousePos()
        local list = GetParentOfKind(terminal.desktop:GetMouseTarget(pt), "GedPropNestedList")
        list = list and list.idList
        local rollover = list and list[list:GetItemAt(pt)]
        if rollover ~= last_rollover then
          if rollover and not rollover.selected then
            rollover.selection_mark:SetBackground(GetDarkModeSetting() and RGB(128, 128, 128) or RGB(180, 180, 180))
          end
          if last_rollover and not last_rollover.selected then
            last_rollover.selection_mark:SetBackground(0)
          end
          if last_rollover then
            last_rollover.RolloverTemplate = nil
            last_rollover.RolloverText = nil
            last_rollover.RolloverAnchor = nil
          end
          if rollover and list:GetSelection() and #list:GetSelection() == 1 and 1 < list:GetItemCount() then
            rollover.RolloverTemplate = "GedPropRollover"
            rollover.RolloverText = "Hold Ctrl or Shift to select multiple list elements."
            rollover.RolloverAnchor = "bottom"
          end
          last_rollover = rollover
        end
        Sleep(50)
      end
    end, prop_panel)
  end
  Msg("XWindowRecreated", self)
end
function GedNestedPropPanel:OnSetFocus()
  self.parent:SetSelection(table.find(self.parent, self))
end
function GedNestedPropPanel:CalcBackground()
  return XContextControl.CalcBackground(self)
end
function GedNestedPropPanel:SetSelected(selected)
  if self.selected ~= selected then
    self.selected = selected
    self.selection_mark:SetBackground(selected and (GetDarkModeSetting() and RGB(180, 180, 180) or RGB(128, 128, 128)) or 0)
    if selected then
      local current_list = GetParentOfKind(self, "GedPropNestedList")
      local prop_panel = GetParentOfKind(self, "GedPropPanel")
      repeat
        prop_panel = GetParentOfKind(prop_panel.parent, "GedPropPanel")
      until prop_panel.class == "GedPropPanel"
      for _, list in ipairs(get_children_of_classes(prop_panel, nil, "GedPropNestedList")) do
        if list ~= current_list then
          list.idList:SetSelection(false)
        end
      end
    end
  end
end
GedPropEditors.nested_list = "GedPropNestedList"
DefineClass.GedPropNestedList = {
  __parents = {
    "GedPropEmbeddedObject",
    "GedPanelBase"
  },
  Interactive = true,
  new_item_idx = false,
  last_move_items_time = 0,
  last_move_items_selection = empty_table,
  table_addr = false
}
function GedPropNestedList:OnMouseButtonDoubleClick(_, button)
  if button == "L" then
    local expanded = true
    for _, panel in ipairs(self.idList or empty_table) do
      expanded = expanded and panel.expanded
    end
    for _, panel in ipairs(self.idList or empty_table) do
      panel:Expand(not expanded)
    end
    return "break"
  end
end
function GedPropNestedList:Init(parent, context, prop_meta)
  function self.idCreateItemButton.OnPress(button)
    CreateRealTimeThread(function()
      local items = self.app:Call("GedGetNestedClassItems", self.panel.context, self.prop_meta.id)
      local title = string.format("New %s element", prop_meta.base_class)
      GedOpenCreateItemPopup(self, title, items, button, function(class)
        if self.window_state == "destroying" then
          return
        end
        local parent_context = self.panel.context
        self.app:Op("GedOpNestedListNewItem", parent_context, parent_context, prop_meta.id, self.idList:GetFocusedItem(), class)
        self.new_item_idx = (self.idList:GetFocusedItem() or #self.idList) + 1
        self:CollapseUnselected()
      end)
    end)
  end
  self.idCopyButton:SetRolloverText("Copy all")
  function self.idCopyButton.OnPress(button)
    self.panel:SetFocus()
    self.app:Op("GedNestedListCopy", self.context, self.prop_meta.base_class)
  end
  self.idPasteButton:SetRolloverText("Paste over")
  function self.idPasteButton.OnPress(button)
    self.panel:SetFocus()
    self.app:Op("GedNestedListPaste", self.panel.context, self.prop_meta.id, self.prop_meta.base_class)
  end
  local movedown_button = XTemplateSpawn("GedToolbarButtonSmall", self)
  movedown_button:SetId("idMoveDown")
  movedown_button:SetIcon("CommonAssets/UI/Ged/down.tga")
  movedown_button:SetRolloverText("Move item(s) down")
  function movedown_button.OnPress(button)
    local idx, sel = self.idList:GetFocusedItem(), self.idList:GetSelection()
    local last_time, last_sel = self.last_move_items_time, self.last_move_items_selection
    if idx then
      if GetPreciseTicks() > last_time + 350 or not table.iequal(last_sel, sel) then
        button:SetFocus()
        self:CollapseUnselected()
        self.app:Op("GedOpListMoveDown", context, sel)
        self.app:Send("GedNotifyPropertyChanged", self.panel.context, prop_meta.id)
        button:SetFocus(false)
        self.last_move_items_time, self.last_move_items_selection = GetPreciseTicks(), sel
      end
    else
      CreateMessageBox(nil, Untranslated("Info"), Untranslated("Please select the item(s) you would like to move."))
    end
  end
  movedown_button:SetEnabled(not prop_meta.read_only)
  movedown_button:SetVisibleInstant(false)
  local moveup_button = XTemplateSpawn("GedToolbarButtonSmall", self)
  moveup_button:SetId("idMoveUp")
  moveup_button:SetIcon("CommonAssets/UI/Ged/up.tga")
  moveup_button:SetRolloverText("Move item(s) up")
  function moveup_button.OnPress(button)
    local idx, sel = self.idList:GetFocusedItem(), self.idList:GetSelection()
    local last_time, last_sel = self.last_move_items_time, self.last_move_items_selection
    if idx then
      if GetPreciseTicks() > last_time + 350 or not table.iequal(last_sel, sel) then
        button:SetFocus()
        self:CollapseUnselected()
        self.app:Op("GedOpListMoveUp", context, sel)
        self.app:Send("GedNotifyPropertyChanged", self.panel.context, prop_meta.id)
        button:SetFocus(false)
        self.last_move_items_time, self.last_move_items_selection = GetPreciseTicks(), sel
      end
    else
      CreateMessageBox(nil, Untranslated("Info"), Untranslated("Please select the item(s) you would like to move."))
    end
  end
  moveup_button:SetEnabled(not prop_meta.read_only)
  moveup_button:SetVisibleInstant(false)
  XList:new({
    Id = "idList",
    Dock = "bottom",
    ZOrder = -1,
    Margins = box(10, 0, 2, 0),
    BorderWidth = 0,
    FoldWhenHidden = true,
    Visible = false,
    MultipleSelection = true
  }, self)
  function self.idList.OnShortcut(list, shortcut, source, ...)
    if shortcut == "Ctrl-C" then
      self.app:Op("GedOpListCopy", self.context, list:GetSelection(), prop_meta.base_class)
      return "break"
    elseif shortcut == "Ctrl-X" then
      self.app:Op("GedOpListCut", self.context, list:GetSelection(), prop_meta.base_class)
      return "break"
    elseif shortcut == "Ctrl-V" then
      self.app:Op("GedOpListPaste", self.context, list:GetSelection(), prop_meta.base_class)
      return "break"
    end
  end
  function self.idList.OnSelection(list, selected)
    self.idMoveUp:SetVisibleInstant(selected)
    self.idMoveDown:SetVisibleInstant(selected)
  end
end
function GedPropNestedList:DetachForReuse()
  self:UnbindViews()
  for _, prop_panel in ipairs(self.idList) do
    prop_panel:UnbindViews()
  end
  self.idList:Clear()
  self.table_addr = false
  GedPropEditor.DetachForReuse(self)
end
function GedPropNestedList:CollapseUnselected()
  local list = self.idList
  for i, win in pairs(list) do
    if IsKindOf(win, "GedNestedPropPanel") and not win.selected and win.context then
      win:Expand(false)
    end
  end
end
function GedPropNestedList:GetSelection()
  local selection = self.idList:GetSelection()
  if not selection then
    return
  end
  return selection[1], selection
end
function GedPropNestedList:SetSelection(selection, multiple_selection)
  self.idList:SetSelection(multiple_selection or selection)
end
function GedPropNestedList:ReassignFocusOrders(x, y)
  y = GedPropEmbeddedObject.ReassignFocusOrders(self, x, y)
  for _, prop_panel in ipairs(self.idList) do
    y = prop_panel:ReassignFocusOrders(x, y)
  end
  return y
end
function GedPropNestedList:UpdateValue()
  GedPropEmbeddedObject.UpdateValue(self)
  local item_data = self:GetProp()
  local prop_meta = self.prop_meta
  local list = self.idList
  if item_data == Undefined() then
    list:Clear()
    self.idValueText:SetText("(undefined)")
    return
  end
  if (item_data and item_data.table_addr or false) ~= self.table_addr then
    self.connection:BindObj(self.context, {
      self.panel.context,
      prop_meta.id
    })
    self.table_addr = item_data.table_addr
  end
  local old_panels = {}
  local old_sel = table.map(list:GetSelection(), function(idx)
    return list[idx].item_addr
  end)
  for i = #list, 1, -1 do
    local win = list[i]
    if not win.Dock or win.Dock == "ignore" then
      table.insert(old_panels, win)
      win:SetFocused(false)
      win:SetSelected(false)
      win:SetParent(false)
    end
  end
  local binding_map = {}
  for idx, addr in ipairs(item_data) do
    local item_context = self.context .. "." .. addr
    local panel = table.find_value(old_panels, "item_addr", addr)
    if panel then
      table.remove_value(old_panels, panel)
      panel:SetParent(list)
    else
      local panel = GedNestedPropPanel:new({
        Title = prop_meta.format or "<EditorView>",
        RootObjectBindName = self.panel.RootObjectBindName,
        StartsExpanded = prop_meta.auto_expand or self.new_item_idx and idx == self.new_item_idx,
        prop_id = prop_meta.id,
        item_addr = addr,
        list_context = self.context,
        parent_obj_context = self.panel.context
      }, self.idList, item_context)
      panel:Open()
      self.connection:BindObj(item_context, {
        self.panel.context,
        prop_meta.id,
        idx
      })
    end
  end
  for _, panel in ipairs(old_panels) do
    panel:delete()
  end
  list:SetVisible(0 < #item_data)
  if self.new_item_idx then
    list:SetFocus(true)
    list:SetSelection(self.new_item_idx)
    self.new_item_idx = false
  else
    local sel = {}
    for _, addr in ipairs(old_sel) do
      local new_idx = table.findfirst(list, function(idx, item)
        return item.item_addr == addr
      end)
      if new_idx then
        table.insert(sel, new_idx)
      end
    end
    list:SetSelection(sel)
  end
  self:QueueReassignFocusOrders()
  self.idValueText:SetText(string.format("(%d objects)", #item_data))
end
function GedPropNestedList:UpdatePropertyNames(internal)
  for _, prop_panel in ipairs(self.idList) do
    prop_panel:UpdatePropertyNames(internal)
  end
  GedPropEditor.UpdatePropertyNames(self, internal)
end
GedPropEditors.linked_presets = "GedPropLinkedPresets"
DefineClass.GedPropLinkedPresets = {
  __parents = {
    "GedPropHelp"
  },
  LayoutMethod = "VList"
}
function GedPropLinkedPresets:CalcBackground()
  local base = GetDarkModeSetting() and RGB(32, 32, 32) or RGB(240, 240, 240)
  return InterpolateRGB(base, TextStyles.GedHighlight.TextColor, 1, 3)
end
function GedPropLinkedPresets:UpdateValue(initial)
  if not initial then
    return
  end
  local prop_meta = self.prop_meta
  for _, class in ipairs(prop_meta.preset_classes) do
    local suppress_props = {}
    for prop, value in pairs(prop_meta.suppress_props) do
      suppress_props[prop] = suppress_props[prop] or value == true
    end
    for prop, value in pairs(prop_meta.suppress_props[class]) do
      suppress_props[prop] = suppress_props[prop] or value == true
    end
    local panel_context = self.panel.context .. "." .. class
    local panel = GedPropPanel:new({
      preset_class = class,
      FoldWhenHidden = true,
      Embedded = true,
      Collapsible = true,
      HideFirstCategory = true,
      RootObjectBindName = self.panel.RootObjectBindName,
      Title = "<style GedHighlight>" .. class,
      ActionsClass = "PropertyObject",
      Copy = "GedOpPropertyCopy",
      Paste = "GedOpPropertyPaste",
      SuppressProps = suppress_props
    }, self, panel_context)
    panel:SetVisible(false)
    panel:Open()
    if self:ShouldShowButtonForFunc("GedRpcEditPreset") then
      local open_button = XTemplateSpawn("GedToolbarButtonSmall", panel.idTitleContainer)
      open_button:SetIcon("CommonAssets/UI/Ged/explorer.tga")
      open_button:SetRolloverText("Open Preset Editor")
      function open_button.OnPress(button)
        button:SetFocus()
        panel.app:Send("GedRpcEditPreset", panel.context)
        button:SetFocus(false)
      end
      open_button:Open()
    end
    self.panel.app:Call("GedRpcBindLinkedPreset", panel_context, self.panel.context, class)
  end
end
function GedPropLinkedPresets:DetachForReuse()
  for i = #self, 1, -1 do
    local win = self[i]
    if IsKindOf(win, "GedPropPanel") then
      win:UnbindViews()
      win:delete()
    end
  end
  GedPropHelp.DetachForReuse(self)
end
local ItemText = function(item)
  if type(item) == "table" then
    return item.name or item.text or item.id
  end
  return tostring(item)
end
local ItemId = function(item)
  if type(item) == "table" then
    return item.id or item.value ~= nil and item.value
  end
  return item
end
DefineClass.GedPropPrimitiveList = {
  __parents = {
    "GedPropEditor"
  },
  Translate = false,
  list_values = false,
  new_item_default = false,
  choice_items = false,
  choice_items_status = false,
  choice_items_fetch_time = false
}
function GedPropPrimitiveList:Init(parent, context, prop_meta)
  self.idLabelHost:SetDock("top")
  local add_button = XTemplateSpawn("GedToolbarButtonSmall", self.idLabelHost)
  add_button:SetIcon("CommonAssets/UI/Ged/new.tga")
  add_button:SetRolloverText("Add new")
  add_button:SetId("idNewElement")
  add_button:SetEnabled(not prop_meta.read_only)
  function add_button.OnPress(button)
    local focus = terminal.desktop.keyboard_focus
    button:SetFocus()
    if focus and focus ~= self.idContainer and focus:IsWithin(self.idContainer) then
      while focus.parent ~= self.idContainer do
        focus = focus.parent
      end
      self:NewElement(table.find(self.idContainer, focus))
      button:SetFocus(false)
      return
    end
    self:NewElement(table.max(self.idContainer:GetSelection()))
    button:SetFocus(false)
  end
  local move_down = XTemplateSpawn("GedToolbarButtonSmall", self.idLabelHost)
  move_down:SetIcon("CommonAssets/UI/Ged/down.tga")
  move_down:SetRolloverText([[
Move down
(select an item first)]])
  move_down:SetId("idDown")
  move_down:SetEnabled(false)
  function move_down.OnPress(button)
    local sel = table.copy(self.idContainer:GetSelection())
    local values = table.copy(self.list_values)
    local focus
    for i = #values - 1, 1, -1 do
      local idx = table.find(sel, i)
      if idx and not table.find(sel, i + 1) then
        values[i], values[i + 1] = values[i + 1], values[i]
        sel[idx] = i + 1
        if self.idContainer[i]:IsFocused(true) then
          self.idContainer[i]:SetFocus(false)
          focus = i + 1
        end
      end
    end
    self.list_values = values
    self:SetProp(values)
    self:UpdateControls()
    if focus then
      self.idContainer[focus][1]:SetFocus()
    end
    self.idContainer:SetSelection(sel)
  end
  local move_up = XTemplateSpawn("GedToolbarButtonSmall", self.idLabelHost)
  move_up:SetIcon("CommonAssets/UI/Ged/up.tga")
  move_up:SetRolloverText([[
Move up
(select an item first)]])
  move_up:SetId("idUp")
  move_up:SetEnabled(false)
  function move_up.OnPress(button)
    local sel = table.copy(self.idContainer:GetSelection())
    local values = table.copy(self.list_values)
    local focus
    for i = 2, #values do
      local idx = table.find(sel, i)
      if idx and not table.find(sel, i - 1) then
        values[i], values[i - 1] = values[i - 1], values[i]
        sel[idx] = i - 1
        if self.idContainer[i]:IsFocused(true) then
          self.idContainer[i]:SetFocus(false)
          focus = i - 1
        end
      end
    end
    self.list_values = values
    self:SetProp(values)
    self:UpdateControls()
    if focus then
      self.idContainer[focus][1]:SetFocus()
    end
    self.idContainer:SetSelection(sel)
  end
  XList:new({
    Id = "idContainer",
    Dock = "bottom",
    BorderWidth = 0,
    MultipleSelection = true,
    OnSelection = function(list, focused_item, selection)
      self.idUp:SetEnabled(next(selection) and not prop_meta.read_only)
      self.idDown:SetEnabled(next(selection) and not prop_meta.read_only)
    end
  }, self)
  self:WithItems(function(items)
    self:ValidatePropMetaAndInitDefault()
  end)
end
function GedPropPrimitiveList:DetachForReuse()
  self.idContainer:SetSelection(false)
  for _, item in ipairs(self.idContainer) do
    if rawget(item, "idCombo") then
      item.idCombo:UpdateMRUList()
    end
  end
  GedPropEditor.DetachForReuse(self)
end
function GedPropPrimitiveList:WithItems(f)
  if self.choice_items_status == "fetched" then
    f(self.choice_items)
  else
    CreateRealTimeThread(function()
      self:WaitForItems()
      if self.window_state ~= "destroying" then
        f(self.choice_items)
      end
    end)
  end
end
function GedPropPrimitiveList:WaitForItems()
  if self.choice_items_status == false or self.choice_items_status == "fetched" and self.choice_items_fetch_time ~= RealTime() then
    self.choice_items_status = {}
    CreateRealTimeThread(function()
      local old_status = self.choice_items_status
      repeat
        self.choice_items = self:GetChoiceItems()
      until self.choice_items ~= "timeout"
      self.choice_items_status = "fetched"
      self.choice_items_fetch_time = RealTime()
      for _, thread in ipairs(old_status) do
        Wakeup(thread)
      end
    end)
  else
    if self.choice_items_status == "fetched" then
      return self.choice_items
    else
    end
  end
  table.insert(self.choice_items_status, CurrentThread())
  WaitWakeup()
  return self.choice_items
end
function GedPropPrimitiveList:ReassignFocusOrders(x, y)
  self.idUp:SetFocusOrder(point(x, y))
  y = y + 1
  self.idDown:SetFocusOrder(point(x, y))
  y = y + 1
  self.idNewElement:SetFocusOrder(point(x, y))
  y = y + 1
  local container = self.idContainer
  for _, edit in ipairs(container) do
    edit:SetFocusOrder(point(x, y))
    y = y + 1
  end
  return y
end
function GedPropPrimitiveList:ValidatePropMetaAndInitDefault()
  self:SetPropResult("")
  local choice_items = self.choice_items
  if choice_items then
    for _, item in ipairs(choice_items) do
      self:CheckUpdateError(self:ValidateValue(item.value), "'items' contains invalid entries.")
    end
  end
  local item_default = self.prop_meta.item_default or self:DefaultValue()
  if item_default and choice_items then
    local value_default = choice_items and choice_items[1] and choice_items[1].value or item_default
    self.new_item_default = value_default
  else
    self.new_item_default = item_default
  end
  self:CheckUpdateError(self:ValidateValue(self.new_item_default), "Invalid 'item_default'")
end
function GedPropPrimitiveList:ValidateWeights()
  if #self.list_values == 0 then
    return true
  end
  local weight_sum = 0
  for _, item in ipairs(self.list_values) do
    local _, weight = self:ResolveItem(item)
    if weight then
      weight_sum = weight_sum + weight
    end
  end
  return 0 < weight_sum
end
function GedPropPrimitiveList:CheckWeightsError()
  if self.prop_meta and self.prop_meta.weights then
    self:CheckUpdateError(self:ValidateWeights(), "The sum of all weights has to be more than zero")
  end
end
function GedPropPrimitiveList:CheckUpdateError(expr, err)
  if not expr then
    self:SetPropResult(err)
  end
end
function GedPropPrimitiveList:NewElement(idx, copy_item_value)
  local max_items = self.prop_meta.max_items or -1
  if max_items ~= -1 and max_items <= #self.list_values then
    return self:SetPropResult("Can not add more than " .. tostring(max_items) .. " items to the list.")
  end
  self:WithItems(function()
    local list_values = self.list_values or {}
    local new_item_value = copy_item_value and list_values[idx] or self.new_item_default
    idx = (idx or #list_values) + 1
    local new_item = self:WrapValue(new_item_value)
    table.insert(list_values, idx, new_item)
    self.list_values = list_values
    self:UpdateControls()
    local last = self.idContainer[idx]
    if last then
      last:SetFocus()
    end
    self:SetProp(list_values)
    self.idContainer:SetSelection(false)
  end)
end
function GedPropPrimitiveList:RemoveElement(idx)
  if self:IsFocused(true) then
  end
  local list_values = self.list_values or {}
  if idx <= #list_values then
    table.remove(list_values, idx)
    local container = self.idContainer
    container[idx]:delete()
    self:UpdateControls()
    self:SetProp(list_values)
  end
  local max_items = self.prop_meta.max_items or -1
  if max_items ~= -1 and max_items >= #self.list_values then
    self:SetPropResult()
  end
end
function GedPropPrimitiveList:ResolveItem(item)
  local prop_meta = self.prop_meta or empty_table
  if not item or not prop_meta.weights then
    return item
  end
  local value_key = prop_meta.value_key or "value"
  local weight_key = prop_meta.weight_key or "weight"
  return item[value_key], item[weight_key]
end
function GedPropPrimitiveList:SetElement(idx, value)
  local list_values = self.list_values or {}
  local old_value, old_weight = self:ResolveItem(list_values[idx])
  local new_value, new_weight = self:ResolveItem(value)
  local has_changed = old_value ~= new_value or old_weight ~= new_weight
  if idx and has_changed then
    list_values[idx] = value
    self.list_values = list_values
    self:SetProp(list_values)
    self:OnListItemValueChanged(idx)
  end
end
function GedPropPrimitiveList:GetChoiceItems()
  local items = self.prop_meta.items
  if not items or #items <= 0 then
    return false
  end
  local t = {}
  for key, value in ipairs(items) do
    if type(value) == "table" then
      table.insert(t, {
        text = ItemText(value),
        value = ItemId(value)
      })
    else
      table.insert(t, {
        text = self:ConvertToText(value),
        value = value
      })
    end
  end
  return t
end
function GedPropPrimitiveList:WrapValue(value, weight)
  local prop_meta = self.prop_meta or empty_table
  if not prop_meta.weights then
    return value
  end
  local value_key = prop_meta.value_key or "value"
  local weight_key = prop_meta.weight_key or "weight"
  return {
    [value_key] = value,
    [weight_key] = weight or self:DefaultWeightValue()
  }
end
function GedPropPrimitiveList:UpdateItem(container, item, value, weight_ctrl)
  self:SetElement(table.find(container, item), self:WrapValue(value, weight_ctrl and weight_ctrl:GetNumber()))
end
function GedPropPrimitiveList:CreateItemEditor(container, choice_items, idx)
  local item = XListItem:new({
    BorderWidth = 0,
    Padding = box(21, 2, 2, 2),
    SelectionBackground = RGB(204, 232, 255),
    SetFocus = function(item, focus)
      if item.idEdit then
        return item.idEdit:SetFocus(focus)
      elseif item.idCombo then
        return item.idCombo:SetFocus(focus)
      end
      return XWindow.SetFocus(item, focus)
    end,
    SetValue = function(item, value)
      local actual_value, weight = self:ResolveItem(value)
      if weight and item.idWeightEdit then
        item.idWeightEdit:SetNumber(weight)
      end
      if item.idEdit then
        item.idEdit:SetText(self:ConvertToText(actual_value))
      elseif item.idCombo then
        item.idCombo:SetValue(actual_value)
      end
      self:OnListItemValueChanged(idx)
    end,
    SetFocusOrder = function(item, order)
      if item.idEdit then
        item.idEdit:SetFocusOrder(order)
      elseif item.idCombo then
        item.idCombo:SetFocusOrder(order)
      end
    end,
    idEdit = false,
    idCombo = false,
    IdNode = true,
    idWeightEdit = false
  }, container)
  local control, weight_control
  if self.prop_meta.weights then
    local weight_label = XText:new({
      Id = "idWeightLabel",
      Dock = "right",
      MinWidth = 50,
      ZOrder = 3,
      Margins = box(5, 0, 0, 0)
    }, item):SetText("Weight:")
    weight_control = XNumberEdit:new({
      Id = "idWeightEdit",
      MinWidth = 40,
      Dock = "right",
      ZOrder = 2,
      Margins = box(2, 0, 2, 0)
    }, item)
    weight_control:SetEnabled(not self.prop_meta.read_only)
    function weight_control.OnTextChanged(weight_edit)
      self:DeleteThread("SetElementWeightThread")
      self:CreateThread("SetElementWeightThread", function()
        Sleep(250)
        local value = (not item.idEdit or not self:ConvertFromText(item.idEdit:GetText())) and item.idCombo and item.idCombo:GetValue()
        self:UpdateItem(container, item, value, weight_edit)
      end)
    end
  end
  if choice_items then
    control = XCombo:new({
      Id = "idCombo",
      RefreshItemsOnOpen = true,
      OnRequestItems = function()
        return self:WaitForItems()
      end,
      DefaultValue = self.new_item_default,
      ArbitraryValue = self.prop_meta.arbitraty_value,
      OnValueChanged = function(combo, value)
        self:UpdateItem(container, item, value, weight_control)
      end,
      MRUStorageId = self.prop_meta.mru_storage_id,
      MRUCount = self.prop_meta.show_recent_items,
      VirtualItems = true
    }, item)
    control:SetEnabled(not self.prop_meta.read_only)
    function control.OnSetFocus(control)
      container:SetSelection(idx)
      XCombo.OnSetFocus(control)
    end
  else
    control = self:CreateTextEditControl(item)
    control:SetEnabled(not self.prop_meta.read_only)
    function control.OnTextChanged(edit)
      self:DeleteThread("SetElementThread")
      self:CreateThread("SetElementThread", function()
        Sleep(250)
        local value = self:ConvertFromText(edit:GetText())
        self:UpdateItem(container, item, value, weight_control)
      end)
    end
    function control.OnKillFocus(edit, new_focus)
      local value = self:ConvertFromText(edit:GetText())
      self:UpdateItem(container, item, value, weight_control)
      return XTextEditor.OnKillFocus(edit, new_focus)
    end
    function control.OnSetFocus(control)
      container:SetSelection(idx)
      XTextEditor.OnSetFocus(control)
    end
  end
  self:CreateAdditionalButtons(item, table.find(container, item))
  local delete_button = XTemplateSpawn("GedToolbarButtonSmall", item)
  delete_button:SetIcon("CommonAssets/UI/Ged/delete.tga")
  delete_button:SetRolloverText("Delete")
  function delete_button.OnPress(button)
    button:SetFocus()
    self:RemoveElement(table.find(container, item))
    button:SetFocus(false)
  end
  delete_button:SetEnabled(not self.prop_meta.read_only)
  local duplicate_button = XTemplateSpawn("GedToolbarButtonSmall", item)
  duplicate_button:SetIcon("CommonAssets/UI/Ged/duplicate.tga")
  duplicate_button:SetRolloverText("Duplicate")
  function duplicate_button.OnPress(button)
    button:SetFocus()
    self:NewElement(table.find(container, item), "copy_item_value")
    button:SetFocus(false)
  end
  duplicate_button:SetEnabled(not self.prop_meta.read_only)
  if self.prop_meta.per_item_buttons then
    self:SpawnCustomButtons(container, item, idx)
  end
  item:Open()
end
function GedPropPrimitiveList:SpawnCustomButtons(container, item, idx)
  for _, button_props in ipairs(self.prop_meta.per_item_buttons) do
    local custom_button = XTemplateSpawn("GedToolbarButtonSmall", item)
    custom_button:SetIcon(button_props.icon)
    custom_button:SetRolloverText(button_props.name)
    function custom_button.OnPress(button)
      button:SetFocus()
      if button_props.func then
        self.panel:Op("GedPropEditorButton", self.panel.context, self.panel.RootObjectBindName or "root", self.prop_meta.id, button_props.name, button_props.func, button_props.param, idx)
      end
      button:SetFocus(false)
    end
    custom_button:SetEnabled(not self.prop_meta.read_only)
  end
end
function GedPropPrimitiveList:OnListItemValueChanged(idx)
  self:CheckWeightsError()
end
function GedPropPrimitiveList:CreateTextEditControl(parent)
  return XEdit:new({Id = "idEdit"}, parent)
end
function GedPropPrimitiveList:CreateAdditionalButtons(parent, idx)
end
function GedPropPrimitiveList:UpdateControls()
  local list_values = self.list_values
  local container = self.idContainer
  if #list_values ~= #container then
    self:QueueReassignFocusOrders()
  end
  while #list_values < #container do
    container[#list_values + 1]:delete()
  end
  local choice_items = self.choice_items
  while #list_values > #container do
    self:CreateItemEditor(container, choice_items, #container + 1)
  end
  for idx, item in ipairs(container) do
    item:SetValue(list_values[idx])
  end
  self:CheckWeightsError()
  Msg("XWindowRecreated", self)
end
function GedPropPrimitiveList:UpdateValue()
  local data = self:GetProp() or {}
  local focus = terminal.desktop.keyboard_focus
  if not (focus and focus:IsWithin(self)) or #data ~= #(self.list_values or empty_table) then
    self.list_values = type(data) == "table" and table.copy(data) or {}
    self:WithItems(function()
      self:UpdateControls()
    end)
  end
  GedPropEditor.UpdateValue(self)
end
function GedPropPrimitiveList:ConvertFromText(text)
  return text
end
function GedPropPrimitiveList:ConvertToText(value)
  return value
end
function GedPropPrimitiveList:DefaultValue()
  return false
end
function GedPropPrimitiveList:DefaultWeightValue()
  return self.prop_meta.weight_default or 100
end
function GedPropPrimitiveList:ValidateValue(value)
  return true
end
GedPropEditors.preset_id_list = "GedPropPresetIdList"
DefineClass.GedPropPresetIdList = {
  __parents = {
    "GedPropPrimitiveList"
  }
}
function GedPropPresetIdList:GetChoiceItems()
  return self.panel.connection:Call("rfnGetPresetItems", self.panel.context, self.prop_meta.id)
end
function GedPropPresetIdList:CreateAdditionalButtons(parent, idx)
  if self:ShouldShowButtonForFunc("GedRpcEditPreset") then
    local open_button = XTemplateSpawn("GedToolbarButtonSmall", parent)
    open_button:SetIcon("CommonAssets/UI/Ged/explorer.tga")
    open_button:SetRolloverText("Open Preset Editor", self.prop_meta.preset_class)
    function open_button.OnPress(button)
      button:SetFocus()
      self.panel.app:Send("GedRpcEditPreset", self.panel.context, self.prop_meta.id, self.list_values[idx])
      button:SetFocus(false)
    end
  end
  if self.prop_meta.editor_preview then
    GedTextPanel:new({
      Title = "",
      Dock = "bottom",
      ZOrder = -1,
      Format = self.prop_meta.editor_preview,
      Shorten = true,
      MaxHeight = 50
    }, parent):SetContext(self.prop_meta.id .. ".ReferencedPreset" .. tostring(idx))
  end
end
function GedPropPresetIdList:OnListItemValueChanged(idx)
  GedPropPrimitiveList:OnListItemValueChanged(idx)
  if self.prop_meta.editor_preview then
    self.panel.app:Send("GedRpcBindPreset", self.prop_meta.id .. ".ReferencedPreset" .. tostring(idx), self.panel.context, self.prop_meta.id, self.list_values[idx])
  end
end
GedPropEditors.number_list = "GedPropNumberList"
DefineClass.GedPropNumberList = {
  __parents = {
    "GedPropPrimitiveList"
  }
}
function GedPropNumberList:ConvertFromText(text)
  return tonumber(text) or 0
end
function GedPropNumberList:ConvertToText(value)
  if type(value) ~= "number" then
    return ""
  end
  return tostring(value)
end
function GedPropNumberList:DefaultValue()
  return 0
end
function GedPropNumberList:ValidateValue(value)
  return type(value) == "number"
end
GedPropEditors.string_list = "GedPropStringList"
DefineClass.GedPropStringList = {
  __parents = {
    "GedPropPrimitiveList"
  }
}
function GedPropStringList:DefaultValue()
  return ""
end
function GedPropStringList:ValidateValue(value)
  return type(value) == "string"
end
GedPropEditors.T_list = "GedPropTList"
DefineClass.GedPropTList = {
  __parents = {
    "GedPropPrimitiveList"
  }
}
function GedPropTList:Init(parent, context, prop_meta)
end
function GedPropTList:DefaultValue()
  return ""
end
function GedPropTList:ValidateValue(value)
  return type(value) == "string"
end
function GedPropTList:CreateTextEditControl(parent)
  local control = XMultiLineEdit:new({
    Id = "idEdit",
    MinVisibleLines = 1,
    MaxVisibleLines = 30,
    Translate = true
  }, parent)
  control:SetPlugins({
    "XSpellcheckPlugin"
  })
  return control
end
function GedPropTList:ConvertToText(value)
  return GedPropValueToT(value)
end
function GedPropTList:ConvertFromText(value)
  return GedTToPropValue(value, "")
end
DefineClass.GedPropListPicker = {
  __parents = {
    "GedPropEditor"
  }
}
function GedPropListPicker:Init()
  local horizontal = self.prop_meta.horizontal
  if not horizontal then
    self.idLabelHost:SetDock("top")
  end
  self.idResetToDefault:SetVisibleInstant(false)
  XList:new({
    Id = "idList",
    VScroll = "idScroll",
    Padding = horizontal and box(2, 1, 2, 0) or empty_box,
    OnSelection = function(list, selected_item, selected_items)
      self:SetValue(selected_items)
    end,
    MultipleSelection = self.prop_meta.multiple or false,
    MaxRowsVisible = self.prop_meta.horizontal and 0 or self.prop_meta.max_rows or 1,
    OnDoubleClick = function(list, idx)
      self.panel.app:Send("GedPickerItemDoubleClicked", self.panel.context, self.prop_meta.id, ItemId(list[idx].item))
    end
  }, self)
  self:SpawnItems()
  if not self.prop_meta.horizontal then
    XSleekScroll:new({
      Id = "idScroll",
      Target = "node",
      Dock = "right",
      Margins = box(2, 0, 0, 0),
      AutoHide = true
    }, self.idList)
  end
  if self.prop_meta.filter_by_prop and self.prop_meta.filter_by_prop ~= "" then
    local filter_editor = self.panel:LocateEditorById(self.prop_meta.filter_by_prop)
    function filter_editor.idEdit.OnTextChanged(edit)
      self:DeleteThread("filter_thread")
      self:CreateThread("filter_thread", function()
        Sleep(150)
        if self.window_state ~= "destroyed" then
          self:FilterItems()
        end
      end)
    end
  end
end
function GedPropListPicker:FilterItems()
  local filter_editor = self.panel:LocateEditorById(self.prop_meta.filter_by_prop)
  if not filter_editor then
    return false
  end
  local filter_string = filter_editor.idEdit:GetText()
  if (filter_string == "" or type(filter_string) ~= "string") and string.lower(filter_string) == self.last_filter_string then
    self.last_filter_string = filter_string
    return false
  end
  filter_string = string.lower(filter_string)
  if filter_string == self.last_filter_string then
    return false
  end
  local fill_and_sort_cache = false
  if not self.sorted_items_cache then
    self.sorted_items_cache = {}
    fill_and_sort_cache = true
  end
  local starting_with = {}
  local idx = 1
  for item_idx, item in ipairs(self.idList) do
    if item.Id ~= "idScroll" then
      local item_text_lower = ItemText(item.item):strip_tags():lower()
      local visible = filter_string == "" or string.find(item_text_lower, filter_string, 1, true)
      if filter_string ~= "" and string.starts_with(item_text_lower, filter_string) then
        table.insert(starting_with, item)
      end
      item:SetVisible(visible)
      item:SetDock(not visible and "ignore" or false)
      idx = idx + 1
    end
    if fill_and_sort_cache then
      table.insert(self.sorted_items_cache, item)
    end
  end
  local starting_with_count = #starting_with
  for i = 1, starting_with_count do
    self.idList[i] = starting_with[i]
  end
  local cache_count = #self.sorted_items_cache
  local list_idx = 1
  for i = 1, cache_count do
    local skip = false
    for _, item in ipairs(starting_with) do
      if item == self.sorted_items_cache[i] then
        skip = true
        break
      end
    end
    if not skip then
      self.idList[starting_with_count + list_idx] = self.sorted_items_cache[i]
      list_idx = list_idx + 1
    end
  end
  local selection = {}
  for idx, item in ipairs(self.idList) do
    if item.selected then
      table.insert(selection, idx)
      item:SetSelected(false)
    end
  end
  self.idList:SetSelection(selection, false)
  self.last_filter_string = filter_string
end
function GedPropListPicker:DetachForReuse()
  self.idList:SetMinHeight(nil)
  self.idList:SetMaxHeight(nil)
  self.idList:SetMaxRowsVisible(self.prop_meta.horizontal and 0 or self.prop_meta.max_rows or 1)
  GedPropEditor.DetachForReuse(self)
end
function GedPropListPicker:Layout(x, y, width, height)
  if not self.prop_meta.max_rows and not self.prop_meta.horizontal and self.idList.MaxHeight == XList.MaxHeight then
    local app = self.panel.app
    local new_height = MulDivTrunc(height + app.parent.content_box:sizey() - app.measure_height, 1000, self.scale:y())
    self.idList:SetMinHeight(new_height)
    self.idList:SetMaxHeight(new_height)
    self.idList:SetMaxRowsVisible(0)
  end
  return GedPropEditor.Layout(self, x, y, width, height)
end
function GedPropListPicker:SetValue(selected)
  local texts = {}
  for _, idx in ipairs(selected) do
    texts[#texts + 1] = ItemId(self.idList[idx].item)
  end
  self:SetProp(self.prop_meta.multiple and texts or texts[1] or "")
end
function GedPropListPicker:UpdateValue()
  local ui_items = self.idList or empty_table
  local tables = type(ui_items[1] and ui_items[1].item) == "table"
  local value = self.prop_meta.multiple and self:GetProp() or {
    self:GetProp()
  }
  local selection = {}
  for _, val in ipairs(value or empty_table) do
    local selection_idx
    for item_idx, ui_item in ipairs(ui_items) do
      if ui_item.Id ~= "idScroll" and (ui_item.item == val or tables and (ui_item.item.id == val or ui_item.item.value == val)) then
        selection_idx = item_idx
        break
      end
    end
    if selection_idx then
      selection[#selection + 1] = selection_idx
    end
  end
  self.idList:SetSelection(selection, false)
  self:FilterItems()
  GedPropEditor.UpdateValue(self)
end
function GedPropListPicker:SpawnItems()
end
GedPropEditors.text_picker = "GedPropTextPicker"
DefineClass.GedPropTextPicker = {
  __parents = {
    "GedPropListPicker"
  }
}
function GedPropTextPicker:Init()
  self.idList:SetLayoutMethod(self.prop_meta.horizontal and "HWrap" or "VList")
end
function GedPropTextPicker:SpawnItems()
  local list = self.idList
  local selectable = not self.prop_meta.read_only
  local has_bookmarks = self.prop_meta.bookmark_fn
  local font = self.prop_meta.small_font and "GedSmall" or "GedDefault"
  list:Clear()
  for _, item in ipairs(self.prop_meta.items or empty_table) do
    local context = {
      text = ItemText(item),
      help = item.help,
      font = font,
      selectable = selectable
    }
    if has_bookmarks then
      context.bookmarked = item.bookmarked and true or false
    end
    local control
    if self.prop_meta.virtual_items then
      control = NewXVirtualContent(list, context, "GedTextPickerItem")
    else
      control = XTemplateSpawn("GedTextPickerItem", list, context)
    end
    control.item = item
  end
end
GedPropEditors.texture_picker = "GedPropTexturePicker"
DefineClass.GedPropTexturePicker = {
  __parents = {
    "GedPropListPicker"
  }
}
function GedPropTexturePicker:Init(parent, context, prop_meta)
  self.idList:SetLayoutMethod("HWrap")
  if prop_meta.alt_prop then
    function self.idList.OnMouseButtonDown(list, pt, button)
      if button == "L" and terminal.IsKeyPressed(const.vkAlt) then
        local item_idx = list:GetItemAt(pt)
        self.panel:Op("GedSetProperty", self.panel.context, prop_meta.alt_prop, ItemId(prop_meta.items[item_idx]))
        return "break"
      end
      return XList.OnMouseButtonDown(list, pt, button)
    end
  end
end
function GedPropTexturePicker:SpawnItems()
  local list = self.idList
  local prop_meta = self.prop_meta
  local enabled = not prop_meta.read_only
  list:Clear()
  for _, item in ipairs(prop_meta.items or empty_table) do
    local listitem = XListItem:new({
      RolloverText = item.help,
      RolloverTemplate = "GedPropRollover",
      RolloverBackground = RGBA(24, 123, 197, 255),
      FocusedBackground = RGBA(24, 123, 197, 255),
      Padding = box(2, 2, 2, 0),
      selectable = enabled,
      SetSelected = function(self, selected)
        if selected and #list.selection > 1 then
          local idx = table.find(list, self)
          local sel_idx = table.find(list.selection, idx)
          self.idSelectedNumber:SetText(string.format("#%d", sel_idx))
        else
          self.idSelectedNumber:SetText("")
        end
        XListItem.SetSelected(self, selected)
      end
    }, list)
    local image_parent = XWindow:new({Dock = "top"}, listitem)
    local image = XImage:new({
      BorderWidth = 1,
      ImageFit = prop_meta.thumb_height and "largest" or "smallest",
      MinWidth = prop_meta.thumb_size or prop_meta.thumb_width or 60,
      MaxWidth = prop_meta.thumb_size or prop_meta.thumb_width or 60,
      MinHeight = prop_meta.thumb_height,
      MaxHeight = prop_meta.thumb_height,
      BaseColorMap = prop_meta.base_color_map
    }, image_parent)
    image:SetImage(item.image or item.value)
    local width, height = UIL.MeasureImage(image.Image)
    local new_width = MulDivRound(width, prop_meta.thumb_zoom or 100, 100)
    local new_starting_point = (width - new_width) / 2
    image:SetImageRect(box(new_starting_point, new_starting_point, new_starting_point + new_width, new_starting_point + new_width))
    if item.color then
      image:SetImageColor(item.color)
    end
    XText:new({
      Id = "idSelectedNumber",
      TextStyle = "GedSmall",
      HAlign = "right",
      VAlign = "bottom"
    }, image_parent)
    XText:new({
      Dock = "bottom",
      TextStyle = prop_meta.small_font and "GedSmall" or "GedDefault",
      MaxWidth = prop_meta.thumb_size or prop_meta.thumb_width or 60,
      VAlign = "center",
      TextHAlign = "center",
      Padding = box(2, 2, 2, 0),
      RolloverText = item.text,
      RolloverTemplate = "GedPropRollover",
      RolloverBackground = RGBA(24, 123, 197, 255)
    }, listitem):SetText(item.text)
    listitem.item = item
  end
end
GedPropEditors.object = "GedPropObjectPicker"
DefineClass.GedPropObjectPicker = {
  __parents = {
    "GedPropEditor"
  },
  last_object = false
}
function GedPropObjectPicker:Init(parent, context, prop_meta)
  XCombo:new({
    Id = "idCombo",
    Items = false,
    RefreshItemsOnOpen = true,
    DefaultValue = self.prop_meta.default or "",
    ArbitraryValue = true,
    OnValueChanged = function(combo, value)
      self:ComboValueChanged(value)
    end,
    OnRequestItems = function(combo)
      return self.panel.connection:Call("rfnMapGetGameObjects", self.panel.context, self.prop_meta.id)
    end,
    MRUStorageId = self.prop_meta.mru_storage_id,
    MRUCount = self.prop_meta.show_recent_items,
    VirtualItems = true
  }, self)
  self.idCombo:SetEnabled(not prop_meta.read_only)
  self.last_object = {}
  local inspect_button = XTemplateSpawn("GedToolbarButtonSmall", self)
  inspect_button:SetIcon("CommonAssets/UI/Ged/explorer.tga")
  inspect_button:SetRolloverText("Inspect Object")
  function inspect_button.OnPress(button)
    button:SetFocus()
    self.panel.app:Send("GedRpcInspectObj", self.panel.context, prop_meta.id)
    button:SetFocus(false)
  end
end
function GedPropObjectPicker:ReassignFocusOrders(x, y)
  self.idCombo:SetFocusOrder(point(x, y))
  return y + 1
end
function GedPropObjectPicker:UpdateValue()
  local combo = self.idCombo
  combo.Items = false
  self.last_object = self:GetProp() or {}
  self.idCombo:SetValueWithText(self.last_object.handle, self.last_object.text)
  GedPropEditor.UpdateValue(self)
end
function GedPropObjectPicker:ComboValueChanged(value)
  if type(value) == "string" and self.prop_meta.trim_spaces ~= false and string.trim_spaces(value) ~= value then
    value = string.trim_spaces(value)
    self.idCombo:SetValue(value)
  end
  if self.last_object.handle ~= value then
    self.last_object.handle = value
    self:SetProp({handle = value})
  end
end
function GedPropObjectPicker:DetachForReuse()
  self.idCombo:UpdateMRUList()
  GedPropEditor.DetachForReuse(self)
end
GedPropEditors.histogram = "GedPropHistogram"
DefineClass.GedPropHistogram = {
  __parents = {
    "GedPropEditorWithSubeditors"
  }
}
function GedPropHistogram:Init(parent, context, prop_meta)
  local histogram = XHistogram:new({
    Id = "idHistogram",
    MinWidth = 200,
    MinHeight = 200
  }, self.subeditor_container)
  self.idLabelHost:SetDock("top")
end
function GedPropHistogram:UpdateValue()
  self.idHistogram:SetValue(self:GetProp())
  GedPropEditorWithSubeditors.UpdateValue(self)
end
GedPropEditors.packedcurve = "GedPropCurvePicker"
GedPropEditors.curve4 = "GedPropCurvePicker"
DefineClass.GedPropCurvePicker = {
  __parents = {
    "GedPropEditorWithSubeditors"
  },
  default_scale = 1000,
  graph_max_value = 10,
  range_editor = false,
  color_args = false,
  control_points = 4
}
function GedPropCurvePicker:UpdateDynamicGraphParams()
  self.graph_max_value = self.range_editor.subeditor_value
  self.graph_max_value = Max(Min(self.graph_max_value, self.prop_meta.max_amplitude), self.prop_meta.min_amplitude)
  self.idCurve.DisplayScaleY = (self.prop_meta.scale or 1000) * 10 / self.graph_max_value
  self.idCurve.scale_texts = false
end
function GedPropCurvePicker:DrawGraphBackground(editor, graph_box, points)
  local color_args = self.color_args
  if not color_args then
    return
  end
  local step = 12
  local units_per_color = 1000 / (#color_args - 2)
  local DrawSolidRect = UIL.DrawSolidRect
  for y = graph_box:miny(), graph_box:maxy(), step do
    local percent = 1000 - MulDivRound(y - graph_box:miny(), 1000, graph_box:sizey())
    local i = percent / units_per_color
    local color_interp = percent % units_per_color
    local color = InterpolateRGB(color_args[i + 1], color_args[i + 2], color_interp, units_per_color)
    DrawSolidRect(box(graph_box:minx(), y, graph_box:maxx(), Min(graph_box:maxy(), y + step)), color, RGBA(0, 0, 0, 0))
  end
end
function GedPropCurvePicker:Init(parent, context, prop_meta)
  prop_meta.max_amplitude = prop_meta.max_amplitude or 10
  prop_meta.min_amplitude = prop_meta.min_amplitude or 10
  if prop_meta.scale then
    prop_meta.max_amplitude = prop_meta.max_amplitude or prop_meta.scale
    prop_meta.min_amplitude = prop_meta.min_amplitude or prop_meta.scale
  end
  self.control_points = prop_meta.control_points or 4
  local curve_editor = XCurveEditor:new({
    Id = "idCurve",
    ControlPoints = self.control_points,
    MaxX = prop_meta.max_x or 1000,
    MinX = prop_meta.min_x or 0,
    MaxY = prop_meta.max or 1000,
    MinY = prop_meta.min or 0,
    DisplayScaleX = prop_meta.scale_x or 1000,
    DisplayScaleY = prop_meta.scale or 1000,
    SnapX = 1,
    SnapY = 1,
    MinWidth = 500,
    MinHeight = 200,
    Smooth = false,
    FixedX = prop_meta.fixedx or false,
    OnCurveChanged = function(editor)
      if not self:IsThreadRunning("scroll_update_thread") then
        self:CreateThread("scroll_update_thread", function()
          Sleep(75)
          self:TrySetProp()
        end)
      end
    end,
    DrawGraphBackground = function(editor, graph_box, points)
      self:DrawGraphBackground(editor, graph_box, points)
    end,
    ReadOnly = prop_meta.read_only and true,
    MinMaxRangeMode = not prop_meta.no_minmax
  }, self.subeditor_container)
  curve_editor.GridUnitY = curve_editor:GetRange():y() / 4
  curve_editor.GridUnitX = curve_editor:GetRange():x() / 4
  if prop_meta.color_args and 0 < #prop_meta.color_args then
    self.color_args = prop_meta.color_args
    table.insert(self.color_args, self.color_args[#self.color_args])
  end
  self.range_editor = self:MakeSubEditor(self.subeditor_container, GedPropNumber, {
    max = prop_meta.max_amplitude or 10,
    min = prop_meta.min_amplitude or 10,
    scale = 10,
    slider = true,
    default = 10,
    id = "range_editor",
    editor = "number"
  })
  if prop_meta.max_amplitude == prop_meta.min_amplitude then
    self.range_editor:SetVisible(false)
    self.range_editor:SetDock("ignore")
  end
  self.idLabelHost:SetDock("top")
end
function GedPropCurvePicker:TrySetProp()
  local result = table.copy(self.idCurve.points)
  result.range_y = self.range_editor.subeditor_value
  result.scale = self.prop_meta.scale or result.range_y
  self.graph_max_value = result.range_y or 10
  self:UpdateDynamicGraphParams()
  self:SetProp(result)
end
function GedPropCurvePicker:UpdateValue()
  GedPropEditorWithSubeditors.UpdateValue(self)
  local prop = self:GetProp()
  if not prop then
    return
  end
  if self.idCurve:IsFocused(true) then
    return
  end
  for i = 1, #prop do
    if IsPoint(prop[i]) then
      local pt = prop[i]
      if not pt:z() then
        pt = pt:SetZ(pt:y())
      end
      self.idCurve.points[i] = pt
    end
  end
  self.idCurve:ValidatePoints()
  self.graph_max_value = prop.range_y or 10
  self.range_editor.subeditor_value = self.graph_max_value
  self:UpdateDynamicGraphParams()
end
GedPropEditors.point_list = "GedPropPointList"
DefineClass.GedPropPointList = {
  __parents = {
    "GedPropPrimitiveList"
  }
}
function GedPropPointList:DefaultValue()
  return point30
end
function GedPropPointList:ValidateValue(value)
  return IsPoint(value)
end
function GedPropPointList:ConvertFromText(value)
  return GedPropPoint.ConvertFromText(self, value)
end
function GedPropPointList:ConvertToText(value)
  return GedPropPoint.ConvertToText(self, value)
end
function GedPropPointList:ApplyScale(...)
  return GedPropPoint.ApplyScale(self, ...)
end
function GedPropPointList:GetDisplayScale(...)
  return GedPropPoint.GetDisplayScale(self, ...)
end
function GedPropPointList:GetMinMax(...)
  return GedPropPoint.GetMinMax(self, ...)
end
function GedPropPointList:UpdateValue()
  local data = self:GetProp() or {}
  if not terminal.desktop.keyboard_focus or not terminal.desktop.keyboard_focus:IsWithin(self) then
    self.list_values = table.map(data, function(p)
      return point(p:xyz())
    end)
    self:WithItems(function()
      self:UpdateControls()
    end)
  end
  GedPropEditor.UpdateValue(self)
end
