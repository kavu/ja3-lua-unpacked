PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu PDA",
  id = "PDAFilterRollover",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XRolloverWindow",
    "Margins",
    box(20, 0, 20, 0),
    "BorderWidth",
    0,
    "Background",
    RGBA(27, 31, 45, 255)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "HAlign",
      "center",
      "VAlign",
      "center",
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
        "Padding",
        box(20, 2, 20, 2),
        "VAlign",
        "center",
        "Clip",
        false,
        "UseClipBox",
        false,
        "FoldWhenHidden",
        true,
        "TextStyle",
        "PDARolloverSmall",
        "Translate",
        true,
        "TextHAlign",
        "center",
        "TextVAlign",
        "center"
      })
    })
  })
})
