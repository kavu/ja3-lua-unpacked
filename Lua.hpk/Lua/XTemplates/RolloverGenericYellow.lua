PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu",
  id = "RolloverGenericYellow",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDARolloverClass",
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
      "UseClipBox",
      false,
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
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Padding",
        box(6, 4, 6, 6),
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        5,
        "UseClipBox",
        false,
        "BackgroundRectGlowSize",
        2,
        "BackgroundRectGlowColor",
        RGBA(32, 35, 47, 255),
        "Image",
        "UI/PDA/imp_panel_2",
        "FrameBox",
        box(5, 5, 5, 5)
      }, {
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
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Id",
          "idParent",
          "IdNode",
          false,
          "Image",
          "UI/PDA/imp_bar",
          "FrameBox",
          box(5, 5, 5, 5)
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
            "PDASectorInfo_Section",
            "Translate",
            true,
            "HideOnEmpty",
            true
          })
        })
      })
    })
  })
})
