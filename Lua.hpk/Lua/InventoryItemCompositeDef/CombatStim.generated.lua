UndefineClass("CombatStim")
DefineClass.CombatStim = {
  __parents = {"MiscItem"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MiscItem",
  Repairable = false,
  Icon = "UI/Icons/Items/combat_stim",
  DisplayName = T(634691805568, "Combat Stim"),
  DisplayNamePlural = T(713501369682, "Combat Stims"),
  AdditionalHint = T(717527540232, [[
<bullet_point> Used through the Item Menu
<bullet_point> Single use
<bullet_point> Gain extra AP until the end of next turn
<bullet_point> Lose Energy after the effect wears off]]),
  effect_moment = "on_use",
  Effects = {
    PlaceObj("UnitAddStatusEffect", {Status = "Stimmed"})
  },
  action_name = T(767441148476, "USE"),
  destroy_item = true
}
