UndefineClass("LeadFromTheFront")
DefineClass.LeadFromTheFront = {
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
          if IsKindOf(target, "Unit") and results.total_damage and results.total_damage >= self:ResolveValue("damageTreshold") and attacker.team:IsPlayerControlled() and not attacker:HasStatusEffect("LeadFromTheFrontFlag") then
            attacker.team:ChangeMorale(self:ResolveValue("moraleBonus"), self.DisplayName)
            attacker:AddStatusEffect("LeadFromTheFrontFlag")
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
        if IsKindOf(target, "Unit") and results.total_damage and results.total_damage >= self:ResolveValue("damageTreshold") and attacker.team:IsPlayerControlled() and not attacker:HasStatusEffect("LeadFromTheFrontFlag") then
          attacker.team:ChangeMorale(self:ResolveValue("moraleBonus"), self.DisplayName)
          attacker:AddStatusEffect("LeadFromTheFrontFlag")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(589057792592, "Inspiring Strike"),
  Description = T(142399887488, [[
Increase <GameTerm('Morale')> when you deal more than <em><damageTreshold> Damage</em> with a <em>single attack</em>.

Once per turn.]]),
  Icon = "UI/Icons/Perks/SquadLeadership",
  Tier = "Silver",
  Stat = "Wisdom",
  StatValue = 80
}
