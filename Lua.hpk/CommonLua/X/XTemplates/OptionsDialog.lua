PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Common",
  id = "OptionsDialog",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      OptionsObj = OptionsObj or OptionsCreateAndLoad()
      return OptionsObj
    end,
    "__class",
    "XDialog",
    "HandleMouse",
    true,
    "InitialMode",
    "categories",
    "InternalModes",
    "categories,properties,items"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        OptionsObj = false
        OptionsObjOriginal = false
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetCategoryId",
      "func",
      function(self, ...)
        local mode_param = GetDialogModeParam(self)
        return mode_param.id
      end
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "DialogTitle",
      "Id",
      "idTitle",
      "Text",
      T(328054656910, "OPTIONS")
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
          PlaceObj("XTemplateMode", {"mode", "categories"}, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                parent:ResolveId("idTitle"):SetText(T(477176115039, "OPTIONS"))
              end
            }),
            PlaceObj("XTemplateForEach", {
              "comment",
              "categories",
              "array",
              function(parent, context)
                return OptionsCategories
              end,
              "condition",
              function(parent, context, item, i)
                return not prop_eval(item.no_edit, nil, item)
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
                  if type(self.context.run) == "function" then
                    self.context.run()
                  else
                    SetDialogMode(self, "properties", self.context)
                  end
                end,
                "Text",
                T(613640636043, "<display_name>")
              })
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "Back",
              "ActionName",
              T(987308914761, "BACK"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "Escape",
              "ActionGamepad",
              "ButtonB",
              "OnActionEffect",
              "back"
            })
          }),
          PlaceObj("XTemplateMode", {"mode", "properties"}, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                parent:ResolveId("idTitle"):SetText(GetDialogModeParam(parent).caps_name)
              end
            }),
            PlaceObj("XTemplateForEach", {
              "comment",
              "properties",
              "array",
              function(parent, context)
                return context:GetProperties()
              end,
              "condition",
              function(parent, context, item, i)
                item.items = prop_eval(item.items, nil, item) or OptionsData.Options[item.id]
                return item.category == GetDialogModeParam(parent).id and not prop_eval(item.no_edit, nil, item)
              end,
              "item_in_context",
              "prop_meta"
            }, {
              PlaceObj("XTemplateTemplate", {"__template", "PropEntry"})
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "cancelOptions",
              "ActionName",
              T(277023742051, "CANCEL"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "Escape",
              "ActionGamepad",
              "ButtonB",
              "OnAction",
              function(self, host, source, ...)
                CancelOptions(host)
              end,
              "__condition",
              function(parent, context)
                return GetDialogModeParam(parent).id ~= "Display"
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "cancelDisplayOptions",
              "ActionName",
              T(277023742051, "CANCEL"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "Escape",
              "ActionGamepad",
              "ButtonB",
              "OnAction",
              function(self, host, source, ...)
                CancelDisplayOptions(host)
              end,
              "__condition",
              function(parent, context)
                return GetDialogModeParam(parent).id == "Display"
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "autoDetect",
              "ActionName",
              T(616811979339, "AUTO DETECT"),
              "ActionToolbar",
              "ActionBar",
              "ActionGamepad",
              "ButtonY",
              "OnAction",
              function(self, host, source, ...)
                Options.Autodetect(EngineOptions)
                local obj = ResolvePropObj(host.context)
                obj:SetVideoPreset(EngineOptions.VideoPreset)
                ObjModified(obj)
              end,
              "__condition",
              function(parent, context)
                return GetDialogModeParam(parent).id == "Video"
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "restoreDefaults",
              "ActionName",
              T(519784994957, "RESET"),
              "ActionToolbar",
              "ActionBar",
              "ActionGamepad",
              "ButtonY",
              "OnAction",
              function(self, host, source, ...)
                local obj = ResolvePropObj(host.context)
                obj:ResetOptionsByCategory(GetDialogModeParam(host).id)
                ObjModified(obj)
              end,
              "__condition",
              function(parent, context)
                return GetDialogModeParam(parent).id == "Keybindings"
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "resetToDefaults",
              "ActionName",
              T(519784994957, "RESET"),
              "ActionToolbar",
              "ActionBar",
              "ActionGamepad",
              "ButtonY",
              "OnAction",
              function(self, host, source, ...)
                local obj = ResolvePropObj(host.context)
                obj:ResetOptionsByCategory(GetDialogModeParam(host).id)
                ObjModified(obj)
              end,
              "__condition",
              function(parent, context)
                local category = GetDialogModeParam(parent).id
                return category == "Audio" or category == "Controls" or category == "Gameplay" or category == "Display"
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "applyOptions",
              "ActionName",
              T(148605689666, "APPLY"),
              "ActionToolbar",
              "ActionBar",
              "ActionGamepad",
              "ButtonX",
              "OnAction",
              function(self, host, source, ...)
                ApplyOptions(host)
              end,
              "__condition",
              function(parent, context)
                return GetDialogModeParam(parent).id ~= "Display"
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "applyDisplayOptions",
              "ActionName",
              T(148605689666, "APPLY"),
              "ActionToolbar",
              "ActionBar",
              "ActionGamepad",
              "ButtonX",
              "OnAction",
              function(self, host, source, ...)
                ApplyDisplayOptions(host)
              end,
              "__condition",
              function(parent, context)
                return GetDialogModeParam(parent).id == "Display"
              end
            })
          }),
          PlaceObj("XTemplateMode", {"mode", "items"}, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                parent:ResolveId("idTitle"):SetText(GetDialogModeParam(parent).name)
              end
            }),
            PlaceObj("XTemplateForEach", {
              "comment",
              "items",
              "array",
              function(parent, context)
                return GetDialogModeParam(parent).items
              end,
              "condition",
              function(parent, context, item, i)
                local ns = item.not_selectable
                if type(ns) == "function" then
                  ns = ns()
                end
                return not ns
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
                  local prop_meta = GetDialogModeParam(self)
                  SetProperty(GetDialogContext(self), prop_meta.id, self.context.value)
                  SetBackDialogMode(self)
                end,
                "Text",
                T(326989843349, "<text>")
              })
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "cancel",
              "ActionName",
              T(277023742051, "CANCEL"),
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
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        OptionsObjOriginal = OptionsCreateAndLoad()
        return OptionsObjOriginal
      end,
      "__class",
      "XContextWindow",
      "Id",
      "idOriginalOptions",
      "Dock",
      "ignore"
    })
  })
})
