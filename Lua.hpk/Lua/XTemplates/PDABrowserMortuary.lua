PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu PDA",
  id = "PDABrowserMortuary",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "MouseCursor",
    "UI/Cursors/Pda_Cursor.tga"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XDialog.Open(self, ...)
        AddPageToBrowserHistory("banner_page", "PDABrowserMortuary")
        PDABrowserTabState.banner_page.mode_param = "PDABrowserMortuary"
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Dock",
      "box",
      "Image",
      "UI/PDA/WEBSites/mortuary_background",
      "ImageFit",
      "stretch"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      1078,
      "MaxWidth",
      1078,
      "MaxHeight",
      849,
      "Image",
      "UI/PDA/WEBSites/mortuary_site"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Margins",
        box(100, 350, 100, 0),
        "HAlign",
        "center",
        "VAlign",
        "top",
        "Background",
        RGBA(238, 0, 0, 0),
        "TextStyle",
        "PDAMortuaryText",
        "Translate",
        true,
        "Text",
        T(756938762590, [[
It is with deep regrets that we inform you that McGillicutty's Mortuary website is out of commission. Our beloved founder and colleague, Murray "Pops" McGillicutty, has passed away, leaving us all deeply saddened. As a result, we are temporarily closing all our services to honor Pops' memory. We ask for your patience and understanding during this difficult time.

While our website may be down, Pops' legacy will live on forever in the mortuary of our hearts. We will continue to provide top-quality funeral and pre-funeral services in the near future.

Sincerely,
The staff of McGillicutty's Mortuary.]]),
        "TextHAlign",
        "center"
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(105, 0, 105, 45),
        "Dock",
        "bottom",
        "VAlign",
        "bottom",
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        30
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "MinWidth",
          150,
          "MinHeight",
          100,
          "MaxWidth",
          150,
          "MaxHeight",
          100,
          "TextStyle",
          "PDAMortuaryBottomButton",
          "Translate",
          true,
          "Text",
          T(644249787339, "Send Flowers"),
          "TextHAlign",
          "center",
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "MinWidth",
          150,
          "MinHeight",
          100,
          "MaxWidth",
          150,
          "MaxHeight",
          100,
          "TextStyle",
          "PDAMortuaryBottomButton",
          "Translate",
          true,
          "Text",
          T(516677551626, "Casket & Urn Collection"),
          "TextHAlign",
          "center",
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "MinWidth",
          150,
          "MinHeight",
          100,
          "MaxWidth",
          150,
          "MaxHeight",
          100,
          "TextStyle",
          "PDAMortuaryBottomButton",
          "Translate",
          true,
          "Text",
          T(629738455462, "Cremation Services"),
          "TextHAlign",
          "center",
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "MinWidth",
          150,
          "MinHeight",
          100,
          "MaxWidth",
          150,
          "MaxHeight",
          100,
          "TextStyle",
          "PDAMortuaryBottomButton",
          "Translate",
          true,
          "Text",
          T(129496128595, "Pre-Funeral Planing Services"),
          "TextHAlign",
          "center",
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "MinWidth",
          150,
          "MinHeight",
          100,
          "MaxWidth",
          150,
          "MaxHeight",
          100,
          "TextStyle",
          "PDAMortuaryBottomButton",
          "Translate",
          true,
          "Text",
          T(269232160182, "Funeral Etiquette"),
          "TextHAlign",
          "center",
          "TextVAlign",
          "center"
        })
      })
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
    })
  })
})
