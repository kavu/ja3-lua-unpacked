PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu",
  id = "RolloverProgress",
  PlaceObj("XTemplateWindow", {
    "IdNode",
    true,
    "MinWidth",
    218,
    "MinHeight",
    25,
    "MaxWidth",
    218,
    "MaxHeight",
    25,
    "LayoutMethod",
    "HList"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Init",
      "func",
      function(self, ...)
        self.ReverseBar = false
        self.ReverseValue = false
      end
    }),
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
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "OnPropUpdate(self, context, prop_meta, value)",
          "func",
          function(self, context, prop_meta, value)
            local prop_id = prop_meta.id
            local preset = Presets.WeaponPropertyDef.Default[prop_id]
            local val_base = context[prop_id] or 0
            if prop_meta.modifiable then
              val_base = preset and preset:Getbase_Prop(context, context.owner) or context["base_" .. prop_id]
              value = preset and preset:GetProp(context, context.owner) or value
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
            local red = GameColors.I
            local green = GameColors.G
            local reverse = self.parent.parent:GetReverseBar()
            local text = self.parent.parent:CreatePropValText(value, scale)
            if self.parent.parent:GetPercentValue() then
              text = text .. "%"
            end
            if rawget(context, "other") then
              local def = Presets.WeaponPropertyDef.Default
              local is_AP = prop_id == "AttackAP" or prop_id == "ShootAP"
              for i, other in ipairs(context.other) do
                local prop_def = def[prop_meta.id]
                local valid = prop_def and prop_def:DisplayForContext(other)
                if not valid then
                  if prop_id == "Damage" then
                    prop_def = def.BaseDamage
                    valid = prop_def and prop_def:DisplayForContext(other)
                  elseif prop_id == "BaseDamage" then
                    prop_def = def.Damage
                    valid = prop_def and prop_def:DisplayForContext(other)
                  elseif prop_id == "AttackAP" then
                    prop_def = def.ShootAP
                    valid = prop_def and prop_def:DisplayForContext(other)
                  elseif prop_id == "ShootAP" then
                    prop_def = def.AttackAP
                    valid = prop_def and prop_def:DisplayForContext(other)
                  end
                end
                if valid then
                  local ovalue = other[prop_def.id]
                  if not is_AP and value > ovalue or (reverse or is_AP) and value < ovalue then
                    ctrl:SetTextColor(green)
                  elseif not is_AP and value < ovalue or (reverse or is_AP) and value > ovalue then
                    ctrl:SetTextColor(red)
                  end
                end
              end
            end
            ctrl:SetText(text)
            value = Clamp(value or 0, 0, self.MaxProgress)
            val_base = Clamp(val_base or 0, 0, self.MaxProgress)
            if reverse then
              value = self.MaxProgress - value
              val_base = self.MaxProgress - val_base
            end
            local progress = self
            local progress_base = self:ResolveId("idProgressbarBase")
            progress_base:SetVisible(value ~= val_base)
            progress_base:SetVisible(true)
            if value == val_base then
              progress:SetProgress(value)
              progress_base:SetProgress(value)
              progress_base:SetProgressImage("UI/Inventory/weapon_meter.tga")
              progress:SetProgressImage("UI/Inventory/weapon_meter.tga")
            elseif value < val_base then
              ctrl:SetTextColor(red)
              progress:SetProgress(val_base)
              progress_base:SetProgress(value)
              progress:SetProgressImage(reverse and "UI/Inventory/weapon_meter_green.tga" or "UI/Inventory/weapon_meter_red.tga")
              progress_base:SetProgressImage("UI/Inventory/weapon_meter.tga")
            elseif value > val_base then
              ctrl:SetTextColor(green)
              progress:SetProgress(value)
              progress_base:SetProgress(val_base)
              progress:SetProgressImage(reverse and "UI/Inventory/weapon_meter_red.tga" or "UI/Inventory/weapon_meter_green.tga")
              progress_base:SetProgressImage("UI/Inventory/weapon_meter.tga")
            end
            self:Invalidate()
            UIL.Invalidate()
          end
        })
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
        "UI/Inventory/weapon_meter_green",
        "ProgressTileFrame",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "MinWidth",
      60,
      "MinHeight",
      25,
      "MaxWidth",
      60,
      "MaxHeight",
      25
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idPropVal",
        "Margins",
        box(8, 4, 10, 0),
        "HAlign",
        "right",
        "MinWidth",
        50,
        "MinHeight",
        25,
        "MaxWidth",
        50,
        "MaxHeight",
        25,
        "HandleMouse",
        false,
        "TextStyle",
        "InventoryRolloverProp",
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
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "Scroll",
    "id",
    "BindTo",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.idProgressbar:SetBindTo(value)
    end,
    "Get",
    function(self)
      return self.idProgressbar:GetBindTo()
    end,
    "name",
    T(967057854915, "Bind to property")
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
    T(869527236278, "Max Progress")
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
    T(740431210175, "Reverse bar")
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
    T(728661799108, "Reverse value")
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
    T(652457737259, "Percent value"),
    "help",
    T(556657353027, "Show percent symbol")
  })
})
