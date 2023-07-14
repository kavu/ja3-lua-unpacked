PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "CombatLog",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return LogData
    end,
    "__class",
    "CombatLogWindow",
    "Id",
    "idCombatLog",
    "HAlign",
    "left",
    "VAlign",
    "top",
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "Id",
      "idLogContainer",
      "HAlign",
      "left",
      "VAlign",
      "top",
      "MinWidth",
      500,
      "MinHeight",
      185,
      "MaxWidth",
      500,
      "MaxHeight",
      185
    }, {
      PlaceObj("XTemplateWindow", {
        "Dock",
        "top",
        "VAlign",
        "top",
        "LayoutMethod",
        "HList",
        "Background",
        RGBA(61, 122, 153, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "Id",
          "idCombatLogButton",
          "HAlign",
          "right",
          "LayoutHSpacing",
          0,
          "Background",
          RGBA(0, 0, 0, 0),
          "FXMouseIn",
          "buttonRollover",
          "FXPress",
          "buttonPress",
          "FocusedBorderColor",
          RGBA(0, 0, 0, 0),
          "FocusedBackground",
          RGBA(0, 0, 0, 0),
          "DisabledBorderColor",
          RGBA(0, 0, 0, 0),
          "OnPress",
          function(self, gamepad)
            HideCombatLog()
          end,
          "RolloverBackground",
          RGBA(0, 0, 0, 0),
          "PressedBackground",
          RGBA(0, 0, 0, 0),
          "ColumnsUse",
          "abcca"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "MinWidth",
            24,
            "MinHeight",
            24,
            "MaxWidth",
            24,
            "MaxHeight",
            24,
            "Image",
            "UI/PDA/T_SmallButton",
            "Columns",
            3
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "GetColumn(self)",
              "func",
              function(self)
                return self.parent:GetColumn()
              end
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Margins",
              box(3, 3, 3, 3),
              "Dock",
              "box",
              "Image",
              "UI/PDA/snype_logo",
              "ImageFit",
              "stretch",
              "ImageColor",
              RGBA(61, 122, 153, 255)
            })
          }),
          PlaceObj("XTemplateWindow", nil, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Margins",
              box(5, 0, 5, -2),
              "VAlign",
              "center",
              "TextStyle",
              "PDASelectedSquad",
              "Translate",
              true,
              "Text",
              T(570152647072, "SNYPE")
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "buttons container",
          "Padding",
          box(0, 0, 3, 0),
          "Dock",
          "right",
          "HAlign",
          "right",
          "VAlign",
          "center",
          "LayoutMethod",
          "HList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return Platform.developer
            end,
            "__class",
            "XTextButton",
            "Id",
            "idDebug",
            "BorderColor",
            RGBA(0, 0, 0, 0),
            "Background",
            RGBA(255, 255, 255, 0),
            "OnContextUpdate",
            function(self, context, ...)
              if LogShowDebug then
                self:SetTextStyle("CombatLogButtonActive")
              else
                self:SetTextStyle("CombatLogButtonInactive")
              end
              self:SetText(self.Text)
              XContextControl.OnContextUpdate(self, context)
            end,
            "FocusedBorderColor",
            RGBA(0, 0, 0, 0),
            "FocusedBackground",
            RGBA(255, 255, 255, 0),
            "OnPress",
            function(self, gamepad)
              local dlg = GetDialog(self)
              LogShowDebug = not LogShowDebug
              dlg:UpdateText()
              self:OnContextUpdate(self, false)
            end,
            "RolloverBackground",
            RGBA(255, 255, 255, 0),
            "PressedBackground",
            RGBA(255, 255, 255, 0),
            "TextStyle",
            "CombatLogButtonInactive",
            "Translate",
            true,
            "Text",
            T(550523949729, "Debug")
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XTextButton",
            "Id",
            "idClose",
            "FXMouseIn",
            "buttonRollover",
            "FXPress",
            "buttonPress",
            "OnPress",
            function(self, gamepad)
              GetDialog(self):AnimatedClose("hideInsteadOfClose")
            end,
            "Image",
            "UI/PDA/Log/T_Log_CloseButton",
            "ColumnsUse",
            "abcca"
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idContent",
        "Dock",
        "box",
        "Background",
        RGBA(32, 35, 47, 230)
      }, {
        PlaceObj("XTemplateWindow", {
          "Id",
          "idTextContainer"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "Transparency",
            230,
            "Image",
            "UI/Common/screen_effect",
            "TileFrame",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XScrollArea",
            "Id",
            "idScrollArea",
            "Margins",
            box(10, 5, 10, 5),
            "Padding",
            box(0, 0, 10, 0),
            "Dock",
            "box",
            "LayoutMethod",
            "VList",
            "VScroll",
            "idScrollbar"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XZuluScroll",
            "Id",
            "idScrollbar",
            "Margins",
            box(0, 0, 3, 0),
            "Dock",
            "right",
            "UseClipBox",
            false,
            "Target",
            "idScrollArea",
            "SnapToItems",
            true
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "controller observer",
        "__context",
        function(parent, context)
          return "GamepadUIStyleChanged"
        end,
        "__class",
        "XContextWindow",
        "IdNode",
        true,
        "HAlign",
        "center",
        "VAlign",
        "bottom",
        "UseClipBox",
        false,
        "Visible",
        false,
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local gamepad = GetUIStyleGamepad()
          local combatLog = self:ResolveId("node")
          if gamepad and combatLog.open then
            combatLog:AnimatedClose(true, true)
          end
        end
      })
    })
  })
})
