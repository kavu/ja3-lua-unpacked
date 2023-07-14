PlaceObj("XTemplate", {
  __is_kind_of = "XPropControl",
  group = "Common",
  id = "PropKeybinding",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPropControl",
    "BorderWidth",
    2,
    "LayoutMethod",
    "HList",
    "Background",
    RGBA(255, 255, 255, 255),
    "RolloverOnFocus",
    true,
    "MouseCursor",
    "CommonAssets/UI/HandCursor.tga",
    "FocusedBackground",
    RGBA(170, 170, 170, 255)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idName",
      "MinWidth",
      400,
      "MaxWidth",
      400,
      "TextStyle",
      "GedTitle",
      "Translate",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "MinWidth",
      400,
      "MaxWidth",
      400,
      "LayoutMethod",
      "Grid",
      "UniformColumnWidth",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idBinding1",
        "HAlign",
        "center",
        "TextStyle",
        "GedTitle",
        "Translate",
        true,
        "Shorten",
        true
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "OnMouseButtonDown(self, pos, button)",
          "func",
          function(self, pos, button)
            if button == "L" then
              self.desktop:SetMouseCapture(self)
              self.binding = true
              return "break"
            end
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnMouseButtonUp(self, pos, button)",
          "func",
          function(self, pos, button)
            if button == "L" then
              self.desktop:SetMouseCapture(false)
              if self.binding then
                RebindKeys(1, self.parent.parent)
              end
              return "break"
            end
          end
        }),
        PlaceObj("XTemplateProperty", {"id", "binding"})
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idBinding2",
        "HAlign",
        "center",
        "GridX",
        2,
        "TextStyle",
        "GedTitle",
        "Translate",
        true,
        "Shorten",
        true
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "OnMouseButtonDown(self, pos, button)",
          "func",
          function(self, pos, button)
            if button == "L" then
              self.desktop:SetMouseCapture(self)
              self.binding = true
              return "break"
            end
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnMouseButtonUp(self, pos, button)",
          "func",
          function(self, pos, button)
            if button == "L" then
              self.desktop:SetMouseCapture(false)
              if self.binding then
                RebindKeys(2, self.parent.parent)
              end
              return "break"
            end
          end
        }),
        PlaceObj("XTemplateProperty", {"id", "binding"})
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnPropUpdate(self, context, prop_meta, value)",
      "func",
      function(self, context, prop_meta, value)
        local binding_1, binding_2 = KeybindingName(value and value[1]), KeybindingName(value and value[2])
        binding_1 = (binding_1 or "") ~= "" and binding_1
        binding_2 = (binding_2 or "") ~= "" and binding_2
        self.idBinding1:SetText(binding_1 or T(682820552090, "(  )"))
        self.idBinding2:SetText(binding_2 or T(682820552090, "(  )"))
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        XPropControl.OnMouseButtonDown(self, pos, button)
        if button == "L" then
          return self.idBinding1:OnMouseButtonDown(pos, button)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonUp(self, pos, button)",
      "func",
      function(self, pos, button)
        if button == "L" then
          return self.idBinding1:OnMouseButtonUp(pos, button)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "ButtonA" then
          self:OnMouseButtonDown(nil, "L")
          self:OnMouseButtonUp(nil, "L")
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        self:SetFocus(selected)
      end
    })
  })
})
