PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu PDA",
  id = "PDAQuestUnreadIndicator",
  PlaceObj("XTemplateWindow", {
    "Id",
    "idUnread",
    "VAlign",
    "center",
    "Visible",
    false,
    "ChildrenHandleMouse",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "HandleMouse",
      false,
      "TextStyle",
      "PDAUnreadIndicator",
      "Text",
      "!"
    })
  })
})
