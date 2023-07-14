PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedScriptEditor",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "Script Editor",
    "AppId",
    "GedScriptEditor"
  }, {
    PlaceObj("XTemplateWindow", nil, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "root"
        end,
        "__class",
        "GedTreePanel",
        "Id",
        "idProgram",
        "Margins",
        box(0, 0, 2, 0),
        "TitleFormatFunc",
        "GedScriptDescription",
        "DisplayWarnings",
        false,
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
        "PanelAction",
        "SearchActionContexts",
        {
          "PanelAction",
          "ChildAction"
        },
        "Format",
        "<EditorView>",
        "SelectionBind",
        "SelectedObject",
        "EnableForRootLevelItems",
        true,
        "ItemClass",
        function(gedapp)
          return gedapp.ItemClass
        end,
        "RootActionContext",
        "PanelAction",
        "ChildActionContext",
        "ChildAction"
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "OnContextUpdate(self, context, view, ...)",
          "func",
          function(self, context, view, ...)
            if view == "tree" then
              self.connection.app:ActionsUpdated()
            end
            return GedTreePanel.OnContextUpdate(self, context, view, ...)
          end
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return "root"
          end,
          "__class",
          "GedTextPanel",
          "ZOrder",
          2,
          "Padding",
          box(2, 2, 2, -2),
          "Dock",
          "top",
          "Title",
          "",
          "DisplayWarnings",
          false,
          "Format",
          "<EditedScriptStatusText>"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "root"
        end,
        "__class",
        "GedPropPanel",
        "Dock",
        "bottom",
        "MaxHeight",
        300,
        "Title",
        "Lua Code",
        "EnableSearch",
        false,
        "DisplayWarnings",
        false,
        "ActionContext",
        "PanelAction",
        "EnableCollapseDefault",
        false,
        "EnableShowInternalNames",
        false,
        "EnableCollapseCategories",
        false,
        "HideFirstCategory",
        true,
        "PropActionContext",
        "PanelAction"
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
      "ActionsClass",
      "PropertyObject",
      "Copy",
      "GedOpPropertyCopy",
      "Paste",
      "GedOpPropertyPaste",
      "ActionContext",
      "PanelAction",
      "SearchActionContexts",
      {
        "PanelAction",
        "ChildAction"
      },
      "HideFirstCategory",
      true,
      "PropActionContext",
      "PanelAction"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "SelectedObject"
      end,
      "__class",
      "GedBindView",
      "BindView",
      "SubItems",
      "BindFunc",
      "GedDynamicItemsMenu",
      "ControlId",
      "idProgram",
      "OnViewChanged",
      function(self, value, control)
        RebuildSubItemsActions(control, value, "New", "main", "main")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "File",
      "ActionName",
      T(940323577396, "File"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup"
    }, {
      PlaceObj("XTemplateAction", {
        "ActionId",
        "SaveParentPreset",
        "ActionName",
        T(755742229826, "Save containing preset"),
        "ActionIcon",
        "CommonAssets/UI/Ged/save.tga",
        "ActionToolbar",
        "main",
        "ActionToolbarSplit",
        true,
        "ActionShortcut",
        "Ctrl-S",
        "ActionState",
        function(self, host)
          local tree = host.idProgram:Obj("root|tree")
          if tree and tree.class == "ScriptTestHarnessProgram" then
            return "hidden"
          end
        end,
        "OnAction",
        function(self, host, source, ...)
          host:OnSaving()
          host:Send("GedSaveScriptParentPreset")
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "TestScript",
        "ActionName",
        T(448341630971, "Test script"),
        "ActionIcon",
        "CommonAssets/UI/Ged/play",
        "ActionToolbar",
        "main",
        "ActionToolbarSplit",
        true,
        "ActionShortcut",
        "Ctrl-T",
        "ActionState",
        function(self, host)
          local tree = host.idProgram:Obj("root|tree")
          if tree and tree.class ~= "ScriptTestHarnessProgram" then
            return "hidden"
          end
        end,
        "OnAction",
        function(self, host, source, ...)
          host:OnSaving()
          host:Send("GedTestScript")
        end
      })
    })
  })
})
