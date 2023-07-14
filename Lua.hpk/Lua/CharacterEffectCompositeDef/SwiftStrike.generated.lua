UndefineClass("SwiftStrike")
DefineClass.SwiftStrike = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "Attack",
      Handler = function(self, action, results, attack_args, combat_starting, attacker, target)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "Attack")
        if not reaction_idx then
          return
        end
        local exec = function(self, action, results, attack_args, combat_starting, attacker, target)
          if action.ActionType == "Melee Attack" and IsKindOf(target, "Unit") then
            if g_Combat then
              attacker:AddStatusEffect("FreeMove")
            elseif combat_starting then
              attacker:AddStatusEffect("FreeMoveOnCombatStart")
            end
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(attacker, "StatusEffectObject") and attacker:HasStatusEffect(id) then
            exec(self, action, results, attack_args, combat_starting, attacker, target)
          end
        else
          exec(self, action, results, attack_args, combat_starting, attacker, target)
        end
      end,
      HandlerCode = function(self, action, results, attack_args, combat_starting, attacker, target)
        if action.ActionType == "Melee Attack" and IsKindOf(target, "Unit") then
          if g_Combat then
            attacker:AddStatusEffect("FreeMove")
          elseif combat_starting then
            attacker:AddStatusEffect("FreeMoveOnCombatStart")
          end
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(441368229605, "Hit and Run"),
  Description = T(931499226151, "Gain <GameTerm('FreeMove')> after making a <em>Melee Attack</em>."),
  Icon = "UI/Icons/Perks/SwiftStrike",
  Tier = "Bronze",
  Stat = "Agility",
  StatValue = 70
}
