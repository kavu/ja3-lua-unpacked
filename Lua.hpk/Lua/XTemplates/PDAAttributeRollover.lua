PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu PDA",
  id = "PDAAttributeRollover",
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
        local show = self.idTitle.text ~= ""
        self.idTitle:SetVisible(show)
        self.idTitle:SetContext(context)
        self.idText:SetText(not enabled and context.RolloverDisabledText ~= "" and context.RolloverDisabledText or control:GetRolloverText() or context.RolloverText ~= "" and context.RolloverText)
        self.idText:SetContext(context)
        local stat = control:GetAttribute()
        local mods = context:GetTotalModsByType(stat)
        if mods then
          if mods.studying and mods.studying > 0 then
            self.idBoosts:SetVisible(true)
            local boostRow = self.idStatStudying
            boostRow:SetVisible(true)
            boostRow.idStatValue:SetText(T({
              745254251351,
              "+<value>",
              value = Untranslated(mods.studying)
            }))
          end
          if mods.training and 0 < mods.training then
            self.idBoosts:SetVisible(true)
            local boostRow = self.idStatTraining
            boostRow:SetVisible(true)
            boostRow.idStatValue:SetText(T({
              745254251351,
              "+<value>",
              value = Untranslated(mods.training)
            }))
          end
          if mods.statGain and 0 < mods.statGain then
            self.idBoosts:SetVisible(true)
            local boostRow = self.idStatGain
            boostRow:SetVisible(true)
            boostRow.idStatValue:SetText(T({
              745254251351,
              "+<value>",
              value = Untranslated(mods.statGain)
            }))
          end
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
        "Padding",
        box(6, 4, 6, 6),
        "LayoutMethod",
        "VList",
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idText",
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
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idBoosts",
        "Padding",
        box(6, 4, 6, 6),
        "LayoutMethod",
        "VList",
        "Visible",
        false,
        "FoldWhenHidden",
        true,
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateForEach", {
          "comment",
          "equiped item mod",
          "array",
          function(parent, context)
            return context:GetStatBoostItemMods(context.control:GetAttribute())
          end,
          "run_after",
          function(child, context, item, i, n, last)
            child.idStatSource:SetText(item.display_text)
            child.idStatValue:SetText(T({
              745254251351,
              "+<value>",
              value = Untranslated(item.add)
            }))
            child.parent:SetVisible(true)
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idItemBoost",
            "IdNode",
            true,
            "LayoutMethod",
            "HList",
            "FoldWhenHidden",
            true
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idStatSource",
              "FoldWhenHidden",
              true,
              "TextStyle",
              "PDARolloverAdditional",
              "Translate",
              true,
              "HideOnEmpty",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idStatValue",
              "Dock",
              "right",
              "FoldWhenHidden",
              true,
              "TextStyle",
              "PDARolloverAdditional",
              "Translate",
              true,
              "HideOnEmpty",
              true,
              "TextHAlign",
              "right"
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idStatStudying",
          "IdNode",
          true,
          "LayoutMethod",
          "HList",
          "Visible",
          false,
          "FoldWhenHidden",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idStatSource",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverAdditional",
            "Translate",
            true,
            "Text",
            T(393632423840, "Studying"),
            "HideOnEmpty",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idStatValue",
            "Dock",
            "right",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverAdditional",
            "Translate",
            true,
            "HideOnEmpty",
            true,
            "TextHAlign",
            "right"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idStatTraining",
          "IdNode",
          true,
          "LayoutMethod",
          "HList",
          "Visible",
          false,
          "FoldWhenHidden",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idStatSource",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverAdditional",
            "Translate",
            true,
            "Text",
            T(383969792797, "Training"),
            "HideOnEmpty",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idStatValue",
            "Dock",
            "right",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverAdditional",
            "Translate",
            true,
            "HideOnEmpty",
            true,
            "TextHAlign",
            "right"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idStatGain",
          "IdNode",
          true,
          "LayoutMethod",
          "HList",
          "Visible",
          false,
          "FoldWhenHidden",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idStatSource",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverAdditional",
            "Translate",
            true,
            "Text",
            T(636384859066, "Field Experience"),
            "HideOnEmpty",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idStatValue",
            "Dock",
            "right",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverAdditional",
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
