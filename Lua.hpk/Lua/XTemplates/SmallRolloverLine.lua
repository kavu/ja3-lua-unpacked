PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu",
  id = "SmallRolloverLine",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XRolloverWindow",
    "Margins",
    box(0, 0, 0, 10),
    "BorderWidth",
    0,
    "Background",
    RGBA(0, 0, 0, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "Background",
      RGBA(52, 55, 61, 255),
      "BackgroundRectGlowSize",
      2,
      "BackgroundRectGlowColor",
      RGBA(32, 35, 47, 255),
      "OnContextUpdate",
      function(self, context, ...)
        local control = context.control
        local enabled = control:GetEnabled()
        self.idTitle:SetText(not enabled and context.RolloverDisabledText ~= "" and context.RolloverDisabledText or context.RolloverText ~= "" and context.RolloverText or control:GetRolloverText())
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idTitle",
        "Margins",
        box(2, 0, 0, 0),
        "Padding",
        box(2, 2, 2, 0),
        "HAlign",
        "left",
        "VAlign",
        "center",
        "Clip",
        false,
        "UseClipBox",
        false,
        "FoldWhenHidden",
        true,
        "TextStyle",
        "PDAMercNameCard_Light",
        "Translate",
        true,
        "Text",
        T(512369062263, "<DisplayName>"),
        "WordWrap",
        false,
        "TextVAlign",
        "bottom"
      })
    })
  })
})
