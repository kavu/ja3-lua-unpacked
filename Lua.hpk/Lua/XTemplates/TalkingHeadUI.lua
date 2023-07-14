PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "TalkingHeadUI",
  PlaceObj("XTemplateWindow", {
    "__class",
    "CombatLogAnchorAnimationWindow",
    "HAlign",
    "left",
    "VAlign",
    "top",
    "MinWidth",
    537,
    "MaxWidth",
    537,
    "UseClipBox",
    false,
    "Visible",
    false,
    "flip_vertically",
    false
  }, {
    PlaceObj("XTemplateWindow", {"Id", "idContent"}, {
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
          "IdNode",
          false,
          "HAlign",
          "right",
          "LayoutHSpacing",
          0,
          "Background",
          RGBA(0, 0, 0, 0),
          "HandleMouse",
          false,
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
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Margins",
              box(5, 0, 0, -2),
              "VAlign",
              "center",
              "TextStyle",
              "PDASelectedSquad",
              "Translate",
              true,
              "Text",
              T(860676081213, "SNYPE -")
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idName",
              "Margins",
              box(0, 0, 0, -2),
              "VAlign",
              "center",
              "TextStyle",
              "PDASelectedSquad",
              "Translate",
              true
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "Id",
          "idClose",
          "Margins",
          box(0, 0, 3, 0),
          "Dock",
          "right",
          "FXMouseIn",
          "buttonRollover",
          "FXPress",
          "buttonPress",
          "OnPress",
          function(self, gamepad)
            local thUI = GetDialog(self)
            thUI.thn_instance:Stop()
            thUI:Close()
          end,
          "Image",
          "UI/PDA/Log/T_Log_CloseButton",
          "ColumnsUse",
          "abcca"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idTextContainer",
        "Padding",
        box(10, 5, 0, 10),
        "Background",
        RGBA(32, 35, 47, 230),
        "ChildrenHandleMouse",
        false
      }, {
        PlaceObj("XTemplateWindow", {"Dock", "left"}, {
          PlaceObj("XTemplateWindow", {"Dock", "top"}, {
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(0, 10, 0, 0),
              "MinWidth",
              80,
              "MinHeight",
              90,
              "MaxWidth",
              80,
              "MaxHeight",
              90,
              "Background",
              RGBA(34, 36, 48, 255)
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Id",
              "idPortrait",
              "HAlign",
              "left",
              "VAlign",
              "top",
              "MinWidth",
              80,
              "MinHeight",
              100,
              "MaxWidth",
              80,
              "MaxHeight",
              100,
              "Image",
              "UI/MercsPortraits/unknown",
              "ImageFit",
              "stretch",
              "ImageRect",
              box(45, 0, 255, 264)
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idRadioImage",
            "Margins",
            box(0, 10, 0, 0),
            "Dock",
            "top",
            "HAlign",
            "center",
            "Image",
            "UI/Hud/radio_call",
            "Rows",
            3,
            "Columns",
            6,
            "Animate",
            true,
            "FPS",
            15
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Padding",
          box(10, 0, 10, 0),
          "Dock",
          "box",
          "HAlign",
          "left",
          "VAlign",
          "top",
          "FoldWhenHidden",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idText",
            "HAlign",
            "left",
            "VAlign",
            "top",
            "MaxWidth",
            500,
            "Clip",
            false,
            "TextStyle",
            "CombatLog",
            "Translate",
            true
          })
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetBoxFromAnchorInternal(self, x, y)",
      "func",
      function(self, x, y)
        x = MulDivRound(x, 1000, self.scale:x())
        y = MulDivRound(y, 1000, self.scale:y())
        self.parent:SetMargins(box(x, y, 0, 0))
      end
    })
  })
})
