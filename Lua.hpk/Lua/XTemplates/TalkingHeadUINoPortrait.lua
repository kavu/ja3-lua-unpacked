PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "TalkingHeadUINoPortrait",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "HAlign",
    "center",
    "VAlign",
    "top",
    "UseClipBox",
    false,
    "Visible",
    false,
    "FadeInTime",
    300,
    "FadeOutTime",
    500,
    "ChildrenHandleMouse",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Dock",
      "box",
      "UseClipBox",
      false,
      "Image",
      "UI/Common/conversation_pad",
      "SqueezeX",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idText",
      "Padding",
      box(20, 10, 20, 10),
      "HAlign",
      "center",
      "MaxWidth",
      400,
      "TextStyle",
      "TalkingHeadTextBigger",
      "Translate",
      true,
      "TextHAlign",
      "center"
    })
  })
})
