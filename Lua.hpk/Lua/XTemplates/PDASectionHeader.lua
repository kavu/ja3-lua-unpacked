PlaceObj("XTemplate", {
  __is_kind_of = "PDASectionHeaderClass",
  group = "Zulu PDA",
  id = "PDASectionHeader",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDASectionHeaderClass",
    "IdNode",
    true,
    "Margins",
    box(0, 10, 0, 0),
    "Padding",
    box(3, 3, 0, 3),
    "Background",
    RGBA(30, 30, 35, 255)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idText",
      "Padding",
      box(5, 0, 5, 0),
      "HAlign",
      "left",
      "MinWidth",
      280,
      "Background",
      RGBA(219, 215, 205, 255),
      "TextStyle",
      "MercStatHeader",
      "Translate",
      true
    })
  })
})
