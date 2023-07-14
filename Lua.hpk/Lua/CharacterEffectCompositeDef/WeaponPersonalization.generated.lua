UndefineClass("WeaponPersonalization")
DefineClass.WeaponPersonalization = {
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
          local unit = gv_UnitData.Vicki
          unit = unit.HireStatus == "Hired" and unit
          if unit then
            local conditionPerHour = self:ResolveValue("conditionPerHour")
            local armor = unit:GetEquipedArmour()
            for _, item in ipairs(armor) do
              if item.Repairable and item.Condition < 100 then
                item.Condition = item.Condition + conditionPerHour
              end
            end
            local weapons = unit:GetHandheldItems()
            for _, item in ipairs(weapons) do
              if item.Repairable and item.Condition < 100 then
                item.Condition = item.Condition + conditionPerHour
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
        local unit = gv_UnitData.Vicki
        unit = unit.HireStatus == "Hired" and unit
        if unit then
          local conditionPerHour = self:ResolveValue("conditionPerHour")
          local armor = unit:GetEquipedArmour()
          for _, item in ipairs(armor) do
            if item.Repairable and item.Condition < 100 then
              item.Condition = item.Condition + conditionPerHour
            end
          end
          local weapons = unit:GetHandheldItems()
          for _, item in ipairs(weapons) do
            if item.Repairable and item.Condition < 100 then
              item.Condition = item.Condition + conditionPerHour
            end
          end
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(662107107735, "Elbow Grease"),
  Description = T(512899017840, [[
Repairs equipped <em>Weapons</em>, <em>Armor</em>, and <em>Items</em> automatically over time.

Deals +<baseDamageBonus> <em>Damage</em> and has +<percent(critChanceBonus)> <GameTerm('Crit')> <em>Chance</em> with fully-modified <em>Firearms</em>.
]]),
  Icon = "UI/Icons/Perks/WeaponPersonalization",
  Tier = "Personal"
}
