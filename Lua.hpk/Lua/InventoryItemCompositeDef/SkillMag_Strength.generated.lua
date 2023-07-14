UndefineClass("SkillMag_Strength")
DefineClass.SkillMag_Strength = {
  __parents = {"MiscItem"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MiscItem",
  Repairable = false,
  Icon = "UI/Icons/Items/mag_flex_em",
  DisplayName = T(949216271403, "Flex 'em!"),
  DisplayNamePlural = T(246425010309, "Flex 'em!"),
  Description = T(817037902641, "For bros who even lift."),
  AdditionalHint = T(595702309304, [[
<bullet_point> Used through the Item Menu
<bullet_point> Single use
<bullet_point> Increases Strength]]),
  UnitStat = "Strength",
  is_valuable = true,
  effect_moment = "on_use",
  Effects = {
    PlaceObj("UnitStatBoost", {Amount = 1, Stat = "Strength"})
  },
  action_name = T(919614237926, "READ"),
  destroy_item = true
}
