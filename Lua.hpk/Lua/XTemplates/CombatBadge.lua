PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu Badges",
  id = "CombatBadge",
  PlaceObj("XTemplateWindow", {
    "__class",
    "CombatBadge",
    "IdNode",
    true,
    "HAlign",
    "left",
    "VAlign",
    "top",
    "MinWidth",
    1,
    "MinHeight",
    1,
    "UseClipBox",
    false,
    "FoldWhenHidden",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "RolloverTemplate",
      "StatusEffectsRollover",
      "RolloverText",
      T(327307292756, "STATUS EFFECTS"),
      "RolloverOffset",
      box(10, 0, 10, 0),
      "Id",
      "idMain",
      "VAlign",
      "top",
      "LayoutMethod",
      "VList",
      "UseClipBox",
      false,
      "HandleMouse",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idAboveName",
        "Dock",
        "top",
        "HAlign",
        "left",
        "Clip",
        false,
        "UseClipBox",
        false,
        "Visible",
        false,
        "FoldWhenHidden",
        true,
        "HandleMouse",
        false,
        "ChildrenHandleMouse",
        false,
        "TextStyle",
        "BadgeName_Red",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          CombatBadgeAboveNameTextUpdate(self)
        end,
        "Translate",
        true,
        "Text",
        T(865071357285, "OUT OF AMMO")
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "name and above",
        "__class",
        "XContextWindow",
        "Id",
        "idNameStripe",
        "Padding",
        box(2, 2, 2, 2),
        "Dock",
        "top",
        "VAlign",
        "top",
        "UseClipBox",
        false,
        "FoldWhenHidden",
        true,
        "ContextUpdateOnOpen",
        true
      }, {
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return SubContext(context, {
              context.session_id .. "_combat_badge"
            })
          end,
          "__class",
          "XText",
          "Id",
          "idName",
          "Margins",
          box(0, -6, 0, -6),
          "HAlign",
          "left",
          "Clip",
          false,
          "UseClipBox",
          false,
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "ChildrenHandleMouse",
          false,
          "TextStyle",
          "BadgeName",
          "Translate",
          true,
          "Text",
          T(459179278354, "<DisplayName>")
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "CombatBadgeLightIndicator"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idSubContainer",
        "LayoutMethod",
        "HList",
        "UseClipBox",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idMercIcon",
          "HAlign",
          "left",
          "MinWidth",
          23,
          "MinHeight",
          30,
          "MaxWidth",
          23,
          "MaxHeight",
          30,
          "UseClipBox",
          false,
          "FoldWhenHidden",
          true,
          "DrawOnTop",
          true,
          "ChildrenHandleMouse",
          false,
          "ImageFit",
          "stretch"
        }),
        PlaceObj("XTemplateWindow", {
          "LayoutMethod",
          "VList",
          "UseClipBox",
          false
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "target health bar",
            "__class",
            "HealthBar",
            "Id",
            "idBar",
            "BorderWidth",
            1,
            "HAlign",
            "left",
            "VAlign",
            "top",
            "MinWidth",
            80,
            "MaxWidth",
            80,
            "UseClipBox",
            false,
            "FoldWhenHidden",
            true,
            "BorderColor",
            RGBA(35, 61, 78, 255),
            "Background",
            RGBA(35, 61, 78, 255),
            "Progress",
            {0, 0},
            "DisplayTempHp",
            true,
            "ShowIcons",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return context.StatusEffects
            end,
            "__condition",
            function(parent, context)
              return IsKindOf(parent:ResolveId("node").context, "StatusEffectObject")
            end,
            "__class",
            "XContentTemplate",
            "Id",
            "idStatusEffectsContainer",
            "IdNode",
            false,
            "Margins",
            box(0, 0, 0, 5),
            "ScaleModifier",
            point(600, 600),
            "UseClipBox",
            false,
            "FoldWhenHidden",
            true,
            "ChildrenHandleMouse",
            false
          }, {
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return parent:ResolveId("node").context
              end,
              "__class",
              "XContextWindow",
              "Id",
              "idStatusEffects",
              "HAlign",
              "left",
              "LayoutMethod",
              "HList",
              "UseClipBox",
              false
            }, {
              PlaceObj("XTemplateForEach", {
                "comment",
                "status effect",
                "array",
                function(parent, context)
                  return context:GetUIVisibleStatusEffects()
                end,
                "__context",
                function(parent, context, item, i, n)
                  return item
                end
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "StatusEffectIcon",
                  "RolloverTemplate",
                  "",
                  "RolloverText",
                  "",
                  "RolloverTitle",
                  "",
                  "ImageScale",
                  point(850, 850)
                })
              }),
              PlaceObj("XTemplateFunc", {
                "comment",
                "toggle xbadge mouse handling when there are any status effects",
                "name",
                "Open(self)",
                "func",
                function(self)
                  XContextWindow.Open(self)
                  do return end
                  local uiBadgeElement = self:ResolveId("node")
                  local wantToHandleMouse = #uiBadgeElement.context:GetUIVisibleStatusEffects(true) > 0
                  local xBadgeInstance = rawget(uiBadgeElement, "xbadge-instance")
                  if xBadgeInstance then
                    if wantToHandleMouse ~= xBadgeInstance.uiHandleMouse then
                      xBadgeInstance:SetHandleMouse(wantToHandleMouse)
                    end
                  else
                    uiBadgeElement:SetHandleMouse(wantToHandleMouse)
                  end
                end
              })
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateTemplate", {
      "__condition",
      function(parent, context)
        return IsKindOf(context, "UnitProperties")
      end,
      "__template",
      "CoOpOtherPlayerMark",
      "Id",
      "idPartner",
      "Dock",
      "ignore",
      "HAlign",
      "left",
      "VAlign",
      "top",
      "MinWidth",
      30,
      "MinHeight",
      30,
      "MaxWidth",
      30,
      "MaxHeight",
      30,
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local badge = self:ResolveId("node")
        badge:UpdateCoOpMarkVisibility(self)
      end
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "UpdateLayout(self)",
        "func",
        function(self)
          local badge = self:ResolveId("node")
          local b = badge.box
          local mercIcon = badge.idMercIcon
          local y = 0
          if mercIcon.visible then
            y = mercIcon.box:miny()
          else
            local nameStripe = badge.idNameStripe
            local nsB = nameStripe.box
            y = nsB:miny() + nsB:sizey() / 2 - self.measure_width / 2
          end
          self:SetBox(b:minx() - self.measure_width, y, self.measure_width, self.measure_width)
          XImage.UpdateLayout(self)
        end
      })
    })
  })
})
