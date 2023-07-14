UndefineClass("SkillMag_Medical")
DefineClass.SkillMag_Medical = {
  __parents = {"MiscItem"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MiscItem",
  Repairable = false,
  Icon = "UI/Icons/Items/mag_national_paramedic",
  DisplayName = T(843836306167, "National Paramedic"),
  DisplayNamePlural = T(324921685110, "National Paramedic"),
  Description = T(526556854684, "90+ beats to which you can perform CPR."),
  AdditionalHint = T(420149826572, [[
<bullet_point> Used through the Item Menu
<bullet_point> Single use
<bullet_point> Increases Medical]]),
  UnitStat = "Medical",
  is_valuable = true,
  effect_moment = "on_use",
  Effects = {
    PlaceObj("UnitStatBoost", {Amount = 1, Stat = "Medical"})
  },
  action_name = T(889884758137, "READ"),
  destroy_item = true
}
