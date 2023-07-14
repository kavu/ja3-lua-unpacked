PlaceObj("XTemplate", {
  __is_kind_of = "XContentTemplate",
  group = "Zulu",
  id = "CoOpButton",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return "coop button"
    end,
    "__class",
    "XContentTemplate",
    "HAlign",
    "right"
  }, {
    PlaceObj("XTemplateTemplate", {
      "__condition",
      function(parent, context)
        return netInGame
      end,
      "__template",
      "GenericHUDButtonFrame",
      "Id",
      "idMPMercsFrame",
      "IdNode",
      false,
      "FoldWhenHidden",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return #netGamePlayers < 2 or not NetIsHost()
        end,
        "__class",
        "HUDButton",
        "RolloverTemplate",
        "SmallRolloverGeneric",
        "RolloverAnchor",
        "center-top",
        "Id",
        "idLobbyButton",
        "Padding",
        box(5, 0, 5, 0),
        "MinWidth",
        170,
        "MaxWidth",
        9999,
        "LayoutMethod",
        "HList",
        "ContextUpdateOnOpen",
        true,
        "OnPressEffect",
        "action",
        "OnPressParam",
        "actionCoOpSetup"
      }, {
        PlaceObj("XTemplateWindow", {
          "Dock",
          "box",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          5
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idLargeText",
            "Margins",
            box(0, 0, 3, 0),
            "HAlign",
            "center",
            "VAlign",
            "center",
            "TextStyle",
            "HUDHeaderBig",
            "Translate",
            true,
            "Text",
            T(507624704706, "CO-OP"),
            "TextHAlign",
            "center",
            "TextVAlign",
            "center"
          }),
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return netGameInfo and netGameInfo.visible_to == "public" and #netGamePlayers < 2
            end,
            "__class",
            "XText",
            "Margins",
            box(0, 0, 3, 0),
            "VAlign",
            "center",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDASectorInfo_SectionItem",
            "Translate",
            true,
            "Text",
            T(239857228353, "Game is listed"),
            "HideOnEmpty",
            true,
            "TextHAlign",
            "center"
          }),
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return netGameInfo and netGameInfo.visible_to == "private" and #netGamePlayers < 2
            end,
            "__class",
            "XText",
            "Margins",
            box(0, 0, 3, 0),
            "VAlign",
            "center",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDASectorInfo_SectionItem",
            "Translate",
            true,
            "Text",
            T(941622899988, "Invite Partner"),
            "HideOnEmpty",
            true,
            "TextHAlign",
            "center"
          })
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnSetRollover(self, rollover)",
          "func",
          function(self, rollover)
            self.idLargeText:SetTextStyle(rollover and "HUDHeaderBigLight" or "HUDHeaderBig")
            XButton.OnSetRollover(self, rollover)
          end
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "actionCoOpSetup",
          "ActionGamepad",
          "LeftTrigger-DPadUp",
          "OnAction",
          function(self, host, source, ...)
            OpenDialog("InGameMenu")
            MultiplayerInGameHostSetUI()
          end
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
          "Margins",
          box(-100, 0, 0, 0),
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
          T(303086508498, "<LeftTrigger>+<DPadUp>")
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return #netGamePlayers >= 2 and NetIsHost()
        end,
        "__class",
        "HUDButton",
        "RolloverTemplate",
        "SmallRolloverGeneric",
        "RolloverAnchor",
        "center-top",
        "Id",
        "idMPMercs",
        "Padding",
        box(5, 0, 5, 0),
        "MinWidth",
        170,
        "MaxWidth",
        9999,
        "LayoutMethod",
        "HList",
        "ContextUpdateOnOpen",
        true,
        "OnPressEffect",
        "action",
        "OnPressParam",
        "actionCoOpInGame"
      }, {
        PlaceObj("XTemplateWindow", {
          "Dock",
          "box",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          5
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idLargeText",
            "Margins",
            box(0, 0, 3, 0),
            "HAlign",
            "center",
            "VAlign",
            "center",
            "TextStyle",
            "HUDHeaderBig",
            "Translate",
            true,
            "Text",
            T(507624704706, "CO-OP"),
            "TextHAlign",
            "center",
            "TextVAlign",
            "center"
          }),
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return CountCoopUnits(2) <= 0
            end,
            "__class",
            "XText",
            "Id",
            "idPartnerText",
            "Margins",
            box(0, 0, 3, 0),
            "VAlign",
            "center",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDASectorInfo_SectionItemRed",
            "Translate",
            true,
            "Text",
            T(844121551822, "Partner has no mercs"),
            "HideOnEmpty",
            true,
            "TextHAlign",
            "center"
          })
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnSetRollover(self, rollover)",
          "func",
          function(self, rollover)
            self.idLargeText:SetTextStyle(rollover and "HUDHeaderBigLight" or "HUDHeaderBig")
            XButton.OnSetRollover(self, rollover)
          end
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "actionCoOpInGame",
          "ActionGamepad",
          "LeftTrigger-DPadUp",
          "OnAction",
          function(self, host, source, ...)
            NetSyncEvent("OpenCoopMercsManagement")
          end
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
          "Margins",
          box(-100, 0, 0, 0),
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
          T(894073201758, "<LeftTrigger>+<DPadUp>")
        })
      })
    })
  })
})
