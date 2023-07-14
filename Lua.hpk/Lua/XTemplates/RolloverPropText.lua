PlaceObj("XTemplate", {
  __is_kind_of = "XPropControl",
  group = "Zulu",
  id = "RolloverPropText",
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
            self.idText:SetText(rawget(self, "DisplayText") or prop_def.show_in_inventory and prop_def.short_display_name or prop_def.display_name)
          end
        end
        rawset(self, "bind_id", prop_id)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnPropUpdate(self, context, prop_meta, value)",
      "func",
      function(self, context, prop_meta, value)
        local prop_id = prop_meta.id
        local preset = Presets.WeaponPropertyDef.Default[prop_id]
        local val_base = context[prop_id] or 0
        if prop_meta.modifiable then
          val_base = preset and preset:Getbase_Prop(context, self:GetUnitId()) or context["base_" .. prop_id]
        end
        value = preset and preset:GetProp(context, self:GetUnitId()) or value
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
        local red = GameColors.I
        local green = GameColors.G
        local def = Presets.WeaponPropertyDef.Default
        local text = self:CreatePropValText(value, scale)
        if self:GetPercentValue() then
          text = text .. "%"
        end
        ctrl:SetText(text)
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
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idPropVal",
        "TextStyle",
        "RolloverPropVal",
        "Translate",
        true,
        "TextHAlign",
        "right"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idText",
        "TextStyle",
        "RolloverPropText",
        "Translate",
        true,
        "TextVAlign",
        "bottom"
      })
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
    T(815344385251, "Reverse value")
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
    T(822067705386, "Text")
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
    T(329896981912, "Max Progress")
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
    T(435070720727, "Percent value"),
    "help",
    T(862953060002, "Show percent symbol")
  })
})
