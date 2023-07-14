PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu Dev",
  id = "CombatTestList",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return GetCheatsTestCombatPresets()
    end,
    "__class",
    "XDialog"
  }, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "DialogTitle",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self:SetText("COMBAT TEST")
      end,
      "Translate",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "VAlign",
      "center",
      "LayoutMethod",
      "HList",
      "LayoutHSpacing",
      60
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XList",
        "Id",
        "idScrollArea",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "LayoutVSpacing",
        20,
        "BorderColor",
        RGBA(0, 0, 0, 0),
        "Background",
        RGBA(0, 0, 0, 0),
        "BackgroundRectGlowColor",
        RGBA(0, 0, 0, 0),
        "FocusedBorderColor",
        RGBA(0, 0, 0, 0),
        "FocusedBackground",
        RGBA(0, 0, 0, 0),
        "DisabledBorderColor",
        RGBA(0, 0, 0, 0),
        "VScroll",
        "idScroll"
      }, {
        PlaceObj("XTemplateForEach", {
          "__context",
          function(parent, context, item, i, n)
            return item
          end,
          "run_after",
          function(child, context, item, i, n, last)
            child:SetText(Untranslated(item.DisplayText or item.id))
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "MenuButton",
            "OnPress",
            function(self, gamepad)
              NetGossip("CombatTest", self.context, GetCurrentPlaytime(), Game and Game.CampaignTime)
              CreateRealTimeThread(TestCombatEnterSector, self.context)
              CloseIngameMainMenu()
            end
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "MessengerScrollbar",
        "Id",
        "idScroll",
        "Target",
        "idScrollArea"
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Back",
        "ActionName",
        T(175671556331, "BACK"),
        "ActionToolbar",
        "ActionBar",
        "ActionShortcut",
        "Escape",
        "ActionGamepad",
        "ButtonB",
        "OnAction",
        function(self, host, source, ...)
          local dlg = GetParentOfKind(host.parent, "XDialog")
          SetBackDialogMode(dlg)
        end
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XToolBar",
        "Id",
        "idToolbar",
        "Margins",
        box(0, 60, 0, 0),
        "Dock",
        "bottom",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "LayoutHSpacing",
        20,
        "Background",
        RGBA(0, 0, 0, 0),
        "Toolbar",
        "ActionBar",
        "Show",
        "text",
        "ButtonTemplate",
        "MenuButton"
      })
    })
  })
})
