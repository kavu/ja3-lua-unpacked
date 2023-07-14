PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu PDA",
  id = "PDAMoneyRollover",
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
          if TutorialHintsState.SatViewFinancesShown then
            TutorialHintsState.SatViewFinances = true
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
          "Text",
          T(478539744445, "Finances"),
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
          "LayoutMethod",
          "Grid"
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "income",
            "__class",
            "XText",
            "Padding",
            box(8, 5, 8, 5),
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverText",
            "Translate",
            true,
            "Text",
            T(670968933606, "Income"),
            "HideOnEmpty",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Padding",
            box(8, 5, 8, 5),
            "GridX",
            2,
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverText",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local income = GetIncome(1) or 0
              local text = T({
                225569119592,
                "<money(income)>/Day",
                income = income
              })
              self:SetText(text)
            end,
            "Translate",
            true,
            "HideOnEmpty",
            true,
            "TextHAlign",
            "right"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "burn",
            "__class",
            "XText",
            "Padding",
            box(8, 5, 8, 5),
            "GridY",
            2,
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverText",
            "Translate",
            true,
            "Text",
            T(974729983146, "Burn Rate"),
            "HideOnEmpty",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Padding",
            box(8, 5, 8, 5),
            "GridX",
            2,
            "GridY",
            2,
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverText",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local burnRate = GetBurnRate(1) or 0
              local text = T({
                105101286891,
                "<money(burnRate)>/Day",
                burnRate = burnRate
              })
              self:SetText(text)
            end,
            "Translate",
            true,
            "HideOnEmpty",
            true,
            "TextHAlign",
            "right"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "14D",
            "__class",
            "XText",
            "Padding",
            box(8, 5, 8, 5),
            "GridY",
            3,
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverText",
            "Translate",
            true,
            "Text",
            T(461157338926, "14D Estimate "),
            "HideOnEmpty",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Padding",
            box(8, 5, 8, 5),
            "GridX",
            2,
            "GridY",
            3,
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverText",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local value = GetMoneyProjection(14)
              local text
              if 0 <= value then
                text = T({
                  149250925651,
                  "<moneyRounded(value)>",
                  value = value
                })
              else
                text = T({
                  917002472262,
                  "<style PDA_FinancesValueTextRed>(<moneyRounded(value)>)</style>",
                  value = abs(value)
                })
              end
              self:SetText(text)
            end,
            "Translate",
            true,
            "HideOnEmpty",
            true,
            "TextHAlign",
            "right"
          })
        })
      })
    })
  })
})
