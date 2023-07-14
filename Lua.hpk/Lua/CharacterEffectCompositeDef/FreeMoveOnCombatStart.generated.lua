UndefineClass("FreeMoveOnCombatStart")
DefineClass.FreeMoveOnCombatStart = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  Conditions = {
    PlaceObj("CheckExpression", {
      Expression = function(self, obj)
        return obj.Tiredness <= 0
      end,
      param_bindings = false
    })
  },
  lifetime = "Until End of Turn",
  RemoveOnEndCombat = true,
  RemoveOnCampaignTimeAdvance = true
}
