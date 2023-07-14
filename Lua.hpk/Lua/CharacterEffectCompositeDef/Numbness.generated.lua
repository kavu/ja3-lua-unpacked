UndefineClass("Numbness")
DefineClass.Numbness = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  DisplayName = T(772658121682, "Numbness"),
  Description = T(829182751378, "Can perform only <em>Basic attacks</em>"),
  AddEffectText = T(844062759116, "<em><DisplayName></em> is numb"),
  type = "Debuff",
  lifetime = "Until End of Turn",
  Icon = "UI/Hud/Status effects/numbness",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
