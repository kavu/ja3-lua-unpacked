PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedMarkerViewer",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "Marker Viewer",
    "AppId",
    "Marker Viewer"
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedListPanel",
      "Id",
      "idMarkers",
      "Title",
      "Objects",
      "Format",
      "<EditorView>",
      "SelectionBind",
      "SelectedObject"
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
      "GedPropPanel"
    })
  })
})
