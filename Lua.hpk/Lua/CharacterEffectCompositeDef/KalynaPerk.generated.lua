UndefineClass("KalynaPerk")
DefineClass.KalynaPerk = {
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
          if mod_data.action_id == "KalynaPerk" then
            mod_data.ignore_armor = true
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
        if mod_data.action_id == "KalynaPerk" then
          mod_data.ignore_armor = true
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(562658628936, "Inevitable Strike"),
  Description = T(289604646108, [[
<em>Ranged attack</em> that bypasses damage reduction from <em>Armor</em>.

Can't be used with Shotguns.]]),
  Icon = "UI/Icons/Perks/KalynaPerk",
  Tier = "Personal"
}
