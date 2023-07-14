PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu Rollover",
  id = "PDAMercRollover",
  PlaceObj("XTemplateWindow", {
    "__condition",
    function(parent, context)
      return not context.control.dontShowRollover
    end,
    "__class",
    "PDARolloverClass",
    "Margins",
    box(30, 1, 0, 0),
    "UseClipBox",
    false,
    "BorderColor",
    RGBA(128, 128, 128, 0),
    "Background",
    RGBA(240, 240, 240, 0)
  }, {
    PlaceObj("XTemplateTemplate", {
      "__context",
      function(parent, context)
        return ResolvePropObj(context)
      end,
      "__condition",
      function(parent, context)
        return not context:IsDead() and context:HasVisibleEffects()
      end,
      "__template",
      "MercStatusEffectsMoreInfo",
      "Id",
      "idMoreInfo"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return ResolvePropObj(context)
      end,
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "Padding",
      box(6, 6, 6, 6),
      "MinWidth",
      356,
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
      RGBA(32, 35, 47, 255)
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
        "Margins",
        box(0, 0, 0, 3),
        "Dock",
        "top",
        "DrawOnTop",
        true,
        "Background",
        RGBA(52, 55, 61, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idName",
          "Margins",
          box(8, 0, 0, 0),
          "Dock",
          "left",
          "Clip",
          false,
          "UseClipBox",
          false,
          "FoldWhenHidden",
          true,
          "TextStyle",
          "PDACombatActionHeader",
          "Translate",
          true,
          "Text",
          T(672790549048, "<Nick><valign bottom -1><style SatelliteContextMenuDate> / <MercClass()></style>"),
          "TextVAlign",
          "bottom"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "ap indicator",
          "__condition",
          function(parent, context)
            return not context:IsDead()
          end,
          "__class",
          "XText",
          "RolloverTemplate",
          "PDAPerkRollover",
          "Dock",
          "right",
          "Clip",
          false,
          "UseClipBox",
          false,
          "TextStyle",
          "PDARolloverHeaderBeige",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local text
            if g_Combat then
              local currentAP = context:GetUIActionPoints()
              local maxAP = context:GetMaxActionPoints()
              local bonus = currentAP - maxAP
              local ctx = SubContext(context, {
                current = currentAP,
                bonus = bonus,
                max = maxAP
              })
              if 1000 <= bonus then
                text = T({
                  158709477285,
                  "<apn(max)>+<apn(bonus)>",
                  ctx
                })
              else
                text = T({
                  263805086279,
                  "<apn(current)>",
                  ctx
                })
              end
            else
              local maxAP = context:GetMaxActionPoints()
              text = T({
                330002924751,
                "<apn(maxActionPoints)>",
                maxActionPoints = maxAP
              })
            end
            text = text .. " " .. T(363250742550, "<style PDARolloverHeaderDark>AP</style>")
            self:SetText(text)
            XContextControl.OnContextUpdate(self, context)
          end,
          "Translate",
          true,
          "TextVAlign",
          "bottom"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return not context:IsDead()
        end,
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextWindow",
          "Padding",
          box(14, 0, 14, 0),
          "MinHeight",
          34,
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "hp",
            "__class",
            "XText",
            "Margins",
            box(0, -1, 0, 0),
            "HAlign",
            "left",
            "Clip",
            false,
            "UseClipBox",
            false,
            "TextStyle",
            "PDAActivitiesButtonSmall",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local maxHp, positiveMaxHp = context:GetModifiedMaxHitPoints()
              local text
              text = T(598059282023, "<style PDARolloverHeaderBeige><HitPoints></style><valign bottom -1> HP")
              if context.TempHitPoints and context.TempHitPoints > 0 then
                text = text .. T(180234152215, " <em>+<TempHitPoints></em>")
              end
              self:SetText(text)
              return XContextControl.OnContextUpdate(self, context)
            end,
            "Translate",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "Padding",
            box(2, 2, 2, 2),
            "HAlign",
            "right",
            "VAlign",
            "center",
            "Background",
            RGBA(52, 55, 61, 255)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "HealthBar",
              "HAlign",
              "right",
              "VAlign",
              "center",
              "MinWidth",
              200,
              "MinHeight",
              10,
              "MaxWidth",
              200,
              "MaxHeight",
              10,
              "Image",
              "UI/Hud/ap_bar_pad",
              "Progress",
              {0, 0},
              "DisplayTempHp",
              true,
              "FitSegments",
              true
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextWindow",
          "Margins",
          box(0, 6, 0, 0),
          "Padding",
          box(14, 3, 14, 3),
          "MinHeight",
          34,
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          -3,
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return context.Affiliation ~= "Secret" and context.HiredUntil
            end,
            "__class",
            "XText",
            "Id",
            "idContract",
            "VAlign",
            "center",
            "Clip",
            false,
            "UseClipBox",
            false,
            "TextStyle",
            "SatelliteContextMenuKeybind",
            "Translate",
            true,
            "Text",
            T(161690410358, "Contract Duration <right><style PDABrowserTextLightBold><MercContractTime()></style>")
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "VAlign",
            "center",
            "Clip",
            false,
            "UseClipBox",
            false,
            "TextStyle",
            "SatelliteContextMenuKeybind",
            "Translate",
            true,
            "Text",
            T(997240698559, "Energy<right><style PDABrowserTextLightMedium><EnergyStatusEffect()></style>")
          }),
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return IsKindOf(context, "Unit")
            end,
            "__class",
            "XText",
            "VAlign",
            "center",
            "Clip",
            false,
            "UseClipBox",
            false,
            "TextStyle",
            "SatelliteContextMenuKeybind",
            "Translate",
            true,
            "Text",
            T(258629704073, "Morale<right><style PDABrowserTextLightMedium><MercMoraleText()></style>")
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "attributes label",
          "__class",
          "XText",
          "Margins",
          box(8, 0, 0, 0),
          "MinHeight",
          34,
          "Clip",
          false,
          "UseClipBox",
          false,
          "FoldWhenHidden",
          true,
          "TextStyle",
          "PDABrowserNameSmall",
          "Translate",
          true,
          "Text",
          T(488971610056, "ATTRIBUTES"),
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return MercStatsItems(context)
          end,
          "__class",
          "XContextWindow",
          "Padding",
          box(14, 4, 14, 4),
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "Grid",
            "LayoutHSpacing",
            58,
            "LayoutVSpacing",
            2,
            "UniformColumnWidth",
            true,
            "UniformRowHeight",
            true
          }, {
            PlaceObj("XTemplateForEach", {
              "run_after",
              function(child, context, item, i, n, last)
                local columnSize = MulDivRound(#context, 1, 2)
                local column = (i - 1) / columnSize + 1
                local row = (i - 1) % columnSize + 1
                child:SetGridY(row)
                child:SetGridX(column)
                child:SetContext(item)
                local meta = Presets.MercStat.Default
                local metaEntry = meta[item.id]
                if metaEntry then
                  child.idName:SetText(metaEntry.ShortenedName)
                  child.idIcon:SetImage(metaEntry.Icon)
                end
                child.idValue:SetText(item.value)
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextWindow",
                "RolloverTemplate",
                "RolloverGeneric",
                "RolloverAnchor",
                "right",
                "RolloverText",
                T(320297314817, "<help>"),
                "RolloverTitle",
                T(801789803619, "<name>"),
                "IdNode",
                true
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "Id",
                  "idIcon",
                  "Margins",
                  box(0, 0, 10, 0),
                  "Dock",
                  "left",
                  "Transparency",
                  127,
                  "ImageScale",
                  point(400, 400),
                  "ImageColor",
                  RGBA(130, 128, 120, 255)
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idName",
                  "Dock",
                  "left",
                  "VAlign",
                  "center",
                  "TextStyle",
                  "MercStatName",
                  "Translate",
                  true
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idValue",
                  "Dock",
                  "right",
                  "HAlign",
                  "right",
                  "VAlign",
                  "center",
                  "TextStyle",
                  "MercStatValue",
                  "WordWrap",
                  false
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "status effects",
          "__condition",
          function(parent, context)
            return context:HasVisibleEffects()
          end,
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "conditions label",
            "__class",
            "XText",
            "Margins",
            box(8, 0, 0, 0),
            "MinHeight",
            34,
            "Clip",
            false,
            "UseClipBox",
            false,
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDABrowserNameSmall",
            "Translate",
            true,
            "Text",
            T(686039592936, "STATUS EFFECTS"),
            "TextVAlign",
            "center"
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return context:GetUIVisibleStatusEffects()
            end,
            "__class",
            "XContextWindow",
            "Padding",
            box(14, 10, 14, 10),
            "LayoutMethod",
            "Grid",
            "LayoutHSpacing",
            10,
            "LayoutVSpacing",
            2,
            "UniformColumnWidth",
            true,
            "UniformRowHeight",
            true,
            "Background",
            RGBA(32, 35, 47, 255)
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "status effects",
              "run_after",
              function(child, context, item, i, n, last)
                local columnSize = MulDivRound(#context, 1, 2)
                local column = (i - 1) / columnSize + 1
                local row = (i - 1) % columnSize + 1
                child:SetGridY(row)
                child:SetGridX(column)
                child:SetContext(item)
                child.idIcon:SetImage(item.Icon)
                child.idLabel:SetText(item.DisplayName)
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextWindow",
                "IdNode",
                true,
                "MaxWidth",
                170,
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                10,
                "UseClipBox",
                false,
                "ChildrenHandleMouse",
                false
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "StatusEffectIcon",
                  "Id",
                  "idIcon",
                  "HandleMouse",
                  false
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idLabel",
                  "HAlign",
                  "left",
                  "VAlign",
                  "center",
                  "Clip",
                  false,
                  "UseClipBox",
                  false,
                  "TextStyle",
                  "MercStatName",
                  "Translate",
                  true
                })
              })
            })
          }),
          PlaceObj("XTemplateTemplate", {"__template", "MoreInfo"})
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return context:IsDead()
        end,
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        6
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextWindow",
          "Padding",
          box(14, 8, 14, 8),
          "LayoutMethod",
          "VList",
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "hp",
            "__class",
            "XText",
            "Clip",
            false,
            "UseClipBox",
            false,
            "TextStyle",
            "PDARolloverText",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local maxHp, positiveMaxHp = context:GetModifiedMaxHitPoints()
              local text
              if maxHp < positiveMaxHp then
                text = T({
                  505183358375,
                  "HP: <HitPoints>/<maxHp>(<positiveMaxHp>)",
                  maxHp = maxHp,
                  positiveMaxHp = positiveMaxHp
                })
              else
                text = T({
                  995385072414,
                  "HP: <HitPoints>/<maxHp>",
                  maxHp = maxHp
                })
              end
              if context.TempHitPoints and context.TempHitPoints > 0 then
                text = text .. T(940545130284, " <em>+ <TempHitPoints></em>")
              end
              self:SetText(text)
              return XContextControl.OnContextUpdate(self, context)
            end,
            "Translate",
            true,
            "Text",
            T(201768379411, "HP: <HitPoints>/<GetModifiedMaxHitPoints()>")
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "killed text",
            "__class",
            "XText",
            "Id",
            "idKilled",
            "Clip",
            false,
            "UseClipBox",
            false,
            "TextStyle",
            "PDARolloverText",
            "Translate",
            true,
            "Text",
            T(342894139693, "Killed in action")
          })
        })
      })
    })
  })
})
