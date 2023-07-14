PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu",
  id = "RolloverProgressLine",
  PlaceObj("XTemplateWindow", {
    "RolloverTemplate",
    "RolloverGeneric",
    "RolloverAnchor",
    "left",
    "RolloverOffset",
    box(0, 0, -50, 0),
    "IdNode",
    true,
    "MinWidth",
    400,
    "MinHeight",
    25,
    "MaxWidth",
    400,
    "MaxHeight",
    25,
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idText",
      "TextStyle",
      "InventoryRolloverProp",
      "Translate",
      true,
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "RolloverProgress",
      "Id",
      "idProgressbar",
      "Dock",
      "right",
      "HandleMouse",
      true
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "SetRollover(self, rollover)",
        "func",
        function(self, rollover)
          return self.parent and self.parent:OnSetRollover(rollover)
        end
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "ChangeColorState(self,  changed_props)",
      "func",
      function(self, changed_props)
        local state
        if not changed_props then
          state = "base"
        end
        if state == "base" then
          self.idText:SetTextStyle("RolloverTextLightGray")
          self.idProgressbar.idPropVal:SetTextStyle("RolloverTextLightGray")
          self.idProgressbar.idProgressbar:SetTransparency(60)
          return
        end
        if changed_props then
          state = changed_props[self.idProgressbar.idProgressbar.BindTo] and "active" or "inactive"
        end
        if state == "active" then
          self.idText:SetTextStyle("InventoryRolloverProp")
          self.idProgressbar.idPropVal:SetTextStyle("InventoryRolloverProp")
          self.idProgressbar.idProgressbar:SetTransparency(0)
        elseif state == "inactive" then
          self.idText:SetTextStyle("RolloverTextDarkGray")
          self.idProgressbar.idPropVal:SetTextStyle("InventoryRolloverProp")
          self.idProgressbar.idProgressbar:SetTransparency(155)
        end
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
    "id",
    "BindTo",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.idProgressbar:SetBindTo(value)
      local def = Presets.WeaponPropertyDef.Default
      if def then
        local prop_def = def[value]
        if prop_def then
          self.idText:SetText(prop_def.display_name)
          self:SetRolloverTitle(prop_def.display_name)
          self:SetRolloverText(prop_def.description)
        end
      end
    end,
    "Get",
    function(self)
      return self.idProgressbar:GetBindTo()
    end,
    "name",
    T(247685009197, "Bind to property")
  }),
  PlaceObj("XTemplateProperty", {
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
    end,
    "Get",
    function(self)
      return self.idProgressbar:GetMaxProgress()
    end,
    "name",
    T(907882520381, "Max Progress")
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "ReverseBar",
    "translate",
    false,
    "Set",
    function(self, value)
      self.idProgressbar:SetReverseBar(value)
    end,
    "Get",
    function(self)
      return self.idProgressbar:GetReverseBar()
    end,
    "name",
    T(663664214752, "Reverse bar")
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "ReverseValue",
    "translate",
    false,
    "Set",
    function(self, value)
      self.idProgressbar:SetReverseValue(value)
    end,
    "Get",
    function(self)
      return self.idProgressbar:GetReverseValue()
    end,
    "name",
    T(698169979310, "Reverse value")
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "PercentValue",
    "translate",
    false,
    "Set",
    function(self, value)
      self.idProgressbar:SetPercentValue(value)
    end,
    "Get",
    function(self)
      return self.idProgressbar:GetPercentValue()
    end,
    "name",
    T(497483875643, "Percent value"),
    "help",
    T(746558075214, "Show percent symbol")
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "Centered",
    "translate",
    false,
    "Set",
    function(self, value)
      self.idText:SetHAlign(value and "right" or "stretched")
      if value then
        self.idText.Margins = box(0, 0, 10, 0)
        self.MaxWidth = 1000
      end
    end,
    "Get",
    function(self)
      return self.idText:GetHAlign() == "right"
    end,
    "name",
    T(935834731350, "Centered")
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
    T(913518042563, "Text")
  })
})
