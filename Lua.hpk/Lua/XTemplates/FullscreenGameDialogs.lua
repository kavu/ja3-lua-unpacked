PlaceObj("XTemplate", {
  Comment = "used for inventory/perks UI",
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "FullscreenGameDialogs",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "Id",
    "idFullscreenHost",
    "ZOrder",
    3,
    "Background",
    RGBA(32, 35, 47, 225),
    "MouseCursor",
    "UI/Cursors/Cursor.tga",
    "InitialMode",
    "inventory",
    "InternalModes",
    "inventory, empty"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        self.squad = false
        SetEnabledMouseViaGamepad(true, "Inventory")
        XShortcutsSetMode("UI")
        Msg("OpenInventorySubDialog", self.context and self.context.autoResolve)
        XDialog.Open(self, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close",
      "func",
      function(self, ...)
        local subDialog = self:GetSubdialog()
        if subDialog then
          subDialog:OnEscape()
        end
        SetEnabledMouseViaGamepad(false, "Inventory")
        XShortcutsSetMode(gv_SatelliteView and "Satellite" or "Game")
        Msg("CloseInventorySubDialog", self.context and self.context.autoResolve)
        XDialog.Close(self, ...)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XHideDialogs"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetSubdialog",
      "func",
      function(self, ...)
        return self.idModeDialog[2]
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        InventoryClosePopup(self:GetSubdialog())
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        local res = XDialog.OnShortcut(self, shortcut, source, ...)
        if res == "break" then
          return "break"
        end
        if shortcut == "Back" then
          self:SetMode("satview")
          return "break"
        end
        local dlg = self.idModeDialog[2]
        return dlg and dlg:OnShortcut(shortcut, source, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnKillFocus(self)",
      "func",
      function(self)
        local sub = self:GetSubdialog()
        if sub then
          sub:OnKillFocus()
        end
        XDialog.OnKillFocus(self)
      end
    }),
    PlaceObj("XTemplateWindow", {"comment", "content"}, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idMouseText",
        "Margins",
        box(30, 30, 0, 0),
        "HAlign",
        "left",
        "VAlign",
        "top",
        "MinWidth",
        100,
        "MinHeight",
        30,
        "MaxHeight",
        30,
        "Clip",
        false,
        "UseClipBox",
        false,
        "Visible",
        false,
        "DrawOnTop",
        true,
        "HandleKeyboard",
        false,
        "HandleMouse",
        false,
        "ChildrenHandleMouse",
        false,
        "TextStyle",
        "InventoryMouseText",
        "Translate",
        true
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "background",
        "Background",
        RGBA(0, 0, 0, 76)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XAspectWindow"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFitContent",
            "IdNode",
            false,
            "Fit",
            "largest"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Margins",
              box(80, 98, 80, 88),
              "Image",
              "UI/Inventory/T_Backpack_Background"
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "inventory frame",
              "__class",
              "XFrame",
              "IdNode",
              false,
              "HAlign",
              "center",
              "VAlign",
              "center",
              "Image",
              "UI/Inventory/T_Backpack_Frame",
              "SqueezeX",
              false,
              "SqueezeY",
              false
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContentTemplate",
                "Id",
                "idModeDialog",
                "Margins",
                box(80, 98, 80, 88)
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XFrame",
                  "Visible",
                  false,
                  "Background",
                  RGBA(255, 255, 255, 0),
                  "FocusedBackground",
                  RGBA(255, 255, 255, 0)
                }),
                PlaceObj("XTemplateMode", {"mode", "inventory"}, {
                  PlaceObj("XTemplateTemplate", {"__template", "Inventory"}),
                  PlaceObj("XTemplateAction", {
                    "comment",
                    "exit",
                    "ActionId",
                    "Close",
                    "ActionName",
                    T(499807098574, "CLOSE"),
                    "ActionShortcut",
                    "Escape",
                    "ActionGamepad",
                    "Start",
                    "OnAction",
                    function(self, host, source, ...)
                      if host.Mode ~= "inventory" or not host:GetSubdialog():OnEscape() then
                        SetEnabledMouseViaGamepad(false, "Inventory")
                        host:Close()
                      end
                    end
                  })
                })
              }),
              PlaceObj("XTemplateTemplate", {
                "__template",
                "HUDStartButton",
                "Margins",
                box(116, 0, 0, 93),
                "HAlign",
                "left"
              }),
              PlaceObj("XTemplateWindow", nil, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idInventory",
                  "Margins",
                  box(0, 58, 0, 0),
                  "Padding",
                  box(0, 0, 0, 0),
                  "HAlign",
                  "center",
                  "VAlign",
                  "top",
                  "TextStyle",
                  "HeaderTitle",
                  "Translate",
                  true,
                  "Text",
                  T(245949906540, "INVENTORY"),
                  "TextHAlign",
                  "center",
                  "TextVAlign",
                  "center"
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "dog tags",
                  "__class",
                  "XImage",
                  "Margins",
                  box(0, 0, -20, 100),
                  "HAlign",
                  "right",
                  "VAlign",
                  "bottom",
                  "ChildrenHandleMouse",
                  false,
                  "Image",
                  "UI/Inventory/dog_tags"
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "close",
                  "__class",
                  "XTextButton",
                  "Id",
                  "idClose",
                  "Margins",
                  box(0, 172, 37, 0),
                  "HAlign",
                  "right",
                  "VAlign",
                  "top",
                  "MinWidth",
                  45,
                  "MinHeight",
                  53,
                  "FXMouseIn",
                  "buttonRollover",
                  "FXPress",
                  "buttonPressGeneric",
                  "FXPressDisabled",
                  "IactDisabled",
                  "OnPress",
                  function(self, gamepad)
                    GetDialog(self):Close()
                  end,
                  "Image",
                  "UI/Inventory/close",
                  "Translate",
                  true,
                  "ColumnsUse",
                  "abcca"
                })
              }),
              PlaceObj("XTemplateTemplate", {
                "__template",
                "InventoryActionBar",
                "ZOrder",
                2,
                "Margins",
                box(0, 0, 130, 100),
                "MarginPolicy",
                "FitInSafeArea",
                "Dock",
                false,
                "VAlign",
                "bottom",
                "FoldWhenHidden",
                true,
                "DrawOnTop",
                true
              })
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idVignette",
        "Dock",
        "box",
        "Image",
        "UI/Inventory/inventory_vignette",
        "ImageFit",
        "stretch"
      })
    })
  })
})
