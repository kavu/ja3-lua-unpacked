UndefineClass("Instagib")
DefineClass.Instagib = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "UnitBeginTurn",
      Handler = function(self, unit)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "UnitBeginTurn")
        if not reaction_idx then
          return
        end
        local exec = function(self, unit)
          unit:AddStatusEffect("InstagibBuff")
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
        unit:AddStatusEffect("InstagibBuff")
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "GatherDamageModifications",
      Handler = function(self, attacker, target, attack_args, hit_descr, mod_data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "GatherDamageModifications")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, target, attack_args, hit_descr, mod_data)
          if attacker:HasStatusEffect("InstagibBuff") then
            local damageBonus = MulDivRound(attacker.Marksmanship, self:ResolveValue("marksmanshipPercent"), 100)
            mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + damageBonus, 100)
            mod_data.breakdown[#mod_data.breakdown + 1] = {
              name = self.DisplayName,
              value = damageBonus
            }
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(attacker, "StatusEffectObject") and attacker:HasStatusEffect(id) then
            exec(self, attacker, target, attack_args, hit_descr, mod_data)
          end
        else
          exec(self, attacker, target, attack_args, hit_descr, mod_data)
        end
      end,
      HandlerCode = function(self, attacker, target, attack_args, hit_descr, mod_data)
        if attacker:HasStatusEffect("InstagibBuff") then
          local damageBonus = MulDivRound(attacker.Marksmanship, self:ResolveValue("marksmanshipPercent"), 100)
          mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + damageBonus, 100)
          mod_data.breakdown[#mod_data.breakdown + 1] = {
            name = self.DisplayName,
            value = damageBonus
          }
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(910328508493, "Sharpshooter"),
  Description = T(557528356408, [[
Gain <em><bonusAims></em> possible <GameTerm('Aims')> with your <em>first attack</em> each turn.

Deal <em><percent(StatPercent('Marksmanship', marksmanshipPercent))> extra </em> Damage with your <em>first attack</em> each turn (based on Marksmanship).]]),
  Icon = "UI/Icons/Perks/Instagib",
  Tier = "Gold",
  Stat = "Dexterity",
  StatValue = 90
}
