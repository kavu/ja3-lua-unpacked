PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedBuildingRulesEditor",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "Building Rules Editor",
    "AppId",
    "GedBuildingRulesEditor",
    "CommonActionsInMenubar",
    false,
    "CommonActionsInToolbar",
    false
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "NewForbidRule",
      "ActionName",
      T(918801280324, "New Forbid Rule"),
      "ActionIcon",
      "CommonAssets/UI/Ged/new.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpNewForbidRule", "SelectedObject")
      end,
      "ActionContexts",
      {
        "RoomPanelGeneral"
      }
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedListPanel",
      "Id",
      "idRules",
      "Margins",
      box(0, 0, 2, 0),
      "Dock",
      "left",
      "Title",
      "Rules",
      "ActionsClass",
      "Object",
      "Delete",
      "GedOpListDeleteItem",
      "SelectionBind",
      "SelectedObject"
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
