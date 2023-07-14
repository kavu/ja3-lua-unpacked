local warn_mark = Untranslated("<color 255 140 0>!</color>")
local err_mark = Untranslated("<color 240 0 0>!!</color>")
local dirty_mark = Untranslated("<color 240 0 0>*</color>")
local match_mark_text = "<color 0 196 0>\226\128\162</color>"
local match_mark = Untranslated(match_mark_text)
local get_warning_msg = function(obj_addr)
  return (Platform.ged and g_GedApp.connection:Obj("root|warnings_cache") or rawget(_G, "DiagnosticMessagesForGed") or empty_table)[obj_addr]
end
function TFormat.ged_marks(context_obj, obj_addr)
  local marks = ""
  local msg = get_warning_msg(obj_addr)
  if msg then
    marks = marks .. (msg[#msg] == "warning" and warn_mark or err_mark)
  end
  local dirty = Platform.ged and g_GedApp.connection:Obj("root|dirty_objects") or empty_table
  if dirty[obj_addr] then
    marks = marks .. dirty_mark
  end
  for _, panel in pairs(Platform.ged and g_GedApp.interactive_panels) do
    local results = panel.search_value_results
    if results and type(results[obj_addr]) == "table" then
      marks = marks .. match_mark
      break
    end
  end
  return marks
end
local reCommaList = "([%w_]+)%s*,%s*"
DefineClass.GedPanelBase = {
  __parents = {
    "XControl",
    "XContextWindow"
  },
  properties = {
    {
      category = "Interaction",
      id = "Collapsible",
      editor = "bool",
      default = false,
      help = "Allows the panel to be collapsed and expanded."
    },
    {
      category = "Interaction",
      id = "StartsExpanded",
      editor = "bool",
      default = false,
      help = "Controls if the panel is initially collapsed or expanded."
    },
    {
      category = "Interaction",
      id = "ExpandedMessage",
      editor = "text",
      default = "",
      help = "Dimmed help message to display right-aligned in the panel's title when it is expanded."
    },
    {
      category = "Interaction",
      id = "EmptyMessage",
      editor = "text",
      default = "",
      help = "Dimmed help message to display right-aligned in the panel's title when it is empty."
    }
  },
  Embedded = false,
  Interactive = false,
  MatchMark = match_mark_text,
  focus_column = 1,
  connection = false,
  app = false
}
function GedPanelBase:Init(parent, context)
  self.app = GetParentOfKind(self.parent, "GedApp")
  self.connection = self.app and self.app.connection
  self.app:AddPanel(self.context, self)
end
function GedPanelBase:Done()
  if self.app.window_state ~= "destroying" then
    self:UnbindViews()
    self.app:RemovePanel(self)
  end
end
function GedPanelBase:SetPanelFocused()
end
function GedPanelBase:GetSelection()
  return false
end
function GedPanelBase:GetMultiSelection()
  return false
end
function GedPanelBase:SetSelection(...)
end
function GedPanelBase:OnSelection(selection)
end
function GedPanelBase:TryHighlightSearchMatch()
end
function GedPanelBase:CancelSearch(dont_select)
end
function GedPanelBase:GetState()
  return {
    selection = table.pack(self:GetSelection())
  }
end
function GedPanelBase:Obj(name)
  return self.connection.bound_objects[name]
end
function GedPanelBase:BindView(suffix, func_name, ...)
  local name = self.context
  self.connection:BindObj(name .. "|" .. suffix, name, func_name, ...)
end
function GedPanelBase:UnbindView(suffix)
  local name = self.context
  self.connection:UnbindObj(name .. "|" .. suffix)
end
function GedPanelBase:BindViews()
end
function GedPanelBase:UnbindViews()
  local name = self.context
  if name then
    self.connection:UnbindObj(name)
    self.connection:UnbindObj(name .. "|", "")
    self:SetContext(false)
  end
end
function GedPanelBase:OnContextUpdate(context, view)
  self:SetVisible(true)
  if view == nil then
    self:BindViews()
  end
  self.app:CheckUpdateItemTexts(view)
end
function GedPanelBase:OnSetFocus()
  if self.app:SetLastFocusedPanel(self) then
    self:BindSelectedObject(self:GetSelection())
  end
end
function GedPanelBase:BindSelectedObject(selected_item)
end
function GedPanelBase:Op(op_name, obj, ...)
  self.app:Op(op_name, obj, ...)
end
function GedPanelBase:Send(rfunc_name, ...)
  self.app:Send(rfunc_name, ...)
end
function GedPanelBase:UpdateItemTexts()
end
local get_warning_nodes = function(self)
  local warning_data = self:Obj(self.context .. "|warning")
  if type(warning_data) == "table" then
    local warning_idxs = {}
    for i = 3, #warning_data do
      table.insert(warning_idxs, warning_data[i])
    end
    return warning_idxs
  end
  return empty_table
end
local common_action_ops = {
  GedListPanel = {
    None = {},
    PropertyObject = {
      MoveUp = "GedOpListMoveUp",
      MoveDown = "GedOpListMoveDown",
      Delete = "GedOpListDeleteItem",
      Cut = "GedOpListCut",
      Copy = "GedOpListCopy",
      Paste = "GedOpListPaste",
      Duplicate = "GedOpListDuplicate"
    },
    Object = {
      Delete = "GedOpListDeleteItem",
      Cut = "GedOpObjectCut",
      Copy = "GedOpObjectCopy",
      Paste = "GedOpObjectPaste",
      Duplicate = "GedOpObjectDuplicate"
    }
  },
  GedTreePanel = {
    None = {},
    PropertyObject = {
      MoveUp = "GedOpTreeMoveItemUp",
      MoveDown = "GedOpTreeMoveItemDown",
      MoveOut = "GedOpTreeMoveItemOutwards",
      MoveIn = "GedOpTreeMoveItemInwards",
      Delete = "GedOpTreeDeleteItem",
      Cut = "GedOpTreeCut",
      Copy = "GedOpTreeCopy",
      Paste = "GedOpTreePaste",
      Duplicate = "GedOpTreeDuplicate"
    },
    Preset = {
      Delete = "GedOpPresetDelete",
      Cut = "GedOpPresetCut",
      Copy = "GedOpPresetCopy",
      Paste = "GedOpPresetPaste",
      Duplicate = "GedOpPresetDuplicate"
    }
  },
  GedPropPanel = {
    None = {},
    PropertyObject = {
      Copy = "GedOpPropertyCopy",
      Paste = "GedOpPropertyPaste"
    }
  }
}
local op_readonly = function(self, prop_meta)
  return self:GetProperty(prop_meta.id) == GedDisabledOp
end
local op_noedit = function(self, prop_meta)
  return not common_action_ops[rawget(self, "__class") or self.class]
end
local op_edit_button = {
  {
    name = "Edit",
    func = "OpEdit",
    is_hidden = function(obj, prop_meta)
      return obj:GetProperty(prop_meta.id) ~= GedDisabledOp
    end
  }
}
DefineClass.GedPanel = {
  __parents = {
    "GedPanelBase"
  },
  properties = {
    {
      category = "General",
      id = "Title",
      editor = "text",
      default = "<class>"
    },
    {
      category = "General",
      id = "TitleFormatFunc",
      editor = "text",
      default = "GedFormatObject"
    },
    {
      category = "General",
      id = "EnableSearch",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "SearchHistory",
      editor = "number",
      default = 0
    },
    {
      category = "General",
      id = "SearchValuesAvailable",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "PersistentSearch",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "Predicate",
      editor = "text",
      default = "",
      help = "This object member function controls whether the panel is visible"
    },
    {
      category = "General",
      id = "DisplayWarnings",
      editor = "bool",
      default = true
    },
    {
      category = "Common Actions",
      id = "ActionsClass",
      editor = "choice",
      default = "None",
      no_edit = op_noedit,
      items = function(self)
        return table.keys2(common_action_ops[rawget(self, "__class") or self.class] or {None = true}, "sorted")
      end
    },
    {
      category = "Common Actions",
      id = "MoveUp",
      editor = "text",
      default = GedDisabledOp,
      read_only = op_readonly,
      no_edit = op_noedit,
      buttons = op_edit_button
    },
    {
      category = "Common Actions",
      id = "MoveDown",
      editor = "text",
      default = GedDisabledOp,
      read_only = op_readonly,
      no_edit = op_noedit,
      buttons = op_edit_button
    },
    {
      category = "Common Actions",
      id = "MoveOut",
      editor = "text",
      default = GedDisabledOp,
      read_only = op_readonly,
      no_edit = op_noedit,
      buttons = op_edit_button
    },
    {
      category = "Common Actions",
      id = "MoveIn",
      editor = "text",
      default = GedDisabledOp,
      read_only = op_readonly,
      no_edit = op_noedit,
      buttons = op_edit_button
    },
    {
      category = "Common Actions",
      id = "Delete",
      editor = "text",
      default = GedDisabledOp,
      read_only = op_readonly,
      no_edit = op_noedit,
      buttons = op_edit_button
    },
    {
      category = "Common Actions",
      id = "Cut",
      editor = "text",
      default = GedDisabledOp,
      read_only = op_readonly,
      no_edit = op_noedit,
      buttons = op_edit_button
    },
    {
      category = "Common Actions",
      id = "Copy",
      editor = "text",
      default = GedDisabledOp,
      read_only = op_readonly,
      no_edit = op_noedit,
      buttons = op_edit_button
    },
    {
      category = "Common Actions",
      id = "Paste",
      editor = "text",
      default = GedDisabledOp,
      read_only = op_readonly,
      no_edit = op_noedit,
      buttons = op_edit_button
    },
    {
      category = "Common Actions",
      id = "Duplicate",
      editor = "text",
      default = GedDisabledOp,
      read_only = op_readonly,
      no_edit = op_noedit,
      buttons = op_edit_button
    },
    {
      category = "Context Menu",
      id = "ActionContext",
      editor = "text",
      default = ""
    },
    {
      category = "Context Menu",
      id = "SearchActionContexts",
      editor = "string_list",
      default = false
    }
  },
  IdNode = true,
  HAlign = "stretch",
  VAlign = "stretch",
  Padding = box(2, 2, 2, 2),
  Background = RGB(255, 255, 255),
  FocusedBackground = RGB(255, 255, 255),
  MinWidth = 300,
  MaxWidth = 100000,
  ContainerControlClass = "XScrollArea",
  HorizontalScroll = false,
  Translate = false,
  documentation_btn = false,
  test_btn = false,
  expanded = true,
  search_popup = false,
  search_values = false,
  search_value_results = false
}
function GedPanel:OnXTemplateSetProperty(prop_id, old_value, ged)
  if prop_id == "__class" or prop_id == "ActionsClass" then
    local data = common_action_ops[self.__class]
    if prop_id == "__class" then
      self.ActionsClass = data and "PropertyObject" or "None"
    end
    local ops = data and data[self.ActionsClass] or empty_table
    for _, op in ipairs(GedCommonOps) do
      self:SetProperty(op.Id, ops[op.Id] or GedDisabledOp)
    end
  end
end
function GedPanel:OpEdit(root, prop_id, ged, param)
  self:SetProperty(prop_id, "")
  ObjModified(self)
end
function GedPanel:ToggleSearch()
  if self.idSearchContainer:GetVisible() then
    self:CloseSearch()
  else
    self:OpenSearch()
  end
end
function GedPanel:SaveSearchToggled(value)
  local settings = self.app.settings or {}
  local opened_panels = settings.opened_panels or {}
  if value ~= nil then
    opened_panels[self.Id] = value
  end
  settings.opened_panels = opened_panels
  self.app.settings = settings
  return opened_panels[self.Id]
end
function GedPanel:OpenSearch()
  if not self:IsSearchAvailable() then
    return
  end
  local search = self.idSearchContainer
  if not search.visible then
    search:SetDock("top")
    search:SetVisible(true)
  end
  self.idSearchEdit:SetFocus()
  self.idSearchEdit:SelectAll()
  self:SaveSearchToggled(true)
end
function GedPanel:CloseSearch()
  local search = self.idSearchContainer
  if not search.visible then
    return
  end
  search:SetDock("ignore")
  search:SetVisible(false)
  if self.idSearchEdit:GetText() ~= "" then
    self:UpdateFilter()
  end
  self:SaveSearchToggled(false)
  return true
end
function GedPanel:CancelSearch(dont_select)
  if not self.idSearchContainer:GetVisible() then
    return false
  end
  if self.PersistentSearch then
    if self.idSearchEdit:GetText() ~= "" then
      self.idSearchEdit:SetText("")
      self.app.search_value_filter_text = ""
      self.app:TryHighlightSearchMatchInChildPanels(self)
      self:UpdateFilter()
    elseif not self.idContainer:IsFocused(true) then
      if not dont_select then
        self:FocusFirstEntry()
      end
    else
      self.idSearchEdit:SetFocus()
      self.idSearchEdit:SelectAll()
    end
    return true
  else
    return self:CloseSearch()
  end
end
function GedPanel:UpdateFilter()
end
function GedPanel:FocusFirstEntry()
end
function GedPanel:GetFilterText()
  local search = self.idSearchContainer
  if not search or not search.visible then
    return ""
  end
  return string.lower(self.idSearchEdit:GetText())
end
function GedPanel:GetHighlightText()
  local app = self.app
  return app.search_value_results and app.search_value_filter_text
end
function GedPanel:OnShortcut(shortcut, source, ...)
  if shortcut == "Escape" and self:CancelSearch() then
    return "break"
  end
  local app = self.app
  local search_panel = app.search_value_panel
  if app.search_value_results and search_panel then
    if shortcut == "F4" then
      search_panel:NextMatch(1)
      return "break"
    elseif shortcut == "Shift-F4" then
      search_panel:NextMatch(-1)
      return "break"
    elseif shortcut == "F5" then
      search_panel:StartUpdateFilterThread()
      return "break"
    end
  end
end
function GedPanel:IsSearchAvailable()
  return self.EnableSearch and not self.Embedded
end
function GedPanel:UpdateSearchVisiblity()
  local enabled = self.EnableSearch and not self.Embedded
  if not enabled then
    self:CloseSearch()
  end
  self.idToggleSearch:SetVisible(enabled)
  self.idToggleSearch:SetDock(enabled and "right" or "ignore")
  self:UpdateSearchContextMenu(self:GetSearchActionContexts())
end
function GedPanel:SetSearchActionContexts(search_contexts)
  if not search_contexts or type(search_contexts) ~= "table" then
    return
  end
  self:UpdateSearchContextMenu(search_contexts)
end
function GedPanel:UpdateSearchContextMenu(new_contexts)
  if not new_contexts or type(new_contexts) ~= "table" or #new_contexts == 0 then
    return
  end
  local host = GetActionsHost(self)
  if not host then
    return
  end
  local search_action = host:ActionById("idSearch")
  if not search_action then
    return
  end
  local contexts = search_action.ActionContexts
  if not contexts then
    return
  end
  local old_contexts = self:GetSearchActionContexts()
  if old_contexts and #old_contexts ~= 0 then
    for _, old in ipairs(old_contexts) do
      table.remove_entry(contexts, old)
    end
  end
  local search_enabled = self.EnableSearch and not self.Embedded
  if search_enabled then
    for _, new in ipairs(new_contexts) do
      table.insert(contexts, new)
    end
  end
  self.SearchActionContexts = new_contexts
end
function GedPanel:AddToSearchHistory(text)
  local settings = self.app.settings or {}
  settings.search_history = settings.search_history or {}
  local history_list = settings.search_history[self.Id] or {}
  if text and #text:trim_spaces() > 0 then
    table.remove_value(history_list, text)
    table.insert(history_list, 1, text)
    if #history_list > self.SearchHistory then
      table.remove(history_list, #history_list)
    end
  end
  settings.search_history[self.Id] = history_list
  self.app.settings = settings
  return history_list
end
function GedPanel:OpenSearchHistory(keyboard)
  local popup = XPopupList:new({LayoutMethod = "VList"}, self.desktop)
  local history = self:AddToSearchHistory(nil)
  if 0 < #history then
    for idx, item in ipairs(history) do
      local entry = XTemplateSpawn("XComboListItem", popup.idContainer, self.context)
      entry:SetFocusOrder(point(1, idx))
      entry:SetFontProps(XCombo)
      entry:SetText(item)
      entry:SetMinHeight(entry:GetFontHeight())
      function entry.OnPress(entry)
        self.idSearchEdit:SetText(item)
        self:AddToSearchHistory(item)
        if popup.window_state ~= "destroying" then
          popup:Close()
        end
      end
    end
  else
    XText:new({}, popup.idContainer):SetText("No history.")
  end
  popup:SetAnchor(self.idSearchContainer.box)
  popup:SetAnchorType("drop")
  popup:Open()
  if keyboard and 0 < #history then
    popup.idContainer[1]:SetFocus()
  end
  self.search_popup = popup
  self.app:UpdateChildrenDarkMode(popup)
end
function GedPanel:InitControls()
  self.expanded = self.StartsExpanded
  XWindow:new({
    Id = "idTitleContainer",
    Dock = "ignore",
    Background = RGB(196, 196, 196),
    HandleMouse = true
  }, self):SetVisible(false)
  local search_container
  if self.SearchValuesAvailable then
    XWindow:new({
      Id = "idSearchContainer",
      Dock = "ignore"
    }, self):SetVisible(false)
    search_container = XWindow:new({BorderWidth = 1}, self.idSearchContainer)
    self:CreateSearchResultsPanel()
    local search_toggle = XTemplateSpawn("GedToolbarToggleButtonSmall", self.idSearchContainer)
    search_toggle:SetId("idSearchValuesButton")
    search_toggle:SetIcon("CommonAssets/UI/Ged/log-dataset.tga")
    search_toggle:SetRolloverText(Untranslated("Toggle search in properties and sub-objects"))
    search_toggle:SetMargins(box(2, 0, 0, 0))
    function search_toggle.OnPress()
      return self:ToggleSearchValues()
    end
  else
    search_container = XWindow:new({
      Id = "idSearchContainer",
      Dock = "ignore",
      BorderWidth = 1,
      Background = RGB(255, 255, 255)
    }, self)
    search_container:SetVisible(false)
  end
  local button = XTemplateSpawn("XComboButton", search_container, self.context)
  button:SetId("idSearchHistory")
  button:SetMargins(empty_box)
  button:SetVisible(0 < self.SearchHistory)
  function button.OnPress(button)
    if not self.search_popup or self.search_popup.window_state ~= "open" then
      self:PopulateSearchValuesCache()
      self:OpenSearchHistory()
    else
      self.search_popup:Close()
    end
  end
  button.FoldWhenHidden = true
  XTextButton:new({
    Id = "idCancelSearch",
    Dock = "right",
    VAlign = "center",
    Text = "x",
    MaxWidth = 20,
    MaxHeight = 16,
    LayoutHSpacing = 0,
    BorderWidth = 0,
    Background = RGBA(0, 0, 0, 0),
    RolloverBackground = RGB(204, 232, 255),
    PressedBackground = RGB(121, 189, 241),
    OnPress = function()
      self:CancelSearch()
    end,
    FoldWhenHidden = true
  }, search_container)
  self.idCancelSearch:SetVisible(false)
  XEdit:new({
    Id = "idSearchEdit",
    Dock = "box",
    Hint = "Search...",
    BorderWidth = 0,
    Background = RGBA(0, 0, 0, 0),
    AllowEscape = false,
    OnTextChanged = function(edit)
      XEdit.OnTextChanged(edit)
      self:StartUpdateFilterThread()
      if edit:GetText() ~= "" then
        self:SetSelection(false)
      end
      self.idCancelSearch:SetVisible(edit:GetText() ~= "")
    end,
    OnShortcut = function(edit, shortcut, source, ...)
      local result = XEdit.OnShortcut(edit, shortcut, source, ...)
      if result == "break" then
        return result
      end
      if shortcut == "Down" or shortcut == "Enter" then
        if shortcut == "Down" and self.SearchHistory > 0 and edit:GetText() == "" then
          self:OpenSearchHistory("keyboard")
          return "break"
        else
          self:FocusFirstEntry()
          return shortcut == "Down" and "break"
        end
      end
    end,
    OnSetFocus = function(edit)
      self:PopulateSearchValuesCache()
      return XEdit.OnSetFocus(edit)
    end,
    OnKillFocus = function(edit, new_focus)
      self:AddToSearchHistory(edit:GetText())
      return XEdit.OnKillFocus(edit, new_focus)
    end
  }, search_container)
  local search_button = XTemplateSpawn("GedToolbarButtonSmall", self.idTitleContainer)
  search_button:SetId("idToggleSearch")
  search_button:SetIcon("CommonAssets/UI/Ged/view.tga")
  search_button:SetRolloverText("Search (Ctrl-F)")
  search_button:SetBackground(self.idTitleContainer:GetBackground())
  function search_button.OnPress()
    self:ToggleSearch()
  end
  XText:new({
    Id = "idTitle",
    Dock = "box",
    ZOrder = 1000,
    Margins = box(2, 1, 2, 1),
    TextStyle = self.Collapsible and "GedDefault" or "GedTitleSmall",
    HandleMouse = self.Collapsible,
    Translate = true,
    OnMouseButtonDown = function(button, pt, button)
      if self.Collapsible and button == "L" and not terminal.IsKeyPressed(const.vkShift) and not terminal.IsKeyPressed(const.vkControl) then
        self:Expand(not self.expanded)
      end
    end
  }, self.idTitleContainer)
  XText:new({
    Id = "idWarningText",
    Dock = "top",
    VAlign = "center",
    TextHAlign = "center",
    BorderWidth = 1,
    BorderColor = RGB(255, 0, 0),
    Background = RGB(255, 196, 196),
    FoldWhenHidden = true
  }, self)
  self.idWarningText:SetVisible(false)
  if self.HorizontalScroll then
    XSleekScroll:new({
      Id = "idHScroll",
      Target = "idContainer",
      Dock = "bottom",
      Margins = box(0, 2, 7, 0),
      Horizontal = true,
      AutoHide = true,
      FoldWhenHidden = true
    }, self)
  end
  local vertical_scroll = _G[self.ContainerControlClass]:IsKindOf("XScrollArea")
  if vertical_scroll then
    XSleekScroll:new({
      Id = "idScroll",
      Target = "idContainer",
      Dock = "right",
      Margins = box(2, 0, 0, 0),
      Horizontal = false,
      AutoHide = true,
      FoldWhenHidden = true
    }, self)
  end
  _G[self.ContainerControlClass]:new({
    Id = "idContainer",
    HAlign = "stretch",
    VAlign = "stretch",
    MinHSize = false,
    LayoutMethod = "VList",
    Padding = box(2, 2, 2, 2),
    BorderWidth = 0,
    HScroll = self.HorizontalScroll and "idHScroll" or "",
    VScroll = vertical_scroll and "idScroll" or "",
    FoldWhenHidden = true,
    RolloverTemplate = "GedPropRollover",
    Translate = self.Translate
  }, self)
  function self.idContainer.OnSetFocus()
    self:OnSetFocus()
  end
  self:UpdateSearchVisiblity()
end
function GedPanel:GetTitleView()
  return self.TitleFormatFunc .. "." .. self.Title
end
function GedPanel:Open(...)
  self:InitControls()
  XWindow.Open(self, ...)
  if self.context then
    self:BindViews()
    if self.Title ~= "" then
      self:BindView(self:GetTitleView(), self.TitleFormatFunc, self.Title)
    end
    if self.Predicate ~= "" then
      self:BindView("predicate", "GedExecMemberFunc", self.Predicate)
    end
  end
  if self.PersistentSearch and self:IsSearchAvailable() and not self.idSearchContainer:GetVisible() and self:SaveSearchToggled(nil) ~= false then
    self:OpenSearch()
  end
end
function GedPanel:Expand(expand)
  self.expanded = expand
  self.idContainer:SetVisible(expand)
  self.idScroll:SetAutoHide(expand)
  self.idScroll:SetVisible(expand)
  if self.HorizontalScroll then
    self.idHScroll:SetAutoHide(expand)
    self.idHScroll:SetVisible(expand)
  end
  self:UpdateTitle(self.context)
end
function GedPanel:UpdateTitle(context)
  local title = self.Title ~= "" and self.Title ~= "<empty>" and self:Obj(context .. "|" .. self:GetTitleView()) or ""
  if self.Collapsible then
    if title == "" and self.Title ~= "<empty>" then
      title = "(no description)"
    end
    local match
    local obj_id = self:Obj(context)
    for _, panel in pairs(self.app.interactive_panels) do
      local res = panel.search_value_results
      if res and res[obj_id] then
        title = GedPanelBase.MatchMark .. title
        match = true
        break
      end
    end
    local is_empty = self:IsEmpty()
    local corner_message = self.EmptyMessage
    if not is_empty then
      corner_message = self.expanded and self.ExpandedMessage or "(click to expand)"
    end
    if not match then
      title = (not is_empty and (self.expanded and "- " or "+ ") or "") .. title
      if not self.Embedded then
        title = title .. "<right><color 128 128 128>" .. corner_message
      end
    end
  end
  self.idTitle:SetText(Untranslated(title))
  self.idTitleContainer:SetVisible(title ~= "")
  self.idTitleContainer:SetDock(title ~= "" and "top" or "ignore")
end
function GedPanel:OnContextUpdate(context, view)
  if not view then
    if self.Title ~= "" then
      self:BindView(self:GetTitleView(), self.TitleFormatFunc, self.Title)
    end
    if self.Predicate ~= "" then
      self:BindView("predicate", "GedExecMemberFunc", self.Predicate)
    end
    if self.DisplayWarnings and not self.app.actions_toggled.ToggleDisplayWarnings then
      self:BindView("warning", "GedGetWarning")
    end
    self:BindView("documentationLink", "GedGetDocumentationLink")
    self:BindView("documentation", "GedGetDocumentation")
    if self.Collapsible then
      local obj_id = self:Obj(self.context)
      for _, panel in pairs(self.app.interactive_panels) do
        local results = panel.search_value_results
        if results and results[obj_id] then
          self.expanded = true
        end
      end
      self:Expand(self.expanded)
    end
  end
  if view == self:GetTitleView() then
    self:UpdateTitle(context)
  end
  if view == "predicate" then
    local predicate = self:Obj(context .. "|predicate")
    self:SetVisible(predicate)
    self:SetDock(not predicate and "ignore")
  end
  if view == "warning" and self.DisplayWarnings then
    local warning = self:Obj(context .. "|warning")
    self.idWarningText:SetVisible(warning)
    self.idWarningText:SetTextColor(RGB(0, 0, 0))
    self.idWarningText:SetRolloverTextColor(RGB(0, 0, 0))
    if type(warning) == "table" then
      self.idWarningText:SetText(warning[1])
      local color = warning[2]
      if color == "warning" then
        color = RGB(255, 140, 0)
      end
      if color == "error" then
        color = RGB(255, 196, 196)
      end
      if color then
        local r, g, b = GetRGB(color)
        local max = Max(Max(r, g), b)
        self.idWarningText:SetBackground(color)
        self.idWarningText:SetBorderColor(RGB(r == max and r or r / 4, g == max and g or g / 4, b == max and b or b / 4))
      else
        self.idWarningText:SetBackground(RGB(255, 196, 196))
        self.idWarningText:SetBorderColor(RGB(255, 0, 0))
      end
    else
      self.idWarningText:SetText(warning)
      self.idWarningText:SetBackground(RGB(255, 196, 196))
      self.idWarningText:SetBorderColor(RGB(255, 0, 0))
    end
  end
  if (view or ""):starts_with("documentation") then
    local documentation = self:Obj(context .. "|documentation")
    local doc_link = self:Obj(context .. "|documentationLink")
    if (documentation or doc_link or "") ~= "" then
      if not self.documentation_btn then
        self.documentation_btn = XTemplateSpawn("GedToolbarButtonSmall", self.idTitleContainer)
        self.documentation_btn:SetIcon("CommonAssets/UI/Ged/help.tga")
        self.documentation_btn:SetZOrder(-1)
      end
      function self.documentation_btn.OnPress(button)
        button:SetFocus()
        if (doc_link or "") ~= "" then
          local link = doc_link:starts_with("http") and doc_link or "file:///" .. doc_link
          OpenUrl(link, "force external browser")
        end
        button:SetFocus(false)
      end
      local rollover_text = ""
      if doc_link then
        rollover_text = string.format([[
Open  %s 

]], doc_link)
      end
      rollover_text = rollover_text .. (documentation or "")
      self.documentation_btn:SetRolloverText(rollover_text)
      self.documentation_btn:SetVisible(true)
      if self.Embedded then
        if not self.test_btn then
          self.test_btn = XTemplateSpawn("GedToolbarButtonSmall", self.idTitleContainer)
          self.test_btn:SetIcon("CommonAssets/UI/Ged/play.tga")
          self.test_btn:SetZOrder(-1)
          self.test_btn:SetRolloverText("Run now!")
        end
        function self.test_btn.OnPress(button)
          button:SetFocus()
          self:Send("GedTestFunctionObject", self.context)
          button:SetFocus(false)
        end
      end
    elseif self.documentation_btn then
      self.documentation_btn:SetVisible(false)
    end
  end
  GedPanelBase.OnContextUpdate(self, context, view)
end
function GedPanel:SetPanelFocused()
  return self.idContainer:SetFocus()
end
function GedPanel:ToggleSearchValues(no_settings_update)
  self.search_values = not self.search_values
  local button = self.idSearchValuesButton
  button:SetToggled(not button:GetToggled())
  self.idSearchEdit:SetFocus(false)
  self.idSearchEdit:SetFocus()
  self:StartUpdateFilterThread()
  if not no_settings_update then
    local settings = self.app.settings
    settings.search_in_props = settings.search_in_props or {}
    settings.search_in_props[self.context] = self.search_values
    self.app:SaveSettings()
  end
end
function GedPanel:StartUpdateFilterThread(not_user_initiated)
  if self.search_values and self.idSearchEdit:GetText() ~= "" then
    self.app:SetUiStatus("value_search_in_progress", "Searching...")
  end
  self:DeleteThread("UpdateFilterThread")
  self:CreateThread("UpdateFilterThread", function()
    Sleep(75)
    if self.search_values then
      local filter = self.idSearchEdit:GetText()
      self.search_value_results = filter ~= "" and self.connection:Call("rfnSearchValues", self.context, self:GetFilterText())
      if self.search_value_results == "timeout" then
        self.search_value_results = false
      end
      if self.PersistentSearch and not not_user_initiated then
        self:ShowSearchResultsPanel(self:GetFilterText(), self.search_value_results)
      end
    else
      self.search_value_results = nil
    end
    if self.window_state ~= "destroyed" then
      self:UpdateFilter()
      for _, panel in pairs(self.app.interactive_panels) do
        if panel ~= self then
          panel:UpdateItemTexts()
        end
      end
      self.app:SetUiStatus("value_search_in_progress", false)
    end
  end)
end
function GedPanel:PopulateSearchValuesCache()
  if self.search_values then
    CreateRealTimeThread(function()
      self.connection:Call("rfnPopulateSearchValuesCache", self.context)
    end)
  end
end
function GedPanel:CreateSearchResultsPanel()
  XWindow:new({
    Id = "idSearchResultsPanel",
    Dock = "bottom",
    FoldWhenHidden = true,
    Padding = box(0, 1, 0, 1)
  }, self.idSearchContainer):SetVisible(false)
  local button = XTemplateSpawn("GedToolbarButtonSmall", self.idSearchResultsPanel)
  button:SetIcon("CommonAssets/UI/Ged/undo.tga")
  button:SetRolloverText("Refresh search results (F5)")
  button:SetDock("right")
  function button.OnPress()
    self:StartUpdateFilterThread()
  end
  local button = XTemplateSpawn("GedToolbarButtonSmall", self.idSearchResultsPanel)
  button:SetIcon("CommonAssets/UI/Ged/up.tga")
  button:SetRolloverText("Previous match (Shift-F4)")
  button:SetDock("right")
  function button.OnPress()
    self:NextMatch(-1)
  end
  local button = XTemplateSpawn("GedToolbarButtonSmall", self.idSearchResultsPanel)
  button:SetIcon("CommonAssets/UI/Ged/down.tga")
  button:SetRolloverText("Next match (F4)")
  button:SetDock("right")
  function button.OnPress()
    self:NextMatch(1)
  end
  XText:new({
    Id = "idSearchResultsText",
    TextStyle = "GedDefault"
  }, self.idSearchResultsPanel)
end
function GedPanel:ShowSearchResultsPanel(filter, search_value_results)
  local app = self.app
  app.search_value_filter_text = filter
  app.search_value_results = search_value_results
  app.search_value_panel = self
  self.idSearchResultsPanel:SetVisible(search_value_results)
  if search_value_results then
    app.search_result_idx = 1
    self:NextMatch(0, "dont_unfocus_search_edit")
  end
end
function GedPanel:NextMatch(direction, dont_unfocus_search_edit)
  local app = self.app
  local count = #app.search_value_results
  app.search_result_idx = Clamp(app.search_result_idx + direction, 1, count)
  app.display_search_result = true
  self.idSearchResultsText:SetText(string.format("Match %d/%d", app.search_result_idx, count))
  local focus = self.desktop:GetKeyboardFocus()
  if not dont_unfocus_search_edit and focus.Id == "idSearchEdit" then
    self.desktop:RemoveKeyboardFocus(focus)
  end
  self:TryHighlightSearchMatch()
end
function GedPanel:FilterItem(text, item_id, filter_text)
  if filter_text == "" then
    return
  end
  if self.search_values then
    return not self.search_value_results or self.search_value_results.hidden[item_id or false]
  else
    text = IsT(text) and TDevModeGetEnglishText(text) or tostring(text):gsub("<[^>]+>", "")
    text = string.lower(text)
    return not text:find(filter_text, 1, true)
  end
end
function GedPanel:UpdateItemTexts()
  self:UpdateTitle(self.context)
end
function GedPanel:IsEmpty()
end
DefineClass.GedPropPanel = {
  __parents = {"GedPanel"},
  properties = {
    {
      category = "General",
      id = "CollapseDefault",
      editor = "bool",
      default = false,
      no_edit = true
    },
    {
      category = "General",
      id = "ShowInternalNames",
      editor = "bool",
      default = false,
      no_edit = true
    },
    {
      category = "General",
      id = "EnableUndo",
      editor = "bool",
      default = true
    },
    {
      category = "General",
      id = "EnableCollapseDefault",
      editor = "bool",
      default = true
    },
    {
      category = "General",
      id = "EnableShowInternalNames",
      editor = "bool",
      default = true
    },
    {
      category = "General",
      id = "EnableCollapseCategories",
      editor = "bool",
      default = true
    },
    {
      category = "General",
      id = "HideFirstCategory",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "RootObjectBindName",
      editor = "text",
      default = false
    },
    {
      category = "General",
      id = "SuppressProps",
      editor = "prop_table",
      default = false,
      help = "Set of properties to skip in format { id1 = true, id2 = true, ... }."
    },
    {
      category = "Context Menu",
      id = "PropActionContext",
      editor = "text",
      default = ""
    }
  },
  MinWidth = 200,
  Interactive = true,
  EnableSearch = true,
  ShowUnusedPropertyWarnings = false,
  update_request = false,
  rebuild_props = true,
  parent_obj_id = false,
  parent_changed = false,
  parent_changed_notified = false,
  collapsed_categories = false,
  collapse_default_button = false,
  active_tab = "All",
  selected_properties = false,
  last_selected_container_indx = false,
  last_selected_property_indx = false
}
function GedPropPanel:InitControls()
  GedPanel.InitControls(self)
  self.idContainer:SetPadding(box(0, 3, 0, 0))
  self.idContainer:SetLayoutVSpacing(5)
  self.collapsed_categories = {}
  self.selected_properties = {}
  GedPanel.SetSearchActionContexts(self, self.SearchActionContexts)
  local host = GetActionsHost(self)
  if not host:ActionById("EditCode") then
    XAction:new({
      ActionId = "EditCode",
      ActionContexts = {
        self.PropActionContext
      },
      ActionName = "Edit Code",
      ActionTranslate = false,
      OnAction = function(action, host)
        local panel = host:GetLastFocusedPanel()
        if IsKindOf(panel, "GedPropPanel") then
          self:Send("GedEditFunction", panel.context, panel:GetSelectedProperties())
        end
      end,
      ActionState = function(action, host)
        local panel = host:GetLastFocusedPanel()
        if not IsKindOf(panel, "GedPropPanel") then
          return "hidden"
        end
        local selected = panel.selected_properties
        if not selected or #selected ~= 1 then
          return "hidden"
        end
        local prop_meta = selected[1].prop_meta
        if prop_meta.editor ~= "func" and prop_meta.editor ~= "expression" and prop_meta.editor ~= "script" then
          return "hidden"
        end
      end
    }, self)
  end
  local show_collapse_action = self.EnableCollapseDefault and not self.Embedded
  if show_collapse_action and not self.collapse_default_button then
    self.collapse_default_button = XTemplateSpawn("GedToolbarToggleButtonSmall", self.idTitleContainer)
    self.collapse_default_button:SetId("idCollapseDefaultBtn")
    self.collapse_default_button:SetIcon("CommonAssets/UI/Ged/collapse.tga")
    self.collapse_default_button:SetRolloverText(T(912785185075, "Hide/show all properties with default values"))
    self.collapse_default_button:SetBackground(self.idTitleContainer:GetBackground())
    self.collapse_default_button:SetToggled(self.CollapseDefault)
    function self.collapse_default_button.OnPress(button)
      self:SetFocus()
      self:SetCollapseDefault(not self.CollapseDefault)
      button:SetToggled(not button:GetToggled())
    end
  end
  local show_internal_names_action = self.EnableShowInternalNames and not self.Embedded
  if show_internal_names_action then
    local show_internal_names_button = XTemplateSpawn("GedToolbarToggleButtonSmall", self.idTitleContainer)
    show_internal_names_button:SetId("idShowInternalNamesBtn")
    show_internal_names_button:SetIcon("CommonAssets/UI/Ged/log-focused.tga")
    show_internal_names_button:SetRolloverText(T(496361185046, "Hide/show internal names of properties"))
    show_internal_names_button:SetBackground(self.idTitleContainer:GetBackground())
    show_internal_names_button:SetToggled(self.ShowInternalNames)
    function show_internal_names_button.OnPress(button)
      self:ShowInternalPropertyNames(not self.ShowInternalNames)
      button:SetToggled(not button:GetToggled())
    end
  end
  if not self.Embedded then
    if self.EnableCollapseCategories then
      local button = XTemplateSpawn("GedToolbarButtonSmall", self.idTitleContainer)
      button:SetIcon("CommonAssets/UI/Ged/collapse_tree.tga")
      button:SetRolloverText("Expand/collapse categories (Shift-C)")
      button:SetBackground(self.idTitleContainer:GetBackground())
      function button.OnPress()
        self:ExpandCollapseCategories()
      end
    end
    if self.app.PresetClass and self.DisplayWarnings then
      self.ShowUnusedPropertyWarnings = self.app.ShowUnusedPropertyWarnings
      local button = XTemplateSpawn("GedToolbarToggleButtonSmall", self.idTitleContainer)
      button:SetIcon("CommonAssets/UI/Ged/warning_button.tga")
      button:SetRolloverText("Show/hide unused property warnings")
      button:SetBackground(self.idTitleContainer:GetBackground())
      button:SetToggled(self.ShowUnusedPropertyWarnings)
      function button.OnPress(button)
        self.ShowUnusedPropertyWarnings = not self.ShowUnusedPropertyWarnings
        button:SetToggled(not button:GetToggled())
        self:UpdatePropertyNames(self.ShowInternalNames)
      end
    end
  end
end
function GedPropPanel:Open(...)
  GedPanel.Open(self, ...)
  self:CreateThread("update", self.UpdateThread, self)
  GetActionsHost(self, true):ActionById("EditCode").ActionContexts = {
    self.PropActionContext
  }
end
function GedPropPanel:ShowInternalPropertyNames(value)
  if self.ShowInternalNames ~= value then
    self.ShowInternalNames = value
    self:UpdatePropertyNames(value)
  end
end
function GedPropPanel:SetSelection(properties)
  if not properties then
    return
  end
  self:ClearSelectedProperties()
  for con_indx, win in ipairs(self.idContainer) do
    for cat_indx, item in ipairs(win.idCategory) do
      for _, id in ipairs(properties) do
        if item.prop_meta.id == id then
          self:AddToSelected(item, con_indx, cat_indx)
        end
      end
    end
  end
end
function GedPropPanel:OnMouseButtonDown(pos, button)
  local prop, container_indx, category_indx = self:GetGedPropAt(pos)
  local selected_props = self.selected_properties
  if button == "L" then
    self:SetFocus()
    self.app:SetLastFocusedPanel(self)
    if prop then
      if #selected_props == 0 then
        self:AddToSelected(prop, container_indx, category_indx)
      elseif terminal.IsKeyPressed(const.vkControl) then
        if prop.selected then
          self:RemoveFromSelected(prop, container_indx, category_indx)
        else
          self:AddToSelected(prop, container_indx, category_indx)
        end
      elseif terminal.IsKeyPressed(const.vkShift) then
        self:ShiftSelectMultiple(prop, container_indx, category_indx)
      else
        local current_prop_selected = prop.selected
        self:ClearSelectedProperties()
        if not current_prop_selected then
          self:AddToSelected(prop, container_indx, category_indx)
        end
      end
    else
      self:ClearSelectedProperties()
    end
    return "break"
  elseif button == "R" then
    self:SetFocus()
    local action_context = self:GetActionContext()
    if prop then
      if #selected_props < 2 then
        self:ClearSelectedProperties()
        self:AddToSelected(prop, container_indx, category_indx)
      end
      action_context = self.PropActionContext
    end
    local host = GetActionsHost(self, true)
    if host then
      host:OpenContextMenu(action_context, pos)
    end
    return "break"
  end
end
function GedPropPanel:GetSelectedProperties()
  local selected_ids = {}
  for _, prop in ipairs(self.selected_properties) do
    table.insert(selected_ids, prop.prop_meta.id)
  end
  return selected_ids
end
function GedPropPanel:ShiftSelectMultiple(prop, container_indx, category_indx)
  self:ClearSelectedProperties("keep_last_selected_container_indx")
  local con_indx = container_indx
  local max_con_indx = container_indx
  local cat_indx = category_indx
  local cat_max_indx = self.last_selected_property_indx
  if category_indx > self.last_selected_property_indx then
    cat_indx = self.last_selected_property_indx
    cat_max_indx = category_indx
  end
  if container_indx ~= self.last_selected_container_indx then
    if container_indx > self.last_selected_container_indx then
      con_indx = self.last_selected_container_indx
      max_con_indx = container_indx
      cat_indx = self.last_selected_property_indx
      cat_max_indx = category_indx
    else
      con_indx = container_indx
      max_con_indx = self.last_selected_container_indx
      cat_indx = category_indx
      cat_max_indx = self.last_selected_property_indx
    end
  end
  local container = false
  local category_cnt = false
  local shift_select = true
  while shift_select do
    container = self.idContainer[con_indx]
    category_cnt = con_indx == max_con_indx and cat_max_indx or #container.idCategory
    if container.idCategory.visible then
      for i = cat_indx, category_cnt do
        self:AddToSelected(container.idCategory[i], self.last_selected_container_indx, self.last_selected_property_indx)
      end
    end
    con_indx = con_indx + 1
    cat_indx = 1
    if max_con_indx < con_indx then
      shift_select = false
    end
  end
end
function GedPropPanel:OnShortcut(shortcut, source, ...)
  local res = GedPanel.OnShortcut(self, shortcut, source, ...)
  if res == "break" then
    return res
  end
  if shortcut == "Escape" or shortcut == "ButtonB" then
    self:ClearSelectedProperties()
  end
end
function GedPropPanel:ClearSelectedProperties(keep_last_selected)
  local selected_props = self.selected_properties
  for i = 1, #selected_props do
    selected_props[i]:SetSelected(false)
    selected_props[i] = nil
  end
  if not keep_last_selected then
    self.last_selected_container_indx = false
    self.last_selected_property_indx = false
  end
end
function GedPropPanel:AddToSelected(prop, con_indx, prop_indx)
  prop:SetSelected(true)
  local selected_props = self.selected_properties
  selected_props[#selected_props + 1] = prop
  self.last_selected_container_indx = con_indx
  self.last_selected_property_indx = prop_indx
end
function GedPropPanel:RemoveFromSelected(prop, con_indx, prop_indx)
  prop:SetSelected(false)
  local selected_props = self.selected_properties
  local indx = table.find(selected_props, prop)
  selected_props[indx] = nil
  self.last_selected_container_indx = con_indx
  self.last_selected_property_indx = prop_indx
end
function GedPropPanel:GetGedPropAt(pt)
  for container_indx, container in ipairs(self.idContainer) do
    if container:HasMember("idCategory") and container.idCategory.visible then
      for gedprop_index, gedprop in ipairs(container.idCategory) do
        if gedprop:MouseInWindow(pt) then
          return gedprop, container_indx, gedprop_index
        end
      end
    end
  end
end
function GedPropPanel:SetCollapseDefault(value)
  if self.CollapseDefault ~= value then
    self.CollapseDefault = value
    self.rebuild_props = true
    self:RequestUpdate()
  end
end
function GedPropPanel:BindViews()
  if not self.context then
    return
  end
  self:UnbindView("props")
  self:UnbindView("values")
  self:BindView("props", "GedGetProperties", self.SuppressProps)
  self:BindView("values", "GedGetValues")
end
function GedPropPanel:OnContextUpdate(context, view)
  GedPanel.OnContextUpdate(self, context, view)
  if view == nil then
    self.parent_obj_id = self.connection.bound_objects[context]
    self.parent_changed = true
    self.parent_changed_notified = true
    self.connection.bound_objects[context .. "|values"] = nil
    self:RequestUpdate()
  end
  if view == "values" then
    self.rebuild_props = self.rebuild_props or self.CollapseDefault
    self:RequestUpdate()
  end
  if view == "props" then
    self.rebuild_props = true
    self:RequestUpdate()
    if view == "props" then
      self:RebuildTabs()
    end
  end
end
function GedPropPanel:GetTabsData()
  local data = self:Obj(self.context .. "|props")
  local tabs = data and data.tabs
  if not tabs then
    return
  end
  if tabs[#tabs].TabName ~= "Other" then
    local categories = {}
    for _, prop in ipairs(data) do
      categories[prop.category or "Misc"] = true
    end
    local allcats = table.copy(categories)
    for i = #tabs, 1, -1 do
      local tab = tabs[i]
      local has_content
      for category in pairs(tab.Categories) do
        has_content = has_content or allcats[category]
        categories[category] = nil
      end
      if not has_content then
        table.remove(tabs, i)
      end
    end
    if self.app.PresetClass == "XTemplate" then
      categories.Template = nil
    end
    tabs[#tabs + 1] = {
      TabName = #table.keys(categories) == 1 and next(categories) or "Other",
      Categories = categories
    }
  end
  return tabs
end
function GedPropPanel:RebuildTabs()
  local container = rawget(self, "idTabContainer")
  container = container or XWindow:new({
    Id = "idTabContainer",
    LayoutMethod = "HList",
    Dock = "bottom",
    ZOrder = -1
  }, self.idTitleContainer)
  container:DeleteChildren()
  local tabs = self:GetTabsData()
  self.idContainer:SetLayoutVSpacing(tabs and 0 or 5)
  if not tabs then
    return
  end
  tabs = table.copy(tabs)
  table.insert(tabs, 1, {TabName = "All"})
  for _, tab in ipairs(tabs) do
    if tab.TabName == "All" or next(tab.Categories) then
      XToggleButton:new({
        Text = tab.TabName,
        Toggled = self.active_tab == tab.TabName,
        OnChange = function(button)
          self.active_tab = tab.TabName
          self:RebuildTabs()
          self:UpdateVisibility()
        end,
        Padding = box(2, 1, 2, 1),
        BorderWidth = 1
      }, container)
    end
  end
  Msg("XWindowRecreated", container)
end
function GedPropPanel:RequestUpdate()
  self.update_request = true
  Wakeup(self:GetThread("update"))
end
local is_slider_dragged = function()
  return IsKindOfClasses(terminal.desktop:GetMouseCapture(), "XSleekScroll", "XCurveEditor")
end
function GedPropPanel:UpdateThread()
  while true do
    if not self.update_request then
      WaitWakeup()
      if self.app.window_state == "closing" or self.window_state == "destroying" or not self.context then
        return
      end
    end
    self.update_request = false
    self:ClearSelectedProperties()
    while is_slider_dragged() do
      if self.app.window_state == "closing" or self.window_state == "destroying" or not self.context then
        return
      end
      self:Update(false)
      Sleep(50)
    end
    if self.app.window_state == "closing" or self.window_state == "destroying" or not self.context then
      return
    end
    self:Update(self.rebuild_props)
  end
end
function GedPropPanel:RemoteSetProperty(obj, prop_id, value, parent_obj_id, slider_drag_id)
  local rebuild_pending = self.rebuild_props and not slider_drag_id
  if not rebuild_pending and not self.parent_changed and (parent_obj_id or false) == self.parent_obj_id then
    return self.app:Op("GedSetProperty", obj, prop_id, value, not self.EnableUndo, slider_drag_id or is_slider_dragged())
  end
end
function GedPropPanel:Update(rebuild_props)
  local has_values = self:Obj(self.context .. "|values")
  if has_values and rebuild_props then
    local scroll_pos = self.idScroll.Scroll
    self:RebuildControls()
    self.idScroll:ScrollTo(scroll_pos)
    self.rebuild_props = false
  else
    for _, category_window in ipairs(self.idContainer) do
      if category_window:HasMember("idCategory") then
        for _, win in ipairs(category_window.idCategory) do
          if has_values then
            win:UpdateValue(self.parent_changed_notified)
          end
          win.parent_obj_id = self.parent_obj_id
        end
      end
    end
  end
  if has_values then
    self.parent_changed_notified = false
  end
  self.parent_changed = false
  self:QueueReassignFocusOrders()
end
function GedPropPanel:ShouldShowButtonForFunc(func_name)
  if rawget(self.app, "suppress_property_buttons") and table.find(self.app.suppress_property_buttons, func_name) then
    return
  end
  return true
end
function GedPropPanel:QueueReassignFocusOrders(x, y)
  local obj = self
  while obj and obj.Embedded do
    obj = GetParentOfKind(obj.parent, "GedPropPanel")
  end
  if obj and not obj:IsThreadRunning("ReasignFocusOrders") then
    obj:CreateThread("ReasignFocusOrders", function()
      obj:ReassignFocusOrders(x, y)
    end)
  end
end
function GedPropPanel:UpdateFilter()
  self:UpdateVisibility()
end
local function find_parent_prop_panel(xcontrol)
  return (not xcontrol:HasMember("panel") or not xcontrol.panel) and xcontrol.parent and find_parent_prop_panel(xcontrol.parent)
end
function GedPropPanel:RebuildControls()
  local editors_by_hash = {}
  for _, category_window in ipairs(self.idContainer) do
    if category_window:HasMember("idCategory") then
      for _, editor in ipairs(category_window.idCategory) do
        local hash = xxhash(editor:GetContext(), table.hash(editor.prop_meta))
        editors_by_hash[hash] = editor
        editor:DetachForReuse()
      end
    end
  end
  self.idContainer:Clear()
  local matching_props = {}
  local obj_id = self:Obj(self.context)
  for _, panel in pairs(self.app.interactive_panels) do
    local res = panel.search_value_results
    if res and type(res[obj_id]) == "table" then
      for idx, prop in ipairs(res[obj_id]) do
        matching_props[prop] = true
      end
      break
    end
  end
  local categories = {}
  local sort_priority = 1
  local context = self.context
  local values = self:Obj(context .. "|values") or empty_table
  local props = self:Obj(context .. "|props") or empty_table
  table.stable_sort(props, function(a, b)
    return (a.sort_order or 0) < (b.sort_order or 0)
  end)
  local filter_text = self:GetFilterText()
  local focus = self.desktop.keyboard_focus
  local order = focus and focus:IsWithin(self) and focus:GetFocusOrder()
  local category_data = self:Obj("root|categories") or empty_table
  local parent_panel = find_parent_prop_panel(self)
  local collapse_default = filter_text == "" and (self.CollapseDefault or self.Embedded and parent_panel and parent_panel.CollapseDefault)
  for _, prop_meta in ipairs(props) do
    if not collapse_default or prop_meta.editor == "buttons" or values[prop_meta.id] ~= nil and values[prop_meta.id] ~= prop_meta.default then
      local group
      local category = prop_meta.category or "Misc"
      local idx = table.find(categories, "category", category)
      if idx then
        group = categories[idx]
      else
        group = {
          prop_metas = {},
          category = category,
          category_name = category,
          priority = sort_priority
        }
        sort_priority = sort_priority + 1
        local property_category = category_data and category_data[category]
        if property_category then
          group.category_name = _InternalTranslate(property_category.display_name, property_category)
          group.priority = group.priority + property_category.SortKey * 1000
        end
        table.insert(categories, group)
      end
      table.insert(group.prop_metas, prop_meta)
    end
  end
  if #categories == 0 then
    if collapse_default or self.Embedded then
      local text = XText:new({
        Id = "idNoPropsToShow",
        MaxWidth = self.MinWidth,
        MaxHeight = 24,
        TextHAlign = "center"
      }, self.idContainer)
      text:SetText(collapse_default and "No properties with non-default value were found." or "The object has no properties.")
      text:Open()
    end
  else
    table.stable_sort(categories, function(a, b)
      return a.priority < b.priority
    end)
    for i, group in ipairs(categories) do
      local category_window = XWindow:new({IdNode = true, FoldWhenHidden = true}, self.idContainer)
      local container = XWindow:new({
        Id = "idCategory",
        LayoutMethod = "VList",
        LayoutVSpacing = 0,
        FoldWhenHidden = true
      }, category_window)
      local button = XTextButton:new({
        Id = "idCategoryButton",
        Dock = "top",
        FoldWhenHidden = true,
        LayoutMethod = "VList",
        Padding = box(2, 2, 2, 2),
        Background = RGBA(38, 146, 227, 255),
        FocusedBackground = RGBA(24, 123, 197, 255),
        DisabledBackground = RGBA(128, 128, 128, 255),
        OnPress = function(button)
          self:ExpandCategory(container, group.category, not container:GetVisible(), not self.Embedded and "save_settings")
        end,
        RolloverBackground = RGBA(24, 123, 197, 255),
        PressedBackground = RGBA(13, 113, 187, 255),
        Image = "CommonAssets/UI/round-frame-20.tga",
        ImageScale = point(500, 500),
        FrameBox = box(9, 9, 9, 9)
      }, category_window)
      button:SetTextStyle("GedButton")
      button:SetText(group.category_name)
      button:SetVisible(not self.HideFirstCategory or i ~= 1)
      if self.collapsed_categories[group.category] then
        container:SetVisible(false)
      end
      rawset(category_window, "category", group.category)
      category_window:Open()
      local values_name = context .. "|values"
      for p, prop_meta in ipairs(group.prop_metas) do
        local editor_name = prop_meta.editor or prop_meta.type
        local editor_class = GedPropEditors[editor_name or false]
        if not editor_class then
        elseif not g_Classes[editor_class] then
        else
          local context = self.context .. "." .. prop_meta.id
          local editor = editors_by_hash[xxhash(context, table.hash(prop_meta))]
          if editor then
            editor:SetParent(container)
            editor:SetContext(context)
          else
            editor = g_Classes[editor_class]:new({panel = self, obj = values_name}, container, context, prop_meta)
            editor:Open()
          end
          editor:SetHighlightSearchMatch(matching_props[prop_meta.id])
          editor:UpdatePropertyNames(self.ShowInternalNames)
          editor:UpdateValue(true)
          editor.parent_obj_id = self.parent_obj_id
        end
      end
    end
    self:UpdateVisibility()
    self:ReassignFocusOrders()
    focus = self:GetRelativeFocus(order, "nearest")
    if focus then
      focus:SetFocus()
    end
  end
  self:TryHighlightSearchMatch("skip_visibility_update")
  Msg("XWindowRecreated", self)
  for _, editor in pairs(editors_by_hash) do
    if not editor.parent then
      editor:delete()
    end
  end
end
function GedPropPanel:ReassignFocusOrders(x, y)
  x = x or self.focus_column
  y = y or 0
  if self.window_state == "destroying" then
    return y
  end
  for _, category_window in ipairs(self.idContainer) do
    if category_window:GetVisible() and category_window:HasMember("idCategory") then
      for _, prop_editor in ipairs(category_window.idCategory) do
        y = prop_editor:ReassignFocusOrders(x, y)
      end
    end
  end
  return y
end
function GedPropPanel:UpdatePropertyNames(internal)
  for _, category_window in ipairs(self.idContainer) do
    for _, prop_editor in ipairs(rawget(category_window, "idCategory") or empty_table) do
      prop_editor:UpdatePropertyNames(internal)
    end
  end
end
function GedPropPanel:IsPropEditorVisible(prop_editor, filter_text, highlight_text)
  local tab = self.active_tab
  local tabs = self:GetTabsData()
  if tab ~= "All" and tabs then
    local prop = prop_editor.prop_meta
    local tab_data = table.find_value(tabs, "TabName", tab)
    if tab_data and not tab_data.Categories[prop.category or "Misc"] then
      return false
    end
  end
  return prop_editor:FindText(filter_text, highlight_text)
end
function GedPropPanel:UpdateVisibility()
  local values = self.context and self:Obj(self.context .. "|values")
  if not values then
    return
  end
  local filter_text = self:GetFilterText()
  local highlight_text = self:GetHighlightText()
  for _, category_window in ipairs(self.idContainer) do
    local hidden = 0
    local prop_editors = rawget(category_window, "idCategory") or empty_table
    for _, prop_editor in ipairs(prop_editors) do
      local visible = self:IsPropEditorVisible(prop_editor, filter_text, highlight_text)
      prop_editor:SetVisible(visible)
      if not visible then
        hidden = hidden + 1
      end
    end
    category_window:SetVisible(hidden ~= #prop_editors)
  end
end
function GedPropPanel:LocateEditorById(id)
  if self.window_state == "destroying" then
    return
  end
  for _, category_window in ipairs(self.idContainer) do
    if category_window:HasMember("idCategory") then
      for _, prop_editor in ipairs(category_window.idCategory) do
        if prop_editor.prop_meta.id == id then
          return prop_editor
        end
      end
    end
  end
end
function GedPropPanel:TryHighlightSearchMatch(skip_visibility_update)
  local match_data = self.app:GetDisplayedSearchResultData()
  local obj_id = self:Obj(self.context)
  if match_data and match_data.path[#match_data.path] == obj_id then
    if self.desktop:GetKeyboardFocus().Id ~= "idSearchEdit" then
      self:FocusPropEditor(match_data.prop)
    end
    self.app.display_search_result = false
  end
  if not skip_visibility_update then
    self:UpdateVisibility()
  end
end
function GedPropPanel:FocusPropEditor(prop_id)
  local old_focused = self.search_value_focused_prop_editor
  if old_focused and old_focused.parent and old_focused.window_state ~= "destroying" then
    old_focused:HighlightAndSelect(false)
  end
  local highlight_text = self:GetHighlightText()
  local prop_editor = self:LocateEditorById(prop_id)
  local focus = highlight_text and prop_editor and prop_editor:HighlightAndSelect(highlight_text)
  if focus then
    local scrollarea = self.idContainer
    local parent = GetParentOfKind(scrollarea.parent, "XScrollArea")
    while parent do
      scrollarea = parent
      parent = GetParentOfKind(scrollarea.parent, "XScrollArea")
    end
    scrollarea:ScrollIntoView(focus)
  end
  self.search_value_focused_prop_editor = prop_editor
end
function GedPropPanel:ExpandCategory(container, category, expand, save_settings)
  self.collapsed_categories[category] = not expand
  if save_settings then
    self:SaveCollapsedCategories(self.context)
  end
  container:SetVisible(expand)
end
function GedPropPanel:SaveCollapsedCategories(key)
  local app = self.app
  local settings = app.settings.collapsed_categories or {}
  settings[key] = self.collapsed_categories
  app.settings.collapsed_categories = settings
  app:SaveSettings()
end
function GedPropPanel:ExpandCollapseCategories()
  if self.window_state == "destroying" then
    return
  end
  local has_expanded
  for _, category_window in ipairs(self.idContainer) do
    if category_window:HasMember("idCategory") and category_window.idCategory:GetVisible() then
      has_expanded = true
      break
    end
  end
  for _, category_window in ipairs(self.idContainer) do
    if category_window:HasMember("idCategory") then
      self:ExpandCategory(category_window.idCategory, category_window.category, not has_expanded, false)
    end
  end
end
DefineClass.GedListPanel = {
  __parents = {"GedPanel"},
  properties = {
    {
      category = "General",
      id = "FormatFunc",
      editor = "text",
      default = "GedListObjects"
    },
    {
      category = "General",
      id = "Format",
      editor = "text",
      default = "<name>"
    },
    {
      category = "General",
      id = "AllowObjectsOnly",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "FilterName",
      editor = "text",
      default = ""
    },
    {
      category = "General",
      id = "FilterClass",
      editor = "text",
      default = ""
    },
    {
      category = "General",
      id = "SelectionBind",
      editor = "text",
      default = ""
    },
    {
      category = "General",
      id = "OnDoubleClick",
      editor = "func",
      params = "self, item_idx",
      default = function(self, item_idx)
      end
    },
    {
      category = "General",
      id = "MultipleSelection",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "EmptyText",
      editor = "text",
      default = ""
    },
    {
      category = "Common Actions",
      id = "ItemClass",
      editor = "expression",
      params = "gedapp",
      default = function(gedapp)
        return ""
      end
    },
    {
      category = "Context Menu",
      id = "ItemActionContext",
      editor = "text",
      default = ""
    }
  },
  ContainerControlClass = "XList",
  Interactive = true,
  EnableSearch = true,
  Translate = true,
  pending_update = false,
  pending_selection = false,
  restoring_state = false
}
function GedListPanel:InitControls()
  GedPanel.InitControls(self)
  local list = self.idContainer
  function list.OnSelection(list, ...)
    self:OnSelection(...)
  end
  function list.OnDoubleClick(list, item_idx)
    self:OnDoubleClick(item_idx)
  end
  list:SetLayoutVSpacing(2)
  list:SetMultipleSelection(true)
  list:SetActionContext(self.ActionContext)
  list:SetItemActionContext(self.ItemActionContext)
  GedPanel.SetSearchActionContexts(self, self.SearchActionContexts)
end
function GedListPanel:Done()
  for bind in string.gmatch(self.SelectionBind .. ",", reCommaList) do
    self.connection:UnbindObj(bind)
  end
end
function GedListPanel:BindViews()
  if self.FilterName ~= "" and self.FilterClass then
    self.connection:BindFilterObj(self.context .. "|list", self.FilterName, self.FilterClass)
  end
  self:BindView("list", self.FormatFunc, self.Format, self.AllowObjectsOnly)
end
function GedListPanel:GetSelection()
  local selection = self.pending_selection or self.idContainer:GetSelection()
  if not selection or not next(selection) then
    return
  end
  return selection[1], selection
end
function GedListPanel:GetMultiSelection()
  return self.idContainer:GetSelection()
end
function GedListPanel:SetSelection(selection, multiple_selection, notify, restoring_state)
  if restoring_state or self.pending_update then
    self.pending_selection = multiple_selection or selection
    self.restoring_state = restoring_state
    return
  end
  self.idContainer:SetSelection(multiple_selection or selection, notify)
end
function GedListPanel:OnSelection(selected_item, selected_items)
  self:BindSelectedObject(selected_item, selected_items)
end
function GedListPanel:SetSelectionAndFocus(idx)
  local list = self.idContainer
  if list:GetSelection() == idx then
    self.app:TryHighlightSearchMatchInChildPanels(self)
  else
    local focus = self.desktop:GetKeyboardFocus()
    if not focus or focus.Id ~= "idSearchEdit" then
      self:SetFocus()
    end
    list:SetSelection(idx)
  end
end
function GedListPanel:TryHighlightSearchMatch()
  local obj_id = self:Obj(self.context)
  local match_data = self.app:GetDisplayedSearchResultData()
  if match_data then
    local match_path = match_data.path
    local match_idx = table.find(match_path, obj_id)
    if match_idx and match_idx < #match_path then
      local match_id = match_path[match_idx + 1]
      local list = self:Obj(self.context .. "|list")
      local ids = list.ids or empty_table
      for idx in ipairs(list) do
        if ids[idx] == match_id then
          self:SetSelectionAndFocus(idx)
          break
        end
      end
    end
  end
end
function GedListPanel:OnContextUpdate(context, view)
  GedPanel.OnContextUpdate(self, context, view)
  if view == nil then
    self.idContainer:SetSelection(false)
    self.pending_update = true
  end
  if view == "list" then
    self:UpdateContent()
    if self.search_values then
      self:StartUpdateFilterThread("not_user_initiated")
    end
    self:TryHighlightSearchMatch()
  end
  if view == "warning" and self.DisplayWarnings then
    self:UpdateContent()
  end
end
function GedListPanel:BindSelectedObject(selected_item, selected_indexes)
  if not selected_item then
    return
  end
  self.app:StoreAppState()
  for bind in string.gmatch(self.SelectionBind .. ",", reCommaList) do
    if self.MultipleSelection and selected_indexes and 1 < #selected_indexes then
      self.app:SelectAndBindMultiObj(bind, self.context, selected_indexes)
    else
      self.app:SelectAndBindObj(bind, {
        self.context,
        selected_item
      })
    end
  end
end
function GedListPanel:UpdateContent()
  if not self.context then
    return
  end
  local list = self:Obj(self.context .. "|list")
  if not list then
    self.idContainer:Clear()
    return
  end
  local sel = self.pending_selection or self.idContainer:GetSelection()
  local scroll_pos = self.idScroll.Scroll
  local filtered, ids = list.filtered, list.ids
  local filter_text = self:GetFilterText()
  if filter_text == "" then
    filter_text = false
  end
  local warning_idxs = self.DisplayWarnings and get_warning_nodes(self) or empty_table
  if #warning_idxs == 0 then
    warning_idxs = false
  end
  local container = self.idContainer
  container:Clear()
  local string_format = string.format
  for i, item_text in ipairs(list) do
    local str = "<literal(text,true)>"
    if warning_idxs and table.find(warning_idxs, i) then
      str = string_format("<underline>%s</underline>", str)
    end
    local item_id = ids and ids[i]
    if item_id then
      str = string_format("<ged_marks('%s')>%s", item_id, str)
    end
    str = T({
      str,
      text = item_text,
      untranslated = true
    })
    local item = container:CreateTextItem(str, {Translate = true})
    if filtered and filtered[i] or filter_text and self:FilterItem(item_text, item_id, filter_text) then
      item:SetDock("ignore")
      item:SetVisible(false)
    end
  end
  if #list == 0 and self.EmptyText then
    self.idContainer:CreateTextItem(self.EmptyText)
  end
  self.idScroll:ScrollTo(scroll_pos)
  self.idContainer:SetSelection(sel, self.pending_update and not self.restoring_state)
  self.pending_update = false
  self.pending_selection = false
  self.restoring_state = false
  Msg("XWindowRecreated", self)
end
function GedListPanel:FocusFirstEntry()
  for idx, value in ipairs(self.idContainer) do
    if value.Dock ~= "ignore" then
      self.idContainer:SetSelection(idx)
      break
    end
  end
  self:SetPanelFocused()
end
function GedListPanel:UpdateFilter()
  self:UpdateContent()
end
function GedListPanel:UpdateItemTexts()
  self:UpdateTitle(self.context)
  for _, item in ipairs(self.idContainer) do
    item[1]:SetText(item[1]:GetText())
  end
end
function GedListPanel:IsEmpty()
  local list = self:Obj(self.context .. "|list")
  return list and 0 < #list
end
DefineClass.GedTreePanel = {
  __parents = {"GedPanel"},
  properties = {
    {
      category = "General",
      id = "FormatFunc",
      editor = "text",
      default = "GedObjectTree"
    },
    {
      category = "General",
      id = "Format",
      editor = "text",
      default = "<name>"
    },
    {
      category = "General",
      id = "AltFormat",
      editor = "text",
      default = ""
    },
    {
      category = "General",
      id = "AllowObjectsOnly",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "FilterName",
      editor = "text",
      default = ""
    },
    {
      category = "General",
      id = "FilterClass",
      editor = "text",
      default = ""
    },
    {
      category = "General",
      id = "SelectionBind",
      editor = "text",
      default = ""
    },
    {
      category = "General",
      id = "OnSelectionChanged",
      editor = "func",
      params = "self, selection",
      default = function(self, selection)
      end
    },
    {
      category = "General",
      id = "OnCtrlClick",
      editor = "func",
      params = "self, selection",
      default = function(self, selection)
      end
    },
    {
      category = "General",
      id = "OnDoubleClick",
      editor = "func",
      params = "self, selection",
      default = function(self, selection)
      end
    },
    {
      category = "General",
      id = "MultipleSelection",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "EmptyText",
      editor = "text",
      default = ""
    },
    {
      category = "Common Actions",
      id = "EnableForRootLevelItems",
      editor = "bool",
      default = false
    },
    {
      category = "Common Actions",
      id = "ItemClass",
      editor = "expression",
      params = "gedapp",
      default = function(gedapp)
        return ""
      end
    },
    {
      category = "Context Menu",
      id = "RootActionContext",
      editor = "text",
      default = ""
    },
    {
      category = "Context Menu",
      id = "ChildActionContext",
      editor = "text",
      default = ""
    },
    {
      category = "Layout",
      id = "FullWidthText",
      editor = "bool",
      default = false
    },
    {
      category = "Layout",
      id = "ShowToolbarButtons",
      name = "Show toolbar buttons",
      editor = "bool",
      default = true,
      help = "Show/hide the buttons in the TreePanel toolbar (expand/collapse tree, etc)"
    }
  },
  ContainerControlClass = "XTree",
  HorizontalScroll = true,
  EnableSearch = true,
  Interactive = true,
  Translate = true,
  expanding_node = false,
  currently_selected_path = false,
  pending_update = false,
  pending_selection = false,
  alt_format_enabled = false,
  filtered_tree = false,
  view_warnings_only = false,
  view_errors_only = false
}
function GedTreePanel:InitControls()
  GedPanel.InitControls(self)
  local tree = self.idContainer
  tree:SetSortChildNodes(false)
  function tree.GetNodeChildren(tree, ...)
    return self:GetNodeChildren(...)
  end
  function tree.InitNodeControls(tree, ...)
    self:InitNodeControls(...)
  end
  function tree.OnSelection(tree, selection, selected_indexes)
    self:OnSelection(selection, selected_indexes)
  end
  function tree.OnCtrlClick(tree, ...)
    self:OnCtrlClick(...)
  end
  function tree.OnUserExpandedNode(tree, path)
    self:OnUserExpandedNode(path)
  end
  function tree.OnUserCollapsedNode(tree, path)
    self:OnUserCollapsedNode(path)
  end
  function tree.OnDoubleClickedItem(tree, path)
    self:OnDoubleClick(path)
  end
  tree:SetActionContext(self.ActionContext)
  tree:SetRootActionContext(self.RootActionContext)
  tree:SetChildActionContext(self.ChildActionContext)
  tree:SetMultipleSelection(true)
  tree:SetFullWidthText(self.FullWidthText)
  GedPanel.SetSearchActionContexts(self, self.SearchActionContexts)
  local alt_format_button = XTemplateSpawn("GedToolbarToggleButtonSmall", self.idTitleContainer)
  alt_format_button:SetId("idAltFormatButton")
  alt_format_button:SetIcon("CommonAssets/UI/Ged/log-focused.tga")
  alt_format_button:SetRolloverText(T(185486815318, "Hide/show alternative names"))
  alt_format_button:SetBackground(self.idTitleContainer:GetBackground())
  alt_format_button:SetToggled(false)
  alt_format_button:SetFoldWhenHidden(true)
  alt_format_button:SetVisible(self.AltFormat and self.AltFormat ~= "")
  function alt_format_button.OnPress(button)
    self.alt_format_enabled = not button:GetToggled()
    button:SetToggled(self.alt_format_enabled)
    self:BindView("tree", self.FormatFunc, self.alt_format_enabled and self.AltFormat or self.Format, self.AllowObjectsOnly)
  end
  if self.ShowToolbarButtons then
    local button = XTemplateSpawn("GedToolbarButtonSmall", self.idTitleContainer)
    button:SetIcon("CommonAssets/UI/Ged/collapse_node.tga")
    button:SetRolloverText("Expand/collapse selected node's children (Alt-C)")
    button:SetBackground(self.idTitleContainer:GetBackground())
    function button.OnPress()
      self.idContainer:ExpandNodeByPath(self.idContainer:GetFocusedNodePath() or {})
      self.idContainer:ExpandCollapseChildren(self.idContainer:GetFocusedNodePath() or {}, false, "user_initiated")
    end
    local button = XTemplateSpawn("GedToolbarButtonSmall", self.idTitleContainer)
    button:SetIcon("CommonAssets/UI/Ged/collapse_tree.tga")
    button:SetRolloverText("Expand/collapse tree (Shift-C)")
    button:SetBackground(self.idTitleContainer:GetBackground())
    function button.OnPress()
      self.idContainer:ExpandCollapseChildren({}, "recursive", "user_initiated")
    end
  end
end
function GedTreePanel:Done()
  for bind in string.gmatch(self.SelectionBind .. ",", reCommaList) do
    self.connection:UnbindObj(bind)
  end
end
function GedTreePanel:BindViews()
  if self.FilterName ~= "" and self.FilterClass then
    self.connection:BindFilterObj(self.context .. "|tree", self.FilterName, self.FilterClass)
  end
  self:BindView("tree", self.FormatFunc, self.alt_format_enabled and self.AltFormat or self.Format, self.AllowObjectsOnly)
  if not terminal.desktop:GetKeyboardFocus() then
    self:SetPanelFocused()
  end
end
local function try_index(root, key, ...)
  if key and root then
    return try_index(root[key], ...)
  end
  return root
end
function GedTreePanel:GetNodeChildren(...)
  if not self.filtered_tree then
    return
  end
  local texts, is_leaf, auto_expand, rollovers, user_datas = {}, {}, {}, {}, {}
  local node_data = try_index(self.filtered_tree, ...)
  local warning_idxs = self.filtered_tree == node_data and get_warning_nodes(self) or empty_table
  if type(node_data) == "table" then
    for i, subnode in ipairs(node_data) do
      if subnode then
        local format = subnode.id and "<ged_marks('%s')><literal(text,true)>" or "<literal(text,true)>"
        if table.find(warning_idxs, i) then
          format = string.format("<underline>%s</underline>", format)
        end
        local str = subnode.id and string.format(format, subnode.id) or format
        texts[i] = T({
          str,
          text = subnode.name,
          untranslated = true
        })
        is_leaf[i] = #subnode == 0
        auto_expand[i] = not subnode.collapsed
        rollovers[i] = subnode.rollover
        user_datas[i] = subnode
      end
    end
  end
  return texts, is_leaf, auto_expand, rollovers, user_datas
end
GedTreePanel.OnShortcut = GedPanel.OnShortcut
local new_item = function(self, child, class, path, button)
  local method = child and "GedGetSubItemClassList" or "GedGetSiblingClassList"
  local items = self.app:Call(method, self.context, path, self.app.ScriptDomain)
  local title = string.format("New %s element", class)
  GedOpenCreateItemPopup(self, title, items, button, function(class)
    if self.window_state == "destroying" then
      return
    end
    self.app:Op("GedOpTreeNewItem", self.context, path, class, child and "child")
  end)
end
function GedTreePanel:InitNodeControls(node, user_data)
  local mode = user_data and user_data.child_button_mode
  if not mode then
    return
  end
  if user_data.child_class and (mode == "docked" or mode == "docked_if_empty" and #self.idContainer:GetChildNodes(node) == 0) then
    local button = XTemplateSpawn("GedPropertyButton", node)
    button:SetText("Add new...")
    button:SetDock(IsKindOf(node, "XTreeNode") and "bottom")
    button:SetZOrder(IsKindOf(node, "XTreeNode") and 0 or 1)
    button:SetMargins(IsKindOf(node, "XTreeNode") and box(40, 2, 0, 2) or box(20, 2, 0, 2))
    button:SetHAlign("left")
    function button.OnPress()
      CreateRealTimeThread(new_item, self, "child", user_data.child_class, node.path, button)
    end
    Msg("XWindowRecreated", button)
    return
  end
  if node == self.idContainer then
    return
  end
  local new_parent = XWindow:new({HandleMouse = true, HAlign = "left"}, node)
  node.idLabel:SetParent(new_parent)
  local create_button = XTemplateSpawn("GedToolbarButtonSmall", new_parent)
  create_button:SetId("idNew")
  create_button:SetDock("right")
  create_button:SetIcon("CommonAssets/UI/Ged/new.tga")
  create_button:SetVisible(false)
  function create_button.OnPress(button)
    if not self:IsThreadRunning("CreateSubItem") then
      self:CreateThread("CreateSubItem", function(self, data)
        if data.child_button_mode == "floating_combined" and data.child_class and data.sibling_class then
          local host = XActionsHost:new({}, self)
          XAction:new({
            ActionId = "AddChild",
            ActionMenubar = "menu",
            ActionTranslate = false,
            ActionName = "Add child item...",
            OnAction = function()
              CreateRealTimeThread(new_item, self, "child", data.child_class, node.path, button)
            end
          }, host)
          XAction:new({
            ActionId = "AddSibling",
            ActionMenubar = "menu",
            ActionTranslate = false,
            ActionName = "Add new item below...",
            OnAction = function()
              CreateRealTimeThread(new_item, self, false, data.sibling_class, node.path, button)
            end
          }, host)
          host:OpenPopupMenu("menu", terminal.GetMousePos())
        elseif data.child_class then
          new_item(self, "child", data.child_class, node.path, button)
        elseif data.sibling_class then
          new_item(self, false, data.sibling_class, node.path, button)
        end
      end, self, user_data)
    end
  end
  if not self:IsThreadRunning("TreeItemRollover") then
    self:CreateThread("TreeItemRollover", function(self)
      local last
      while true do
        local focus = terminal.desktop.keyboard_focus
        if not focus or not GetParentOfKind(focus, "XPopup") then
          local pt = terminal.GetMousePos()
          local rollover = GetParentOfKind(terminal.desktop:GetMouseTarget(pt), "XTreeNode")
          if rollover ~= last then
            if last and last.idNew then
              last.idNew:SetVisible(false)
            end
            last = rollover
            if last and last.idNew then
              last.idNew:SetVisible(true)
            end
          end
        end
        Sleep(50)
      end
    end, self)
  end
end
function GedTreePanel:OnUserExpandedNode(path)
  self.connection:Send("rfnTreePanelNodeCollapsed", self.context, path, false)
  local entry = try_index(self.filtered_tree, table.unpack(path))
  if entry then
    entry.collapsed = false
  end
  local orig_entry = try_index(self:Obj(self.context .. "|tree"), table.unpack(path))
  if orig_entry then
    orig_entry.collapsed = false
  end
end
function GedTreePanel:OnUserCollapsedNode(path)
  self.connection:Send("rfnTreePanelNodeCollapsed", self.context, path, true)
  local entry = try_index(self.filtered_tree, table.unpack(path))
  if entry then
    entry.collapsed = true
  end
  local orig_entry = try_index(self:Obj(self.context .. "|tree"), table.unpack(path))
  if orig_entry then
    orig_entry.collapsed = true
  end
end
function GedTreePanel:GetSelection()
  return self.idContainer:GetSelection()
end
function GedTreePanel:GetMultiSelection()
  return table.pack(self:GetSelection())
end
function GedTreePanel:SetSelection(selection, selected_keys, notify, restoring_state)
  if type(selection) == "table" and type(selection[1]) == "table" then
    selected_keys = selection[2]
    selection = selection[1]
  end
  if restoring_state or self.pending_update then
    self.pending_selection = {selection, selected_keys}
    self.restoring_state = restoring_state
    return
  end
  self.idContainer:SetSelection(selection, selected_keys, notify)
end
function GedTreePanel:BindSelectedObject(selection, selected_keys)
  if not selection then
    return
  end
  self.app:StoreAppState()
  for bind in string.gmatch(self.SelectionBind .. ",", reCommaList) do
    if self.MultipleSelection and selected_keys and 1 < #selected_keys then
      self.app:SelectAndBindMultiObj(bind, {
        self.context,
        unpack_params(selection, 1, #selection - 1)
      }, selected_keys)
    else
      self.app:SelectAndBindObj(bind, {
        self.context,
        table.unpack(selection)
      })
    end
  end
end
function GedTreePanel:OnSelection(selection, selected_keys)
  self:BindSelectedObject(selection, selected_keys)
  local old_selection = self.currently_selected_path or empty_table
  if not table.iequal(old_selection, selection) then
    self:OnSelectionChanged(selection)
    self.currently_selected_path = selection
    self.app:ActionsUpdated()
  end
end
function GedTreePanel:SetSelectionAndFocus(path)
  local tree = self.idContainer
  if not tree then
    return
  end
  if table.iequal(tree:GetSelection() or empty_table, path) then
    self.app:TryHighlightSearchMatchInChildPanels(self)
  else
    local focus = self.desktop:GetKeyboardFocus()
    if not focus or focus.Id ~= "idSearchEdit" then
      self:SetFocus()
    end
    tree:SetSelection(path)
  end
end
function GedTreePanel:TryHighlightSearchMatch()
  local match_data = self.app:GetDisplayedSearchResultData()
  if match_data then
    local match_path = match_data.path
    local max_idx, path = 0
    self.idContainer:ForEachNode(function(node)
      local text = TDevModeGetEnglishText(node:GetText())
      for idx, obj_id in ipairs(match_path) do
        if string.find(text, obj_id, 1, true) then
          max_idx = Max(max_idx, idx)
          path = node.path
        end
      end
    end)
    if 0 < max_idx then
      self:SetSelectionAndFocus(path)
    end
  end
end
function GedTreePanel:OnContextUpdate(context, view)
  GedPanel.OnContextUpdate(self, context, view)
  if view == nil then
    self.idContainer:ClearSelection(false)
    self.pending_update = true
  end
  if view == "tree" then
    self:RebuildTree()
    local tree_empty = self:IsEmpty()
    if context == "bookmarks" then
      if tree_empty then
        self:Expand(false)
      elseif not self.expanded then
        self:Expand(true)
      end
    end
    local first_update = self.app.first_update
    local sel = self.pending_selection or first_update and (tree_empty and {
      {},
      {}
    } or {
      {1},
      {1}
    }) or table.pack(self.idContainer:GetSelection())
    local scroll_pos = self.idScroll.Scroll
    self.idContainer:Clear()
    if tree_empty and self.context ~= "bookmarks" then
      self:OnSelection(empty_table)
      local text = XText:new({
        ZOrder = 1,
        Margins = box(20, 2, 0, 2)
      }, self.idContainer)
      text:SetText(self.EmptyText)
      Msg("XWindowRecreated", text)
    else
      self.idContainer:SetSelection(sel[1], sel[2], first_update or self.pending_update and not self.restoring_state)
    end
    self.idScroll:ScrollTo(scroll_pos)
    self.pending_update = false
    self.pending_selection = false
    self.app.first_update = false
    self.restoring_state = false
    self:InitNodeControls(self.idContainer, self.filtered_tree)
    Msg("XWindowRecreated", self)
    if self.search_values then
      self:StartUpdateFilterThread("not_user_initiated")
    end
    self:TryHighlightSearchMatch()
  end
end
function GedTreePanel:SetViewWarningsOnly(mode)
  if self.view_warnings_only ~= mode then
    self.view_warnings_only = mode
    if self.idSearchEdit:GetText() ~= "" then
      self:CancelSearch()
    else
      self:UpdateFilter()
    end
  end
end
function GedTreePanel:SetViewErrorsOnly(mode)
  if self.view_errors_only ~= mode then
    self.view_errors_only = mode
    if self.idSearchEdit:GetText() ~= "" then
      self:CancelSearch()
    else
      self:UpdateFilter()
    end
  end
end
function GedTreePanel:FilterItem(text, item_id, filter_text, has_child_nodes)
  local msg = get_warning_msg(item_id)
  local msg_type = msg and msg[#msg]
  local filter = GedPanel.FilterItem(self, text, item_id, filter_text)
  local children = not has_child_nodes
  if self.view_warnings_only and not self.view_errors_only then
    return filter or children and msg_type ~= "warning"
  elseif not self.view_warnings_only and self.view_errors_only then
    return filter or children and msg_type ~= "error"
  elseif self.view_warnings_only and self.view_errors_only then
    return filter or children and not msg_type
  else
    return filter
  end
end
function GedTreePanel:BuildTree(root, filter_text)
  if not root or root.filtered then
    return false
  end
  local has_child_nodes = type(root) ~= "string" and 0 < #root
  if (self.search_value_results or type(root) == "string") and self:FilterItem(root, root.id, filter_text, has_child_nodes) then
    return false
  end
  if type(root) == "string" then
    return {
      id = root.id,
      name = root
    }
  end
  local node = {
    id = root.id,
    name = root.name,
    class = root.class,
    child_button_mode = root.child_button_mode,
    child_class = root.child_class,
    sibling_class = root.sibling_class,
    rollover = root.rollover,
    collapsed = filter_text == "" and not self.view_warnings_only and not self.view_errors_only and root.collapsed
  }
  local visible = false
  for key, subnode in ipairs(root) do
    local child = self:BuildTree(subnode, filter_text) or false
    table.insert(node, child)
    if child then
      visible = true
    end
  end
  if visible or root.name and (self.search_value_results or not self:FilterItem(root.name, root.id, filter_text)) then
    return node
  end
end
function GedTreePanel:RebuildTree()
  local data = self:Obj(self.context .. "|tree")
  if not data then
    return
  end
  self.filtered_tree = self:BuildTree(data, self:GetFilterText()) or empty_table
end
function GedTreePanel:FocusFirstEntry()
  if self:GetFilterText() == "" then
    if not self:GetSelection() then
      self:SetSelection({1})
    end
    self:SetPanelFocused()
    return
  end
  local path = {}
  local root = self.filtered_tree
  while type(root) == "table" do
    local to_iterate = root
    root = nil
    for key, node in ipairs(to_iterate) do
      if node then
        root = node
        table.insert(path, key)
        break
      end
    end
  end
  self:SetSelection(path)
  self:SetPanelFocused()
end
function GedTreePanel:UpdateFilter()
  self:RebuildTree()
  local sel = table.pack(self.idContainer:GetSelection())
  local scroll_pos = self.idScroll.Scroll
  self.idContainer:Clear()
  self.idContainer:SetSelection(sel[1], sel[2], false)
  self.idScroll:ScrollTo(scroll_pos)
  self:InitNodeControls(self.idContainer, self.filtered_tree)
  Msg("XWindowRecreated", self)
end
function GedTreePanel:UpdateItemTexts()
  self:UpdateTitle(self.context)
  self.idContainer:ForEachNode(function(node)
    node.idLabel:SetText(node.idLabel:GetText())
  end)
end
function GedTreePanel:IsEmpty()
  return type(self.filtered_tree) ~= "table"
end
DefineClass.GedBreadcrumbPanel = {
  __parents = {"GedPanel"},
  properties = {
    {
      category = "General",
      id = "FormatFunc",
      editor = "text",
      default = "GedFormatObject"
    },
    {
      category = "General",
      id = "TreePanelId",
      editor = "text",
      default = ""
    }
  },
  ContainerControlClass = "XWindow",
  MaxWidth = 1000000
}
function GedBreadcrumbPanel:InitControls()
  GedPanel.InitControls(self)
  self.idContainer.LayoutMethod = "HWrap"
end
function GedBreadcrumbPanel:BindViews()
  self:BindView("path", self.FormatFunc)
end
function GedBreadcrumbPanel:OnContextUpdate(context, view)
  GedPanel.OnContextUpdate(self, context, view)
  if view == "path" then
    local pathdata = self:Obj(self.context .. "|path")
    self.idContainer:DeleteChildren()
    for k, entry in ipairs(pathdata) do
      local button = XButton:new({
        OnPress = function(button)
          self.app[self.TreePanelId]:SetSelection(entry.path)
        end,
        Background = RGBA(0, 0, 0, 0),
        RolloverBackground = RGBA(72, 72, 72, 255)
      }, self.idContainer)
      XText:new({}, button):SetText(entry.text)
      if k < #pathdata then
        XText:new({}, self.idContainer):SetText("<color 32 128 32> >> </color>")
      end
    end
    for _, win in ipairs(self.idContainer) do
      win:Open()
    end
    Msg("XWindowRecreated", self)
  end
end
DefineClass.GedTextPanel = {
  __parents = {
    "GedPanel",
    "XFontControl"
  },
  properties = {
    {
      category = "General",
      id = "FormatFunc",
      editor = "text",
      default = "GedFormatObject"
    },
    {
      category = "General",
      id = "Format",
      editor = "text",
      default = ""
    }
  },
  ContainerControlClass = "XText",
  MaxWidth = 1000000,
  TextStyle = "GedTextPanel"
}
LinkFontPropertiesToChild(GedTextPanel, "idContainer")
function GedTextPanel:InitControls()
  GedPanel.InitControls(self)
  local text = self.idContainer
  text:SetEnabled(false)
  text:SetBorderWidth(0)
  text:SetFontProps(self)
end
function GedTextPanel:GetView()
  return self.FormatFunc .. "." .. self.Format
end
function GedTextPanel:BindViews()
  self:BindView(self:GetView(), self.FormatFunc, self.Format)
end
function GedTextPanel:GetTextToDisplay()
  return self:Obj(self.context .. "|" .. self:GetView()) or ""
end
function GedTextPanel:OnContextUpdate(context, view)
  GedPanel.OnContextUpdate(self, context, view)
  if self.window_state == "open" then
    local text = self:GetTextToDisplay()
    self.idContainer:SetText(text)
    self:SetVisible(text ~= "")
  end
end
DefineClass.GedMultiLinePanel = {
  __parents = {
    "GedTextPanel"
  },
  ContainerControlClass = "XMultiLineEdit",
  TextStyle = "GedMultiLine"
}
function GedMultiLinePanel:InitControls()
  GedTextPanel.InitControls(self)
  self.idContainer:SetPlugins({
    "XCodeEditorPlugin"
  })
end
DefineClass.GedObjectPanel = {
  __parents = {"GedPanel"},
  properties = {
    {
      category = "General",
      id = "FormatFunc",
      editor = "text",
      default = "GedInspectorFormatObject"
    }
  },
  ContainerControlClass = "XScrollArea",
  MaxWidth = 1000000
}
function GedObjectPanel:BindViews()
  self:BindView("objectview", self.FormatFunc)
end
function GedObjectPanel:OnContextUpdate(context, view)
  GedPanel.OnContextUpdate(self, context, view)
  if view == "objectview" then
    self.idContainer:DeleteChildren()
    local objectview = self:Obj(self.context .. "|objectview")
    if not objectview then
      return
    end
    local metatable_id = objectview.metatable_id
    local text = objectview.name .. (objectview.metatable_id and " [ <color 128 128 216> <h OpenKey 1>" .. objectview.metatable_name .. "</h></color> ]" or "")
    local txtCtrl = XText:new({
      TextStyle = self.app.dark_mode and "GedTitleDarkMode" or "GedTitle"
    }, self.idContainer)
    txtCtrl:SetText(text)
    function txtCtrl.OnHyperLink(this, id, ...)
      if id == "OpenKey" then
        self.app:Op("GedOpBindObjByRefId", "root", objectview.metatable_id, terminal.IsKeyPressed(const.vkControl))
      end
    end
    for _, v in ipairs(objectview.members) do
      local key = v.key
      local val = v.value
      local value_id = v.value_id
      local key_id = v.key_id
      local text = (key_id and "<color 128 128 216><h OpenKey q>" .. key .. "</h></color>" or key) .. " = " .. (value_id and "<color 128 128 216><h OpenValue 2>" .. val .. "</h></color>" or val)
      local txtCtrl = XText:new({
        TextStyle = self.app.dark_mode and "GedDefaultDarkMode" or "GedDefault"
      }, self.idContainer)
      txtCtrl:SetText(text)
      function txtCtrl.OnHyperLink(this, id, ...)
        if id == "OpenKey" then
          self.app:Op("GedOpBindObjByRefId", "root", key_id, terminal.IsKeyPressed(const.vkControl))
        elseif id == "OpenValue" then
          self.app:Op("GedOpBindObjByRefId", "root", value_id, terminal.IsKeyPressed(const.vkControl))
        end
      end
    end
    self.idContainer:ScrollTo(0, 0)
  end
end
function GedObjectPanel:UpdateFilter()
  for _, container in ipairs(self) do
    if container.Id == "idContainer" then
      local search_text = self.idSearchEdit:GetText()
      for _, textChild in ipairs(container) do
        if search_text ~= "" and not string.find_lower(string.strip_tags(textChild.Text), search_text) then
          textChild:SetDock("ignore")
          textChild:SetVisible(false)
        else
          textChild:SetDock(false)
          textChild:SetVisible(true)
        end
      end
    end
  end
end
DefineClass.XPanelSizer = {
  __parents = {"XControl"},
  properties = {
    {
      category = "Visual",
      id = "Cursor",
      editor = "ui_image",
      force_extension = ".tga",
      default = "CommonAssets/UI/Controls/resize03.tga"
    },
    {
      category = "Visual",
      id = "BorderSize",
      editor = "number",
      default = 3
    }
  },
  is_horizontal = true,
  drag_start_mouse_pos = false,
  drag_start_panel1_max_sizes = false,
  drag_start_panel2_max_sizes = false,
  panel1 = false,
  panel2 = false,
  valid = true
}
function XPanelSizer:Open(...)
  local layout_method = self.parent.LayoutMethod
  self.is_horizontal = layout_method == "HPanel"
  if self.is_horizontal then
    self:SetMaxWidth(self.BorderSize)
    self:SetMinWidth(self.BorderSize)
  else
    self:SetMaxHeight(self.BorderSize)
    self:SetMinHeight(self.BorderSize)
  end
  if not self.panel1 or not self.panel2 then
    local current_index = table.find(self.parent, self)
    if current_index then
      for i = current_index - 1, 1, -1 do
        if not self.parent[i].Dock then
          self.panel1 = self.parent[i]
          break
        end
      end
      for i = current_index + 1, #self.parent do
        if not self.parent[i].Dock then
          self.panel2 = self.parent[i]
          break
        end
      end
    end
    if not self.panel1 or not self.panel2 then
      self.valid = false
    end
  end
end
function XPanelSizer:OnMouseButtonDown(pos, button)
  if not self.valid then
    return "break"
  end
  if button == "L" then
    self:SetFocus()
    self.desktop:SetMouseCapture(self)
    self.drag_start_mouse_pos = pos
    self.drag_start_panel1_max_size = point(self.panel1.MaxWidth, self.panel1.MaxHeight)
    self.drag_start_panel2_max_size = point(self.panel2.MaxWidth, self.panel2.MaxHeight)
  end
  return "break"
end
function XPanelSizer:OnMousePos(new_pos)
  if self.valid and self.desktop:GetMouseCapture() == self then
    self:MovePanel(new_pos)
  end
  return "break"
end
local MulDivRoundPoint = MulDivRoundPoint
local ElementwiseMax = function(min_value, point2)
  return point(Max(min_value, point2:x()), Max(min_value, point2:y()))
end
function XPanelSizer:MovePanel(new_pos)
  local old_pos = self.drag_start_mouse_pos
  local diff = new_pos - old_pos
  local total_size = point(0, 0)
  local min_sizes = point(0, 0)
  local total_items = 0
  local panel_pixel_sizes = point(0, 0)
  for _, win in ipairs(self.parent) do
    if not win.Dock and not IsKindOf(win, "XPanelSizer") then
      local min_width, min_height, max_width, max_height = ScaleXY(win.scale, win.MinWidth, win.MinHeight, win.MaxWidth, win.MaxHeight)
      total_size = total_size + point(max_width, max_height)
      min_sizes = min_sizes + point(min_width, min_height)
      total_items = total_items + 1
      panel_pixel_sizes = panel_pixel_sizes + win.box:size()
    end
  end
  if self.is_horizontal then
  else
  end
  local pixels_to_distribute = panel_pixel_sizes - min_sizes
  if pixels_to_distribute:x() == 0 or pixels_to_distribute:y() == 0 then
    return
  end
  local pixels_to_max_space_units = MulDivRoundPoint(total_size - min_sizes, 1000, pixels_to_distribute)
  local prop_diff = MulDivRoundPoint(diff, pixels_to_max_space_units, 1000)
  local min_diff = MulDivRoundPoint(self.panel1.scale, -ElementwiseMax(0, self.drag_start_panel1_max_size - point(self.panel1.MinWidth, self.panel1.MinHeight)), 1000)
  local max_diff = MulDivRoundPoint(self.panel2.scale, ElementwiseMax(0, self.drag_start_panel2_max_size - point(self.panel2.MinWidth, self.panel2.MinHeight)), 1000)
  prop_diff = ClampPoint(prop_diff, box(min_diff, max_diff))
  local panel1_new_max_size = self.drag_start_panel1_max_size + MulDivRoundPoint(prop_diff, 1000, self.panel1.scale)
  local panel2_new_max_size = self.drag_start_panel2_max_size - MulDivRoundPoint(prop_diff, 1000, self.panel2.scale)
  if self.is_horizontal then
    self.panel1.MaxWidth = panel1_new_max_size:x()
    self.panel2.MaxWidth = panel2_new_max_size:x()
  else
    self.panel1.MaxHeight = panel1_new_max_size:y()
    self.panel2.MaxHeight = panel2_new_max_size:y()
  end
  self.panel1:InvalidateMeasure()
  self.panel2:InvalidateMeasure()
  self.parent:InvalidateLayout()
  self.parent:UpdateLayout()
end
function XPanelSizer:GetMouseTarget(pos)
  return self, self.Cursor
end
function XPanelSizer:OnMouseButtonUp(pos, button)
  if self.valid and self.desktop:GetMouseCapture() == self and button == "L" then
    self:OnMousePos(pos)
    self.desktop:SetMouseCapture()
    self.drag_start_mouse_pos = false
  end
  return "break"
end
