PlaceObj("XTemplate", {
  __is_kind_of = "XLoadingScreenClass",
  group = "Zulu",
  id = "AutosaveScreen",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XLoadingScreenClass",
    "Background",
    RGBA(0, 0, 0, 129)
  }, {
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "VAlign",
      "center",
      "LayoutMethod",
      "VList",
      "UseClipBox",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "IdNode",
        false,
        "Padding",
        box(2, 2, 2, 10),
        "HAlign",
        "center",
        "VAlign",
        "center",
        "Clip",
        false,
        "UseClipBox",
        false,
        "TextStyle",
        "EnemyUnitIndicator_ChanceToHit",
        "Translate",
        true,
        "Text",
        T(631298662093, "Autosaving...")
      })
    })
  })
})
