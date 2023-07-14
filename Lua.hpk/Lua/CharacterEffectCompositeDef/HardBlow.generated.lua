UndefineClass("HardBlow")
DefineClass.HardBlow = {
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
          local action = CombatActions[mod_data.action_id or false]
          if action and action.ActionType == "Melee Attack" then
            mod_data.effects[#mod_data.effects + 1] = "CancelShot"
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
        local action = CombatActions[mod_data.action_id or false]
        if action and action.ActionType == "Melee Attack" then
          mod_data.effects[#mod_data.effects + 1] = "CancelShot"
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(373820313755, "Sudden Strike"),
  Description = T(854979683764, [[
Does not trigger <GameTerm('Interrupt')> attacks while making <em>Melee Attacks</em>.

Cancel <GameTerm('Overwatch')> and <GameTerm('PinDown')> with successful <em>Melee Attacks</em>.
]]),
  Icon = "UI/Icons/Perks/HardBlow",
  Tier = "Silver",
  Stat = "Strength",
  StatValue = 80
}
