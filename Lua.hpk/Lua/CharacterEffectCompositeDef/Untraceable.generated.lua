UndefineClass("Untraceable")
DefineClass.Untraceable = {
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
          if attack_args.stealth_attack then
            local bonus = self:ResolveValue("stealth_damage")
            mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + bonus, 100)
            mod_data.breakdown[#mod_data.breakdown + 1] = {
              name = self.DisplayName,
              value = bonus
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
        if attack_args.stealth_attack then
          local bonus = self:ResolveValue("stealth_damage")
          mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + bonus, 100)
          mod_data.breakdown[#mod_data.breakdown + 1] = {
            name = self.DisplayName,
            value = bonus
          }
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(945408716551, "Untraceable"),
  Description = T(788630661787, [[
<em>Slower</em> enemy <em>detection</em> while <GameTerm('Sneaking')>.

Failed <GameTerm('StealthKills')> deal <em><percent(stealth_damage)></em> more <em>Damage</em>.
]]),
  Icon = "UI/Icons/Perks/Untraceable",
  Tier = "Bronze",
  Stat = "Dexterity",
  StatValue = 70
}
