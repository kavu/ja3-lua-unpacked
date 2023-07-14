PlaceObj("XTemplate", {
  group = "GedControls",
  id = "GedNestedElementsCategory",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "Id",
    "idWin",
    "IdNode",
    true,
    "Margins",
    box(0, 0, 0, 5),
    "BorderWidth",
    1,
    "MinWidth",
    280,
    "MaxWidth",
    280,
    "LayoutMethod",
    "VList",
    "Background",
    RGBA(128, 128, 128, 64)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idCategoryTitle",
      "TextStyle",
      "GedTitleSmall"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XList",
      "Id",
      "idCategoryElements",
      "BorderWidth",
      0
    })
  })
})
