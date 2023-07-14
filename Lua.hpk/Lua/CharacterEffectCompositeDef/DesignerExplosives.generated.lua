UndefineClass("DesignerExplosives")
DefineClass.DesignerExplosives = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "StatusEffectAdded",
      Handler = function(self, obj, id, stacks)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectAdded")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks)
          local effect = obj:GetStatusEffect("DesignerExplosives")
          effect:SetParameter("nextProductionTime", Game.CampaignTime + effect:ResolveValue("hoursToProduce") * const.Scale.h)
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        local effect = obj:GetStatusEffect("DesignerExplosives")
        effect:SetParameter("nextProductionTime", Game.CampaignTime + effect:ResolveValue("hoursToProduce") * const.Scale.h)
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "NewHour",
      Handler = function(self)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "NewHour")
        if not reaction_idx then
          return
        end
        local exec = function(self)
          local unit = gv_UnitData.Barry
          unit = unit.HireStatus == "Hired" and unit
          if unit then
            local effect = unit:GetStatusEffect("DesignerExplosives")
            local next_production = effect:ResolveValue("nextProductionTime")
            if next_production <= Game.CampaignTime then
              local amountToProduce = DesignerExplosives:ResolveValue("amountToProduce")
              effect:SetParameter("nextProductionTime", Game.CampaignTime + effect:ResolveValue("hoursToProduce") * const.Scale.h)
              local canPlaceError = CanPlaceItemInInventory("ShapedCharge", amountToProduce, unit)
              local item_name = 1 < amountToProduce and g_Classes.ShapedCharge.DisplayNamePlural or g_Classes.ShapedCharge.DisplayName
              if canPlaceError then
                CombatLog("important", T({
                  899101854825,
                  "<merc> produced <amount> <item_name> but inventory is full.",
                  merc = unit.Nick,
                  amount = amountToProduce,
                  item_name = item_name
                }))
                return
              end
              PlaceItemInInventory("ShapedCharge", amountToProduce, unit)
              CombatLog("important", T({
                318623454402,
                "<merc> produced <amount> <item_name>",
                merc = unit.Nick,
                amount = amountToProduce,
                item_name = item_name
              }))
              if IsKindOf(unit, "Unit") then
                local unit_data = gv_UnitData[unit.session_id]
                CopyPropertiesShallow(unit_data, unit, StatusEffectObject:GetProperties(), "copy_values")
                ObjModified(unit_data)
              end
            end
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          local objs = {}
          for session_id, data in pairs(gv_UnitData) do
            local obj = g_Units[session_id] or data
            if obj:HasStatusEffect(id) then
              objs[session_id] = obj
            end
          end
          for _, obj in sorted_pairs(objs) do
            exec(self)
          end
        else
          exec(self)
        end
      end,
      HandlerCode = function(self)
        local unit = gv_UnitData.Barry
        unit = unit.HireStatus == "Hired" and unit
        if unit then
          local effect = unit:GetStatusEffect("DesignerExplosives")
          local next_production = effect:ResolveValue("nextProductionTime")
          if next_production <= Game.CampaignTime then
            local amountToProduce = DesignerExplosives:ResolveValue("amountToProduce")
            effect:SetParameter("nextProductionTime", Game.CampaignTime + effect:ResolveValue("hoursToProduce") * const.Scale.h)
            local canPlaceError = CanPlaceItemInInventory("ShapedCharge", amountToProduce, unit)
            local item_name = 1 < amountToProduce and g_Classes.ShapedCharge.DisplayNamePlural or g_Classes.ShapedCharge.DisplayName
            if canPlaceError then
              CombatLog("important", T({
                899101854825,
                "<merc> produced <amount> <item_name> but inventory is full.",
                merc = unit.Nick,
                amount = amountToProduce,
                item_name = item_name
              }))
              return
            end
            PlaceItemInInventory("ShapedCharge", amountToProduce, unit)
            CombatLog("important", T({
              318623454402,
              "<merc> produced <amount> <item_name>",
              merc = unit.Nick,
              amount = amountToProduce,
              item_name = item_name
            }))
            if IsKindOf(unit, "Unit") then
              local unit_data = gv_UnitData[unit.session_id]
              CopyPropertiesShallow(unit_data, unit, StatusEffectObject:GetProperties(), "copy_values")
              ObjModified(unit_data)
            end
          end
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(715337616257, "Boutique Explosives"),
  Description = T(405122724505, "Produces <amountToProduce> <GameTerm('ShapedCharge')> every <hoursToProduce> hours. Can craft Shaped Charges with the Craft Explosives operation in Sat View. "),
  Icon = "UI/Icons/Perks/DesignerExplosives",
  Tier = "Personal"
}
