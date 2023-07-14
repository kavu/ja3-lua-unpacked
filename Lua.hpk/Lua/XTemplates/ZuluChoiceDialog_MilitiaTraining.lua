PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "ZuluChoiceDialog_MilitiaTraining",
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
      620,
      "MinHeight",
      360,
      "MaxWidth",
      620
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Dock",
        "top",
        "DrawOnTop",
        true,
        "Image",
        "UI/PDA/Event/T_Event_HeaderBar",
        "FrameBox",
        box(3, 3, 3, 3),
        "SqueezeY",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          5
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "HAlign",
            "left",
            "MinWidth",
            24,
            "MinHeight",
            24,
            "MaxWidth",
            24,
            "MaxHeight",
            24,
            "Image",
            "UI/PDA/sector_ally",
            "ImageFit",
            "stretch"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "Open(self)",
              "func",
              function(self)
                local node = self:ResolveId("node")
                local sector = node.context.obj.sector
                local side = sector.Side
                if side == "player1" then
                  self:SetImage("UI/PDA/sector_ally")
                else
                  self:SetImage("UI/PDA/sector_enemy")
                end
                self.idSectorId:SetText(sector.Id)
                XWindow.Open(self)
              end
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idSectorId",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "HandleMouse",
              false,
              "TextStyle",
              "PDASelectedSquad"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idTitle",
            "VAlign",
            "center",
            "HandleMouse",
            false,
            "TextStyle",
            "SatelliteEventSectorName",
            "Translate",
            true,
            "Text",
            T(913039416595, "<title>")
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 4, 5, 0),
          "HAlign",
          "right",
          "VAlign",
          "top",
          "MinWidth",
          18,
          "MinHeight",
          18,
          "MaxWidth",
          18,
          "MaxHeight",
          18,
          "Background",
          RGBA(133, 130, 123, 255)
        })
      }),
      PlaceObj("XTemplateWindow", {
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
          "Margins",
          box(10, 0, 10, 8)
        }, {
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(10, 10, 10, 3),
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idText",
              "TextStyle",
              "PDARolloverText",
              "Translate",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(0, 8, 0, 5)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "Dock",
                "box",
                "Image",
                "UI/PDA/os_background_2",
                "FrameBox",
                box(2, 2, 2, 2)
              }),
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(10, 8, 10, 15),
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                10
              }, {
                PlaceObj("XTemplateForEach", {
                  "comment",
                  "merc",
                  "array",
                  function(parent, context)
                    return context.obj.mercs
                  end,
                  "__context",
                  function(parent, context, item, i, n)
                    return item
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "HUDMerc",
                    "Margins",
                    box(0, 7, 0, 0),
                    "HandleMouse",
                    false,
                    "ChildrenHandleMouse",
                    false
                  })
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return context.obj
              end,
              "__class",
              "XText",
              "Margins",
              box(5, 0, 0, 0),
              "TextStyle",
              "PDARolloverText",
              "Translate",
              true,
              "Text",
              T(972572826404, "<textLower>")
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(10, 0, 10, 0),
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Margins",
            box(8, 0, 8, 0),
            "Image",
            "UI/PDA/separate_line_vertical",
            "ImageFit",
            "stretch-x"
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return context.obj
            end,
            "__class",
            "XContextWindow",
            "IdNode",
            true,
            "Margins",
            box(13, 3, 13, 3)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idName",
              "HAlign",
              "left",
              "VAlign",
              "center",
              "TextStyle",
              "MercStatName_Bigger",
              "Translate",
              true,
              "Text",
              T(879462448033, "Cost")
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idValue",
              "HAlign",
              "right",
              "VAlign",
              "center",
              "TextStyle",
              "MercStatValue",
              "Translate",
              true,
              "Text",
              T(424119434446, "<costText>")
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Margins",
            box(8, 0, 8, 0),
            "Image",
            "UI/PDA/separate_line_vertical",
            "ImageFit",
            "stretch-x"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XToolBarList",
          "Id",
          "idActionBar",
          "Margins",
          box(0, 8, 0, 8),
          "Dock",
          "bottom",
          "HAlign",
          "center",
          "VAlign",
          "bottom",
          "MinHeight",
          35,
          "MaxHeight",
          35,
          "LayoutHSpacing",
          30,
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
})
