PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu Dev",
  id = "PresetSquadList",
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
      T(115956064510, "CHOOSE PRESET SQUAD")
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
          "XList",
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
          false
        }, {
          PlaceObj("XTemplateForEach", {
            "array",
            function(parent, context)
              return PresetSquadCheatSquads
            end,
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
                NetSyncEvent("ReplaceCurrentSquadWithPresetSquad", self.context.id)
                CloseMenuDialogs()
              end,
              "Text",
              T(267821607277, "<Name>")
            })
          }),
          PlaceObj("XTemplateAction", {
            "ActionId",
            "Back",
            "ActionName",
            T(164467629513, "BACK"),
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
