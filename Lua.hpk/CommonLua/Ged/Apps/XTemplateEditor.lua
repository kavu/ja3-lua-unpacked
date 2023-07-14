DefineClass.XTemplateEditor = {
  __parents = {"GedApp"},
  Translate = true,
  Title = "XTemplate Editor<opt(u(EditorShortcut),' (',')')>",
  AppId = "XTemplateEditor",
  InitialWidth = 1600,
  InitialHeight = 900
}
function XTemplateEditor:Init(parent, context)
  XAction:new({
    ActionId = "NewElement",
    ActionName = "New Element",
    ActionMenubar = "main",
    ActionTranslate = false,
    ActionSortKey = "2",
    OnActionEffect = "popup"
  }, self)
  XAction:new({
    ActionId = "NewXTemplate",
    ActionMenubar = "File",
    ActionToolbar = "main",
    ActionShortcut = "Ctrl-N",
    ActionName = "New XTemplate",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/new.tga",
    ActionContexts = {
      "XTemplatesPanelAction",
      "XTemplatesChildAction",
      "XTemplatesRootAction"
    },
    OnAction = function()
      self:Op("GedOpNewPreset", "root", self.idTemplates:GetSelection(), "XTemplate")
    end
  }, self)
  XAction:new({
    ActionId = "Save",
    ActionMenubar = "File",
    ActionToolbar = "main",
    ActionShortcut = "Ctrl-S",
    ActionName = "Save",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/save.tga",
    OnAction = function()
      self:OnSaving()
      self:Send("GedPresetSave", "SelectedXTemplate", "XTemplate")
    end
  }, self)
  XAction:new({
    ActionId = "Save",
    ActionMenubar = "File",
    ActionShortcut = "Ctrl-Shift-S",
    ActionName = "Force Save All",
    ActionTranslate = false,
    OnAction = function()
      self:OnSaving()
      self:Send("GedPresetSave", "SelectedXTemplate", "XTemplate", "force_save_all")
    end
  }, self)
  XAction:new({
    ActionId = "LivePreviewXTemplate",
    ActionMenubar = "File",
    ActionToolbar = "main",
    ActionToolbarSplit = false,
    ActionName = "Live Preview XTemplate",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/preview.tga",
    ActionToggle = true,
    ActionToggled = function(self, host)
      return host.actions_toggled.LivePreviewXTemplate
    end,
    OnAction = function()
      self:Op("GedOpPreviewXTemplate", "SelectedXTemplate", true)
    end,
    ActionContexts = {
      "XTemplatesChildAction"
    }
  }, self)
  XAction:new({
    ActionId = "PreviewXTemplate",
    ActionMenubar = "File",
    ActionToolbar = "main",
    ActionToolbarSplit = true,
    ActionName = "Preview XTemplate",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/play.tga",
    ActionToggle = true,
    ActionToggled = function(self, host)
      return host.actions_toggled.PreviewXTemplate
    end,
    OnAction = function()
      self:Op("GedOpPreviewXTemplate", "SelectedXTemplate", false)
    end,
    ActionContexts = {
      "XTemplatesChildAction"
    }
  }, self)
  XAction:new({
    ActionId = "SVNShowLogXTemplate",
    ActionMenubar = "File",
    ActionName = "SVN Show Log",
    ActionTranslate = false,
    ActionContexts = {
      "XTemplatesChildAction"
    },
    OnAction = function()
      self:Op("GedOpSVNShowLog", "SelectedXTemplate")
    end
  }, self)
  XAction:new({
    ActionId = "SVNShowBlameXTemplate",
    ActionMenubar = "File",
    ActionName = "SVN Blame",
    ActionTranslate = false,
    ActionContexts = {
      "XTemplatesChildAction"
    },
    OnAction = function()
      self:Op("GedOpSVNShowBlame", "SelectedXTemplate")
    end
  }, self)
  XAction:new({
    ActionId = "SVNShowDiffXTemplate",
    ActionMenubar = "File",
    ActionName = "SVN Diff",
    ActionTranslate = false,
    ActionContexts = {
      "XTemplatesChildAction"
    },
    OnAction = function()
      self:Op("GedOpSVNShowDiff", "SelectedXTemplate")
    end
  }, self)
  XAction:new({
    ActionId = "Exit",
    ActionMenubar = "File",
    ActionName = "Exit",
    ActionTranslate = false,
    OnAction = function()
      self:Exit()
    end
  }, self)
  local list = ClassLeafDescendantsList("XTemplateElement")
  for _, class_name in ipairs(list) do
    XAction:new({
      ActionId = "New" .. class_name,
      ActionMenubar = "NewElement",
      ActionName = "New " .. class_name,
      ActionTranslate = false,
      ActionContexts = {
        "XElementsPanelAction",
        "XElementsChildAction",
        "XElementsRootAction"
      },
      OnAction = function()
        local panel = self.idElements
        self:Op("GedOpTreeNewItem", panel.context, panel:GetSelection(), class_name)
      end
    }, self)
  end
  XAction:new({
    ActionId = "AddRemoveBookmark",
    ActionToolbar = "main",
    ActionToolbarSplit = true,
    ActionName = "Add / Remove Bookmark",
    ActionTranslate = false,
    ActionIcon = "CommonAssets/UI/Ged/bookmark_icon",
    ActionShortcut = "Ctrl-F2",
    ActionContexts = {
      "XTemplatesChildAction"
    },
    OnAction = function(self, host, win)
      host:Send("GedToggleBookmark", "SelectedXTemplate", host.PresetClass)
    end
  }, self)
  XAction:new({
    ActionId = "NextBookmark",
    ActionName = "Next Bookmark",
    ActionTranslate = false,
    ActionShortcut = "F2",
    OnAction = function(self, host, win)
      local tree = host.idTemplates.idBookmarks.idContainer
      local selection = tree:GetSelection()
      if not selection then
        tree:SetSelection({1})
      else
        tree:OnShortcut("Down")
        local new_selection = tree:GetSelection()
        if ValueToLuaCode(selection) == ValueToLuaCode(new_selection) then
          tree:SetSelection({1})
        end
      end
    end
  }, self)
  self.LayoutHSpacing = 0
  local tree_panel = GedTreePanel:new({
    Id = "idTemplates",
    Title = "XTemplates",
    TitleFormatFunc = "GedFormatPresets",
    Format = "<EditorView>",
    FormatFunc = "GedPresetTree",
    SelectionBind = "SelectedXTemplate,SelectedObject",
    MultipleSelection = true,
    SearchHistory = 20,
    SearchValuesAvailable = true,
    PersistentSearch = true,
    ActionContext = "XTemplatesPanelAction",
    RootActionContext = "XTemplatesRootAction",
    ChildActionContext = "XTemplatesChildAction",
    SearchActionContexts = {
      "XTemplatesPanelAction"
    },
    ActionsClass = "Preset",
    Delete = "GedOpPresetDelete",
    Cut = "GedOpPresetCut",
    Copy = "GedOpPresetCopy",
    Paste = "GedOpPresetPaste",
    Duplicate = "GedOpPresetDuplicate",
    ItemClass = function(gedapp)
      return "XTemplate"
    end,
    EnableForRootLevelItems = false
  }, self, "root")
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
  GedTreePanel:new({
    Id = "idElements",
    Title = "Elements",
    Format = "<TreeView>",
    AllowObjectsOnly = true,
    SelectionBind = "SelectedObject",
    SortChildNodes = false,
    MultipleSelection = true,
    ActionContext = "XElementsPanelAction",
    RootActionContext = "XElementsRootAction",
    ChildActionContext = "XElementsChildAction",
    SearchActionContexts = {
      "XElementsPanelAction"
    },
    ActionsClass = "PropertyObject",
    MoveUp = "GedOpTreeMoveItemUp",
    MoveDown = "GedOpTreeMoveItemDown",
    MoveOut = "GedOpTreeMoveItemOutwards",
    MoveIn = "GedOpTreeMoveItemInwards",
    Delete = "GedOpTreeDeleteItem",
    Cut = "GedOpTreeCut",
    Copy = "GedOpTreeCopy",
    Paste = "GedOpTreePaste",
    Duplicate = "GedOpTreeDuplicate",
    ItemClass = function(gedapp)
      return "XTemplateElement"
    end,
    EnableForRootLevelItems = true
  }, self, "SelectedXTemplate")
  XPanelSizer:new({}, self)
  GedPropPanel:new({
    Id = "idProperties",
    Title = "Properties",
    RootObjectBindName = "SelectedXTemplate",
    ActionContext = "XPropPanelAction",
    PropActionContext = "XPropAction",
    SearchActionContexts = {
      "XPropPanelAction",
      "XPropAction"
    },
    ActionsClass = "PropertyObject",
    Copy = "GedOpPropertyCopy",
    Paste = "GedOpPropertyPaste"
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
  }, self.idTemplates, "SelectedXTemplate")
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
  }, status_bar, "SelectedXTemplate")
end
