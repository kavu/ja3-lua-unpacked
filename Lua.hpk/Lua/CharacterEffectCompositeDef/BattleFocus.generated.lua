UndefineClass("BattleFocus")
DefineClass.BattleFocus = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "DamageTaken",
      Handler = function(self, attacker, target, dmg, hit_descr)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "DamageTaken")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, target, dmg, hit_descr)
          target:AddStatusEffect("BattleFocusBuff")
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(target, "StatusEffectObject") and target:HasStatusEffect(id) then
            exec(self, attacker, target, dmg, hit_descr)
          end
        else
          exec(self, attacker, target, dmg, hit_descr)
        end
      end,
      HandlerCode = function(self, attacker, target, dmg, hit_descr)
        target:AddStatusEffect("BattleFocusBuff")
      end,
      param_bindings = false
    })
  },
  DisplayName = T(822626767198, "Battle Focus"),
  Description = T(235322784555, [[
Gain <em><battleFocusAP></em> <em>AP</em> when <em>hit</em> by an enemy for the <em>first</em> time.

Ends at the end of combat.]]),
  Icon = "UI/Icons/Perks/BattleFocus",
  Tier = "Gold",
  Stat = "Health",
  StatValue = 90
}
