UndefineClass("BreachAndClear")
DefineClass.BreachAndClear = {
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
          if IsKindOfClasses(results.weapon, "Grenade", "Shotgun") then
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
      HandlerCode = function(self, attacker, action, target, results, attack_args)
        if IsKindOfClasses(results.weapon, "Grenade", "Shotgun") then
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
  DisplayName = T(609540599823, "Breach and Clear"),
  Description = T(853841959476, "Gain <GameTerm('FreeMove')> after throwing <em>Grenades</em> or making <em>Shotgun</em> attacks."),
  Icon = "UI/Icons/Perks/BreachAndClear",
  Tier = "Bronze",
  Stat = "Strength",
  StatValue = 70
}
