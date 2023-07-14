PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu Satellite UI",
  id = "PDAFinances",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "Padding",
    box(16, 0, 0, 16),
    "LayoutMethod",
    "VList"
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "Finances",
      "__class",
      "XText",
      "TextStyle",
      "PDA_FinancesHeader",
      "Translate",
      true,
      "Text",
      T(163622507649, "Finances")
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Margins",
      box(2, 8, 0, 0),
      "Image",
      "UI/PDA/separate_line_vertical",
      "FrameBox",
      box(3, 3, 3, 3),
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "Daily",
      "__class",
      "XText",
      "Margins",
      box(0, 0, 0, 8),
      "TextStyle",
      "PDA_FinancesHeaderSmall",
      "Translate",
      true,
      "Text",
      T(982164253236, "Daily")
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "income",
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "left",
        "TextStyle",
        "PDA_FinancesText",
        "Translate",
        true,
        "Text",
        T(253135338545, "Income")
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "right",
        "TextStyle",
        "PDA_FinancesText",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local value = GetIncome(1)
          local text = T({
            812946341374,
            "<style PDA_FinancesValueText><money(value)></style>/Day",
            value = value
          })
          self:SetText(text)
        end,
        "Translate",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "burn rate",
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "left",
        "TextStyle",
        "PDA_FinancesText",
        "Translate",
        true,
        "Text",
        T(942392081358, "Burn Rate")
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "right",
        "TextStyle",
        "PDA_FinancesText",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local value = GetBurnRate(1)
          local text = T({
            812946341374,
            "<style PDA_FinancesValueText><money(value)></style>/Day",
            value = value
          })
          self:SetText(text)
        end,
        "Translate",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Margins",
      box(2, 8, 0, 0),
      "Image",
      "UI/PDA/separate_line_vertical",
      "FrameBox",
      box(3, 3, 3, 3),
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "48 Hours",
      "__class",
      "XText",
      "Margins",
      box(0, 0, 0, 8),
      "TextStyle",
      "PDA_FinancesHeaderSmall",
      "Translate",
      true,
      "Text",
      T(175727812929, "Past 48 Hours")
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "deposits",
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "left",
        "TextStyle",
        "PDA_FinancesText",
        "Translate",
        true,
        "Text",
        T(703805597401, "Deposits")
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "right",
        "TextStyle",
        "PDA_FinancesText",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local value = GetPastMoneyTransfers(const.Scale.day * 2)
          value = value.deposit or 0
          local text = T({
            265144828910,
            "<style PDA_FinancesValueText><money(value)></style>",
            value = value
          })
          self:SetText(text)
        end,
        "Translate",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "operations",
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "left",
        "TextStyle",
        "PDA_FinancesText",
        "Translate",
        true,
        "Text",
        T(382878127945, "Operations")
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "right",
        "TextStyle",
        "PDA_FinancesText",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local value = GetPastMoneyTransfers(const.Scale.day * 2)
          value = value.operation or 0
          local text
          text = T({
            265144828910,
            "<style PDA_FinancesValueText><money(value)></style>",
            value = value
          })
          self:SetText(text)
        end,
        "Translate",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "expenses",
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "left",
        "TextStyle",
        "PDA_FinancesText",
        "Translate",
        true,
        "Text",
        T(788490944804, "Expenses")
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "right",
        "TextStyle",
        "PDA_FinancesText",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local value = GetPastMoneyTransfers(const.Scale.day * 2)
          value = value.expense or 0
          local text
          if 0 <= value then
            text = T({
              265144828910,
              "<style PDA_FinancesValueText><money(value)></style>",
              value = value
            })
          else
            text = T({
              614766635958,
              "(<style PDA_FinancesValueText><money(value)></style>)",
              value = abs(value)
            })
          end
          self:SetText(text)
        end,
        "Translate",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Margins",
      box(2, 8, 0, 0),
      "Image",
      "UI/PDA/separate_line_vertical",
      "FrameBox",
      box(3, 3, 3, 3),
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "Balance",
      "__class",
      "XText",
      "Margins",
      box(0, 0, 0, 8),
      "TextStyle",
      "PDA_FinancesHeaderSmall",
      "Translate",
      true,
      "Text",
      T(841988355234, "Balance")
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "current",
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "left",
        "TextStyle",
        "PDA_FinancesText",
        "Translate",
        true,
        "Text",
        T(822876069333, "Current Cash")
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "right",
        "TextStyle",
        "PDA_FinancesText",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local value = Game.Money
          local text = T({
            265144828910,
            "<style PDA_FinancesValueText><money(value)></style>",
            value = value
          })
          self:SetText(text)
        end,
        "Translate",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "7d",
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "left",
        "TextStyle",
        "PDA_FinancesText",
        "Translate",
        true,
        "Text",
        T(483684761215, "7D Estimate")
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "right",
        "TextStyle",
        "PDA_FinancesText",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local value = GetMoneyProjection(7)
          local text
          if 0 <= value then
            text = T({
              261662348090,
              "<style PDA_FinancesValueText><moneyRounded(value)></style>",
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
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "14d",
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "left",
        "TextStyle",
        "PDA_FinancesText",
        "Translate",
        true,
        "Text",
        T(836857610428, "14D Estimate")
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Dock",
        "right",
        "TextStyle",
        "PDA_FinancesText",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local value = GetMoneyProjection(14)
          local text
          if 0 <= value then
            text = T({
              261662348090,
              "<style PDA_FinancesValueText><moneyRounded(value)></style>",
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
        true
      })
    })
  })
})
