PlaceObj("XTemplate", {
  group = "Zulu Dev",
  id = "IModeAIDebug",
  PlaceObj("XTemplateWindow", {
    "__condition",
    function(parent, context)
      return Platform.developer
    end,
    "__class",
    "IModeAIDebug",
    "OnContextUpdate",
    function(self, context, ...)
      self:ResolveId("idCommonUnitControl"):SetContext(Selection, true)
      self:ResolveId("idTurn"):SetContext(Selection, true)
    end
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ExitMode",
      "ActionName",
      T(741395989540, "Exit Mode"),
      "ActionShortcut",
      "Escape",
      "ActionBindable",
      true,
      "OnAction",
      function(self, host, source, ...)
        if g_Combat then
          SetInGameInterfaceMode("IModeCombatMovement")
        else
          SetInGameInterfaceMode("IModeExploration")
        end
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XTextButton",
      "Margins",
      box(0, 0, 20, 20),
      "HAlign",
      "right",
      "VAlign",
      "bottom",
      "Background",
      RGBA(84, 74, 72, 255),
      "OnPressEffect",
      "action",
      "OnPressParam",
      "ExitMode",
      "TextStyle",
      "ActionBarButtonYellowBig",
      "Text",
      "Close"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return parent
      end,
      "__class",
      "XText",
      "Id",
      "idText",
      "Margins",
      box(20, 20, 0, 0),
      "HAlign",
      "left",
      "VAlign",
      "top",
      "MinWidth",
      300,
      "MinHeight",
      500,
      "Background",
      RGBA(52, 45, 41, 255),
      "HandleKeyboard",
      false,
      "ChildrenHandleMouse",
      false,
      "TextStyle",
      "CombatLogButtonActive"
    })
  })
})
