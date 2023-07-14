PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "SetLoyaltyCheat",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return table.keys2(gv_Cities, "sorted")
    end,
    "__class",
    "XDialog",
    "HandleMouse",
    true,
    "InitialMode",
    "cities",
    "InternalModes",
    "cities, choose_loyalty"
  }, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "DialogTitle",
      "Id",
      "idTitle",
      "Text",
      T(947716588623, "SET LOYALTY")
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
          PlaceObj("XTemplateMode", {"mode", "cities"}, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                parent:ResolveId("idTitle"):SetText(T(373317789244, "SET LOYALTY"))
              end
            }),
            PlaceObj("XTemplateForEach", {
              "__context",
              function(parent, context, item, i, n)
                return item
              end,
              "run_after",
              function(child, context, item, i, n, last)
                child:SetText(Untranslated(context))
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "MenuButton",
                "OnPress",
                function(self, gamepad)
                  SetDialogMode(self, "choose_loyalty", self.context)
                end
              })
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "idClose",
              "ActionName",
              T(710381235614, "BACK"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "Escape",
              "ActionGamepad",
              "ButtonB",
              "OnAction",
              function(self, host, source, ...)
                local dlg = GetDialog(host.parent)
                SetBackDialogMode(dlg)
              end,
              "replace_matching_id",
              true
            })
          }),
          PlaceObj("XTemplateMode", {
            "mode",
            "choose_loyalty"
          }, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                parent:ResolveId("idTitle"):SetText(T({
                  667442261149,
                  "SET LOYALTY TO <DisplayName>",
                  gv_Cities[GetDialog(parent).mode_param]
                }))
              end
            }),
            PlaceObj("XTemplateForEach", {
              "comment",
              "merc",
              "array",
              function(parent, context)
                return {
                  0,
                  10,
                  20,
                  30,
                  40,
                  50,
                  60,
                  70,
                  80,
                  90,
                  100
                }
              end,
              "__context",
              function(parent, context, item, i, n)
                return item
              end,
              "run_after",
              function(child, context, item, i, n, last)
                child:SetText(Untranslated(context))
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "MenuButton",
                "OnPressEffect",
                "close",
                "OnPress",
                function(self, gamepad)
                  local city = GetDialog(self).mode_param
                  CheatSetLoyalty(city, self.context - gv_Cities[city].Loyalty)
                  CloseMenuDialogs()
                end
              })
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "idClose",
              "ActionName",
              T(942193564942, "CANCEL"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "Escape",
              "ActionGamepad",
              "ButtonB",
              "OnActionEffect",
              "back",
              "replace_matching_id",
              true
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
