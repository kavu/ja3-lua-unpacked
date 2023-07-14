PlaceObj("XTemplate", {
  group = "Editor",
  id = "XEditorSettings",
  save_in = "Common",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "GedPropertyObject"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Exit",
      "func",
      function(self, ...)
        XEditorSettings:ToggleGedEditor()
      end
    })
  })
})
