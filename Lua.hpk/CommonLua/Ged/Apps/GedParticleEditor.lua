DefineClass.GedParticleEditor = {
  __parents = {"GedApp"},
  Translate = false,
  Title = "Ged Particle Editor",
  AppId = "GedParticleEditor",
  IdNode = true,
  is_ui_particle = false
}
function GedParticleEditor:SetIsUIParticle(value)
  self.is_ui_particle = value
  self:ActionsUpdated()
end
function GedParticleEditor:UpdateTitle()
  local default_title = "Ged Particle Editor"
  local sel = self.idPresets:GetSelection()
  local obj = self.connection:Obj("root|tree")
  if not sel or not obj then
    self:SetTitle(default_title)
    return
  end
  local title = obj[sel[1]][sel[2]]
  if title and type(title) == "string" then
    self:SetTitle(title:gsub("<[^>]*>", ""))
  else
    self:SetTitle(default_title)
  end
end
function GedParticleEditor:Init(parent, context)
  XAction:new({
    ActionId = "Menu.File",
    ActionMenubar = "main",
    ActionName = "File",
    ActionTranslate = false,
    OnActionEffect = "popup"
  }, self)
  XAction:new({
    ActionId = "Menu.Edit",
    ActionMenubar = "main",
    ActionName = "Edit",
    ActionTranslate = false,
    OnActionEffect = "popup"
  }, self)
  XAction:new({
    ActionId = "Menu.NewBehavior",
    ActionMenubar = "main",
    ActionName = "New Behavior",
    ActionTranslate = false,
    OnActionEffect = "popup"
  }, self)
  if not context.lock_preset then
    XAction:new({
      ActionId = "NewPreset",
      ActionMenubar = "Menu.File",
      ActionToolbar = "main",
      ActionToolbarSplit = true,
      ActionShortcut = "Ctrl-N",
      ActionName = "New Preset",
      ActionTranslate = false,
      ActionContexts = {
        "PresetsRootAction",
        "PresetsPanelAction"
      },
      ActionIcon = "CommonAssets/UI/Ged/new.tga",
      OnAction = function(self, host, win)
        host:Op("GedOpNewPreset", "root", host.idPresets:GetSelection(), host.PresetClass)
      end
    }, self)
  end
  XAction:new({
    ActionMenubar = "Menu.File",
    ActionName = "-----",
    ActionTranslate = false
  }, self)
  XAction:new({
    ActionId = "SVNShowLog",
    ActionMenubar = "Menu.File",
    ActionName = "SVN Show Log",
    ActionTranslate = false,
    ActionContexts = {
      "PresetsChildAction"
    },
    OnAction = function(self, host)
      host:Op("GedOpSVNShowLog", "SelectedPreset")
    end
  }, self)
  XAction:new({
    ActionId = "SVNShowBlame",
    ActionMenubar = "Menu.File",
    ActionName = "SVN Blame",
    ActionTranslate = false,
    ActionContexts = {
      "PresetsChildAction"
    },
    OnAction = function(self, host)
      host:Op("GedOpSVNShowBlame", "SelectedPreset")
    end
  }, self)
  XAction:new({
    ActionId = "SVNShowDiff",
    ActionMenubar = "Menu.File",
    ActionName = "SVN Diff",
    ActionTranslate = false,
    ActionContexts = {
      "PresetsChildAction"
    },
    OnAction = function(self, host)
      host:Op("GedOpSVNShowDiff", "SelectedPreset")
    end
  }, self)
  XAction:new({
    ActionId = "Exit",
    ActionMenubar = "Menu.File",
    ActionName = "Exit",
    ActionTranslate = false,
    OnAction = function()
      self:Exit()
    end
  }, self)
  XAction:new({
    ActionId = "AddRemoveBookmark",
    ActionToolbar = "main",
    ActionToolbarSplit = true,
    ActionName = "Add / Remove Bookmark",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/bookmark_icon",
    ActionShortcut = "Ctrl-F2",
    ActionContexts = {
      "PresetsChildAction"
    },
    OnAction = function(self, host, win)
      host:Send("GedToggleBookmark", "SelectedPreset", host.PresetClass)
    end
  }, self)
  XAction:new({
    ActionId = "MoveUp",
    ActionMenubar = "Menu.Edit",
    ActionToolbar = "main",
    ActionName = "Move Up",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/up.tga",
    ActionShortcut = "Ctrl-Up",
    ActionContexts = {
      "BehaviorsItemContext"
    },
    OnAction = function(self, host, win)
      local panel = host:GetLastFocusedPanel()
      if panel == host.idBehaviors then
        host:Op("GedOpListMoveUp", panel.context, panel:GetMultiSelection())
      end
    end
  }, self)
  XAction:new({
    ActionId = "MoveDown",
    ActionMenubar = "Menu.Edit",
    ActionToolbar = "main",
    ActionName = "Move Down",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/down.tga",
    ActionShortcut = "Ctrl-Down",
    ActionContexts = {
      "BehaviorsItemContext"
    },
    OnAction = function(self, host, win)
      local panel = host:GetLastFocusedPanel()
      if panel == host.idBehaviors then
        host:Op("GedOpListMoveDown", panel.context, panel:GetMultiSelection())
      end
    end
  }, self)
  XAction:new({
    ActionId = "Delete",
    ActionMenubar = "Menu.Edit",
    ActionToolbar = "main",
    ActionToolbarSplit = true,
    ActionName = "Delete",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/delete.tga",
    ActionShortcut = "Delete",
    ActionContexts = {
      "PresetsChildAction",
      "BehaviorsItemContext"
    },
    OnAction = function(self, host, win)
      local panel = host:GetLastFocusedPanel()
      if panel == host.idBehaviors then
        host:Op("GedOpListDeleteItem", panel.context, panel:GetMultiSelection())
      elseif panel == host.idPresets then
        host:Op("GedOpPresetDelete", "root", host.idPresets:GetMultiSelection())
      end
    end
  }, self)
  XAction:new({
    ActionMenubar = "Menu.Edit",
    ActionName = "-----",
    ActionTranslate = false
  }, self)
  XAction:new({
    ActionId = "Undo",
    ActionMenubar = "Menu.Edit",
    ActionName = "Undo",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/undo.tga",
    ActionToolbar = "main",
    ActionShortcut = "Ctrl-Z",
    ActionContexts = {},
    OnAction = function(self, host, win)
      host:Undo()
    end
  }, self)
  XAction:new({
    ActionId = "Redo",
    ActionMenubar = "Menu.Edit",
    ActionName = "Redo",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/redo.tga",
    ActionToolbar = "main",
    ActionToolbarSplit = true,
    ActionShortcut = "Ctrl-Y",
    ActionContexts = {},
    OnAction = function(self, host, win)
      host:Redo()
    end
  }, self)
  XAction:new({
    ActionMenubar = "Menu.Edit",
    ActionName = "-----",
    ActionTranslate = false
  }, self)
  XAction:new({
    ActionId = "Cut",
    ActionMenubar = "Menu.Edit",
    ActionName = "Cut",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/cut.tga",
    ActionToolbar = "main",
    ActionShortcut = "Ctrl-X",
    ActionContexts = {
      "PresetsChildAction",
      "BehaviorsItemContext"
    },
    OnAction = function(self, host, win)
      local panel = host:GetLastFocusedPanel()
      if panel == host.idPresets then
        host:Op("GedOpPresetCut", panel.context, panel:GetMultiSelection(), host.PresetClass)
      elseif panel == host.idBehaviors then
        host:Op("GedOpListCut", panel.context, panel:GetMultiSelection(), "ParticleSystemSubItem")
      end
    end
  }, self)
  XAction:new({
    ActionId = "Copy",
    ActionMenubar = "Menu.Edit",
    ActionName = "Copy",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/copy.tga",
    ActionToolbar = "main",
    ActionShortcut = "Ctrl-C",
    ActionContexts = {
      "PresetsChildAction",
      "PropAction",
      "BehaviorsItemContext"
    },
    OnAction = function(self, host, win)
      local panel = host:GetLastFocusedPanel()
      if panel == host.idPresets then
        host:Op("GedOpPresetCopy", panel.context, panel:GetMultiSelection(), host.PresetClass)
      elseif panel == host.idBehaviors then
        host:Op("GedOpListCopy", panel.context, panel:GetMultiSelection(), "ParticleSystemSubItem")
      elseif panel:IsKindOf("GedPropPanel") then
        host:Op("GedOpPropertyCopy", panel.context, panel:GetSelectedProperties(), panel.context)
      end
    end
  }, self)
  XAction:new({
    ActionId = "Paste",
    ActionMenubar = "Menu.Edit",
    ActionName = "Paste",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/paste.tga",
    ActionToolbar = "main",
    ActionShortcut = "Ctrl-V",
    ActionContexts = {
      "PresetsChildAction",
      "PropAction",
      "BehaviorsItemContext"
    },
    OnAction = function(self, host, win)
      local panel = host:GetLastFocusedPanel()
      if panel == host.idPresets then
        host:Op("GedOpPresetPaste", panel.context, panel:GetMultiSelection(), host.PresetClass)
      elseif panel == host.idBehaviors then
        host:Op("GedOpListPaste", panel.context, panel:GetMultiSelection(), "ParticleSystemSubItem")
      elseif panel:IsKindOf("GedPropPanel") then
        self:Op("GedOpPropertyPaste", panel.context)
      end
    end
  }, self)
  XAction:new({
    ActionId = "Duplicate",
    ActionMenubar = "Menu.Edit",
    ActionName = "Duplicate",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/duplicate.tga",
    ActionToolbar = "main",
    ActionShortcut = "Ctrl-D",
    ActionToolbarSplit = true,
    ActionContexts = {
      "PresetsChildAction",
      "BehaviorsItemContext"
    },
    OnAction = function(self, host, win)
      local panel = host:GetLastFocusedPanel()
      if panel == host.idPresets then
        host:Op("GedOpPresetDuplicate", panel.context, panel:GetMultiSelection())
      elseif panel == host.idBehaviors then
        host:Op("GedOpListDuplicate", panel.context, panel:GetMultiSelection())
      end
    end
  }, self)
  XAction:new({
    ActionId = "NewParam",
    ActionMenubar = "main",
    ActionToolbar = "main",
    ActionName = "New Param",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/cog.tga",
    ActionContexts = {
      "BehaviorsPanelContext"
    },
    OnAction = function(self, host, win)
      if host.idPresets:GetSelection() then
        host:Op("GedOpListNewItemInClass", "SelectedPreset", host.idBehaviors:GetSelection() or 0, "ParticleParam", "ParticleSystemPreset")
      end
    end
  }, self)
  local behaviors = GetParticleBehaviorsCombo()
  for idx, behavior in ipairs(behaviors) do
    if behavior.value ~= "" then
      XAction:new({
        ActionId = "Add" .. behavior.value,
        ActionMenubar = "Menu.NewBehavior",
        ActionName = "Add " .. behavior.text,
        ActionTranslate = false,
        ActionContexts = {
          "BehaviorsPanelContext"
        },
        OnAction = function(self, host, win)
          if host.idPresets:GetSelection() then
            host:Op("GedOpListNewItemInClass", "SelectedPreset", host.idBehaviors:GetSelection(), behavior.value, "ParticleSystemPreset")
          end
        end
      }, self)
    end
  end
  local detail_levels = OptionsData.Options.Effects
  local detail_level_names = {
    "Low",
    "Medium",
    "High",
    "Ultra"
  }
  for name_idx, detail_name in ipairs(detail_level_names) do
    local idx = table.find(detail_levels, "value", detail_name)
    XAction:new({
      ActionId = "Preview" .. idx,
      ActionToolbar = "main",
      ActionName = "Preview " .. detail_levels[idx].value,
      ActionTranslate = false,
      ActionToolbarSplit = name_idx == #detail_level_names,
      ActionIcon = "CommonAssets/UI/Ged/preview-level-0" .. name_idx .. ".tga",
      OnAction = function(self, host, win, toggled)
        host:Send("GedSetParticleEmitDetail", detail_levels[idx].value)
      end,
      ActionToggle = true,
      ActionToggled = function(self, host)
        return host.actions_toggled["Preview" .. detail_levels[idx].value]
      end
    }, self)
  end
  XAction:new({
    ActionId = "TestUIParticle",
    ActionToolbar = "main",
    ActionName = "Test UI Particle",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/play.tga",
    ActionToggle = true,
    OnAction = function(self, host, win, toggled)
      host.actions_toggled.TestUIParticle = not host.actions_toggled.TestUIParticle
      host:Send("GedTestUIParticle", host.actions_toggled.TestUIParticle)
    end,
    ActionToggled = function(self, host)
      return host.actions_toggled.TestUIParticle
    end,
    ActionState = function(self, host)
      if host.is_ui_particle then
        return false
      end
      return "hidden"
    end
  }, self)
  XAction:new({
    ActionId = "GedResetAllParticleSystemInstances",
    ActionToolbar = "main",
    ActionName = "Reset all particles",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/view.tga",
    OnAction = function(self, host, win, toggled)
      host:Send("GedResetAllParticleSystemInstances")
    end
  }, self)
  XAction:new({
    ActionId = "SavePreset",
    ActionMenubar = "Menu.File",
    ActionName = "Save",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/save.tga",
    ActionToolbar = "main",
    ActionShortcut = "Ctrl-S",
    OnAction = function(self, host, win)
      host:OnSaving()
      if context.lock_preset then
        host:Send("GedPresetSaveOne", "SelectedPreset")
      else
        host:Send("GedPresetSave", "SelectedPreset", host.PresetClass, false)
      end
    end
  }, self)
  if not context.lock_preset then
    XAction:new({
      ActionId = "SaveAll",
      ActionMenubar = "Menu.File",
      ActionName = "Force Save All",
      ActionTranslate = false,
      ActionIcon = "CommonAssets/UI/Ged/save.tga",
      ActionToolbar = "",
      ActionShortcut = "Ctrl-Shift-S",
      OnAction = function(self, host, win)
        host:OnSaving()
        host:Send("GedPresetSave", "SelectedPreset", host.PresetClass, "force_save_all")
      end
    }, self)
  end
  XAction:new({
    ActionId = "Commit",
    ActionMenubar = "Menu.File",
    ActionToolbar = "main",
    ActionName = "Commit",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/commit.tga",
    OnAction = function(self, host, win)
      host:Send("GedParticleSystemPresetCommit")
    end
  }, self)
  self.LayoutHSpacing = 0
  GedPropPanel:new({
    Id = "idPresetProps",
    Title = "Properties",
    ActionContext = "PropPanelAction",
    PropActionContext = "PropAction",
    SearchActionContexts = {
      "PropAction",
      "PropPanelAction"
    },
    Dock = not context.lock_preset and "ignore" or false
  }, self, "PresetProps")
  self.idPresetProps:SetVisible(context.lock_preset)
  local tree_panel = GedTreePanel:new({
    Id = "idPresets",
    Title = "Particles",
    TitleFormatFunc = "GedFormatPresets",
    Format = "<EditorView>",
    FormatFunc = "GedPresetTree",
    SelectionBind = "SelectedPreset,SelectedObject,PresetProps,SelectedPresetWarning",
    MultipleSelection = true,
    SearchHistory = 20,
    SearchValuesAvailable = true,
    PersistentSearch = true,
    ActionContext = "PresetsPanelAction",
    RootActionContext = "PresetsRootAction",
    ChildActionContext = "PresetsChildAction",
    SearchActionContexts = {
      "PresetsPanelAction",
      "PresetsChildAction",
      "PresetsRootAction"
    },
    OnSelectionChanged = function(tree, sel)
      self:UpdateTitle()
      return GedTreePanel.OnSelectionChanged(tree, sel)
    end,
    OnDoubleClick = function(tree, sel)
      self:Op("GedOpOpenParticleEditor", "SelectedPreset", true)
    end,
    Dock = context.lock_preset and "ignore" or false
  }, self, "root")
  self.idPresets:SetVisible(not context.lock_preset)
  local bookmarks_panel = GedTreePanel:new({
    Id = "idBookmarks",
    Title = "Bookmarks",
    EnableSearch = false,
    Collapsible = true,
    StartsExpanded = true,
    EmptyMessage = "(press Ctrl-F2 to bookmark)",
    ExpandedMessage = "(press F2 to cycle)",
    ShowToolbarButtons = false,
    FormatFunc = "GedBookmarksTree",
    Format = "<EditorView>",
    SelectionBind = "SelectedXTemplate,SelectedObject,SelectedBookmark",
    EmptyText = "Add a bookmark here by pressing Ctrl-F2.",
    Dock = "bottom",
    MaxHeight = 350,
    ChildActionContext = "BookmarksChildAction"
  }, tree_panel, "bookmarks")
  function bookmarks_panel:Open(...)
    self.expanded = true
    GedTreePanel.Open(self, ...)
    self.connection:Send("rfnBindBookmarks", self.context, self.app.PresetClass)
  end
  XAction:new({
    ActionId = "RemoveBookmark",
    ActionName = "Remove Bookmark",
    ActionTranslate = false,
    ActionContexts = {
      "BookmarksChildAction"
    },
    OnAction = function(self, host, win)
      host:Send("GedToggleBookmark", "SelectedBookmark", host.PresetClass)
    end
  }, bookmarks_panel)
  XPanelSizer:new({}, self)
  local mid_panel = XWindow:new({
    Id = "idMidPanel",
    MaxWidth = 100000,
    MinWidth = 300
  }, self)
  GedPropPanel:new({
    Id = "idBehaviorFilter",
    Title = "Filter",
    Dock = "top",
    EnableUndo = false,
    EnableCollapseDefault = false,
    EnableShowInternalNames = false,
    EnableCollapseCategories = false,
    EnableSearch = false,
    HideFirstCategory = true,
    Margins = box(0, 0, 0, 2)
  }, mid_panel, "BehaviorFilterObject")
  GedListPanel:new({
    Id = "idBehaviors",
    Title = "Behaviors",
    Format = "<FormatNameForGed>",
    AllowObjectsOnly = true,
    TitleFormatFunc = "GedFormatObjectWithCount",
    FormatFunc = "GedListParticleSystemBehaviors",
    SelectionBind = "SelectedObject",
    FilterName = "BehaviorFilterObject",
    FilterClass = "BehaviorFilter",
    MultipleSelection = true,
    SortChildNodes = false,
    ActionContext = "BehaviorsPanelContext",
    ItemActionContext = "BehaviorsItemContext",
    SearchActionContexts = {
      "BehaviorsPanelContext"
    }
  }, mid_panel, "SelectedPreset")
  XPanelSizer:new({}, self)
  GedPropPanel:new({
    Id = "idProps",
    Title = "Properties",
    RootObjectBindName = "SelectedPreset",
    ActionContext = "PropPanelAction",
    PropActionContext = "PropAction",
    SearchActionContexts = {
      "PropAction",
      "PropPanelAction"
    }
  }, self, "SelectedObject")
  local status_bar = GedTextPanel:new({
    Id = "idStatusBar",
    Title = "",
    DisplayWarnings = false,
    FormatFunc = "GedPresetStatusText",
    Margins = box(2, 2, 2, 0),
    Padding = box(2, 0, 1, 0),
    Dock = "bottom",
    FoldWhenHidden = true
  }, self.idPresets, "SelectedPreset")
  status_bar:SetVisible(false)
  XToggleButton:new({
    Id = "idViewErrorsOnly",
    Margins = box(2, 2, 2, 2),
    BorderWidth = 1,
    Padding = box(2, 0, 2, 0),
    Dock = "right",
    VAlign = "center",
    LayoutMethod = "VList",
    BorderColor = RGBA(0, 0, 0, 0),
    OnPress = function(self, gamepad)
      XToggleButton.OnPress(self, gamepad)
      local root_panel = GetParentOfKind(self, "GedTreePanel")
      local mode = not root_panel.view_errors_only
      root_panel:SetViewErrorsOnly(mode)
    end,
    PressedBackground = RGBA(160, 160, 160, 255),
    TextStyle = "GedError",
    Text = "Errors only",
    ToggledBackground = RGBA(40, 43, 48, 255),
    ToggledBorderColor = RGBA(240, 0, 0, 255)
  }, status_bar)
  XToggleButton:new({
    Id = "idViewWarningsOnly",
    Margins = box(2, 2, 2, 2),
    BorderWidth = 1,
    Padding = box(2, 0, 2, 0),
    Dock = "right",
    VAlign = "center",
    LayoutMethod = "VList",
    BorderColor = RGBA(0, 0, 0, 0),
    OnPress = function(self, gamepad)
      XToggleButton.OnPress(self, gamepad)
      local root_panel = GetParentOfKind(self, "GedTreePanel")
      local mode = not root_panel.view_warnings_only
      root_panel:SetViewWarningsOnly(mode)
    end,
    PressedBackground = RGBA(160, 160, 160, 255),
    TextStyle = "GedWarning",
    Text = "Warnings only",
    ToggledBackground = RGBA(40, 43, 48, 255),
    ToggledBorderColor = RGBA(255, 140, 0, 255)
  }, status_bar)
  GedBindView:new({
    BindView = "warning_error_count",
    BindFunc = "GedPresetWarningsErrors",
    OnViewChanged = function(self, value, control)
      local errsButton = self:ResolveId("idViewErrorsOnly")
      if errsButton then
        errsButton:SetVisible(value ~= 0)
      end
      local warnsButton = self:ResolveId("idViewWarningsOnly")
      if warnsButton then
        warnsButton:SetVisible(value ~= 0)
      end
      if value == 0 then
        GetParentOfKind(self, "GedTreePanel"):SetViewWarningsOnly(false)
        GetParentOfKind(self, "GedTreePanel"):SetViewErrorsOnly(false)
      end
    end
  }, status_bar, "SelectedPreset")
end
