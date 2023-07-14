UndefineClass("SidneyPerk")
DefineClass.SidneyPerk = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReactionEffects", {
      Effects = {
        PlaceObj("ConditionalEffect", {
          "Effects",
          {
            PlaceObj("UnitAddStatusEffect", {
              Status = "SidneyPerkBuff",
              TargetUnit = "current unit",
              param_bindings = false
            })
          }
        })
      },
      Event = "CombatStart",
      Handler = function(self, dynamic_data)
        CE_ExecReactionEffects(self, "CombatStart")
      end,
      param_bindings = false
    })
  },
  DisplayName = T(883237005145, "Smug Operator"),
  Description = T(659602887115, "Gains <GameTerm('Vigorous')> at the start of combat."),
  Icon = "UI/Icons/Perks/SidneyPerk",
  Tier = "Personal"
}
