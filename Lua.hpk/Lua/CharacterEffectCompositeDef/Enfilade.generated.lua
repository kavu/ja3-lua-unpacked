UndefineClass("Enfilade")
DefineClass.Enfilade = {
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
          if not hit_descr.aoe and attack_args.opportunity_attack_type and IsKindOf(target, "Unit") and target:HasStatusEffect("Flanked") then
            local bonus = self:ResolveValue("damage_bonus")
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
        if not hit_descr.aoe and attack_args.opportunity_attack_type and IsKindOf(target, "Unit") and target:HasStatusEffect("Flanked") then
          local bonus = self:ResolveValue("damage_bonus")
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
  DisplayName = T(152999250650, "Enfilade Fire"),
  Description = T(580006805326, "Deal +<percent(damage_bonus)> bonus damage to Flanked enemies with Interrupt attacks."),
  Icon = "UI/Icons/Perks/Inescapable"
}
