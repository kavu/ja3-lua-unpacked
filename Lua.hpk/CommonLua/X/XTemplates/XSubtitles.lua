PlaceObj("XTemplate", {
  group = "Common",
  id = "XSubtitles",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XSubtitles",
    "ZOrder",
    -1,
    "VAlign",
    "bottom",
    "MinHeight",
    100,
    "DrawOnTop",
    true,
    "HandleKeyboard",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idText",
      "HandleKeyboard",
      false,
      "HandleMouse",
      false,
      "ChildrenHandleMouse",
      false,
      "TextStyle",
      "UISubtitles",
      "Translate",
      true,
      "TextHAlign",
      "center"
    })
  })
})
