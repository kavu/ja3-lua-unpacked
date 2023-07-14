PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu Dev",
  id = "CheatsList",
  PlaceObj("XTemplateWindow", {"__class", "XDialog"}, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "DialogTitle",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self:SetText("CHEATS")
      end,
      "Translate",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "VAlign",
      "center"
    }, {
      PlaceObj("XTemplateTemplate", {
        "__template",
        "IGMainActions",
        "Id",
        "idActions"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "SnappingScrollArea",
        "Id",
        "idList",
        "IdNode",
        false,
        "LayoutMethod",
        "Grid",
        "LayoutHSpacing",
        10,
        "LayoutVSpacing",
        20,
        "UniformColumnWidth",
        true,
        "BorderColor",
        RGBA(255, 255, 255, 0),
        "Background",
        RGBA(32, 35, 47, 255),
        "FocusedBorderColor",
        RGBA(255, 255, 255, 0),
        "FocusedBackground",
        RGBA(32, 35, 47, 255),
        "DisabledBorderColor",
        RGBA(255, 255, 255, 0),
        "VScroll",
        "idScroll",
        "LeftThumbScroll",
        false,
        "KeepSelectionOnRespawn",
        true
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "SetInitialSelection(self)",
          "func",
          function(self)
            RunWhenXWindowIsReady(self, function()
              if not self:SelectFirstValidItem() then
                self:SetSelection(1)
              end
            end)
          end
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "MessengerScrollbar",
          "Id",
          "idScroll",
          "Margins",
          box(20, 3, 3, 3),
          "Dock",
          "right",
          "FoldWhenHidden",
          false,
          "Target",
          "idList"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "IsSelectable(self)",
            "func",
            function(self)
              return false
            end
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "MAPS",
          "__condition",
          function(parent, context)
            return Platform.developer
          end,
          "__template",
          "DialogTitle",
          "Margins",
          box(0, 0, 0, 0),
          "Dock",
          false,
          "Text",
          T(662905161298, "MAPS")
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "IsSelectable(self)",
            "func",
            function(self)
              return false
            end
          })
        }),
        PlaceObj("XTemplateForEachAction", {
          "toolbar",
          "cheats",
          "condition",
          function(parent, context, action, i)
            return Platform.developer and action.ActionToolbarSection == "MAPS"
          end,
          "run_after",
          function(child, context, action, n)
            child:SetText(action.ActionName)
            child:SetOnPressParam(action.ActionId)
            child:SetGridY(n + 1)
          end
        }, {
          PlaceObj("XTemplateTemplate", {"__template", "MenuButton"})
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "GENERAL",
          "__template",
          "DialogTitle",
          "Margins",
          box(0, 0, 0, 0),
          "Dock",
          false,
          "GridX",
          2,
          "Text",
          T(416706301043, "GENERAL")
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "IsSelectable(self)",
            "func",
            function(self)
              return false
            end
          })
        }),
        PlaceObj("XTemplateForEachAction", {
          "toolbar",
          "cheats",
          "condition",
          function(parent, context, action, i)
            return action.ActionToolbarSection == "GENERAL"
          end,
          "run_after",
          function(child, context, action, n)
            child:SetText(action.ActionName)
            child:SetOnPressParam(action.ActionId)
            child:SetGridY(n + 1)
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "MenuButton",
            "GridX",
            2
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "COMBAT",
          "__template",
          "DialogTitle",
          "Margins",
          box(0, 0, 0, 0),
          "Dock",
          false,
          "GridX",
          3,
          "Text",
          T(261152057685, "COMBAT")
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "IsSelectable(self)",
            "func",
            function(self)
              return false
            end
          })
        }),
        PlaceObj("XTemplateForEachAction", {
          "toolbar",
          "cheats",
          "condition",
          function(parent, context, action, i)
            return action.ActionToolbarSection == "COMBAT"
          end,
          "run_after",
          function(child, context, action, n)
            child:SetText(action.ActionName)
            child:SetOnPressParam(action.ActionId)
            child:SetGridY(n + 1)
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "MenuButton",
            "GridX",
            3
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "HIRING",
          "__template",
          "DialogTitle",
          "Margins",
          box(0, 0, 0, 0),
          "Dock",
          false,
          "GridX",
          4,
          "Text",
          T(486183100390, "HIRING")
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "IsSelectable(self)",
            "func",
            function(self)
              return false
            end
          })
        }),
        PlaceObj("XTemplateForEachAction", {
          "toolbar",
          "cheats",
          "condition",
          function(parent, context, action, i)
            return action.ActionToolbarSection == "HIRING"
          end,
          "run_after",
          function(child, context, action, n)
            child:SetText(action.ActionName)
            child:SetOnPressParam(action.ActionId)
            child:SetGridY(n + 1)
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "MenuButton",
            "GridX",
            4
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "LIGHTING",
          "__condition",
          function(parent, context)
            return Platform.developer
          end,
          "__template",
          "DialogTitle",
          "Margins",
          box(0, 0, 0, 0),
          "Dock",
          false,
          "GridX",
          5,
          "Text",
          T(275856763974, "LIGHTING")
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "IsSelectable(self)",
            "func",
            function(self)
              return false
            end
          })
        }),
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return Platform.developer and GetCheatsWeatherTOD() or {}
          end,
          "run_after",
          function(child, context, item, i, n, last)
            child:SetText(Untranslated(string.format("%s: %s-%s", mapdata.Region, item.weather, item.tod)))
            child:SetOnPressParam(item)
            child:SetGridY(n + 1)
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "MenuButton",
            "GridX",
            5,
            "OnPress",
            function(self, gamepad)
              XButton.OnPress(self, gamepad)
              CloseMenuDialogs()
              NetSyncEvent("CheatWeatherTOD", self.OnPressParam)
            end
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "SETPIECES",
          "__condition",
          function(parent, context)
            return next(Presets.SetpiecePrg.Trailers or {})
          end,
          "__template",
          "DialogTitle",
          "Margins",
          box(0, 0, 0, 0),
          "Dock",
          false,
          "GridX",
          6,
          "Text",
          T(825265755855, "SETPIECES")
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "IsSelectable(self)",
            "func",
            function(self)
              return false
            end
          })
        }),
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return Presets.SetpiecePrg.Trailers
          end,
          "run_after",
          function(child, context, item, i, n, last)
            child:SetText(Untranslated(item.id))
            child:SetOnPressParam(item)
            child:SetGridY(n + 1)
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "MenuButton",
            "GridX",
            6,
            "OnPress",
            function(self, gamepad)
              XButton.OnPress(self, gamepad)
              CloseMenuDialogs()
              NetSyncEvents.CheatPlaySetpiece(self.OnPressParam)
            end
          })
        })
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "idClose",
        "ActionName",
        T(535988861706, "Close"),
        "ActionToolbar",
        "ActionBar",
        "ActionShortcut",
        "Escape",
        "ActionGamepad",
        "ButtonB",
        "OnActionEffect",
        "close",
        "OnAction",
        function(self, host, source, ...)
          local effect = self.OnActionEffect
          local param = self.OnActionParam
          if effect == "close" and host and host.window_state ~= "destroying" then
            host.parent.parent:Close(param ~= "" and param or nil)
          end
        end,
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XToolBar",
        "Id",
        "idToolbar",
        "Margins",
        box(0, 60, 0, 50),
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
