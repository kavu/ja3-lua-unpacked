PlaceObj("XTemplate", {
  __is_kind_of = "ZuluModalDialog",
  group = "Zulu PDA",
  id = "PDAMercImageInspect",
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
      682,
      "MaxWidth",
      682
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
            "Translate",
            true,
            "Text",
            T(944265936250, "<Nick>'s profile"),
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
              "800x420x24bpp"
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
                local hash = xxhash(context.session_id)
                local randomSize = BraidRandom(hash, 70, 120)
                self:SetText(T({
                  254295447571,
                  "<size>KB",
                  size = randomSize
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
              T(743006454152, "40%"),
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
                local hash = xxhash(context.session_id)
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
                local hash = xxhash(context.session_id)
                local randomHour = BraidRandom(hash, 9, 20)
                local randomMinute = BraidRandom(hash, 1, 60)
                self:SetText(T({
                  815629925333,
                  "<hour>:<min>",
                  hour = randomHour,
                  min = randomMinute
                }))
              end,
              "Translate",
              true,
              "TextHAlign",
              "right"
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
          "MinWidth",
          634,
          "MaxWidth",
          634,
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
              "MessengerScrollbar",
              "Id",
              "idImageScrollV",
              "Margins",
              box(0, 0, 0, 20),
              "Dock",
              "right",
              "Target",
              "idImageArea"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "MessengerScrollbarHorizontal",
              "Id",
              "idImageScrollH",
              "Dock",
              "bottom",
              "Target",
              "idImageArea"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XScrollArea",
              "Id",
              "idImageArea",
              "IdNode",
              false,
              "MinWidth",
              634,
              "MinHeight",
              830,
              "MaxWidth",
              634,
              "MaxHeight",
              830,
              "HScroll",
              "idImageScrollH",
              "VScroll",
              "idImageScrollV",
              "MouseScroll",
              false
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextImage",
                "Id",
                "idPortrait",
                "ScaleModifier",
                point(400, 400),
                "ImageRect",
                box(500, 0, 1520, 2000),
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  self:SetImage(context.BigPortrait)
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnMouseButtonDown(self, pos, button)",
                "func",
                function(self, pos, button)
                  if button == "L" then
                    self.drag_start = pos
                    self.desktop:SetMouseCapture(self)
                  end
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnMouseButtonUp(self, pos, button)",
                "func",
                function(self, pos, button)
                  if button == "L" then
                    self.drag_start = false
                    self.desktop:SetMouseCapture(false)
                  end
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnCaptureLost(self)",
                "func",
                function(self)
                  self.drag_start = false
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnMousePos(self, pt)",
                "func",
                function(self, pt)
                  if self.drag_start then
                    local diff = self.drag_start - pt
                    local x, y = diff:xy()
                    x = x + self.PendingOffsetX
                    y = y + self.PendingOffsetY
                    local xMax = Max(0, self.scroll_range_x - self.content_box:sizex())
                    local yMax = Max(0, self.scroll_range_y - self.content_box:sizey())
                    x = Clamp(x, 0, xMax)
                    y = Clamp(y, 0, yMax)
                    self:ScrollTo(x, y)
                    self.drag_start = pt
                  end
                end
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "HAlign",
            "right",
            "VAlign",
            "bottom",
            "MinWidth",
            21,
            "MinHeight",
            21,
            "MaxWidth",
            21,
            "MaxHeight",
            21,
            "Image",
            "UI/PDA/os_system_buttons",
            "FrameBox",
            box(8, 8, 8, 8),
            "Columns",
            3,
            "SqueezeX",
            false,
            "SqueezeY",
            false
          })
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseWheelForward(self)",
      "func",
      function(self)
        local portrait = self:ResolveId("idPortrait")
        local scale = portrait:GetScaleModifier()
        if scale:x() < 1000 then
          local step = 25
          local newScale = scale + point(step, step)
          newScale = PointMin(newScale, 1000)
          portrait:SetScaleModifier(newScale)
          self:ResolveId("idScalePercent"):SetText(T({
            487196026340,
            "<percent(scale)>",
            scale = newScale:x() / 10
          }))
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseWheelBack(self)",
      "func",
      function(self)
        local portrait = self:ResolveId("idPortrait")
        local scale = portrait:GetScaleModifier()
        if scale:x() > 400 then
          local step = 25
          local newScale = scale - point(step, step)
          newScale = PointMax(newScale, 400)
          portrait:SetScaleModifier(newScale)
          self:ResolveId("idScalePercent"):SetText(T({
            487196026340,
            "<percent(scale)>",
            scale = newScale:x() / 10
          }))
        end
      end
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
    })
  })
})
