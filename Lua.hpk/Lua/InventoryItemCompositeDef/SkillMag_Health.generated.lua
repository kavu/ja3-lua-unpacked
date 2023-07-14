UndefineClass("SkillMag_Health")
DefineClass.SkillMag_Health = {
  __parents = {"MiscItem"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MiscItem",
  Repairable = false,
  Icon = "UI/Icons/Items/mag_an_apple_a_day",
  DisplayName = T(211277073057, "An Apple a Day"),
  DisplayNamePlural = T(312204213439, "An Apple a Day"),
  Description = T(862144835554, "Doctors really hate this one simple trick."),
  AdditionalHint = T(333976389871, [[
<bullet_point> Used through the Item Menu
<bullet_point> Single use
<bullet_point> Increases Health]]),
  UnitStat = "Health",
  is_valuable = true,
  effect_moment = "on_use",
  Effects = {
    PlaceObj("UnitStatBoost", {Amount = 1, Stat = "Health"})
  },
  action_name = T(499509380474, "READ"),
  destroy_item = true
}
