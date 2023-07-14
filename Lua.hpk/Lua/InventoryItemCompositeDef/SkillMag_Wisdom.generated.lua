UndefineClass("SkillMag_Wisdom")
DefineClass.SkillMag_Wisdom = {
  __parents = {"MiscItem"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MiscItem",
  Repairable = false,
  Icon = "UI/Icons/Items/mag_grilled_bears_survival_guide",
  DisplayName = T(281562344902, "Grilled Bears' Survival Guide"),
  DisplayNamePlural = T(338161393803, "Grilled Bears' Survival Guide"),
  Description = T(672223422197, "The latest pee-based recipes for your outdoor trips."),
  AdditionalHint = T(680885967646, [[
<bullet_point> Used through the Item Menu
<bullet_point> Single use
<bullet_point> Increases Wisdom]]),
  UnitStat = "Wisdom",
  is_valuable = true,
  effect_moment = "on_use",
  Effects = {
    PlaceObj("UnitStatBoost", {Amount = 1, Stat = "Wisdom"})
  },
  action_name = T(887349045271, "READ"),
  destroy_item = true
}
