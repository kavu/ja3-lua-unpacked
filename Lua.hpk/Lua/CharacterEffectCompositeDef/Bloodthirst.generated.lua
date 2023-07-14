UndefineClass("Bloodthirst")
DefineClass.Bloodthirst = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "GatherDamageModifications",
      Handler = function(self, attacker, target, attack_args, hit_descr, mod_data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "GatherDamageModifications")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, target, attack_args, hit_descr, mod_data)
          local damageBonus = self:ResolveValue("damageMod")
          mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + damageBonus, 100)
          mod_data.breakdown[#mod_data.breakdown + 1] = {
            name = self.DisplayName,
            value = damageBonus
          }
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
        local damageBonus = self:ResolveValue("damageMod")
        mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + damageBonus, 100)
        mod_data.breakdown[#mod_data.breakdown + 1] = {
          name = self.DisplayName,
          value = damageBonus
        }
      end,
      param_bindings = false
    })
  },
  DisplayName = T(664271538492, "Bloodthirst"),
  Description = T(616307363329, "Deal <em><percent(damageMod)> more Damage</em> until the end of the battle."),
  Icon = "UI/Hud/Status effects/bloodthirst",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
