PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedMapDataEditor",
  save_in = "Ged",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PresetEditor"
  }, {
    PlaceObj("XTemplateFunc", {
      "comment",
      "Enable double clicking",
      "name",
      "Open",
      "func",
      function(self, ...)
        GedApp.Open(self, ...)
        function self.idPresets.idContainer.OnDoubleClickedItem(tree, selection)
          self:Send("GedMapDataOpenMap")
          return "break"
        end
      end
    })
  })
})
