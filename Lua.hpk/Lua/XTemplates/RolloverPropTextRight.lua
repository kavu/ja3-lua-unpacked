PlaceObj("XTemplate", {
  __is_kind_of = "XPropControl",
  group = "Zulu",
  id = "RolloverPropTextRight",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPropControl"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "SetBindTo(self, prop, prop_id)",
      "func",
      function(self, prop, prop_id)
        XPropControl.SetBindTo(self, prop)
        local def = Presets.WeaponPropertyDef.Default
        if def then
          local prop_def = def[prop_id or prop]
          if prop_def then
            self.idPropVal:SetNameText(rawget(self, "DisplayText") or prop_def.show_in_inventory and prop_def.short_display_name or prop_def.display_name)
          end
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnPropUpdate(self, context, prop_meta, value)",
      "func",
      function(self, context, prop_meta, value)
        if not prop_meta then
          return
        end
        local prop_id = prop_meta.id
        local preset = Presets.WeaponPropertyDef.Default[prop_id]
        local val_base = context[prop_id] or 0
        if prop_meta.modifiable then
          val_base = preset and preset:Getbase_Prop(context, self:GetUnitId()) or context["base_" .. prop_id]
          value = preset and preset:GetProp(context, self:GetUnitId()) or value
        end
        local obj = ResolvePropObj(context)
        if IsKindOf(obj, "HeavyWeapon") and prop_meta.id == "Damage" then
          value = obj:GetBaseDamage()
          val_base = obj:GetBaseDamage()
        end
        local scale = prop_meta.scale
        if type(scale) == "string" then
          scale = const.Scale[scale]
        end
        scale = scale or 1
        local ctrl = self:ResolveId("idPropVal")
        local text = self:CreatePropValText(value, scale)
        if self:GetPercentValue() then
          text = text .. "%"
        end
        ctrl:SetValueText(text)
        self:Invalidate()
        UIL.Invalidate()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetUnitId(self)",
      "func",
      function(self)
        local unit = GetInventoryUnit() or SelectedObj
        if unit then
          return unit.session_id
        end
        return self:GetContext().owner
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CreatePropValText(self, value, scale)",
      "func",
      function(self, value, scale)
        return Untranslated(self:GetReverseValue() and FormatNumberProp(self:GetMaxProgress() - (value or 0), scale) or FormatNumberProp(value or 0, scale))
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XNameValueText",
      "Id",
      "idPropVal",
      "TextStyle",
      "PDABrowserFlavorMedium",
      "TextStyleRight",
      "PDABrowserTextHighlight"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self,...)",
      "func",
      function(self, ...)
        self.idPropVal:SetTextStyle("PDABrowserFlavorMedium")
        self.idPropVal:SetTextStyleRight("PDABrowserTextHighlight")
        XPropControl.Open(self, ...)
      end
    })
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
    T(177816837351, "Reverse value")
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "Text",
    "editor",
    "text",
    "Set",
    function(self, value)
      rawset(self, "DisplayText", value)
    end,
    "Get",
    function(self)
      rawget(self, "DisplayText")
    end,
    "name",
    T(408976862738, "Text")
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
      rawset(self, "MaxProgress", value)
    end,
    "Get",
    function(self)
      return rawget(self, "MaxProgress")
    end,
    "name",
    T(867981954422, "Max Progress")
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
    T(150385534483, "Percent value"),
    "help",
    T(631923950366, "Show percent symbol")
  })
})
