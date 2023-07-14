PlaceObj("XTemplate", {
  group = "Zulu",
  id = "IModeCombatMovement",
  PlaceObj("XTemplateWindow", {
    "__class",
    "IModeCombatMovement",
    "FocusOnOpen",
    ""
  }, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "IModeCommonUnitControl"
    }, {
      PlaceObj("XTemplateAction", {
        "ActionId",
        "ExitMovementMode",
        "ActionName",
        T(905101415376, "Exit Movement Mode"),
        "ActionShortcut",
        "Escape",
        "ActionGamepad",
        "ButtonB",
        "ActionState",
        function(self, host)
          return host.movement_mode and "enabled" or "disabled"
        end,
        "OnAction",
        function(self, host, source, ...)
          host:SetMovementMode(false)
        end,
        "IgnoreRepeated",
        true
      }),
      PlaceObj("XTemplateTemplate", {
        "__template",
        "GenericHUDButtonFrame",
        "Id",
        "idEndTurnFrame",
        "IdNode",
        false,
        "HAlign",
        "right",
        "FoldWhenHidden",
        true
      }, {
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return Selection
          end,
          "__class",
          "HUDButton",
          "RolloverTemplate",
          "SmallRolloverGeneric",
          "RolloverAnchor",
          "center-top",
          "Id",
          "idTurn",
          "Padding",
          box(5, 0, 5, 0),
          "MinWidth",
          170,
          "MaxWidth",
          170,
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local visible = false
            if self.context and self.context[1] then
              local canControlUnit, reason = self.context[1]:CanBeControlled()
              visible = canControlUnit
              if reason == "not_local_turn" then
                visible = true
              end
            end
            if IsCoOpGame() then
              if g_Combat and g_Combat:IsLocalPlayerEndTurn() then
                self.idLargeText:SetText(T(940649323656, "NOT READY"))
              else
                self.idLargeText:SetText(T(562439070450, "READY"))
              end
            elseif not g_Combat or g_Combat:AreEnemiesAware(g_CurrentTeam) then
              self.idLargeText:SetText(T(848419963999, "END TURN"))
              visible = visible and IsInCombat("check pending")
            else
              self.idLargeText:SetText(T(549061627560, "EXIT COMBAT"))
            end
            XContextWindow.OnContextUpdate(self, context, ...)
            self:ResolveId("node").idEndTurnFrame:SetVisible(visible)
          end,
          "OnPressEffect",
          "action",
          "OnPressParam",
          "EndTurn"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idEndTurnIcon",
            "Dock",
            "right",
            "Image",
            "UI/Hud/end_turn",
            "Columns",
            2
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idLargeText",
            "Margins",
            box(0, 0, 3, 0),
            "VAlign",
            "center",
            "TextStyle",
            "HUDHeaderBig",
            "Translate",
            true,
            "TextHAlign",
            "center"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "controller hint",
            "__context",
            function(parent, context)
              return "GamepadUIStyleChanged"
            end,
            "__class",
            "XText",
            "HAlign",
            "left",
            "VAlign",
            "bottom",
            "ScaleModifier",
            point(700, 700),
            "TextStyle",
            "HUDHeaderBig",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              self:SetVisible(GetUIStyleGamepad())
              XText.OnContextUpdate(self, context, ...)
            end,
            "Translate",
            true,
            "Text",
            T(539750644643, "<LeftTrigger> + <ButtonB>")
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnSetRollover(self, rollover)",
            "func",
            function(self, rollover)
              PlayFX("buttonRollover", rollover and "start" or "end", self.idEndTurnIcon, "idEndTurnIcon")
              self.idEndTurnIcon:SetColumn(rollover and 2 or 1)
              self.idLargeText:SetTextStyle(rollover and "HUDHeaderBigLight" or "HUDHeaderBig")
              XButton.OnSetRollover(self, rollover)
            end
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XDialog",
      "IdNode",
      false,
      "HAlign",
      "center",
      "VAlign",
      "center",
      "ChildrenHandleMouse",
      false,
      "FocusOnOpen",
      ""
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idTurnText",
        "Padding",
        box(0, 0, 0, 0),
        "Visible",
        false,
        "FadeInTime",
        100,
        "FadeOutTime",
        3000,
        "TextStyle",
        "TacticalNotification",
        "Translate",
        true
      })
    })
  })
})
