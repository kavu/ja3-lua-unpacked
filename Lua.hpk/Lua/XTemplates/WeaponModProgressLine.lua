PlaceObj("XTemplate", {
  __is_kind_of = "WeaponModProgressLineClass",
  group = "Zulu Weapon Mod",
  id = "WeaponModProgressLine",
  PlaceObj("XTemplateWindow", {
    "__class",
    "WeaponModProgressLineClass",
    "RolloverTemplate",
    "RolloverGeneric",
    "RolloverAnchor",
    "left"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idText",
      "Margins",
      box(0, 0, 10, 0),
      "HAlign",
      "right",
      "Clip",
      false,
      "UseClipBox",
      false,
      "FoldWhenHidden",
      true,
      "TextStyle",
      "PDAQuests_HeaderBig",
      "Translate",
      true,
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateWindow", {
      "Dock",
      "right",
      "MinWidth",
      214,
      "MinHeight",
      17,
      "MaxWidth",
      214,
      "MaxHeight",
      17,
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", nil, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "ZuluFrameProgress",
          "Id",
          "idProgressbar",
          "MinWidth",
          177,
          "MinHeight",
          25,
          "MaxWidth",
          177,
          "MaxHeight",
          25,
          "Image",
          "UI/Inventory/weapon_panel",
          "SqueezeX",
          false,
          "ProgressImage",
          "UI/Inventory/weapon_meter_green",
          "ProgressTileFrame",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "ZuluFrameProgress",
          "Id",
          "idProgressbarBase",
          "MinWidth",
          177,
          "MinHeight",
          25,
          "MaxWidth",
          177,
          "MaxHeight",
          25,
          "BorderColor",
          RGBA(0, 0, 0, 0),
          "Background",
          RGBA(255, 255, 255, 0),
          "FocusedBorderColor",
          RGBA(0, 0, 0, 0),
          "DisabledBorderColor",
          RGBA(0, 0, 0, 0),
          "Image",
          "UI/Inventory/weapon_panel",
          "SqueezeX",
          false,
          "ProgressImage",
          "UI/Inventory/weapon_meter",
          "ProgressTileFrame",
          true
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idPropVal",
        "HAlign",
        "right",
        "MinWidth",
        40,
        "MinHeight",
        17,
        "MaxWidth",
        45,
        "MaxHeight",
        17,
        "HandleMouse",
        false,
        "TextStyle",
        "PDAQuests_HeaderBig",
        "TextHAlign",
        "right",
        "TextVAlign",
        "center"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idDifference",
        "Margins",
        box(5, 0, 0, 0),
        "HAlign",
        "right",
        "MinHeight",
        17,
        "MaxHeight",
        17,
        "HandleMouse",
        false,
        "Translate",
        true,
        "TextHAlign",
        "right",
        "TextVAlign",
        "center"
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CreatePropValText(self, value, scale)",
      "func",
      function(self, value, scale)
        return self.ReverseValue and FormatNumberProp(self:GetMaxProgress() - (value or 0), scale) or FormatNumberProp(value or 0, scale)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self.idText:SetRollover(rollover)
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "Scroll",
    "id",
    "MaxProgress",
    "editor",
    "number",
    "default",
    100,
    "translate",
    false,
    "Set",
    function(self, value)
      self.idProgressbar:SetMaxProgress(value)
      self.idProgressbarBase:SetMaxProgress(value)
    end,
    "Get",
    function(self)
      return self.idProgressbar:GetMaxProgress()
    end,
    "name",
    T(478227754025, "Max Progress")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "Scroll",
    "id",
    "ReverseBar",
    "translate",
    false,
    "Set",
    function(self, value)
      rawset(self, "ReverseBar", value)
    end,
    "Get",
    function(self)
      return rawget(self, "ReverseBar")
    end,
    "name",
    T(892653857090, "Reverse bar")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "Scroll",
    "id",
    "ReverseValue",
    "translate",
    false,
    "Set",
    function(self, value)
      rawset(self, "ReverseValue", value)
    end,
    "Get",
    function(self)
      return rawget(self, "ReverseValue")
    end,
    "name",
    T(744742251053, "Reverse value")
  }),
  PlaceObj("XTemplateProperty", {
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
    T(475973054792, "Text")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "Scroll",
    "id",
    "PercentValue",
    "translate",
    false,
    "Set",
    function(self, value)
      rawset(self, "PercentValue", value)
    end,
    "Get",
    function(self)
      return rawget(self, "PercentValue")
    end,
    "name",
    T(759777441648, "Percent value"),
    "help",
    T(858864842246, "Show percent symbol")
  })
})
