UndefineClass("SkillMag_Mechanical")
DefineClass.SkillMag_Mechanical = {
  __parents = {"MiscItem"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MiscItem",
  Repairable = false,
  Icon = "UI/Icons/Items/mag_screw_you",
  DisplayName = T(593394887790, "Nuts and Bolts Magazine"),
  DisplayNamePlural = T(115283650556, "Nuts and Bolts Magazine"),
  Description = T(882249328783, "Not to be confused with the NSFW magazine with the same name."),
  AdditionalHint = T(594623778604, [[
<bullet_point> Used through the Item Menu
<bullet_point> Single use
<bullet_point> Increases Mechanical]]),
  UnitStat = "Mechanical",
  is_valuable = true,
  effect_moment = "on_use",
  Effects = {
    PlaceObj("UnitStatBoost", {Amount = 1, Stat = "Mechanical"})
  },
  action_name = T(196171082016, "READ"),
  destroy_item = true
}
