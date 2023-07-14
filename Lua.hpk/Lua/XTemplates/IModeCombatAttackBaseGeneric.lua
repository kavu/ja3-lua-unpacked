PlaceObj("XTemplate", {
  Comment = "base of all attack targeting modes",
  __content = function(parent, context)
    return parent:ResolveId("idParent")
  end,
  group = "Zulu",
  id = "IModeCombatAttackBaseGeneric",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "IModeCommonUnitControl"
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ExitAttackMode",
      "ActionName",
      T(727215168833, "Exit Attack Mode"),
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "ActionBindable",
      true,
      "OnAction",
      function(self, host, source, ...)
        local dlg = GetInGameInterfaceModeDlg()
        if dlg.crosshair then
          dlg:RemoveCrosshair()
          if not IsKindOfClasses(dlg, "IModeCombatAttack", "IModeCombatMelee") then
            return
          end
        end
        if g_Combat then
          if g_Combat:ShouldEndCombat() then
            g_Combat:EndCombatCheck(true)
          else
            SetInGameInterfaceMode("IModeCombatMovement")
          end
        else
          SetInGameInterfaceMode("IModeExploration", {suppress_camera_init = true})
        end
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "GenericHUDButtonFrame",
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
        "Padding",
        box(5, 0, 5, 0),
        "MinWidth",
        170,
        "MaxWidth",
        170,
        "LayoutMethod",
        "HList",
        "FoldWhenHidden",
        true,
        "OnPressEffect",
        "action",
        "OnPressParam",
        "ExitAttackMode"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idLargeText",
          "Dock",
          "box",
          "VAlign",
          "center",
          "MaxWidth",
          120,
          "TextStyle",
          "HUDHeaderBig",
          "Translate",
          true,
          "Text",
          T(247399428705, "CANCEL"),
          "TextHAlign",
          "center"
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnSetRollover(self, rollover)",
          "func",
          function(self, rollover)
            self.idLargeText:SetTextStyle(rollover and "HUDHeaderBigLight" or "HUDHeaderBig")
            XButton.OnSetRollover(self, rollover)
          end
        })
      })
    })
  })
})
