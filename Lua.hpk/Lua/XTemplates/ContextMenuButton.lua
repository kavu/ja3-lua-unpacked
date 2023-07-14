PlaceObj("XTemplate", {
  __is_kind_of = "XTextButton",
  group = "Zulu ContextMenu",
  id = "ContextMenuButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XTextButton",
    "Padding",
    box(14, 0, 10, 0),
    "LayoutHSpacing",
    0,
    "UseClipBox",
    false,
    "FoldWhenHidden",
    true,
    "Background",
    RGBA(255, 255, 255, 0),
    "BackgroundRectGlowColor",
    RGBA(255, 255, 255, 0),
    "FXMouseIn",
    "buttonRollover",
    "FXPress",
    "buttonPress",
    "FXPressDisabled",
    "IactDisabled",
    "FocusedBackground",
    RGBA(215, 159, 80, 255),
    "RolloverBackground",
    RGBA(215, 159, 80, 255),
    "PressedBackground",
    RGBA(215, 159, 80, 255),
    "TextStyle",
    "SatelliteContextMenuText",
    "Translate",
    true,
    "UseXTextControl",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idBinding",
      "ZOrder",
      0,
      "Padding",
      box(2, 2, -2, 2),
      "TextStyle",
      "SatelliteContextMenuKeybind",
      "Translate",
      true
    }),
    PlaceObj("XTemplateFunc", {
      "comment",
      "since this is not a class it cannot be overriden propertly",
      "name",
      "base_OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        XTextButton.OnSetRollover(self, rollover)
        for i, c in ipairs(self) do
          c:OnSetRollover(rollover)
        end
        self.idBinding:SetTextStyle(rollover and "SatelliteContextMenuKeybindRollover" or "SatelliteContextMenuKeybind")
        self:SetTextStyle(rollover and self.enabled and "SatelliteContextMenuTextRollover" or "SatelliteContextMenuText")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self:base_OnSetRollover(rollover)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        self:SetFocus(selected)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "IsSelectable(self)",
      "func",
      function(self)
        return self:GetEnabled()
      end
    })
  })
})
