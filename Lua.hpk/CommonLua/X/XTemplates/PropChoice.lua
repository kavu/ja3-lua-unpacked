PlaceObj("XTemplate", {
  __is_kind_of = "XPropControl",
  group = "Common",
  id = "PropChoice",
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
      "idValue",
      "TextStyle",
      "GedTitle",
      "Translate",
      true
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnPropUpdate(self, context, prop_meta, value)",
      "func",
      function(self, context, prop_meta, value)
        local items = prop_meta.items
        if type(items) == "function" then
          items = items(context, prop_meta.id)
        end
        local text
        if type(value) == "table" then
          local count = 0
          for k, v in pairs(value) do
            if v ~= "none" then
              count = count + 1
            end
          end
          if count == 0 then
            text = T(732036341296, "None selected")
          elseif count == 1 and value.random then
            text = T(141246507157, "Random")
          else
            text = Untranslated("x" .. count)
          end
        else
          local entry = items and table.find_value(items, "value", value) or table.find_value(items, "value", prop_meta.default)
          text = entry and entry.text or ""
        end
        self.idValue:SetText(text)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        XPropControl.OnMouseButtonDown(self, pos, button)
        if button == "L" then
          SetDialogMode(self, "items", self.prop_meta)
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
