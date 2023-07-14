UndefineClass("LuckyStreak")
DefineClass.LuckyStreak = {
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
          if results.crit and IsKindOf(target, "Unit") then
            attacker:AddStatusEffect("LuckyStreakBuff")
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
        if results.crit and IsKindOf(target, "Unit") then
          attacker:AddStatusEffect("LuckyStreakBuff")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(838318520600, "Lucky Streak"),
  Description = T(350209296951, "Become <GameTerm('Inspired')> when you make <em><crits_number></em> <GameTerm('Crits')> in the <em>same</em> turn."),
  Icon = "UI/Icons/Perks/LuckyStreak",
  Tier = "Gold",
  Stat = "Agility",
  StatValue = 90
}
