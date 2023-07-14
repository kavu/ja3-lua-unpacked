PlaceObj("XTemplate", {
  __content = function(parent, context)
    return parent.idParent
  end,
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "InventoryPopupButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "Margins",
    box(0, 0, 10, 0),
    "Padding",
    box(5, 5, 5, 0),
    "UseClipBox",
    false,
    "BorderColor",
    RGBA(255, 255, 255, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "ChildrenHandleMouse",
    true,
    "FXMouseIn",
    "buttonRollover",
    "FXPress",
    "buttonPressGeneric",
    "FXPressDisabled",
    "IactDisabled",
    "FocusedBorderColor",
    RGBA(255, 255, 255, 0),
    "FocusedBackground",
    RGBA(255, 255, 255, 0),
    "DisabledBorderColor",
    RGBA(255, 255, 255, 0),
    "RolloverBackground",
    RGBA(255, 255, 255, 0),
    "PressedBackground",
    RGBA(255, 255, 255, 0)
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "+ButtonA" then
          self:OnPress()
          return "break"
        end
        return XButton.OnShortcut(self, shortcut, source, ...)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idSelectedBG",
      "Margins",
      box(5, 0, -5, 0),
      "Dock",
      "box",
      "UseClipBox",
      false,
      "Visible",
      false,
      "Background",
      RGBA(215, 159, 80, 255)
    }),
    PlaceObj("XTemplateWindow", {"HAlign", "left"}, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idText",
        "IdNode",
        false,
        "ZOrder",
        2,
        "Padding",
        box(15, 2, 0, 2),
        "HAlign",
        "left",
        "VAlign",
        "center",
        "Clip",
        false,
        "UseClipBox",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "InventoryActionsText",
        "Translate",
        true,
        "Text",
        T(975999935851, "<display_name>")
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "Id",
      "idParent"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        local selected = self:GetSelected()
        self.idSelectedBG:SetVisible(rollover or selected)
        if not self.enabled then
          return
        end
        self.idText:SetRollover(rollover or selected)
        for i, c in ipairs(self) do
          c:OnSetRollover(rollover)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetEnabled(self, enabled)",
      "func",
      function(self, enabled)
        local desat = 255
        local style = "InventoryActionsTextDisabled"
        local trans = 128
        if enabled then
          desat = 0
          style = "InventoryActionsText"
          trans = 0
        end
        self.idText:SetTextStyle(style)
        self.idSelectedBG:SetTransparency(trans)
        XButton.SetEnabled(self, enabled)
        self:OnSetRollover(self.rollover)
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "Translate",
    "default",
    true,
    "Set",
    function(self, value)
      self.idText:SetTranslate(value)
    end,
    "Get",
    function(self)
      return self.idText:GetTranslate()
    end,
    "name",
    T(263940886905, "Translate"),
    "help",
    T(187378468427, "Whether to translate the text")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "Text",
    "editor",
    "text",
    "Set",
    function(self, value)
      self.idText:SetText(value)
    end,
    "Get",
    function(self)
      return self.idText:GetText()
    end,
    "name",
    T(118055494822, "Text"),
    "help",
    T(758649721820, "Button Text")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "Selected",
    "Set",
    function(self, value)
      rawset(self, "selected", value)
      if value then
      else
      end
      self:OnSetRollover(value)
    end,
    "Get",
    function(self)
      return rawget(self, "selected") or false
    end,
    "name",
    T(919280735506, "Selected"),
    "help",
    T(933411012014, "Whether to use the selected style.")
  })
})
