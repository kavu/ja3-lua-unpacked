UndefineClass("Caretaker")
DefineClass.Caretaker = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "OnBandage",
      Handler = function(self, healer, target, healAmount)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "OnBandage")
        if not reaction_idx then
          return
        end
        local exec = function(self, healer, target, healAmount)
          local tempHp = MulDivRound(healer.Medical, self:ResolveValue("medicalPercent"), 100)
          if target.command == "DownedRally" then
            target:AddStatusEffect("GritAfterRally", tempHp)
          else
            target:ApplyTempHitPoints(tempHp)
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(healer, "StatusEffectObject") and healer:HasStatusEffect(id) then
            exec(self, healer, target, healAmount)
          end
        else
          exec(self, healer, target, healAmount)
        end
      end,
      HandlerCode = function(self, healer, target, healAmount)
        local tempHp = MulDivRound(healer.Medical, self:ResolveValue("medicalPercent"), 100)
        if target.command == "DownedRally" then
          target:AddStatusEffect("GritAfterRally", tempHp)
        else
          target:ApplyTempHitPoints(tempHp)
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(416037614632, "Painkiller"),
  Description = T(527875226325, "Grant <em><StatPercent('Medical', medicalPercent)></em> <GameTerm('Grit')> to an ally when using <em>Bandage</em> on them (based on Medical)."),
  Icon = "UI/Icons/Perks/Caretaker",
  Tier = "Gold",
  Stat = "Wisdom",
  StatValue = 90
}
