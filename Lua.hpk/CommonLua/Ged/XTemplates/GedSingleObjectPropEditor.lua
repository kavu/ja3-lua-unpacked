PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedSingleObjectPropEditor",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "Prop Editor",
    "AppId",
    "GedSingleObjectPropEditor",
    "CommonActionsInMenubar",
    false,
    "CommonActionsInToolbar",
    false
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
