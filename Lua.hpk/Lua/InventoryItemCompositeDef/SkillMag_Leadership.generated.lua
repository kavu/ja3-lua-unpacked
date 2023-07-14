UndefineClass("SkillMag_Leadership")
DefineClass.SkillMag_Leadership = {
  __parents = {"MiscItem"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MiscItem",
  Repairable = false,
  Icon = "UI/Icons/Items/mag_puntastic_dad_jokes",
  DisplayName = T(624085403180, "Puntastic Dad Jokes"),
  DisplayNamePlural = T(542345156012, "Puntastic Dad Jokes"),
  Description = T(437039053771, "Why is issue six afraid of issue seven?"),
  AdditionalHint = T(787629043274, [[
<bullet_point> Used through the Item Menu
<bullet_point> Single use
<bullet_point> Increases Leadership]]),
  UnitStat = "Leadership",
  is_valuable = true,
  effect_moment = "on_use",
  Effects = {
    PlaceObj("UnitStatBoost", {Amount = 1, Stat = "Leadership"})
  },
  action_name = T(134463686670, "READ"),
  destroy_item = true
}
