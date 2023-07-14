PlaceObj("XTemplate", {
  __is_kind_of = "XContextControl",
  group = "Zulu Rollover",
  id = "MercStatusEffectsMoreInfo",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextControl",
    "Margins",
    box(6, 0, 0, 0),
    "Padding",
    box(6, 6, 6, 6),
    "Dock",
    "right",
    "VAlign",
    "top",
    "LayoutMethod",
    "VList",
    "UseClipBox",
    false,
    "Background",
    RGBA(52, 55, 61, 255),
    "BackgroundRectGlowSize",
    2,
    "BackgroundRectGlowColor",
    RGBA(32, 35, 47, 255)
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "more info observer",
      "__context",
      function(parent, context)
        return "g_RolloverShowMoreInfo"
      end,
      "__class",
      "XContextWindow",
      "Dock",
      "ignore",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:SetVisible(g_RolloverShowMoreInfo)
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
        box(10, 0, 0, 0),
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
        T(195286264466, "INFO"),
        "TextVAlign",
        "bottom"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return IsKindOf(context, "StatusEffectObject") and context:GetUIVisibleStatusEffects() or empty_table
      end,
      "__class",
      "XContentTemplate",
      "Id",
      "idEffectList",
      "MaxHeight",
      600,
      "LayoutMethod",
      "VWrap",
      "LayoutHSpacing",
      6,
      "LayoutVSpacing",
      6
    }, {
      PlaceObj("XTemplateForEach", {
        "comment",
        "status effects",
        "__context",
        function(parent, context, item, i, n)
          return item
        end,
        "run_after",
        function(child, context, item, i, n, last)
          child.idIcon:SetImage(item.Icon)
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextWindow",
          "IdNode",
          true,
          "Padding",
          box(10, 10, 10, 10),
          "MinWidth",
          356,
          "MaxWidth",
          356,
          "LayoutMethod",
          "VList",
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 0, 0, 3),
            "LayoutMethod",
            "HList"
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
              "Margins",
              box(10, 0, 0, 0),
              "HAlign",
              "left",
              "VAlign",
              "center",
              "Clip",
              false,
              "UseClipBox",
              false,
              "TextStyle",
              "UIDlgTitle",
              "Translate",
              true,
              "Text",
              T(110936112713, "<DisplayName>")
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idLastsUntil",
            "HAlign",
            "left",
            "VAlign",
            "center",
            "Clip",
            false,
            "UseClipBox",
            false,
            "TextStyle",
            "StatusEffectLastsUntilLabel",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local unit = self:ResolveId("node"):ResolveId("node"):ResolveId("node").context
              if not IsKindOf(unit, "Unit") then
                return
              end
              local statusEffect = context
              if statusEffect.type == "AttackBased" then
                self:SetText(T(643513756959, "ATTACK"))
                return
              end
              local expirationTurn = unit:GetEffectExpirationTurn(context.class, "expiration")
              if expirationTurn == -1 then
                self:SetVisible(false)
                return
              end
              if g_Combat then
                local expiresIn = expirationTurn - g_Combat.current_turn
                if expiresIn == 0 then
                  self:SetText(T(146885902735, "Until end of turn"))
                elseif expiresIn == 1 then
                  self:SetText(T(743845693646, "Until end of next turn"))
                else
                  self:SetText(T({
                    484004363812,
                    "<num> turns left",
                    num = expiresIn
                  }))
                end
                self:SetVisible(true)
              end
              XContextControl.OnContextUpdate(self, context)
            end,
            "Translate",
            true,
            "HideOnEmpty",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "TextStyle",
            "SatelliteContextMenuKeybind",
            "Translate",
            true,
            "Text",
            T(798944656602, "<Description>")
          })
        })
      })
    })
  })
})
