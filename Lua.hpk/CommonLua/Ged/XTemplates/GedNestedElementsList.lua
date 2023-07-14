PlaceObj("XTemplate", {
  group = "GedControls",
  id = "GedNestedElementsList",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "Background",
    RGBA(0, 0, 0, 160)
  }, {
    PlaceObj("XTemplateWindow", {
      "Id",
      "idPopupBackground",
      "Margins",
      box(30, 50, 30, 30),
      "BorderWidth",
      2,
      "HAlign",
      "center",
      "VAlign",
      "center",
      "Background",
      RGBA(128, 128, 128, 16)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XMoveControl",
        "Margins",
        box(0, 0, 0, 10),
        "Dock",
        "top",
        "Background",
        RGBA(128, 128, 128, 64),
        "Target",
        "idPopupBackground",
        "FocusedBackground",
        RGBA(128, 128, 128, 64)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Margins",
          box(4, 2, 4, 2),
          "Dock",
          "left",
          "TextStyle",
          "GedTitle"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "Padding",
          box(1, 1, 1, 1),
          "Dock",
          "right",
          "VAlign",
          "center",
          "LayoutHSpacing",
          0,
          "Background",
          RGBA(0, 0, 0, 0),
          "OnPressEffect",
          "close",
          "RolloverBackground",
          RGBA(204, 232, 255, 255),
          "PressedBackground",
          RGBA(121, 189, 241, 255),
          "TextStyle",
          "GedTitle",
          "Text",
          "X"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idLeftList",
        "IdNode",
        true,
        "Margins",
        box(0, 0, 0, 7),
        "Padding",
        box(10, 0, 10, 0),
        "Dock",
        "left",
        "MinWidth",
        310,
        "MaxWidth",
        310
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XEdit",
          "Id",
          "idSearch",
          "IdNode",
          true,
          "Margins",
          box(0, 0, 0, 5),
          "Dock",
          "top"
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idWin",
          "IdNode",
          true,
          "BorderWidth",
          1
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XList",
            "Id",
            "idList",
            "IdNode",
            false,
            "BorderWidth",
            0,
            "VScroll",
            "idScroll"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XSleekScroll",
            "Id",
            "idScroll",
            "Dock",
            "right",
            "Target",
            "idList",
            "SnapToItems",
            true,
            "AutoHide",
            true
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XScrollArea",
        "Id",
        "idRightList",
        "IdNode",
        false,
        "Margins",
        box(0, 0, 5, 7),
        "BorderWidth",
        1,
        "Padding",
        box(3, 3, 3, 0),
        "LayoutMethod",
        "VWrap",
        "LayoutHSpacing",
        5,
        "Background",
        RGBA(240, 240, 240, 255),
        "HScroll",
        "idHScroll"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XSleekScroll",
          "Id",
          "idHScroll",
          "Dock",
          "bottom",
          "DrawOnTop",
          true,
          "Target",
          "idRightList",
          "SnapToItems",
          true,
          "AutoHide",
          true,
          "Horizontal",
          true
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Margins",
        box(4, 2, 4, 2),
        "Dock",
        "bottom",
        "Text",
        "(click to choose an item)"
      })
    })
  })
})
