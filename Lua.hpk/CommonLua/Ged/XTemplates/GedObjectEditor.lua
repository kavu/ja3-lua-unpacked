PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedObjectEditor",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "Object Editor",
    "AppId",
    "GedObjectEditor",
    "CommonActionsInMenubar",
    false,
    "CommonActionsInToolbar",
    false
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ViewObject",
      "ActionTranslate",
      false,
      "ActionName",
      "View Object",
      "ActionIcon",
      "CommonAssets/UI/Ged/view.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpViewGameObject", "SelectedObject")
      end,
      "ActionContexts",
      {
        "ObjectPanelChildActions"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "OpenEntityEditor",
      "ActionTranslate",
      false,
      "ActionName",
      "Open Entity Editor",
      "ActionIcon",
      "CommonAssets/UI/Ged/tune.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpOpenEntityEditor", "SelectedObject")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "OpenAutoattachEditor",
      "ActionTranslate",
      false,
      "ActionName",
      "Open Autoattach Editor",
      "ActionIcon",
      "CommonAssets/UI/Ged/tune.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedOpenAutoattachEditorButton")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ToggleSpots",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Spots",
      "ActionIcon",
      "CommonAssets/UI/Ged/preview.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpToggleSpotVisiblity", "SelectedObject")
      end,
      "ActionContexts",
      {
        "ObjectPanelActions"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "FilterSpots",
      "ActionTranslate",
      false,
      "ActionName",
      "Display Spots with Filter",
      "ActionIcon",
      "CommonAssets/UI/Ged/filter.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpDisplaySpotsWithFilter", "SelectedObject")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ConvertToTemplate",
      "ActionTranslate",
      false,
      "ActionName",
      "Convert to Template",
      "ActionIcon",
      "CommonAssets/UI/Ged/usb.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpConvertToTemplate", "SelectedObject")
      end,
      "ActionContexts",
      {
        "ObjectPanelChildActions"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ConvertToObject",
      "ActionTranslate",
      false,
      "ActionName",
      "Convert to Object",
      "ActionIcon",
      "CommonAssets/UI/Ged/trillian.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpConvertToObject", "SelectedObject")
      end,
      "ActionContexts",
      {
        "ObjectPanelChildActions"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "RemoveDuplicated",
      "ActionTranslate",
      false,
      "ActionName",
      "Remove Duplicated",
      "ActionIcon",
      "CommonAssets/UI/Ged/collection.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpRemoveDuplicated", "SelectedObject")
      end,
      "ActionContexts",
      {
        "ObjectPanelActions"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "InvertSelection",
      "ActionTranslate",
      false,
      "ActionName",
      "Invert Selection",
      "ActionIcon",
      "CommonAssets/UI/Ged/rollover-mode.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host.idObjects.idContainer:InvertSelection(true)
      end,
      "ActionContexts",
      {
        "ObjectPanelChildActions"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Delete",
      "ActionTranslate",
      false,
      "ActionName",
      "Delete",
      "ActionIcon",
      "CommonAssets/UI/Ged/delete.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpDeleteObject", "SelectedObject")
      end,
      "ActionContexts",
      {
        "ObjectPanelChildActions"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Remove Unselected",
      "ActionTranslate",
      false,
      "ActionName",
      "Remove Unselected",
      "ActionIcon",
      "CommonAssets/UI/Ged/cut.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpRemoveUnselected", "SelectedObject")
      end,
      "ActionContexts",
      {
        "ObjectPanelChildActions"
      }
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedTreePanel",
      "Id",
      "idObjects",
      "Margins",
      box(0, 0, 2, 0),
      "Title",
      "Objects",
      "ActionContext",
      "ObjectPanelActions",
      "Format",
      "<GedTreeViewFormat>",
      "SelectionBind",
      "SelectedObject",
      "MultipleSelection",
      true,
      "RootActionContext",
      "ObjectPanelChildActions"
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
      "Title",
      "Properties",
      "ActionsClass",
      "PropertyObject",
      "Copy",
      "GedOpPropertyCopy",
      "Paste",
      "GedOpPropertyPaste"
    })
  })
})
