PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAQuests_AboutMenu",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "Background",
    RGBA(30, 30, 35, 115)
  }, {
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      490,
      "MaxWidth",
      490
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Dock",
        "box",
        "Image",
        "UI/PDA/os_background",
        "FrameBox",
        box(5, 5, 5, 5)
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(15, 15, 15, 10)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Dock",
          "left",
          "Image",
          "UI/PDA/Quest/about"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "content",
          "Margins",
          box(10, 0, 0, 0),
          "Dock",
          "box"
        }, {
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            15
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "app name",
              "VAlign",
              "top"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "VAlign",
                "top",
                "Image",
                "UI/PDA/separate_line_vertical",
                "FrameBox",
                box(3, 3, 3, 3),
                "SqueezeY",
                false
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "HAlign",
                "left",
                "Image",
                "UI/PDA/separate_line",
                "FrameBox",
                box(3, 3, 3, 3),
                "SqueezeX",
                false
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "HAlign",
                "right",
                "Image",
                "UI/PDA/separate_line",
                "FrameBox",
                box(3, 3, 3, 3),
                "SqueezeX",
                false
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "VAlign",
                "bottom",
                "Image",
                "UI/PDA/separate_line_vertical",
                "FrameBox",
                box(3, 3, 3, 3),
                "SqueezeY",
                false
              }),
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(8, 8, 8, 8)
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "Margins",
                  box(0, 0, 8, 0),
                  "Dock",
                  "left",
                  "Image",
                  "UI/PDA/Quest/aim_tracker_logo"
                }),
                PlaceObj("XTemplateWindow", {"Dock", "box"}, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "TextStyle",
                    "PDAQuests_AboutText",
                    "Translate",
                    true,
                    "Text",
                    T(912186623588, "A.I.M. Tracker<right>v.2.0c<newline><left>\194\169 1992-2001 <right>A.I.M. Corp")
                  })
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "licensed to"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "Dock",
                "box",
                "Image",
                "UI/PDA/os_background",
                "FrameBox",
                box(5, 5, 5, 5)
              }),
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(5, 5, 5, 5),
                "HAlign",
                "center",
                "VAlign",
                "center",
                "LayoutMethod",
                "VList",
                "LayoutVSpacing",
                -5
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "HAlign",
                  "center",
                  "TextStyle",
                  "PDAQuests_AboutText",
                  "Translate",
                  true,
                  "Text",
                  T(704350483667, "Registered To:")
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "HAlign",
                  "center",
                  "TextStyle",
                  "PDAQuests_AboutTextLink",
                  "Translate",
                  true,
                  "Text",
                  T(768795653905, "the_boss@aim.com")
                })
              })
            }),
            PlaceObj("XTemplateWindow", nil, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "TextStyle",
                "PDAQuests_AboutTextSmall",
                "Translate",
                true,
                "Text",
                T(488160186197, "This computer program is protected by copyright law and international treaties. Unauthorized reproduction is forbidden!")
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "vertical sep",
            "__class",
            "XFrame",
            "VAlign",
            "bottom",
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(3, 3, 3, 3),
            "SqueezeY",
            false
          })
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "CloseABout",
          "ActionName",
          T(826598845168, "Ok"),
          "ActionToolbar",
          "ActionBar",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnActionEffect",
          "close"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, 0, 15, 10),
        "Dock",
        "bottom"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XToolBarList",
          "Id",
          "idToolBar",
          "HAlign",
          "right",
          "VAlign",
          "bottom",
          "OnLayoutComplete",
          function(self)
            self.list:SetPadding(box(0, 0, 0, 0))
          end,
          "LayoutHSpacing",
          18,
          "Background",
          RGBA(255, 255, 255, 0),
          "Toolbar",
          "ActionBar",
          "Show",
          "text",
          "ButtonTemplate",
          "PDACommonButton"
        })
      })
    })
  })
})
