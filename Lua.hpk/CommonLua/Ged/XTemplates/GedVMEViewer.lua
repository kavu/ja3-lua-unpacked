PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedVMEViewer",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "VMEViewer",
    "AppId",
    "VMEViewer"
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedListPanel",
      "Id",
      "idMeshes",
      "Title",
      "Objects",
      "Format",
      "<EditorView>",
      "SelectionBind",
      "SelectedVME"
    })
  })
})
