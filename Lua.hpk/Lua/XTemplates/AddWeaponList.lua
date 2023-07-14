PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu Dev",
  id = "AddWeaponList",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return GetWeaponTypes()
    end,
    "__class",
    "XDialog",
    "HandleMouse",
    true,
    "InitialMode",
    "groups",
    "InternalModes",
    "groups,weapons"
  }, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "DialogTitle",
      "Id",
      "idTitle",
      "Text",
      T(889068448644, "ADD WEAPON")
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
                parent:ResolveId("idTitle"):SetText(T(786355812777, "CHOOSE WEAPON TYPE"))
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
                "OnContextUpdate",
                function(self, context, ...)
                  self:SetText(self.Text)
                  return XContextControl.OnContextUpdate(self, context)
                end,
                "OnPress",
                function(self, gamepad)
                  SetDialogMode(self, "weapons", self.context.id)
                end,
                "Text",
                T(500491021262, "<Name>")
              })
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "Back",
              "ActionName",
              T(211496886535, "BACK"),
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
          PlaceObj("XTemplateMode", {"mode", "weapons"}, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                parent:ResolveId("idTitle"):SetText(T(767404112434, "ADD WEAPON"))
              end
            }),
            PlaceObj("XTemplateForEach", {
              "comment",
              "weapon",
              "array",
              function(parent, context)
                return table.ifilter(GetWeaponsByType(GetDialogModeParam(parent)), function(_, o)
                  return o:HasMember("DisplayName")
                end)
              end,
              "__context",
              function(parent, context, item, i, n)
                return item
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "MenuButton",
                "OnPressEffect",
                "close",
                "OnPress",
                function(self, gamepad)
                  CheatAddWeapon(self.context)
                  CloseMenuDialogs()
                end,
                "Text",
                T(936184434198, "<DisplayName>")
              })
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "cancel",
              "ActionName",
              T(405878588824, "CANCEL"),
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
