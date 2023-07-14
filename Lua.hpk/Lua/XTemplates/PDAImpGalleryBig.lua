PlaceObj("XTemplate", {
  __is_kind_of = "ZuluModalDialog",
  group = "Zulu PDA",
  id = "PDAImpGalleryBig",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "Background",
    RGBA(32, 35, 47, 120)
  }, {
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(0, 24, 0, 48),
      "Dock",
      "box",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      1400,
      "MaxWidth",
      1400
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Padding",
        box(0, 1, 0, 0),
        "Dock",
        "top",
        "MinHeight",
        32,
        "MaxHeight",
        32,
        "Image",
        "UI/PDA/os_header",
        "FrameBox",
        box(5, 5, 5, 5),
        "SqueezeY",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(10, 0, 0, 0),
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          10
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idHeaderText",
            "VAlign",
            "bottom",
            "TextStyle",
            "PDABrowserTitle",
            "OnContextUpdate",
            function(self, context, ...)
              self:SetImage("UI/PDA/WEBSites/" .. context.name)
            end,
            "TextVAlign",
            "bottom"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "PDASmallButton",
            "Margins",
            box(0, 0, 2, 1),
            "Dock",
            "right",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "MinWidth",
            20,
            "MinHeight",
            20,
            "MaxWidth",
            20,
            "MaxHeight",
            20,
            "OnPress",
            function(self, gamepad)
              local dlg = GetDialog(self)
              dlg:Close()
            end,
            "CenterImage",
            "UI/PDA/Event/T_Icon_Close"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "PDASmallButton",
            "Margins",
            box(0, 0, 2, 1),
            "Dock",
            "right",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "MinWidth",
            20,
            "MinHeight",
            20,
            "MaxWidth",
            20,
            "MaxHeight",
            20,
            "CenterImage",
            "UI/PDA/Event/T_Icon_Help"
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Padding",
        box(24, 18, 24, 0),
        "Dock",
        "box",
        "Image",
        "UI/PDA/os_background",
        "FrameBox",
        box(5, 5, 5, 5)
      }, {
        PlaceObj("XTemplateWindow", {
          "Dock",
          "bottom",
          "MinHeight",
          64,
          "MaxHeight",
          64,
          "LayoutMethod",
          "Grid"
        }, {
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "TextStyle",
              "PDABrowserFlavorMedium",
              "Text",
              "1920x1080x24bpp"
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "file size",
              "__class",
              "XText",
              "TextStyle",
              "PDABrowserFlavorMedium",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                self:SetText(T({
                  254295447571,
                  "<size>KB",
                  size = context.size
                }))
              end,
              "Translate",
              true
            })
          }),
          PlaceObj("XTemplateWindow", {
            "HAlign",
            "left",
            "VAlign",
            "center",
            "GridX",
            2
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idScalePercent",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "TextStyle",
              "PDABrowserFlavorBig",
              "Translate",
              true,
              "Text",
              T(354437866514, "100%"),
              "TextVAlign",
              "center"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "HAlign",
            "right",
            "GridX",
            3,
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "photo date",
              "__class",
              "XText",
              "TextStyle",
              "PDABrowserFlavorMedium",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local hash = xxhash(context.name)
                local randomMonth = BraidRandom(hash, 1, 12)
                local randomDay = BraidRandom(hash, 1, 28)
                local randomYear = BraidRandom(hash, 1997, 2000)
                self:SetText(T({
                  319320644886,
                  "<date_mdy(m, d, y)>",
                  m = randomMonth,
                  d = randomDay,
                  y = randomYear
                }))
              end,
              "Translate",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "photo time",
              "__class",
              "XText",
              "TextStyle",
              "PDABrowserFlavorMedium",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local hash = xxhash(context.name)
                local randomHour = BraidRandom(hash, 9, 20)
                local randomMinute = BraidRandom(hash, 10, 60)
                self:SetText(T({
                  815629925333,
                  "<hour>:<min>",
                  hour = randomHour,
                  min = randomMinute
                }))
              end,
              "Translate",
              true
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "IdNode",
          false,
          "Dock",
          "box",
          "Image",
          "UI/PDA/os_background_2",
          "FrameBox",
          box(5, 5, 5, 5)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "IdNode",
            false,
            "Margins",
            box(1, 1, 1, 1),
            "Background",
            RGBA(32, 35, 47, 255),
            "Image",
            "UI/PDA/os_background_2",
            "FrameBox",
            box(5, 5, 5, 5)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContextImage",
              "Id",
              "idBig",
              "ImageFit",
              "smallest",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                self:SetImage("UI/PDA/WEBSites/" .. context.name_big)
              end
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnAction",
      function(self, host, source, ...)
        local dlg = GetDialog(host)
        dlg:Close()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        self:Close()
      end
    })
  })
})
