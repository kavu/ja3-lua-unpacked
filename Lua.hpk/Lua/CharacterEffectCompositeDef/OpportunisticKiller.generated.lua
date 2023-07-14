UndefineClass("OpportunisticKiller")
DefineClass.OpportunisticKiller = {
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
          if attack_args and attack_args.opportunity_attack_type == "Overwatch" then
            attacker:AddStatusEffect("OpportunisticKillerBuff")
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
        if attack_args and attack_args.opportunity_attack_type == "Overwatch" then
          attacker:AddStatusEffect("OpportunisticKillerBuff")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(132879109293, "Opportunistic Killer"),
  Description = T(770924869822, [[
Enables <GameTerm('Crits')> with <GameTerm('Interrupt')> attacks.

<em>Automatic reload</em> if <GameTerm('Overwatch')> was used last turn.]]),
  Icon = "UI/Icons/Perks/OpportunisticKiller",
  Tier = "Bronze",
  Stat = "Dexterity",
  StatValue = 70
}
