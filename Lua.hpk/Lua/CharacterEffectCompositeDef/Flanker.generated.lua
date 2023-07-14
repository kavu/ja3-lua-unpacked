UndefineClass("Flanker")
DefineClass.Flanker = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "GatherDamageModifications",
      Handler = function(self, attacker, target, attack_args, hit_descr, mod_data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "GatherDamageModifications")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, target, attack_args, hit_descr, mod_data)
          if IsKindOf(target, "Unit") and target:HasStatusEffect("Flanked") then
            local damageBonus = self:ResolveValue("damageBonus")
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
        if IsKindOf(target, "Unit") and target:HasStatusEffect("Flanked") then
          local damageBonus = self:ResolveValue("damageBonus")
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
  DisplayName = T(238393129994, "Flanker"),
  Description = T(644752752416, "Deal <em><percent(damageBonus)></em> more <em>Damage</em> against <GameTerm('Flanked')> enemies."),
  Icon = "UI/Icons/Perks/Flanker",
  Tier = "Bronze",
  Stat = "Agility",
  StatValue = 70
}
