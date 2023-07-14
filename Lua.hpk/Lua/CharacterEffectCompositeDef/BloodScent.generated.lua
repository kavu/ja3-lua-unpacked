UndefineClass("BloodScent")
DefineClass.BloodScent = {
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
          if not results.miss and IsKindOf(target, "Unit") then
            target:AddStatusEffect("Marked")
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
        if not results.miss and IsKindOf(target, "Unit") then
          target:AddStatusEffect("Marked")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(738259813299, "True Strike"),
  Description = T(868553471362, [[
Successful <em>Melee Attacks</em> are <GameTerm('Crits')> and apply <GameTerm('Marked')> to the target.

]]),
  Icon = "UI/Icons/Perks/BloodScent",
  Tier = "Gold",
  Stat = "Strength",
  StatValue = 90
}
