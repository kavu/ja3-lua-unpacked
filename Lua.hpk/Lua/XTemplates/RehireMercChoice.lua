PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "RehireMercChoice",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "Background",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "RolloverBackground",
    RGBA(0, 0, 0, 0),
    "PressedBackground",
    RGBA(0, 0, 0, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Id",
      "idImage",
      "Margins",
      box(-15, 0, 0, 0),
      "VAlign",
      "center",
      "MinWidth",
      500,
      "MinHeight",
      45,
      "MaxHeight",
      45,
      "Visible",
      false,
      "HandleMouse",
      true,
      "Image",
      "UI/Common/rollover_row",
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idContainer"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idText",
        "HAlign",
        "left",
        "VAlign",
        "center",
        "Clip",
        false,
        "UseClipBox",
        false,
        "TextStyle",
        "PopupNotificationChoice",
        "Translate",
        true,
        "TextVAlign",
        "center"
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetRollover(self, rollover)",
      "func",
      function(self, rollover)
        if not self:GetEnabled() then
          return
        end
        self.idImage:SetVisible(rollover)
        XText.SetRollover(self.idText, rollover)
        XButton.SetRollover(self, rollover)
      end
    })
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
    end
  })
})
