PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedPropertyObject",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "Properties",
    "CommonActionsInMenubar",
    false,
    "CommonActionsInToolbar",
    false,
    "InitialWidth",
    400
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedPropPanel",
      "ActionsClass",
      "PropertyObject",
      "Copy",
      "GedOpPropertyCopy",
      "Paste",
      "GedOpPropertyPaste"
    })
  })
})
