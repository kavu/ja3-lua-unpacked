PlaceObj("XTemplate", {
  __is_kind_of = "XPopup",
  group = "Zulu Satellite UI",
  id = "TutorialPopup",
  PlaceObj("XTemplateWindow", {
    "__class",
    "TutorialPopupClass",
    "Margins",
    box(5, 5, 5, 5),
    "MinWidth",
    280,
    "MinHeight",
    100,
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(191, 67, 77, 0),
    "BackgroundRectGlowColor",
    RGBA(0, 0, 0, 0),
    "FadeInTime",
    300,
    "FadeOutTime",
    300,
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(20, 20, 20, 23),
      "Dock",
      "box"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Dock",
        "box",
        "Image",
        "UI/PDA/th_background",
        "FrameBox",
        box(15, 15, 15, 15),
        "SqueezeX",
        false,
        "SqueezeY",
        false
      }),
      PlaceObj("XTemplateWindow", {"Id", "idContent"}, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(8, 5, 8, 2),
          "Dock",
          "top"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Dock",
            "left",
            "Image",
            "UI/PDA/th_icon"
          }),
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(7, 0, 3, 0),
            "Dock",
            "bottom",
            "VAlign",
            "top",
            "MinHeight",
            1,
            "MaxHeight",
            1,
            "Background",
            RGBA(195, 189, 172, 255)
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idTitle",
            "Margins",
            box(5, 0, 0, 0),
            "MaxWidth",
            280,
            "TextStyle",
            "PDARolloverTutorialTitle",
            "Translate",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XTextButton",
            "Id",
            "idCloseBut",
            "HAlign",
            "right",
            "VAlign",
            "top",
            "BorderColor",
            RGBA(0, 0, 0, 0),
            "Background",
            RGBA(0, 0, 0, 0),
            "FocusedBorderColor",
            RGBA(0, 0, 0, 0),
            "FocusedBackground",
            RGBA(0, 0, 0, 0),
            "DisabledBorderColor",
            RGBA(0, 0, 0, 0),
            "OnPress",
            function(self, gamepad)
              local diag = self:ResolveId("node")
              if diag then
                TutorialDismissHint(self.context)
                CloseCurrentTutorialPopup()
                diag:Close()
              end
            end,
            "RolloverBackground",
            RGBA(0, 0, 0, 0),
            "PressedBackground",
            RGBA(0, 0, 0, 0),
            "TextStyle",
            "PDARolloverTutorialCross",
            "Text",
            "X"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idText",
          "Margins",
          box(13, 0, 13, 9),
          "Dock",
          "top",
          "MaxWidth",
          280,
          "TextStyle",
          "PDARolloverTutorialText",
          "Translate",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "gamepad hint",
          "__context",
          function(parent, context)
            return "GamepadUIStyleChanged"
          end,
          "__class",
          "XText",
          "Margins",
          box(13, 0, 13, 9),
          "Clip",
          false,
          "UseClipBox",
          false,
          "FoldWhenHidden",
          true,
          "TextStyle",
          "PDARolloverTutorialText",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            self:SetVisible(GetUIStyleGamepad())
            local node = self:ResolveId("node")
            node:UpdateText()
            XText.OnContextUpdate(self, context, ...)
          end,
          "Translate",
          true,
          "Text",
          T(617313399753, "<ButtonB> Close")
        })
      })
    }),
    PlaceObj("XTemplateWindow", {"Dock", "box"}, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idArrow",
        "HAlign",
        "left",
        "VAlign",
        "top",
        "Image",
        "UI/PDA/th_arrow"
      })
    })
  })
})
