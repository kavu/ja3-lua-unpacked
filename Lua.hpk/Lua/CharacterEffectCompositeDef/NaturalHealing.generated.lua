UndefineClass("NaturalHealing")
DefineClass.NaturalHealing = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "NewHour",
      Handler = function(self)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "NewHour")
        if not reaction_idx then
          return
        end
        local exec = function(self)
          local unit = gv_UnitData.Thor
          if unit.HireStatus == "Hired" then
            local tracker = unit:GetStatusEffect("HerbalMedicineProduction")
            if not tracker or Game.CampaignTime >= tracker.CampaignTimeAdded + self:ResolveValue("hoursToProduce") * const.Scale.h then
              local amountToProduce = self:ResolveValue("amountToProduce")
              unit:RemoveStatusEffect("HerbalMedicineProduction")
              unit:AddStatusEffect("HerbalMedicineProduction")
              local item_name = 1 < amountToProduce and g_Classes.HerbalMedicine.DisplayNamePlural or g_Classes.HerbalMedicine.DisplayName
              local canPlaceError = CanPlaceItemInInventory("HerbalMedicine", amountToProduce, unit)
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
              PlaceItemInInventory("HerbalMedicine", amountToProduce, unit)
              CombatLog("important", T({
                318623454402,
                "<merc> produced <amount> <item_name>",
                merc = unit.Nick,
                amount = amountToProduce,
                item_name = item_name
              }))
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
        local unit = gv_UnitData.Thor
        if unit.HireStatus == "Hired" then
          local tracker = unit:GetStatusEffect("HerbalMedicineProduction")
          if not tracker or Game.CampaignTime >= tracker.CampaignTimeAdded + self:ResolveValue("hoursToProduce") * const.Scale.h then
            local amountToProduce = self:ResolveValue("amountToProduce")
            unit:RemoveStatusEffect("HerbalMedicineProduction")
            unit:AddStatusEffect("HerbalMedicineProduction")
            local item_name = 1 < amountToProduce and g_Classes.HerbalMedicine.DisplayNamePlural or g_Classes.HerbalMedicine.DisplayName
            local canPlaceError = CanPlaceItemInInventory("HerbalMedicine", amountToProduce, unit)
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
            PlaceItemInInventory("HerbalMedicine", amountToProduce, unit)
            CombatLog("important", T({
              318623454402,
              "<merc> produced <amount> <item_name>",
              merc = unit.Nick,
              amount = amountToProduce,
              item_name = item_name
            }))
          end
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "StatusEffectAdded",
      Handler = function(self, obj, id, stacks)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectAdded")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks)
          obj:AddStatusEffect("HerbalMedicineProduction")
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        obj:AddStatusEffect("HerbalMedicineProduction")
      end,
      param_bindings = false
    })
  },
  DisplayName = T(328966753815, "Nature's Bounty"),
  Description = T(749196034892, "Produces <amountToProduce> <GameTerm('HerbalMedicine')> every <hoursToProduce> hours."),
  Icon = "UI/Icons/Perks/NaturalHealing",
  Tier = "Personal"
}
