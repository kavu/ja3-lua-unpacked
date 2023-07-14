PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Editor",
  id = "SelectionEditorDlg",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "SelectionEditorDlg",
    "Margins",
    box(0, 60, 0, 35),
    "Padding",
    box(5, 5, 5, 5),
    "HAlign",
    "right",
    "MinWidth",
    500,
    "MinHeight",
    200,
    "UniformColumnWidth",
    true,
    "Background",
    RGBA(255, 255, 255, 255),
    "FocusOnOpen",
    ""
  }, {
    PlaceObj("XTemplateWindow", {
      "Dock",
      "top",
      "Background",
      RGBA(160, 160, 160, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XLabel",
        "Margins",
        box(4, 2, 4, 2),
        "Dock",
        "left",
        "TextStyle",
        "GedTitle",
        "Text",
        "Selection Editor"
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
      "comment",
      "search",
      "__class",
      "XEdit",
      "Id",
      "idFilterText",
      "Margins",
      box(0, 5, 0, 5),
      "Dock",
      "top"
    }),
    PlaceObj("XTemplateWindow", {
      "Dock",
      "top",
      "LayoutHSpacing",
      2
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XTextButton",
        "Id",
        "idClassStatic",
        "Text",
        "Class"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XTextButton",
        "Id",
        "idPercentStatic",
        "Dock",
        "right",
        "MinWidth",
        60,
        "LayoutMethod",
        "Box",
        "Text",
        "%"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XTextButton",
        "Id",
        "idNumberStatic",
        "Dock",
        "right",
        "MinWidth",
        60,
        "Text",
        "#"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "selection list",
      "__class",
      "XList",
      "Id",
      "idStatList",
      "MultipleSelection",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "action",
      "Margins",
      box(0, 5, 0, 0),
      "Dock",
      "bottom",
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      5
    }, {
      PlaceObj("XTemplateWindow", nil, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "total",
          "__class",
          "XLabel",
          "Id",
          "idTotalCount",
          "Dock",
          "left",
          "Text",
          "Total 0, 0,0 per m2"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XCheckButton",
          "RolloverTranslate",
          false,
          "RolloverTemplate",
          "GedPropRollover",
          "RolloverAnchor",
          "center-top",
          "RolloverText",
          "All objects without gofPermanent are filtered out (this includes attached objects).",
          "Id",
          "idSelectOnlyPermanentCheck",
          "Dock",
          "right",
          "OnPress",
          function(self, gamepad)
            XCheckButton.OnPress(self, gamepad)
            local dlg = self:ResolveId("node")
            dlg.select_only_permanents = self:GetCheck()
            dlg:Update()
          end,
          "Text",
          "Select only permanents"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "selection buttons",
        "Margins",
        box(0, 0, 0, 10),
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        4
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "Id",
          "idSelectionButton",
          "Margins",
          box(0, 0, 0, 8),
          "Padding",
          box(2, 2, 2, 2),
          "Dock",
          "top",
          "LayoutMethod",
          "VList",
          "Background",
          RGBA(38, 146, 227, 255),
          "FocusedBackground",
          RGBA(24, 123, 197, 255),
          "DisabledBackground",
          RGBA(128, 128, 128, 255),
          "OnPress",
          function(self, gamepad)
            local buttons = self:ResolveId("idButtons")
            buttons:SetVisible(not buttons:GetVisible())
            buttons:SetDock(buttons:GetVisible() and "bottom" or "ignore")
          end,
          "RolloverBackground",
          RGBA(24, 123, 197, 255),
          "PressedBackground",
          RGBA(13, 113, 187, 255),
          "Image",
          "CommonAssets/UI/round-frame-20.tga",
          "ImageScale",
          point(500, 500),
          "FrameBox",
          box(9, 9, 9, 9),
          "TextStyle",
          "GedButton",
          "Text",
          "Selection"
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idButtons",
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          2
        }, {
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            2
          }, {
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idSelAll"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idSelVisible",
              "Text",
              "Visible"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idSelDuplicate",
              "Text",
              "Duplicate"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idSelUnderground",
              "Text",
              "Underground"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            10
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "Id",
              "idSelPercent",
              "VAlign",
              "center",
              "MinWidth",
              70,
              "Background",
              RGBA(255, 255, 255, 255),
              "Text",
              "Sel %"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idPercent5",
              "MinWidth",
              30,
              "Text",
              "5"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idPercent10",
              "MinWidth",
              30,
              "Text",
              "10"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idPercent25",
              "MinWidth",
              30,
              "Text",
              "25"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idPercent33",
              "MinWidth",
              30,
              "Text",
              "33"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idPercent50",
              "MinWidth",
              30,
              "Text",
              "50"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idPercent75",
              "MinWidth",
              30,
              "Text",
              "75"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idPercent90",
              "MinWidth",
              30,
              "Text",
              "90"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idPercent100",
              "MinWidth",
              30,
              "Text",
              "100"
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "Vew buttons",
        "Margins",
        box(0, 0, 0, 10),
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        4
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "Id",
          "idViewButton",
          "Margins",
          box(0, 0, 0, 8),
          "Padding",
          box(2, 2, 2, 2),
          "Dock",
          "top",
          "LayoutMethod",
          "VList",
          "Background",
          RGBA(38, 146, 227, 255),
          "FocusedBackground",
          RGBA(24, 123, 197, 255),
          "DisabledBackground",
          RGBA(128, 128, 128, 255),
          "OnPress",
          function(self, gamepad)
            local buttons = self:ResolveId("idButtons1")
            buttons:SetVisible(not buttons:GetVisible())
            buttons:SetDock(buttons:GetVisible() and "bottom" or "ignore")
          end,
          "RolloverBackground",
          RGBA(24, 123, 197, 255),
          "PressedBackground",
          RGBA(13, 113, 187, 255),
          "Image",
          "CommonAssets/UI/round-frame-20.tga",
          "ImageScale",
          point(500, 500),
          "FrameBox",
          box(9, 9, 9, 9),
          "TextStyle",
          "GedButton",
          "Text",
          "View"
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idButtons1",
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          2
        }, {
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            2
          }, {
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idHide",
              "Text",
              "Hide"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idHideOthers",
              "Text",
              "HideOthers"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idShow",
              "Text",
              "Show"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            2
          }, {
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idViewNext",
              "Text",
              "View Next"
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "Randomize",
        "Margins",
        box(0, 0, 0, 10),
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        4
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "Id",
          "idRandomizeButton",
          "Margins",
          box(0, 0, 0, 8),
          "Padding",
          box(2, 2, 2, 2),
          "Dock",
          "top",
          "LayoutMethod",
          "VList",
          "Background",
          RGBA(38, 146, 227, 255),
          "FocusedBackground",
          RGBA(24, 123, 197, 255),
          "DisabledBackground",
          RGBA(128, 128, 128, 255),
          "OnPress",
          function(self, gamepad)
            local buttons = self:ResolveId("idButtons2")
            buttons:SetVisible(not buttons:GetVisible())
            buttons:SetDock(buttons:GetVisible() and "bottom" or "ignore")
          end,
          "RolloverBackground",
          RGBA(24, 123, 197, 255),
          "PressedBackground",
          RGBA(13, 113, 187, 255),
          "Image",
          "CommonAssets/UI/round-frame-20.tga",
          "ImageScale",
          point(500, 500),
          "FrameBox",
          box(9, 9, 9, 9),
          "TextStyle",
          "GedButton",
          "Text",
          "Randomize"
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idButtons2",
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          2
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "EditorButton",
            "Id",
            "idRotate",
            "HAlign",
            "right",
            "MaxWidth",
            100,
            "Text",
            "Rotate"
          }),
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 10, 0, 10),
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            2
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "VAlign",
              "center",
              "Text",
              "Colorize"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XCombo",
              "Id",
              "ctrlColorProp",
              "MinWidth",
              200
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idColorize",
              "Dock",
              "right",
              "Text",
              "Colorize"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "red",
            "MinHeight",
            20
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "R:",
              "__class",
              "XLabel",
              "Dock",
              "left",
              "VAlign",
              "center",
              "MinWidth",
              30,
              "Text",
              "R:"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idRMin",
              "Dock",
              "left",
              "HAlign",
              "center",
              "MinWidth",
              35,
              "MaxWidth",
              35,
              "Text",
              "100"
            }),
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(10, 0, 10, 0),
              "MinWidth",
              200,
              "LayoutMethod",
              "VList",
              "LayoutVSpacing",
              2
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "EditorSlider",
                "Id",
                "idRMinSlider",
                "Target",
                "idRMinSlider",
                "Max",
                200
              }),
              PlaceObj("XTemplateTemplate", {
                "__template",
                "EditorSlider",
                "Id",
                "idRMaxSlider",
                "Target",
                "idRMaxSlider",
                "Max",
                200
              })
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idRMax",
              "Dock",
              "right",
              "HAlign",
              "center",
              "MinWidth",
              35,
              "MaxWidth",
              35,
              "Text",
              "100"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "green",
            "Margins",
            box(0, 5, 0, 0),
            "MinHeight",
            20
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "G:",
              "__class",
              "XLabel",
              "Dock",
              "left",
              "VAlign",
              "center",
              "MinWidth",
              30,
              "Text",
              "G:"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idGMin",
              "Dock",
              "left",
              "HAlign",
              "center",
              "MinWidth",
              35,
              "MaxWidth",
              35,
              "Text",
              "100"
            }),
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(10, 0, 10, 0),
              "MinWidth",
              200,
              "LayoutMethod",
              "VList",
              "LayoutVSpacing",
              2
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "EditorSlider",
                "Id",
                "idGMinSlider",
                "Target",
                "idGMinSlider",
                "Max",
                200
              }),
              PlaceObj("XTemplateTemplate", {
                "__template",
                "EditorSlider",
                "Id",
                "idGMaxSlider",
                "Target",
                "idGMaxSlider",
                "Max",
                200
              })
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idGMax",
              "Dock",
              "right",
              "HAlign",
              "center",
              "MinWidth",
              35,
              "MaxWidth",
              35,
              "Text",
              "100"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "blue",
            "Margins",
            box(0, 5, 0, 0),
            "MinHeight",
            20
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "B:",
              "__class",
              "XLabel",
              "Dock",
              "left",
              "VAlign",
              "center",
              "MinWidth",
              30,
              "Text",
              "B:"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idBMin",
              "Dock",
              "left",
              "HAlign",
              "center",
              "MinWidth",
              35,
              "MaxWidth",
              35,
              "Text",
              "100"
            }),
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(10, 0, 10, 0),
              "MinWidth",
              200,
              "LayoutMethod",
              "VList",
              "LayoutVSpacing",
              2
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "EditorSlider",
                "Id",
                "idBMinSlider",
                "Target",
                "idBMinSlider",
                "Max",
                200
              }),
              PlaceObj("XTemplateTemplate", {
                "__template",
                "EditorSlider",
                "Id",
                "idBMaxSlider",
                "Target",
                "idBMaxSlider",
                "Max",
                200
              })
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idBMax",
              "Dock",
              "right",
              "HAlign",
              "center",
              "MinWidth",
              35,
              "MaxWidth",
              35,
              "Text",
              "100"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 10, 0, 0),
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            5
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "Min scale",
              "__class",
              "XLabel",
              "VAlign",
              "center",
              "Text",
              "Min"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "NumberEditor",
              "Id",
              "idScaleMin"
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "Max scale",
              "__class",
              "XLabel",
              "VAlign",
              "center",
              "Text",
              "Max"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "NumberEditor",
              "Id",
              "idScaleMax"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "EditorButton",
              "Id",
              "idScale",
              "Dock",
              "right",
              "Text",
              "Scale"
            })
          })
        })
      })
    })
  })
})
