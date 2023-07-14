PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu",
  id = "RolloverGeneric",
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
      2,
      "BackgroundRectGlowColor",
      RGBA(32, 35, 47, 255),
      "OnContextUpdate",
      function(self, context, ...)
        local control = context.control
        local enabled = control:GetEnabled()
        local title = not enabled and context.RolloverDisabledTitle ~= "" and context.RolloverDisabledTitle or control:GetRolloverTitle() or context.RolloverTitle ~= "" and context.RolloverTitle
        self.idTitle:SetText(title)
        local showTitle = self.idTitle.text ~= ""
        self.idTitle:SetVisible(showTitle)
        self.idTitle:SetContext(context)
        self.idText:SetText(not enabled and (context.RolloverDisabledText ~= "" and context.RolloverDisabledText or control:GetRolloverDisabledText()) or control:GetRolloverText() or context.RolloverText ~= "" and context.RolloverText)
        self.idText:SetContext(context)
        if not showTitle then
          self.idTitlebar:SetVisible(false)
        end
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
        "Id",
        "idTitlebar",
        "FoldWhenHidden",
        true
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Margins",
          box(10, 0, 10, 0),
          "Padding",
          box(0, 0, 0, 0),
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
          box(6, 6, 6, 6),
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
