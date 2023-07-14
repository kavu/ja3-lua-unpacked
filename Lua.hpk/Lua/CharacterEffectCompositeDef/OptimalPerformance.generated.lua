UndefineClass("OptimalPerformance")
DefineClass.OptimalPerformance = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "OnAttack",
      Handler = function(self, attacker, action, target, results, attack_args)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "OnAttack")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, action, target, results, attack_args)
          if results.weapon and IsKindOf(results.weapon, "MeleeWeapon") and action.ActionType == "Melee Attack" and not results.miss and IsKindOf(target, "Unit") then
            attacker:ApplyTempHitPoints(self:ResolveValue("temp_HP_on_melee"))
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(attacker, "StatusEffectObject") and attacker:HasStatusEffect(id) then
            exec(self, attacker, action, target, results, attack_args)
          end
        else
          exec(self, attacker, action, target, results, attack_args)
        end
      end,
      HandlerCode = function(self, attacker, action, target, results, attack_args)
        if results.weapon and IsKindOf(results.weapon, "MeleeWeapon") and action.ActionType == "Melee Attack" and not results.miss and IsKindOf(target, "Unit") then
          attacker:ApplyTempHitPoints(self:ResolveValue("temp_HP_on_melee"))
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(935000833692, "Full Body Contact"),
  Description = T(946942648822, "Gain <em><temp_HP_on_melee></em> <GameTerm('Grit')> on a successful <em>Melee Attack</em>."),
  Icon = "UI/Icons/Perks/OptimalPerformance",
  Tier = "Bronze",
  Stat = "Health",
  StatValue = 70
}
