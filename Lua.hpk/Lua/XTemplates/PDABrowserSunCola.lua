PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu PDA",
  id = "PDABrowserSunCola",
  PlaceObj("XTemplateWindow", {
    "comment",
    "Full page",
    "__class",
    "XDialog",
    "Id",
    "PDABrowserSunCola",
    "MouseCursor",
    "UI/Cursors/Pda_Cursor.tga"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XDialog.Open(self, ...)
        AddPageToBrowserHistory("banner_page", "PDABrowserSunCola")
        PDABrowserTabState.banner_page.mode_param = "PDABrowserSunCola"
        local normalYellow = "PDABrowserColaTextNormal"
        local normalWhite = "PDABrowserColaTextNormalAlt"
        local bigYellow = "PDABrowserColaTextBig"
        local bigWhite = "PDABrowserColaTextBigAlt"
        local imageColor1 = "UI/PDA/WEBSites/sun_cola_fresh_1"
        local imageColor2 = "UI/PDA/WEBSites/sun_cola_fresh_2"
        local tex1 = self:ResolveId("AnimatedText1")
        local tex2 = self:ResolveId("AnimatedText2")
        local tex3 = self:ResolveId("AnimatedText3")
        local tex4 = self:ResolveId("AnimatedText4")
        local img = self:ResolveId("AnimatedImage")
        self:CreateThread("sun_cola_animation_text", function()
          local i = 0
          while true do
            Sleep(500)
            tex1:SetTextStyle(i == 0 and normalWhite or normalYellow)
            tex2:SetTextStyle(i == 1 and normalWhite or normalYellow)
            tex3:SetTextStyle(i == 2 and normalWhite or normalYellow)
            tex4:SetTextStyle(3 <= i and i % 2 == 1 and bigWhite or bigYellow)
            i = (i + 1) % 8
          end
        end)
        self:CreateThread("sun_cola_animation_image", function()
          local i = 0
          while true do
            Sleep(700)
            img:SetImage(i == 0 and imageColor1 or imageColor2)
            i = (i + 1) % 2
          end
        end)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "Background",
      "__class",
      "XImage",
      "Dock",
      "box",
      "Image",
      "UI/PDA/WEBSites/sun_cola_background",
      "ImageFit",
      "stretch"
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
      "__template",
      "PDABrowserBanners"
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "PageSpecific",
      "Padding",
      box(0, 10, 0, 0),
      "Dock",
      "box",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "HandleKeyboard",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "PageContent",
        "__class",
        "XImage",
        "IdNode",
        false,
        "HAlign",
        "center",
        "VAlign",
        "center",
        "ScaleModifier",
        point(950, 950),
        "HandleKeyboard",
        false,
        "Image",
        "UI/PDA/WEBSites/sun_cola_site"
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 530, 0, 0),
          "HAlign",
          "center",
          "VAlign",
          "center",
          "MinWidth",
          450,
          "MinHeight",
          150,
          "MaxWidth",
          450,
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          -10,
          "Background",
          RGBA(120, 200, 43, 0),
          "HandleKeyboard",
          false
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "AnimatedText1",
            "HandleKeyboard",
            false,
            "HandleMouse",
            false,
            "TextStyle",
            "PDABrowserColaTextNormal",
            "Translate",
            true,
            "Text",
            T(593314015120, "Only at Carnival!"),
            "TextHAlign",
            "center",
            "TextVAlign",
            "center"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "AnimatedText2",
            "HandleKeyboard",
            false,
            "HandleMouse",
            false,
            "TextStyle",
            "PDABrowserColaTextNormal",
            "Translate",
            true,
            "Text",
            T(697483709058, "Order a service at Le Lys Rouge!"),
            "TextHAlign",
            "center",
            "TextVAlign",
            "center"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "AnimatedText3",
            "HandleKeyboard",
            false,
            "HandleMouse",
            false,
            "TextStyle",
            "PDABrowserColaTextNormal",
            "Translate",
            true,
            "Text",
            T(882466523653, "Get two Sun Colas"),
            "TextHAlign",
            "center",
            "TextVAlign",
            "center"
          }),
          PlaceObj("XTemplateWindow", {
            "HAlign",
            "center",
            "VAlign",
            "center",
            "MinHeight",
            80,
            "MaxHeight",
            80
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "AnimatedText4",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "HandleKeyboard",
              false,
              "HandleMouse",
              false,
              "TextStyle",
              "PDABrowserColaTextBig",
              "Translate",
              true,
              "Text",
              T(158977597586, "FOR FREE!"),
              "TextHAlign",
              "center",
              "TextVAlign",
              "center"
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "AnimatedImage",
          "Margins",
          box(0, 0, 75, 240),
          "HAlign",
          "right",
          "VAlign",
          "center",
          "Background",
          RGBA(0, 72, 130, 0),
          "HandleKeyboard",
          false,
          "Image",
          "UI/PDA/WEBSites/sun_cola_fresh_2"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "PagePrivacyLinks",
        "Dock",
        "bottom",
        "VAlign",
        "center",
        "LayoutMethod",
        "VList",
        "HandleKeyboard",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(0, 5, 0, 0),
          "HAlign",
          "center",
          "HandleKeyboard",
          false,
          "HandleMouse",
          false,
          "TextStyle",
          "PDABrowserColaCopyright",
          "Translate",
          true,
          "Text",
          T(903266218528, "Privacy Policy | Copyright Sun Cola Company 2001"),
          "TextHAlign",
          "center"
        })
      })
    })
  })
})
