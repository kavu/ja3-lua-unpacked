PlaceObj("XTemplate", {
  group = "Zulu Satellite UI",
  id = "SectorWindowId",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XMapObject",
    "IdNode",
    true,
    "ZOrder",
    3,
    "HAlign",
    "left",
    "VAlign",
    "top",
    "MinWidth",
    120,
    "MinHeight",
    64,
    "HandleMouse",
    false,
    "ChildrenHandleMouse",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "Id",
      "idSectorIdBg",
      "HAlign",
      "left",
      "VAlign",
      "top",
      "MinWidth",
      64,
      "MinHeight",
      64,
      "MaxHeight",
      64,
      "UseClipBox",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idSectorId",
        "Padding",
        box(4, 2, 4, 2),
        "HAlign",
        "center",
        "VAlign",
        "center",
        "Clip",
        false,
        "UseClipBox",
        false,
        "TextStyle",
        "SectorId",
        "Translate",
        true,
        "TextVAlign",
        "center"
      })
    })
  })
})
