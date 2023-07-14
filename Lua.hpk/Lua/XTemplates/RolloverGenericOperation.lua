PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu",
  id = "RolloverGenericOperation",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XRolloverWindow",
    "BorderWidth",
    0,
    "MaxWidth",
    400,
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
      box(6, 4, 6, 6),
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      5,
      "UseClipBox",
      false,
      "Background",
      RGBA(52, 55, 61, 255),
      "BackgroundRectGlowSize",
      1,
      "BackgroundRectGlowColor",
      RGBA(52, 55, 61, 255),
      "OnContextUpdate",
      function(self, context, ...)
        local control = context.control
        local enabled = control:GetEnabled()
        local title = not enabled and context.RolloverDisabledTitle ~= "" and context.RolloverDisabledTitle or control:GetRolloverTitle() or context.RolloverTitle ~= "" and context.RolloverTitle
        self.idTitle:SetText(title)
        local show = self.idTitle.text ~= ""
        self.idTitle:SetVisible(show)
        self.idTitle:SetContext(context)
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
      PlaceObj("XTemplateWindow", nil, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Margins",
          box(10, 0, 0, 0),
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "center",
          "MaxWidth",
          450,
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "TextStyle",
          "PDACombatActionHeader",
          "Translate",
          true,
          "TextVAlign",
          "center"
        }),
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
          21,
          "MinHeight",
          21,
          "MaxWidth",
          21,
          "MaxHeight",
          21,
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
