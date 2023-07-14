PlaceObj("XTemplate", {
  group = "Zulu Satellite UI",
  id = "PDASquadManagementFilterMenu",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPopup",
    "Id",
    "idFilterMenu",
    "Padding",
    box(0, 4, 0, 4),
    "LayoutMethod",
    "Box",
    "DrawOnTop",
    true,
    "Background",
    RGBA(195, 189, 172, 255),
    "FocusedBackground",
    RGBA(195, 189, 172, 255),
    "AnchorType",
    "top"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XList",
      "IdNode",
      false,
      "BorderWidth",
      0,
      "Padding",
      box(0, 4, 0, 4),
      "Background",
      RGBA(195, 189, 172, 255),
      "FocusedBackground",
      RGBA(195, 189, 172, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XTextButton",
        "Padding",
        box(4, 0, 0, 0),
        "Background",
        RGBA(195, 189, 172, 0),
        "OnContextUpdate",
        function(self, context, ...)
          local dlg = GetDialog(self)
          self.idLabel:SetEnabled(dlg.Filter ~= "Salary")
        end,
        "OnPress",
        function(self, gamepad)
          local node = self:ResolveId("node")
          node:SetFilter("Salary")
        end,
        "RolloverBackground",
        RGBA(32, 35, 47, 255),
        "PressedBackground",
        RGBA(32, 35, 47, 255),
        "TextStyle",
        "PDACommonButtonWithRollover",
        "Translate",
        true,
        "Text",
        T(503216972892, "Salary")
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "SetSelected(self, selected)",
          "func",
          function(self, selected)
            self:SetFocus(true)
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "IsSelectable(self)",
          "func",
          function(self)
            return true
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XTextButton",
        "Padding",
        box(4, 0, 0, 0),
        "Background",
        RGBA(195, 189, 172, 0),
        "OnContextUpdate",
        function(self, context, ...)
          local dlg = GetDialog(self)
          self.idLabel:SetEnabled(dlg.Filter ~= "Professions")
        end,
        "OnPress",
        function(self, gamepad)
          local node = self:ResolveId("node")
          node:SetFilter("Professions")
        end,
        "RolloverBackground",
        RGBA(32, 35, 47, 255),
        "PressedBackground",
        RGBA(32, 35, 47, 255),
        "TextStyle",
        "PDACommonButtonWithRollover",
        "Translate",
        true,
        "Text",
        T(645074869947, "Professions")
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "SetSelected(self, selected)",
          "func",
          function(self, selected)
            self:SetFocus(true)
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "IsSelectable(self)",
          "func",
          function(self)
            return true
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Margins",
        box(4, 4, 4, 4),
        "Image",
        "UI/PDA/separate_line_vertical",
        "FrameBox",
        box(3, 3, 3, 3),
        "SqueezeY",
        false
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
          return UnitPropertiesStats:GetProperties()
        end,
        "__context",
        function(parent, context, item, i, n)
          return item
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "Padding",
          box(4, 0, 0, 0),
          "Background",
          RGBA(195, 189, 172, 0),
          "OnContextUpdate",
          function(self, context, ...)
            self:SetText(context.name)
            local dlg = GetDialog(self)
            self.idLabel:SetEnabled(dlg.Filter ~= context.id)
          end,
          "OnPress",
          function(self, gamepad)
            local node = self:ResolveId("node")
            local context = self.context
            node:SetFilter(context.id)
          end,
          "RolloverBackground",
          RGBA(32, 35, 47, 255),
          "PressedBackground",
          RGBA(32, 35, 47, 255),
          "TextStyle",
          "PDACommonButtonWithRollover",
          "Translate",
          true
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "SetSelected(self, selected)",
            "func",
            function(self, selected)
              self:SetFocus(true)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "IsSelectable(self)",
            "func",
            function(self)
              return true
            end
          })
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnCaptureLost(self)",
      "func",
      function(self)
        if self.window_state ~= "open" then
          return
        end
        self:Close()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        if self:MouseInWindow(pos) then
          return
        end
        if self.window_state ~= "open" then
          return
        end
        self:Close()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "Escape" or shortcut == "ButtonB" then
          self:Close()
          return "break"
        end
        return XPopup.OnShortcut(self, shortcut, source, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetFilter(self, filter)",
      "func",
      function(self, filter)
        local dlg = GetDialog(self)
        dlg:SetFilter(filter)
        for i, p in ipairs(self[1]) do
          if p.OnContextUpdate then
            p:OnContextUpdate(p.context)
          end
        end
      end
    })
  })
})
