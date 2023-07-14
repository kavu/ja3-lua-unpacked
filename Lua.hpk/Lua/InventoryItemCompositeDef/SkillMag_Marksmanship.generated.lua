UndefineClass("SkillMag_Marksmanship")
DefineClass.SkillMag_Marksmanship = {
  __parents = {"MiscItem"},
  __generated_by_class = "InventoryItemCompositeDef",
  object_class = "MiscItem",
  Repairable = false,
  Icon = "UI/Icons/Items/mag_long_distance_relations",
  DisplayName = T(262432851703, "Long Distance Relations"),
  DisplayNamePlural = T(130303695300, "Long Distance Relations"),
  Description = T(658693817283, "The articles really hit the mark."),
  AdditionalHint = T(315614091781, [[
<bullet_point> Used through the Item Menu
<bullet_point> Single use
<bullet_point> Increases Marksmanship]]),
  UnitStat = "Marksmanship",
  is_valuable = true,
  effect_moment = "on_use",
  Effects = {
    PlaceObj("UnitStatBoost", {
      Amount = 1,
      Stat = "Marksmanship"
    })
  },
  action_name = T(889536988208, "READ"),
  destroy_item = true
}
