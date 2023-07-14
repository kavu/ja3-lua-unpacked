PlaceObj("XTemplate", {
  group = "Zulu Dev",
  id = "AIDebugRollover",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContentTemplate",
    "Id",
    "idSquadRollover",
    "Margins",
    box(10, 20, 0, 0),
    "HAlign",
    "left",
    "VAlign",
    "top",
    "UseClipBox",
    false,
    "DrawOnTop",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Margins",
      box(-5, -5, -5, -10),
      "Padding",
      box(5, 5, 5, 5),
      "Dock",
      "box",
      "UseClipBox",
      false,
      "BorderColor",
      RGBA(255, 255, 255, 10),
      "FocusedBorderColor",
      RGBA(255, 255, 255, 10),
      "FocusedBackground",
      RGBA(255, 255, 255, 10),
      "DisabledBorderColor",
      RGBA(255, 255, 255, 10),
      "Image",
      "UI/Common/rollover_pad"
    }),
    PlaceObj("XTemplateWindow", {
      "Padding",
      box(3, 3, 3, 3),
      "LayoutMethod",
      "VList",
      "UseClipBox",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Clip",
        false,
        "UseClipBox",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "EnemyCth",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local text = context:GetVoxelRolloverText()
          self:SetText(text)
          XContextControl.OnContextUpdate(self, context)
        end
      })
    })
  })
})
