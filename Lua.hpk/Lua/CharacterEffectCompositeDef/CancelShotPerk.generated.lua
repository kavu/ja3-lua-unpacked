UndefineClass("CancelShotPerk")
DefineClass.CancelShotPerk = {
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
          if action.id == "CancelShotCone" and IsKindOf(target, "Unit") then
            target:AddStatusEffect("CancelShot")
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
        if action.id == "CancelShotCone" and IsKindOf(target, "Unit") then
          target:AddStatusEffect("CancelShot")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(775794001413, "Distracting Shot"),
  Description = T(658775460639, [[
Firearm attack - <em>Distracting Shot</em>:

Removes <GameTerm('Overwatch')> and <GameTerm('PinDown')>. Doesn't provoke <GameTerm('Interrupt')> attacks.]]),
  Icon = "UI/Icons/Perks/CancelShotPerk",
  Tier = "Bronze",
  Stat = "Wisdom",
  StatValue = 70
}
