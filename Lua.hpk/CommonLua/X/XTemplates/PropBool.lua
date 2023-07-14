PlaceObj("XTemplate", {
  __is_kind_of = "XPropControl",
  group = "Common",
  id = "PropBool",
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
    RGBA(170, 170, 170, 255),
    "DisabledBackground",
    RGBA(170, 170, 170, 255)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idName",
      "MinWidth",
      300,
      "TextStyle",
      "GedTitle",
      "Translate",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idOn",
      "FoldWhenHidden",
      true,
      "TextStyle",
      "GedTitle",
      "Translate",
      true,
      "Text",
      T(124979663072, "On")
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idOff",
      "FoldWhenHidden",
      true,
      "TextStyle",
      "GedTitle",
      "Translate",
      true,
      "Text",
      T(388319833630, "Off")
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnPropUpdate(self, context, prop_meta, value)",
      "func",
      function(self, context, prop_meta, value)
        if prop_meta.on_value ~= nil then
          self.idOn:SetVisible(value == prop_meta.on_value)
        else
          self.idOn:SetVisible(value)
        end
        if prop_meta.off_value ~= nil then
          self.idOff:SetVisible(value == prop_meta.off_value)
        else
          self.idOff:SetVisible(not value)
        end
        self:SetEnabled(not prop_meta.read_only)
        self:SetHandleMouse(self.enabled)
        self:SetChildrenHandleMouse(self.enabled)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        XPropControl.OnMouseButtonDown(self, pos, button)
        if button == "L" then
          local id = self.prop_meta.id
          local value = ResolveValue(self.context, id)
          local on_value, off_value = self.prop_meta.on_value, self.prop_meta.off_value
          if on_value ~= nil and value == on_value and off_value ~= nil then
            value = off_value
          elseif off_value ~= nil and value == off_value and on_value ~= nil then
            value = on_value
          else
            value = not value
          end
          local obj = ResolvePropObj(self.context)
          SetProperty(obj, id, value)
          self.value = value
          self:OnPropUpdate(self.context, self.prop_meta, value)
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
