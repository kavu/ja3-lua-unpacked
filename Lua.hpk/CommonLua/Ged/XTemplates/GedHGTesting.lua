PlaceObj("XTemplate", {
  __is_kind_of = "GedApp",
  group = "GedApps",
  id = "GedHGTesting",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "Testing Project <Project>, Dev <Dev>"
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedListPanel",
      "Id",
      "idList",
      "Title",
      "Tests",
      "ActionContext",
      "ContentPanelAction",
      "Format",
      "<TestView>",
      "FilterName",
      "HGTestFilterObject",
      "FilterClass",
      "HGTestFilter",
      "SelectionBind",
      "SelectedPreset",
      "ItemActionContext",
      "ContentPanelAction"
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "HGTestFilterObject"
        end,
        "__class",
        "GedPropPanel",
        "Dock",
        "bottom",
        "Title",
        "Filter",
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
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Save",
      "ActionTranslate",
      false,
      "ActionName",
      "Save",
      "ActionIcon",
      "CommonAssets/UI/Ged/save.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "ActionShortcut",
      "Ctrl-S",
      "OnAction",
      function(self, host, source, ...)
        CreateRealTimeThread(function()
          host:OnSaving()
          host:Call("GedPresetSave", "SelectedPreset", "HGTest")
          host:Send("GedObjModified", "root")
        end)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Refresh",
      "ActionTranslate",
      false,
      "ActionName",
      "Refresh",
      "ActionIcon",
      "CommonAssets/UI/Ged/redo.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "ActionShortcut",
      "F5",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedObjModified", "root")
      end,
      "ActionContexts",
      {
        "ContentPanelAction"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Edit",
      "ActionTranslate",
      false,
      "ActionName",
      "Edit Test",
      "ActionIcon",
      "CommonAssets/UI/Ged/rollover-mode.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "ActionShortcut",
      "Ctrl-E",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedCallMethod", "SelectedPreset", "OpenEditor")
      end,
      "ActionContexts",
      {
        "ContentPanelAction"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "TestSuccess",
      "ActionTranslate",
      false,
      "ActionName",
      "Log test success",
      "ActionIcon",
      "CommonAssets/UI/Icons/thumbs up.tga",
      "ActionToolbar",
      "main",
      "ActionShortcut",
      "Ctrl-O",
      "OnActionParam",
      "Sample",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedCallMethod", "SelectedPreset", "LogTest", true)
        host:Send("GedObjModified", "root")
      end,
      "ActionContexts",
      {
        "ContentPanelAction"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "TestFail",
      "ActionTranslate",
      false,
      "ActionName",
      "Log test fail",
      "ActionIcon",
      "CommonAssets/UI/Icons/down thumbs.tga",
      "ActionToolbar",
      "main",
      "ActionShortcut",
      "Ctrl-F",
      "OnActionParam",
      "Sample",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedCallMethod", "SelectedPreset", "LogTest", false)
        host:Send("GedObjModified", "root")
      end,
      "ActionContexts",
      {
        "ContentPanelAction"
      }
    })
  })
})
