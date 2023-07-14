UndefineClass("BonecrusherEnraged")
DefineClass.BonecrusherEnraged = {
  __parents = {
    "StatusEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "StatusEffect",
  msg_reactions = {},
  DisplayName = T(854094952820, "Enraged"),
  Description = T(374881592438, "Bonecrusher seems full of rage. He will not stop until breaking every bone in his opponent's body."),
  AddEffectText = T(276266266622, "<em><DisplayName></em> is enraged"),
  type = "Buff",
  Icon = "UI/Hud/Status effects/well_rested",
  RemoveOnEndCombat = true,
  Shown = true,
  ShownSatelliteView = true,
  HasFloatingText = true
}
