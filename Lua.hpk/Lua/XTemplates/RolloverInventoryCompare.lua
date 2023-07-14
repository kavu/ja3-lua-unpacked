PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu",
  id = "RolloverInventoryCompare",
  PlaceObj("XTemplateWindow", {
    "IdNode",
    true,
    "VAlign",
    "top",
    "MinWidth",
    400,
    "MaxWidth",
    450,
    "ChildrenHandleMouse",
    false
  }, {
    PlaceObj("XTemplateTemplate", {
      "__condition",
      function(parent, context)
        return not UseNewInventoryRollover(ResolvePropObj(context))
      end,
      "__template",
      "RolloverInventoryBase",
      "OnContextUpdate",
      function(self, context, ...)
        local control = context.control
        local title = context.RolloverTitle ~= "" and context.RolloverTitle or control:GetRolloverTitle()
        local slot = control:GetInventorySlotCtrl()
        local name = slot and slot.slot_name or ""
        local item = ResolvePropObj(context)
        if IsEquipSlot(name) then
          local unit = GetInventoryUnit()
          local is_weapon = item:IsWeapon()
          if not is_weapon or unit.current_weapon == name then
            title = T({
              947705095257,
              "<title> <style PDAActivitiesButtonSmall><GameColorK>(Equipped)</GameColorK></style>",
              title = title
            })
          elseif is_weapon and unit.current_weapon ~= name then
            title = T({
              446557690587,
              "<title> <style PDAActivitiesButtonSmall><GameColorK>(Equipped)</GameColorK></style>",
              title = title
            })
          end
        end
        self.idTitle:SetText(title)
        local show = self.idTitle.text ~= ""
        self.idTitle:SetVisible(show)
        if rawget(self, "idText") then
          local description = context.Description ~= "" and context.Description or ""
          self.idText:SetText(description)
        end
        local hint = item:GetRolloverHint()
        self.idItemHint:SetText(hint or "")
      end
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "Open",
        "func",
        function(self, ...)
          return XContextControl.Open(self, ...)
        end
      })
    }),
    PlaceObj("XTemplateTemplate", {
      "__condition",
      function(parent, context)
        return UseNewInventoryRollover(ResolvePropObj(context))
      end,
      "__template",
      "RolloverInventoryWeaponBase",
      "OnContextUpdate",
      function(self, context, ...)
        local control = context.control
        local title = context.RolloverTitle ~= "" and context.RolloverTitle or control:GetRolloverTitle()
        local slot = control:GetInventorySlotCtrl()
        local name = slot and slot.slot_name or ""
        local item = ResolvePropObj(context)
        if IsEquipSlot(name) then
          local unit = GetInventoryUnit()
          local is_weapon = item:IsWeapon()
          if not is_weapon or unit.current_weapon == name then
            title = T({
              465580833787,
              "<title> <style PDAActivitiesButtonSmall><GameColorK>(<equipped>)</GameColorK></style>",
              equipped = name == "Handheld A" and T(850044659556, "Loadout I") or name == "Handheld B" and T(471776201807, "Loadout II") or T(987350124807, "Equipped"),
              title = title
            })
          elseif is_weapon and unit.current_weapon ~= name then
            title = T({
              465580833787,
              "<title> <style PDAActivitiesButtonSmall><GameColorK>(<equipped>)</GameColorK></style>",
              equipped = name == "Handheld A" and T(850044659556, "Loadout I") or name == "Handheld B" and T(471776201807, "Loadout II") or T(987350124807, "Equipped"),
              title = title
            })
          end
        end
        self.idTitle:SetText(title)
        local show = self.idTitle.text ~= ""
        self.idTitle:SetVisible(show)
        if rawget(self, "idText") then
          local description = context.Description ~= "" and context.Description or ""
          self.idText:SetText(description)
        end
        local hint = item:GetRolloverHint()
        self.idItemHint:SetText(hint or "")
      end
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "Open",
        "func",
        function(self, ...)
          return XContextControl.Open(self, ...)
        end
      })
    })
  })
})
