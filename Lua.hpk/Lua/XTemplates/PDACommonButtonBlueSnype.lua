PlaceObj("XTemplate", {
  __is_kind_of = "PDACommonButtonClass",
  group = "Zulu PDA",
  id = "PDACommonButtonBlueSnype",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDACommonButtonClass",
    "LayoutMethod",
    "Box",
    "DisabledBackground",
    RGBA(255, 255, 255, 100),
    "Image",
    "UI/PDA/os_system_buttons_blue",
    "FrameBox",
    box(10, 10, 10, 10),
    "TextStyle",
    "PDACommonButtonBlue",
    "Translate",
    true,
    "ColumnsUse",
    "abcca"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Margins",
      box(5, 3, 0, 3),
      "Dock",
      "left",
      "Image",
      "UI/PDA/snype_logo",
      "ImageFit",
      "smallest",
      "ImageColor",
      RGBA(196, 196, 190, 255)
    })
  })
})
