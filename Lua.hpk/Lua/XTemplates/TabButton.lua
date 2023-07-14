PlaceObj("XTemplate", {
  __is_kind_of = "XTextButton",
  group = "Zulu",
  id = "TabButton",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return "layerButton"
    end,
    "__class",
    "XTextButton",
    "HAlign",
    "center",
    "VAlign",
    "top",
    "MinWidth",
    160,
    "MaxWidth",
    160,
    "Background",
    RGBA(255, 255, 255, 0),
    "OnContextUpdate",
    function(self, context, ...)
      self:SetHandleMouse(not g_ZuluMessagePopup)
      return XContextControl.OnContextUpdate(self, context)
    end,
    "FXMouseIn",
    "TabButtonRollover",
    "FXPress",
    "TabButtonPress",
    "FXPressDisabled",
    "TabButtonDisabled",
    "FocusedBackground",
    RGBA(255, 255, 255, 0),
    "RolloverBackground",
    RGBA(255, 255, 255, 0),
    "PressedBackground",
    RGBA(255, 255, 255, 0),
    "Translate",
    true,
    "ColumnsUse",
    "abcca"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        rawset(self, "selected", false)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        XTextButton.OnSetRollover(self, rollover)
        self.idText:SetRollover(rollover or self.selected)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        local parent = self.parent
        for _, ctrl in ipairs(parent) do
          ctrl.selected = false
          ctrl:OnSetRollover(false)
        end
        self.selected = selected
        self:OnSetRollover(selected)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetText(self, text)",
      "func",
      function(self, text)
        self.idText:SetText(text)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        if button == "L" and self:GetEnabled() then
          local dlg = GetDialog("FullscreenGameDialogs")
          dlg:SetMode(self:GetMode())
          self:SetRollover(true)
          self:SetSelected(true)
          return "break"
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonUp(self, pos, button)",
      "func",
      function(self, pos, button)
        return "break"
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idText",
      "Padding",
      box(0, 0, 0, 0),
      "Dock",
      "box",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "TextStyle",
      "HeaderButton",
      "Translate",
      true,
      "TextHAlign",
      "center",
      "TextVAlign",
      "center"
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "Mode",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      rawset(self, "Mode", value)
    end,
    "Get",
    function(self)
      return rawget(self, "Mode")
    end,
    "name",
    T(139828286707, "Mode")
  })
})
