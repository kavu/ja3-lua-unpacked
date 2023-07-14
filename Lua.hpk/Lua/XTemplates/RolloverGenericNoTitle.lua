PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu",
  id = "RolloverGenericNoTitle",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDARolloverClass",
    "ZOrder",
    999,
    "BorderWidth",
    0,
    "MaxWidth",
    350,
    "UseClipBox",
    false,
    "Background",
    RGBA(0, 0, 0, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "Padding",
      box(2, 2, 2, 2),
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      5,
      "UseClipBox",
      false,
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
        self.idText:SetText(not enabled and context.RolloverDisabledText ~= "" and context.RolloverDisabledText or control:GetRolloverText() or context.RolloverText ~= "" and context.RolloverText)
        self.idText:SetContext(context)
      end
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "Open",
        "func",
        function(self, ...)
          XContextControl.Open(self, ...)
          local control = self.context.control
          local offset = control and control:GetRolloverOffset()
          if offset and offset ~= box(0, 0, 0, 0) then
            self.parent:SetMargins(self.parent.Margins + offset)
          end
        end
      }),
      PlaceObj("XTemplateWindow", {"MinWidth", 350}, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(5, 0, 0, 0),
          "Dock",
          "right",
          "HAlign",
          "right",
          "VAlign",
          "center",
          "MinWidth",
          6,
          "MinHeight",
          6,
          "MaxWidth",
          6,
          "MaxHeight",
          6,
          "Background",
          RGBA(69, 73, 81, 255)
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idParent",
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idText",
          "Padding",
          box(8, 5, 8, 5),
          "FoldWhenHidden",
          true,
          "TextStyle",
          "PDARolloverText",
          "Translate",
          true,
          "HideOnEmpty",
          true
        })
      })
    })
  })
})
