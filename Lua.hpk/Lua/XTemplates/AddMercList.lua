PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu Dev",
  id = "AddMercList",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return GetGroupedMercsForCheats()
    end,
    "__class",
    "XDialog",
    "HandleMouse",
    true,
    "InitialMode",
    "groups",
    "InternalModes",
    "groups,mercs"
  }, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "DialogTitle",
      "Id",
      "idTitle",
      "Text",
      T(102642177591, "ADD MERCENARY")
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
          PlaceObj("XTemplateMode", {"mode", "groups"}, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                parent:ResolveId("idTitle"):SetText(T(216101900153, "ADD MERCENARY"))
              end
            }),
            PlaceObj("XTemplateForEach", {
              "comment",
              "group",
              "__context",
              function(parent, context, item, i, n)
                return item
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "MenuButton",
                "OnPress",
                function(self, gamepad)
                  SetDialogMode(self, "mercs", self.context)
                end,
                "Text",
                T(148846089787, "<display_name>")
              })
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "Back",
              "ActionName",
              T(353724719778, "BACK"),
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
          }),
          PlaceObj("XTemplateMode", {"mode", "mercs"}, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                parent:ResolveId("idTitle"):SetText(T(216101900153, "ADD MERCENARY"))
              end
            }),
            PlaceObj("XTemplateForEach", {
              "comment",
              "merc",
              "array",
              function(parent, context)
                return GetDialogModeParam(parent)
              end,
              "__context",
              function(parent, context, item, i, n)
                return item
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__condition",
                function(parent, context)
                  return not Presets.UnitDataCompositeDef.IMP[context.id]
                end,
                "__template",
                "MenuButton",
                "OnPressEffect",
                "close",
                "OnPress",
                function(self, gamepad)
                  CheatAddMercIG(self.context.id)
                  CloseMenuDialogs()
                end,
                "Text",
                T(771210066843, "<Name>")
              })
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "cancel",
              "ActionName",
              T(530612077779, "CANCEL"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "Escape",
              "ActionGamepad",
              "ButtonB",
              "OnActionEffect",
              "back"
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
