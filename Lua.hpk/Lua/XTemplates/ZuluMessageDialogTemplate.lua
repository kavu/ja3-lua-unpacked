PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "ZuluMessageDialogTemplate",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "Id",
    "idMain",
    "Background",
    RGBA(30, 30, 35, 115),
    "HostInParent",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      500,
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Dock",
        "box",
        "Image",
        "UI/PDA/os_background",
        "FrameBox",
        box(2, 2, 2, 2)
      }),
      PlaceObj("XTemplateWindow", {
        "VAlign",
        "top",
        "FoldWhenHidden",
        true
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Margins",
          box(18, 5, 0, 0),
          "HAlign",
          "left",
          "MinHeight",
          30,
          "TextStyle",
          "PDARolloverHeader",
          "Translate",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 0, 8, 0),
          "HAlign",
          "right",
          "VAlign",
          "center",
          "MinWidth",
          22,
          "MinHeight",
          22,
          "MaxWidth",
          22,
          "MaxHeight",
          22,
          "Background",
          RGBA(78, 82, 91, 255)
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(8, 0, 8, 0),
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(8, 8, 8, 8)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idText",
            "MaxWidth",
            500,
            "TextStyle",
            "PDARolloverText",
            "Translate",
            true
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XToolBarList",
        "Id",
        "idActionBar",
        "Margins",
        box(8, 8, 8, 8),
        "HAlign",
        "center",
        "VAlign",
        "bottom",
        "MinHeight",
        35,
        "MaxHeight",
        35,
        "OnLayoutComplete",
        function(self)
          for _, button in ipairs(self.list) do
            button:SetMouseCursor("UI/Cursors/Hand.tga")
          end
        end,
        "LayoutHSpacing",
        30,
        "LayoutVSpacing",
        10,
        "Background",
        RGBA(255, 255, 255, 0),
        "Toolbar",
        "ActionBar",
        "ButtonTemplate",
        "PDACommonButton"
      })
    })
  })
})
