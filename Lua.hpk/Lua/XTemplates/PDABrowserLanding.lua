PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDABrowserLanding",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "Id",
    "idBrowserContent"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XDialog.Open(self, ...)
        for k, v in pairs(PDABrowserTabState) do
          UndockBrowserTab(k)
        end
        DockBrowserTab("landing")
        AddPageToBrowserHistory("landing")
        ObjModified("pda browser tabs")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        UndockBrowserTab("landing")
        DockBrowserTab("aim")
        if not g_TestCombat then
          DockBrowserTab("imp")
        end
        ObjModified("pda browser tabs")
        XDialog.OnDelete(self, ...)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "bkg frame",
      "__class",
      "XImage",
      "Dock",
      "box",
      "Image",
      "UI/PDA/aim_background",
      "ImageFit",
      "stretch"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "VirtualCursorManager",
      "Reason",
      "Langing",
      "ActionType",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "banner",
      "Margins",
      box(0, 0, 0, 40),
      "Dock",
      "bottom",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      5
    }, {
      PlaceObj("XTemplateWindow", {
        "HAlign",
        "center",
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        20
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "VAlign",
          "top",
          "TextStyle",
          "AimCopyrightText",
          "Translate",
          true,
          "Text",
          T(657753827058, "<style AimCopyrightTextC><copyright></style> A.I.M. 2001")
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PDALinkButton",
          "VAlign",
          "center",
          "OnPress",
          function(self, gamepad)
            local msg = CreateMessageBox(self.desktop, T(193416941017, "Error Page"), T(399424889814, "HTTP Error 400. The request URL is invalid."), T({"OK"}))
          end,
          "TextStyle",
          "WebLinkButton_Hiring",
          "Text",
          T(196572239600, "About Us"),
          "ActiveTextStyle",
          "WebLinkButton_Hiring_Heavy"
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PDALinkButton",
          "VAlign",
          "center",
          "OnPress",
          function(self, gamepad)
            local msg = CreateMessageBox(self.desktop, T(193416941017, "Error Page"), T(548899058407, "HTTP Error 403. You don't have permission to access on this server."), T({"OK"}))
          end,
          "TextStyle",
          "WebLinkButton_Hiring",
          "Text",
          T(591945544080, "Terms of Service"),
          "ActiveTextStyle",
          "WebLinkButton_Hiring_Heavy"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "AnimatedIMPBanner",
        "HAlign",
        "center",
        "VAlign",
        "top",
        "HandleMouse",
        true,
        "MouseCursor",
        "UI/Cursors/Pda_Hand.tga",
        "Image",
        "UI/PDA/imp_banner_1"
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "OnMouseButtonDown(self, pos, button)",
          "func",
          function(self, pos, button)
            local dlg = GetDialog(self)
            dlg:ActionById("idContinue"):OnAction(dlg)
          end
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idMegaphone",
          "Margins",
          box(0, 0, 25, 0),
          "HAlign",
          "right",
          "VAlign",
          "center",
          "Image",
          "UI/PDA/imp_banner_megaphone"
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idTextContainer",
          "Margins",
          box(25, -5, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "center",
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          5
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idText",
            "HAlign",
            "center",
            "Image",
            "UI/PDA/imp_banner_text_1"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idTextTwo",
            "HAlign",
            "center",
            "Image",
            "UI/PDA/imp_banner_text_2"
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {"Dock", "box"}, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "main",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Image",
          "UI/PDA/aim_logo"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "header txt",
          "__class",
          "XText",
          "Margins",
          box(0, 20, 0, 0),
          "HAlign",
          "center",
          "TextStyle",
          "PDALandingHeader",
          "Translate",
          true,
          "Text",
          T(977617334059, "WELCOME TO THE A.I.M. RECRUITMENT WEBSITE")
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "main txt",
          "__class",
          "XText",
          "Margins",
          box(0, 55, 0, 0),
          "MaxWidth",
          1150,
          "TextStyle",
          "PDALandingText",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            self:SetText(Untranslated(_InternalTranslate(self.Text, {
              em = "<style PDALandingEm>",
              ["/em"] = "</style>"
            })))
          end,
          "Translate",
          true,
          "Text",
          T(989191017446, "This is the web page for the Association of International Mercenaries, or A.I.M. for short. Here you can browse and hire different mercs. For your starting squad it is recommended that you <em>hire at least three mercs</em>, but do keep a watch on your funds. You will be able to hire mercs at any time during your mission, so do not worry if you currently lack the funds to hire the most legendary mercs."),
          "TextHAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "button text",
          "__class",
          "XText",
          "Margins",
          box(0, 50, 0, 0),
          "MaxWidth",
          1150,
          "TextStyle",
          "PDALandingEm",
          "Translate",
          true,
          "Text",
          T(326877401379, "Hit the continue button below to browse our catalogue!"),
          "TextHAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "button",
          "__class",
          "XToolBarList",
          "Id",
          "idToolBar",
          "Margins",
          box(0, 30, 0, 0),
          "HAlign",
          "center",
          "Background",
          RGBA(255, 255, 255, 0),
          "Toolbar",
          "ActionBar",
          "Show",
          "text",
          "ButtonTemplate",
          "PDALandingPageButton"
        })
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idContinue",
      "ActionName",
      T(451752778865, "Continue"),
      "ActionToolbar",
      "ActionBar",
      "ActionShortcut",
      "C",
      "ActionGamepad",
      "ButtonA",
      "OnAction",
      function(self, host, source, ...)
        TutorialHintsState.LandingPageShown = true
        host:SetMode("aim")
      end
    })
  })
})
