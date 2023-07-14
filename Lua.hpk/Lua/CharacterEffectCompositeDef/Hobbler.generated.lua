UndefineClass("Hobbler")
DefineClass.Hobbler = {
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
          mod_data.ignore_body_part_damage.Arms = true
          mod_data.ignore_body_part_damage.Legs = true
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
        mod_data.ignore_body_part_damage.Arms = true
        mod_data.ignore_body_part_damage.Legs = true
      end,
      param_bindings = false
    })
  },
  DisplayName = T(314220589449, "Arterial Shot"),
  Description = T(562754701434, "No <em>Damage Penalty</em> for <em>Arms</em> and <em>Legs</em> shots."),
  Icon = "UI/Icons/Perks/Hobbler",
  Tier = "Bronze",
  Stat = "Wisdom",
  StatValue = 70
}
