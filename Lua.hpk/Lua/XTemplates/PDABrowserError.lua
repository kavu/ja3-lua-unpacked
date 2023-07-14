PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu PDA",
  id = "PDABrowserError",
  PlaceObj("XTemplateWindow", {
    "comment",
    "Full page",
    "__context",
    function(parent, context)
      return IMPErrorTexts[GetDialog(parent).mode_param] or IMPErrorTexts.Error404
    end,
    "__class",
    "XDialog",
    "Id",
    "PDABrowserError",
    "LayoutMethod",
    "VList",
    "MouseCursor",
    "UI/Cursors/Pda_Cursor.tga"
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "Background",
      "__class",
      "XImage",
      "Dock",
      "box",
      "Image",
      "UI/PDA/browser_panel",
      "ImageFit",
      "largest"
    }),
    PlaceObj("XTemplateTemplate", {
      "__condition",
      function(parent, context)
        return not InitialConflictNotStarted()
      end,
      "__template",
      "PDAStartButton",
      "Dock",
      "box",
      "VAlign",
      "bottom",
      "MinWidth",
      200
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "SetOutsideScale(self, scale)",
        "func",
        function(self, scale)
          local dlg = GetDialog("PDADialog")
          local screen = dlg.idPDAScreen
          XWindow.SetOutsideScale(self, screen.scale)
        end
      })
    }),
    PlaceObj("XTemplateTemplate", {
      "__condition",
      function(parent, context)
        return not InitialConflictNotStarted()
      end,
      "__template",
      "PDABrowserBanners",
      "Visible",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "PageSpecific",
      "Margins",
      box(110, 30, 0, 0),
      "Dock",
      "box",
      "HAlign",
      "left",
      "VAlign",
      "top",
      "HandleKeyboard",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "ErrorTitle",
        "Dock",
        "top",
        "HAlign",
        "left",
        "TextStyle",
        "PDABrowserErrorTitle",
        "Translate",
        true,
        "Text",
        T(207129590037, "<title>")
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "ErrorDescription",
        "Margins",
        box(0, 20, 0, 0),
        "Dock",
        "top",
        "HAlign",
        "left",
        "TextStyle",
        "PDABrowserErrorText",
        "Translate",
        true,
        "Text",
        T(260009954892, "<text>")
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return IMPErrorTexts.Error404
        end,
        "Margins",
        box(0, 15, 0, 5),
        "Dock",
        "top",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "MinWidth",
        946,
        "MinHeight",
        2,
        "MaxWidth",
        946,
        "MaxHeight",
        2,
        "BorderColor",
        RGBA(0, 0, 0, 0),
        "Background",
        RGBA(130, 128, 120, 139)
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return context
        end,
        "__class",
        "XText",
        "Id",
        "IP Text",
        "Dock",
        "top",
        "HAlign",
        "left",
        "TextStyle",
        "PDABrowserErrorIP",
        "Text",
        "OAK 3.5.49 Server at staging.mt-oak.domain.com Port 80"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "Back Text",
        "Margins",
        box(0, 20, 0, 0),
        "Padding",
        box(0, 0, 0, 0),
        "Background",
        RGBA(255, 0, 0, 0),
        "MouseCursor",
        "UI/Cursors/Pda_Hand.tga",
        "TextStyle",
        "PDABrowserErrorBackNormal",
        "Translate",
        true,
        "Text",
        T(931613236873, "<underline>Back</underline>")
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "Open",
          "func",
          function(self, ...)
            XText.Open(self, ...)
            local pdaBrowser = GetPDABrowserDialog()
            self:SetTextStyle(HyperlinkVisited(pdaBrowser, "PDABrowserErrorBack") and "PDABrowserErrorBackVisited" or "PDABrowserErrorBackNormal")
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnMouseButtonDown(self, pos, button)",
          "func",
          function(self, pos, button)
            XText.OnMouseButtonDown(self, pos, button)
            if button == "L" then
              if not self.parent:GetEnabled() then
                return
              end
              local pdaBrowser = GetPDABrowserDialog()
              VisitHyperlink(pdaBrowser, "PDABrowserErrorBack")
              pdaBrowser:SetMode(pdaBrowser:GetProperty("LastModeBeforeError"), pdaBrowser:GetProperty("LastModeParamBeforeError"))
            end
          end
        })
      })
    })
  })
})
