PlaceObj("XTemplate", {
  __is_kind_of = "XPopup",
  group = "Zulu",
  id = "PartyAttachedDamageNotification",
  PlaceObj("XTemplateWindow", {
    "__class",
    "DamageNotificationPopup",
    "HAlign",
    "left",
    "VAlign",
    "top",
    "LayoutMethod",
    "Box",
    "UseClipBox",
    false,
    "BorderColor",
    RGBA(255, 255, 255, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "FocusedBorderColor",
    RGBA(255, 255, 255, 0),
    "FocusedBackground",
    RGBA(255, 255, 255, 0),
    "DisabledBorderColor",
    RGBA(255, 255, 255, 0)
  }, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "HUDMerc",
      "Id",
      "idHudMerc",
      "Margins",
      box(0, 0, 0, 0),
      "LayoutMethod",
      "Box",
      "HandleMouse",
      false,
      "ChildrenHandleMouse",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "Id",
        "idBackground",
        "ZOrder",
        0,
        "Margins",
        box(-3, -3, -3, -3),
        "Dock",
        "box",
        "Background",
        RGBA(222, 60, 75, 255),
        "BackgroundRectGlowSize",
        1,
        "BackgroundRectGlowColor",
        RGBA(222, 60, 75, 255)
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idDamageText",
        "Dock",
        "ignore",
        "HAlign",
        "left",
        "VAlign",
        "bottom",
        "Clip",
        false,
        "UseClipBox",
        false,
        "TextStyle",
        "PDAMercNameCard_DamageTaken",
        "Translate",
        true
      })
    })
  })
})
