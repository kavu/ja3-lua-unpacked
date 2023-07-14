PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu Dev",
  id = "RemoveMercList",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "HandleMouse",
    true,
    "InitialMode",
    "mercs",
    "InternalModes",
    "mercs"
  }, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "DialogTitle",
      "Id",
      "idTitle",
      "Text",
      T(161192036978, "REMOVE MERCENARY")
    }),
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "VAlign",
      "center",
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      20
    }, {
      PlaceObj("XTemplateWindow", nil, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContentTemplateList",
          "Id",
          "idList",
          "BorderWidth",
          0,
          "Padding",
          box(0, 0, 0, 0),
          "LayoutVSpacing",
          20,
          "UniformRowHeight",
          true,
          "Clip",
          false,
          "Background",
          RGBA(0, 0, 0, 0),
          "FocusedBackground",
          RGBA(0, 0, 0, 0),
          "VScroll",
          "idScroll",
          "ShowPartialItems",
          false,
          "MouseScroll",
          true,
          "RespawnOnContext",
          false
        }, {
          PlaceObj("XTemplateMode", {"mode", "mercs"}, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                parent:ResolveId("idTitle"):SetText(T(389335876177, "REMOVE MERCENARY"))
              end
            }),
            PlaceObj("XTemplateForEach", {
              "comment",
              "merc",
              "array",
              function(parent, context)
                return Selection[1] and Selection[1].team.units or empty_table
              end,
              "__context",
              function(parent, context, item, i, n)
                return item
              end,
              "run_after",
              function(child, context, item, i, n, last)
                child:SetContext(Selection[1].team.units[i])
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "MenuButton",
                "OnPress",
                function(self, gamepad)
                  CheatRemoveMercIG(self.context)
                  CloseMenuDialogs()
                end,
                "Text",
                T(593405095038, "<Nick>")
              })
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "Back",
              "ActionName",
              T(971567621541, "BACK"),
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
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XSleekScroll",
          "Id",
          "idScroll",
          "Margins",
          box(20, 0, 0, 0),
          "Dock",
          "right",
          "Target",
          "idList",
          "SnapToItems",
          true,
          "AutoHide",
          true
        })
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
