PlaceObj("XTemplate", {
  __is_kind_of = "XListItem",
  group = "Editor",
  id = "ClassesListItem",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {"__class", "XListItem"}, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XLabel",
      "Id",
      "idClass"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XLabel",
      "Id",
      "idPercent",
      "Dock",
      "right",
      "MinWidth",
      60
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XLabel",
      "Id",
      "idCount",
      "Dock",
      "right",
      "MinWidth",
      60
    })
  })
})
