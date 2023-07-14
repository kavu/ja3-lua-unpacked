UndefineClass("OpportunisticKillerBuff")
DefineClass.OpportunisticKillerBuff = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "UnitBeginTurn",
      Handler = function(self, unit)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "UnitBeginTurn")
        if not reaction_idx then
          return
        end
        local exec = function(self, unit)
          local weapon1, weapon2 = unit:GetActiveWeapons()
          if IsKindOf(weapon1, "Firearm") then
            unit:ReloadWeapon(weapon1)
          end
          if IsKindOf(weapon2, "Firearm") then
            unit:ReloadWeapon(weapon2)
          end
          unit:RemoveStatusEffect(self.id)
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(unit, "StatusEffectObject") and unit:HasStatusEffect(id) then
            exec(self, unit)
          end
        else
          exec(self, unit)
        end
      end,
      HandlerCode = function(self, unit)
        local weapon1, weapon2 = unit:GetActiveWeapons()
        if IsKindOf(weapon1, "Firearm") then
          unit:ReloadWeapon(weapon1)
        end
        if IsKindOf(weapon2, "Firearm") then
          unit:ReloadWeapon(weapon2)
        end
        unit:RemoveStatusEffect(self.id)
      end,
      param_bindings = false
    })
  }
}
