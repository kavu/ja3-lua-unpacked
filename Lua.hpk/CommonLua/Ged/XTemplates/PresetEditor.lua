PlaceObj("XTemplate", {
  __is_kind_of = "GedApp",
  group = "GedApps",
  id = "PresetEditor",
  save_in = "Ged",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PresetEditTemplate"
  }, {
    PlaceObj("XTemplateGroup", {
      "comment",
      "sub-items",
      "__condition",
      function(parent, context)
        return parent.ContainerClass ~= ""
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XPanelSizer"
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "SelectedPreset"
        end,
        "__condition",
        function(parent, context)
          return parent.ContainerTree
        end,
        "__class",
        "GedTreePanel",
        "Id",
        "idPresetContent",
        "Title",
        "Subitems",
        "ActionsClass",
        "PropertyObject",
        "MoveUp",
        "GedOpTreeMoveItemUp",
        "MoveDown",
        "GedOpTreeMoveItemDown",
        "MoveOut",
        "GedOpTreeMoveItemOutwards",
        "MoveIn",
        "GedOpTreeMoveItemInwards",
        "Delete",
        "GedOpTreeDeleteItem",
        "Cut",
        "GedOpTreeCut",
        "Copy",
        "GedOpTreeCopy",
        "Paste",
        "GedOpTreePaste",
        "Duplicate",
        "GedOpTreeDuplicate",
        "ActionContext",
        "ContentPanelAction",
        "SearchActionContexts",
        {
          "ContentRootPanelAction",
          "ContentPanelAction",
          "ContentChildPanelAction"
        },
        "Format",
        "<EditorView>",
        "AllowObjectsOnly",
        true,
        "FilterName",
        "PresetSubItemFilter",
        "SelectionBind",
        "SelectedObject",
        "MultipleSelection",
        true,
        "EnableForRootLevelItems",
        true,
        "ItemClass",
        function(gedapp)
          return gedapp.ContainerClass
        end,
        "RootActionContext",
        "ContentRootPanelAction",
        "ChildActionContext",
        "ContentChildPanelAction",
        "FullWidthText",
        true
      }, {
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return "PresetSubItemFilter"
          end,
          "__class",
          "GedPropPanel",
          "Dock",
          "bottom",
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "Title",
          "<FilterName>",
          "EnableSearch",
          false,
          "DisplayWarnings",
          false,
          "EnableUndo",
          false,
          "EnableCollapseDefault",
          false,
          "EnableShowInternalNames",
          false,
          "EnableCollapseCategories",
          false,
          "HideFirstCategory",
          true
        }),
        PlaceObj("XTemplateCode", {
          "comment",
          "-- Setup preset filter",
          "run",
          function(self, parent, context)
            parent.FilterClass = parent.parent.SubItemFilterClass
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "SelectedPreset"
        end,
        "__condition",
        function(parent, context)
          return not parent.ContainerTree
        end,
        "__class",
        "GedListPanel",
        "Id",
        "idPresetContent",
        "Title",
        "Subitems",
        "ActionsClass",
        "PropertyObject",
        "MoveUp",
        "GedOpListMoveUp",
        "MoveDown",
        "GedOpListMoveDown",
        "Delete",
        "GedOpListDeleteItem",
        "Cut",
        "GedOpListCut",
        "Copy",
        "GedOpListCopy",
        "Paste",
        "GedOpListPaste",
        "Duplicate",
        "GedOpListDuplicate",
        "ActionContext",
        "ContentPanelAction",
        "SearchActionContexts",
        {
          "ContentRootPanelAction",
          "ContentPanelAction",
          "ContentChildPanelAction"
        },
        "Format",
        "<EditorView>",
        "AllowObjectsOnly",
        true,
        "FilterName",
        "PresetSubItemFilter",
        "SelectionBind",
        "SelectedObject",
        "MultipleSelection",
        true,
        "ItemClass",
        function(gedapp)
          return gedapp.ContainerClass
        end,
        "ItemActionContext",
        "ContentRootPanelAction"
      }, {
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return "PresetSubItemFilter"
          end,
          "__class",
          "GedPropPanel",
          "Dock",
          "bottom",
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "Title",
          "<FilterName>",
          "EnableSearch",
          false,
          "DisplayWarnings",
          false,
          "EnableUndo",
          false,
          "EnableCollapseDefault",
          false,
          "EnableShowInternalNames",
          false,
          "EnableCollapseCategories",
          false,
          "HideFirstCategory",
          true
        }),
        PlaceObj("XTemplateCode", {
          "comment",
          "-- Setup preset filter",
          "run",
          function(self, parent, context)
            parent.FilterClass = parent.parent.SubItemFilterClass
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "SelectedPreset"
        end,
        "__class",
        "GedBindView",
        "BindView",
        "SubItems",
        "BindFunc",
        "GedDynamicItemsMenu",
        "ControlId",
        "idPresetContent",
        "GetBindParams",
        function(self, control)
          return "Preset"
        end,
        "OnViewChanged",
        function(self, value, control)
          RebuildSubItemsActions(control, value, "New", "main", "main")
        end
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "SelectedObject"
      end,
      "__class",
      "GedPropPanel",
      "Id",
      "idProps",
      "Title",
      "Properties",
      "ActionsClass",
      "PropertyObject",
      "Copy",
      "GedOpPropertyCopy",
      "Paste",
      "GedOpPropertyPaste",
      "ActionContext",
      "PropPanelAction",
      "SearchActionContexts",
      {
        "PropPanelAction",
        "PropAction"
      },
      "RootObjectBindName",
      "SelectedPreset",
      "PropActionContext",
      "PropAction"
    }, {
      PlaceObj("XTemplateCode", {
        "run",
        function(self, parent, context)
          parent.DisplayWarnings = not context.ContainerClass or context.ContainerClass == ""
        end
      })
    })
  })
})
