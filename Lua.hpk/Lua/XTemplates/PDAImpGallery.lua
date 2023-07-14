PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAImpGallery",
  PlaceObj("XTemplateProperty", {
    "id",
    "HeaderButtonId",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.HeaderButtonId = value
    end,
    "Get",
    function(self)
      return self.HeaderButtonId
    end,
    "name",
    T(781809329109, "HeaderButtonId")
  }),
  PlaceObj("XTemplateWindow", {
    "LayoutMethod",
    "VList",
    "LayoutVSpacing",
    8
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XWindow.Open(self, ...)
        PDAImpHeaderEnable(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        XWindow.OnDelete(self, ...)
        PDAImpHeaderDisable(self)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextFrame",
      "Image",
      "UI/PDA/imp_panel",
      "FrameBox",
      box(8, 8, 8, 8),
      "ContextUpdateOnOpen",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(20, 20, 20, 20),
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "center",
          "VAlign",
          "top",
          "HandleMouse",
          false,
          "TextStyle",
          "PDAIMPContentTitle",
          "Translate",
          true,
          "Text",
          T(361347984095, "GALLERY")
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 10, 0, 0),
          "HAlign",
          "center",
          "VAlign",
          "top",
          "LayoutMethod",
          "Grid",
          "LayoutHSpacing",
          50,
          "LayoutVSpacing",
          30
        }, {
          PlaceObj("XTemplateForEach", {
            "array",
            function(parent, context)
              return {
                1,
                2,
                3,
                4,
                5,
                6,
                7,
                8
              }
            end,
            "run_after",
            function(child, context, item, i, n, last)
              child.idImage:SetImage("UI/PDA/WEBSites/img_0" .. i)
              local imgname = "img_0" .. i
              child.idImageName:SetText(imgname)
              local hash = xxhash(imgname)
              local randomSize = BraidRandom(hash, 70, 250)
              child.idImageSize:SetText(T({
                254295447571,
                "<size>KB",
                size = randomSize
              }))
              rawset(child, "size", randomSize)
              rawset(child, "name", imgname)
              rawset(child, "name_big", imgname .. "_big")
              local d, r = i / 4, i % 4
              child:SetGridY(r == 0 and d or d + 1)
              child:SetGridX(r == 0 and 4 or r)
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XButton",
              "HAlign",
              "left",
              "VAlign",
              "top",
              "LayoutMethod",
              "VList",
              "Background",
              RGBA(255, 255, 255, 0),
              "MouseCursor",
              "UI/Cursors/Pda_Hand.tga",
              "FocusedBackground",
              RGBA(255, 255, 255, 0),
              "OnPress",
              function(self, gamepad)
                local popupHost = GetDialog("PDADialog")
                popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
                local mercWindow = XTemplateSpawn("PDAImpGalleryBig", popupHost, {
                  name = self.name,
                  name_big = self.name_big,
                  size = self.size
                })
                mercWindow:Open()
              end,
              "RolloverBackground",
              RGBA(255, 255, 255, 0),
              "PressedBackground",
              RGBA(255, 255, 255, 0)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idImage",
                "HAlign",
                "left",
                "VAlign",
                "top",
                "MinWidth",
                116,
                "MinHeight",
                134,
                "MaxWidth",
                116,
                "MaxHeight",
                134
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idImageName",
                "HandleMouse",
                false,
                "TextStyle",
                "PDAIMPGalleryName",
                "TextHAlign",
                "center"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idImageSize",
                "HandleMouse",
                false,
                "TextStyle",
                "PDAIMPGalleryBottom",
                "Translate",
                true,
                "TextHAlign",
                "center"
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idBottom",
          "Margins",
          box(0, 40, 0, 0),
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "center",
          "VAlign",
          "bottom",
          "HandleMouse",
          false,
          "TextStyle",
          "PDAIMPGalleryBottom",
          "Translate",
          true,
          "Text",
          T(509636760606, "Last updated Fri, Jan 21:39:09 2001")
        })
      })
    })
  })
})
