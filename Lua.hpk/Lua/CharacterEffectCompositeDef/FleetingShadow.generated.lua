UndefineClass("FleetingShadow")
DefineClass.FleetingShadow = {
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
          if results and results.stealth_kill and IsKindOf(target, "Unit") then
            local grit = self:ResolveValue("gritOnStealthKill")
            attacker:ApplyTempHitPoints(grit)
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
        if results and results.stealth_kill and IsKindOf(target, "Unit") then
          local grit = self:ResolveValue("gritOnStealthKill")
          attacker:ApplyTempHitPoints(grit)
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(968034759216, "Fleeting Shadow"),
  Description = T(515755043627, [[
Can <em>Sneak</em> while standing.

Gains <em><gritOnStealthKill></em> <GameTerm('Grit')> on successful <GameTerm('StealthKills')>.]]),
  Icon = "UI/Icons/Perks/FleetingShadow",
  Tier = "Personal"
}
